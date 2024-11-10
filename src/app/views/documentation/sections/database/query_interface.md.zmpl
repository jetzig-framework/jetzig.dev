# Query Interface

This section provides an overview of the available member functions of a `Query`.

## Execution

In each case, the resulting query can be executed by calling `repo.execute(query)`.

For convenience, queries also implement `execute` and `all`, allowing a result to be fetched with a single statement. The following two examples are equivalent:

```zig
const query = jetzig.database.Query(.Blog)
    .where(.{ .author = "bob@jetzig.dev" });
const blogs = try request.repo.all(query);
```
```zig
const blogs = try jetzig.database.Query(.Blog)
    .where(.{ .author = "bob@jetzig.dev" })
    .all(request.repo);
```

The return type of `repo.execute` varies depending on the query type:

* `insert`, `delete`, `deleteAll`, `update` return `!void`
* `find`, `findBy` return `!?@TypeOf(query).ResultType`
* `count` returns `i64`

All other queries return a `Result` which can be iterated over using `result.next()`, or the entire result set can be fetched with `repo.all(query)` or `query.all(repo)`.

`@TypeOf(query).ResultType` is a dynamic type comprising only the columns selected by the query and any included relations. `all` returns an array of results: `![]@TypeOf(query).ResultType`.

See [Fetching Records](/documentation/sections/database/fetching_records) to see full examples of how each result type can be used.

## Member Functions

### `select`

Specify a tuple of enum literals as columns. All columns must be defined in the `Schema`.

```zig
jetzig.database.Query(.Blog).select(.{ .id, .title, .content });
```

To select all columns, pass an empty tuple:

```zig
jetzig.database.Query(.Blog).select(.{});
```

Synthetic columns can also be selected using `jetquery.sql.column`:

```zig
jetzig.database.Query(.Blog).select(.{ .id, jetquery.sql.column(i32, "100 + 50").as(.addition_result) });
```

Results from this query will have both `id` and `addition_result` attributes. Any `comptime` string can be passed to `jetquery.sql.column`. Synthetic columns must always be aliased using `as()` to provide a mapping on result values.

For convenience, some common _SQL_ aggregate functions are available for use with `GROUP BY` expressions:

```zig
jetzig.database.Query(.Cat).select(.{
    jetquery.sql.max(.age),
    jetquery.sql.min(.age),
    jetquery.sql.sum(.age).as("sum_of_ages"),
    jetquery.sql.avg(.age),
    jetquery.sql.count(.age),
});
```

By default, functions are aliased as the function name and the referenced column separated by double underscores, e.g. `max__age`. As in the example above, this can be customized by calling `as()` to specify an alias explicitly.

### `find`

Generate a query that fetches a single row for the matching primary key, as defined by the model (default value: `id`).

```zig
jetzig.database.Query(.Cat).find(1000);
```

By default, all columns are selected. To select specific columns, use in combination with `select`:

```zig
jetzig.database.Query(.Dog).find(1000).select(.{ .name, .color });
```

The result type from executing this query is an optional: if no records are found, the result is `null`, otherwise a single record is returned.

### `findBy`

Generate a query that fetches a single row for the matching `WHERE` clause.

```zig
jetzig.database.Query(.Cat).findBy(.{ .name = "Hercules" });
```

By default, all columns are selected. To select specific columns, use in combination with `select`:

```zig
jetzig.database.Query(.Cat).findBy(.{ .name = "Hercules" }).select(.{ .name, .color });
```

The result type from executing this query is an optional: if no records are found, the result is `null`, otherwise a single value is returned.

### `where`

Apply a `WHERE` clause to the query. There are many supported argument formats to allow complex `WHERE` clauses to be generated with (hopefully) intuitive syntax.

For common patterns, queries typically look like this:
```zig
jetzig.database.Query(.Cat).where(.{ .name = "Hercules" });
```

However, _JetQuery_ provides a large number of options for generating where clauses. See [Where Clauses](/documentation/sections/database/where_clauses) for a detailed overview of all supported features.

### `include`

Include results from a relation in the query.

The result type from `include` queries is a factor of the base model plus the type of relation being included.

#### hasMany

```zig
jetzig.database.Query(.Blog).include(.comments, .{})
```
Each returned `Blog` result has a `comments` field which is an array of comments.

#### belongsTo

```zig
jetzig.database.Query(.Comment).include(.blog, .{})
```
Each returned `Comment` result has a `blog` field which is a single blog post.

In both cases, all columns are selected by default and are available on each result.

#### Options

The following options can be passed in the second argument to `include`:

* `select`: A tuple of column specifiers to select from the relation. The format is identical to `select()`.
* `order_by`: Any variation of the arguments supported by `orderBy` (see below). `hasMany` relations only.
* `limit`: Limit a `hasMany` result set to the provided value.

```zig
jetzig.database.Query(.Blog).include(.comments, .{
    .select = .{.title},
    .order_by = .{ .created_at = .desc },
    .limit = 4,
})
```

### `join`

Similar to `include` but does not include any columns from the relation in the result set. Use `join` for filtering results, use `include` to fetch relation data.

`join_context` must be either `.inner` or `.outer` depending on the required join type.

The following query returns only `Blog` records that have comments.

```zig
jetzig.databse.Query(.Blog).join(.inner, .comments);
```

### `distinct`

Indicates that the specified columns should have a `DISTINCT` condition applied.

```zig
jetzig.database.Query(.Blog).distinct(.{.title})
```

### `count`

Generates a `COUNT` query. The result type of executing a `count()` query is always `i64`.

Can be used in conjunction with `distinct`.

```zig
jetzig.database.Query(.Cat).where(.{ .name = "Hercules" }).count()
```

```zig
jetzig.database.Query(.Cat).distinct(.{.name}).count()
```

### `orderBy`

Specifies an `ORDER BY` clause for the query. The following argument formats are supported:

```zig
jetzig.database.Query(.Cat).orderBy(.name);
jetzig.database.Query(.Cat).orderBy(.{ .name, .age });
jetzig.database.Query(.Cat).orderBy(.{ .name = .ascending, .age = .descending });
jetzig.database.Query(.Cat).orderBy(.{ .name = .asc, .age = .desc });
jetzig.database.Query(.Cat).join(.inner, .home).orderBy(.{ .name = .asc, .home = .{ .priority = .ascending });
```

`.asc` and `.desc` are synonyms for `.ascending` and `.descending` respectively and can be used interchangeably.
