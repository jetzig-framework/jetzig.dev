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

Generates a query that fetches a single row for the matching primary key, as defined by the model (default value: `id`).

```zig
jetzig.database.Query(.Cat).find(1000);
```

By default, all columns are selected. To select specific columns, use in combination with `select`:

```zig
jetzig.database.Query(.Dog).find(1000).select(.{ .name, .color });
```

The result type from executing this query is an optional: if no records are found, the result is `null`, otherwise a single value is returned.

### `findBy`

Generates a query that fetches a single row for the matching `WHERE` clause.

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

However, _JetQuery_ provides a large number of options for generating queries. The following contrived example illustrates how many options are available:

```zig
jetzig.database.Query(.Cat)
    .join(.inner, .homes)
    .where(.{
        .{ .name = "Hercules" }, .OR, .{ .name = "Heracles" },
        .{ .{ .age, .gt, 4 }, .{ .age, .lt, 10 } },
        .{ .favorite_sport, .like, "%ball" },
        .{ .favorite_sport, .not_eql, "basketball" },
        .{ jetquery.sql.raw("my_sql_function(age)"), .eql, 100 },
        .{ .NOT, .{ .{ .age = 1 }, .OR, .{ .age = 2 } } },
        .{ "age / paws = ? or age * paws < ?", .{ 2, 10 } },
        .{ .homes = .{ .zip_code = "10304" } },
    });
```

From this query we get the following _SQL_:
```sql
    SELECT "cats"."id", "cats"."name", "cats"."age", "cats"."favorite_sport"
      FROM "cats"
INNER JOIN "homes"
        ON "cats"."id" = "homes"."cat_id"
     WHERE ("cats"."name" = $1
        OR "cats"."name" = $2
       AND ("cats"."age" > $3 AND "cats"."age" < $4)
       AND "cats"."favorite_sport" LIKE $5
       AND "cats"."favorite_sport" <> $6
       AND my_sql_function(age) = $7
       AND (NOT ("cats"."age" = $8 OR "cats"."age" = $9))
       AND age / paws = $10 or age * paws < $11
       AND "homes"."zip_code" = $12)
  ORDER BY "cats"."id" ASC
```

#### Logical Operators

* `.OR`
* `.AND`
* `.NOT`

By default, groups of parameters are combined with `AND`.

#### Comparison Operators

`.eql`: Equal to `=`
`.not_eql`: Not Equal to `<>`
`.lt`: Less Than `<`
`.lt_eql`: Less Than or Equal to `<=`
`.gt`: Greater Than `>`
`.gt_eql`: Greater Than or Equal To `>=`
`.like`: Substring match `LIKE`
`.ilike`: Case-insensitive match `ILIKE`

#### Raw SQL

When a query cannot be expressed using other syntax, pass a two-element tuple containing a `comptime` string and a tuple of arguments.

Raw _SQL_ strings must be `comptime` known. Bind params are normalized as `?` and translated to the appropriate adapter's format. The tuple must always have two elements to signify that this is a raw SQL string.

Alternatively, use `jetquery.sql.raw` in a three-element tuple where the second element is a comparison operator:

```zig
.{ "age / paws = ? or age * paws < ?", .{ 2, 10 } }
```

```zig
.{ jetquery.sql.raw("my_sql_function(age)"), .eql, 100 }
```

#### Relations

When used in conjunction with `include` or `join`, `WHERE` clause parameters for relations are denoted by nesting arguments in a field named after the relation, as can be seen above by the `homes` field. Nested parameters adhere to the same rules and provide the same functionality as non-nested parameters.

#### Type Coercion

_JetQuery_ coerces types where possible. This allows common usage patterns like using a query parameter or URI segment as a numeric ID. In most use cases, parameters can be passed to `where()` without needing to manually coerce to the desired type.

### include

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

* `select`: A tuple of enum literals specifying the columns to select from the relation. The format is identical to `select()`.
* `order_by`: Any variation of the arguments supported by `orderBy` (see below). `hasMany` relations only.
* `limit`: Limit a `hasMany` result set to the provided value.

```zig
jetzig.database.Query(.Blog).include(.comments, .{
    .select = .{.title},
    .order_by = .{ .created_at = .desc },
    .limit = 4,
})
```

### join

Similar to `include` but does not include any columns from the relation in the result set. Use `join` for filtering results, use `include` to fetch relation data.

`join_context` must be either `.inner` or `.outer` depending on the required join type.

The following query returns only `Blog` records that have comments.

```zig
jetzig.databse.Query(.Blog).join(.inner, .comments);
```

### distinct

Indicates that the specified columns should have a `DISTINCT` condition applied.

```zig
jetzig.database.Query(.Blog).distinct(.{.title})
```

### count

Generates a `COUNT` query. The result type of executing a `count()` query is always `i64`.

Can be used in conjunction with `distinct`.

```zig
jetzig.database.Query(.Cat).where(.{ .name = "Hercules" }).count()
```

```zig
jetzig.database.Query(.Cat).distinct(.{.name}).count()
```
