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

* `insert`, `delete`, `deleteAll`, `update`: `!void`
* `find`, `findBy`: `!?@TypeOf(query).ResultType`
* `count`: `i64`

All other queries return a `Result` which can be iterated over using `result.next()`, or the entire result set can be fetched with `repo.all(query)` or `query.all(repo)`.

`@TypeOf(query).ResultType` is a dynamic type comprising only the columns selected by the query and any included relations. `all` returns an array of results: `![]@TypeOf(query).ResultType`.

See the examples for each member function below to understand how each result type can be used.

## Member Functions

### `select`

```zig
pub fn select(comptime columns: anytype)
```

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

```zig
pub fn find(id: anytype)
```

Executes a query that fetches a single row for the matching primary key, as defined by the model (default value: `id`).
