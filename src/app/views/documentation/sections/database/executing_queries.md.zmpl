# Executing Queries

Queries are executed by invoking `request.repo.execute`. _JetQuery_ separates the query generation process from the execution process, ensuring that no implicit query execution takes place.

When a query is generated the following two steps occur:

1. The query's _SQL_ is compiled at `comptime`, i.e. queries are only generated once. The _SQL_ for all queries is available as `query.sql`.
1. At run time, query parameters are bound to the query. Types are automatically coerced where possible. Query values are available as `query.values`, a tuple of the computed types for each parameter, and any errors that occurred during type coercion (e.g. casting "foo" to an integer) are available as `query.errors`

## Result Types

The return type of `request.repo.execute` varies depending on the query type.

* `insert`, `delete`, `deleteAll`, `update`, `updateAll` return `!void`
* `find`, `findBy` return `!?@TypeOf(query).ResultType`
* `select` returns `!jetquery.Result`
* `repo.all` returns `![]@TypeOf(query).ResultType`
* `count` returns `!i64`

`@TypeOf(query).ResultType` is a dynamic type comprising only the columns selected by the query and any included relations. This allows _Zig_ to type check all field access and generate compile errors if a missing field is accessed.

### Many-result Queries

The default implicit query type is `select`. For example the following queries all generate a query that returns multiple results when executed:

```zig
jetzig.database.Query(.Cat).where(.{ .name = "Hercules" });
jetzig.database.Query(.Cat).include(.homes, .{});
jetzig.database.Query(.Cat).join(.favorite_foods, .{});
```

To iterate over a result set, use `next()`:

```zig
const query = jetzig.database.Query(.Cat).select(.{.name}).where(.{ .paws = 4 });
var result = try request.repo.execute(query);
defer result.deinit();

while (try result.next(query)) |cat| {
    std.debug.print("Cat is named {s}\n", .{cat.name});
}
```

Alternatively, fetch a slice of results with `all()` and iterate over the records directly:

```zig
const query = jetzig.database.Query(.Cat).select(.{.name}).where(.{ .paws = 4 });
const cats = try request.repo.all(query);
defer request.repo.free(cats);

for (cats) |cat| {
    std.debug.print("Cat is named {s}\n", .{cat.name});
}
```

### Single-result queries

`findBy` and `find` both return an optional resolving to a single result:

```zig
const query = jetzig.database.Query(.Cat).findBy(.{ .name = "Hercules" });
if (try request.repo.execute(query)) |cat| {
    std.debug.print("Cat is named {s}\n", .{cat.name});
    request.repo.free(cat);
}
```

### Unary-result queries

`count` returns a single unary value:

```zig
const query = jetzig.database.Query(.Cat).where(.{ .paws = 4 });
const count = try request.repo.execute(query);
std.debug.print("Found {} cats with 4 paws.\n", .{count});
```

### Void-result queries

`insert`, `update`, `delete`, `updateAll`, and `deleteAll` queries return nothing:

```zig
const query = jetzig.database.Query(.Cat).delete().where(.{ .paws = 3 });
try request.repo.execute(query);
```

## Update

Similar to `insert`, updating records can be achieved using the query generator:

```zig
const query = jetzig.database.Query(.Cat)
    .update(.{ .name = "Hercules" })
    .where(.{ .name = "Heracles" });
try request.repo.execute(query);
```

If you have already fetched a record and want to modify it, updating can be achieved with `Repo.save()`:

```zig
const query = jetzig.database.Query(.Cat).findBy(.{ .name = "Hercules" });
var maybe_cat = try repo.execute(query);
if (maybe_cat) |*cat| {
	cat.name = "Heracles";
	try repo.save(cat);
}
```

Note that the record's primary key **must** be selected in order to use `Repo.save()`. By default, all implicit `SELECT` queries include all columns.

## Relations

### hasMany

Fetching `hasMany` relations provides a field for each relation on each result object:

```zig
const query = jetzig.database.Query(.Person).include(.cats, .{});
const people = try request.all(query);
defer request.repo.free(people);

for (people) |person| {
    for (person.cats) |cat| {
        std.debug.print("{s} has a cat named {s}\n", .{person.name, cat.name});
    }
}
```

`hasMany` relations are fetched as separate queries. This avoids the problem of generating queries that join multiple tables, with each table multiplying the number of rows (of mostly duplicate data) returned.

**Important**: Note that, in order to fetch all associated records in a `hasMany` relation, all IDs for the left side of the relation must be known so that an efficient query can be executed. This means that using `all()` to fetch the entire result set will typically provide much better performance than iterating over each result (in which case, _JetQuery_ issues one query per relation per iteration). Developers must choose between query speed and memory use to decide whether iteration or a full result fetch is the preferred option.

### belongsTo

`belongsTo` relations work in a similar way, but provide a field containing a single record instead:

```zig
const query = jetzig.database.Query(.Cat).include(.owner, .{});
const cats = try request.all(query);
defer request.repo.free(cats);

for (cats) |cat| {
    std.debug.print("Cat named {s} lives in {s}'s house\n", .{cat.name, cat.owner.name});
}
```

## Managing Memory Allocation

The examples above show how to use `request.repo.free`. This function accepts many result types (including `null`, so it can be used with optional query result types as well).

In _Jetzig_, every request operates within an arena allocator which is automatically freed at the end of the request so, in most situations, freeing resources manually is not required.

When using iteration with `result.next()`, you **must** call `result.deinit()`. Use the patterns provided above with `defer` to achieve this.

## Convenience Functions

For convenience, queries also implement `all` and `execute`, allowing you to execute the query directly with a given repository:

```zig
const cats = try jetzig.database.Query(.Cat).all(request.repo);
var result = try jetzig.database.Query(.Cat).execute(request.repo);
```
