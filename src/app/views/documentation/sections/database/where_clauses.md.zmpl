# `WHERE` Clauses

_JetQuery_'s interface for generating `WHERE` clauses provides a large number of options which aim to cover every use case, including allowing users to use `comptime`-known strings.

Values are automatically converted to bind params, significantly limiting the potential for _SQL_ injection vulnerabilities.

## Example

The following contrived example illustrates how many options are available:

```zig
jetzig.database.Query(.Cat)
    .join(.inner, .homes)
    .where(.{
        .{ .name = "Hercules" }, .OR, .{ .name = "Heracles" },
        .{ .{ .age, .gt, 4 }, .{ .age, .lt, 10 } },
		.{ .favorite_sport, .like, "%ball" },
        .{ .favorite_sport, .not_eql, "basketball" },
        .{ "my_sql_function(age)", .eql, 100 },
        .{ .NOT, .{ .{ .age = 1 }, .OR, .{ .age = 2 } } },
        .{ "age / paws = ? or age * paws < ?", .{ 2, 10 } },
        .{ .{ .status = null }, .OR, .{ .status = [_][]const u8{ "sleeping", "eating" } } },
        .{ .homes = .{ .zip_code = "10304" } },
    });
```

From this query we get the following _SQL_:
```sql
	SELECT "cats"."id", "cats"."name", "cats"."age", "cats"."favorite_sport", "cats"."status"
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
       AND ("cats"."status" IS NULL OR "cats"."status" = ANY ($12))
       AND "homes"."zip_code" = $13)
  ORDER BY "cats"."id" ASC
```

The following sections break down all of the above options in more detail.

## Logical Operators

* `.OR`
* `.AND`
* `.NOT`

By default, groups of parameters are combined with `AND`.

## Comparison Operators

`.eql`: Equal to `=`
`.not_eql`: Not Equal to `<>`
`.lt`: Less Than `<`
`.lt_eql`: Less Than or Equal to `<=`
`.gt`: Greater Than `>`
`.gt_eql`: Greater Than or Equal To `>=`
`.like`: Substring match `LIKE`
`.ilike`: Case-insensitive match `ILIKE`

## Raw SQL

When a query cannot be expressed using other syntax, pass a two-element tuple containing a `comptime` string and a tuple of arguments.

Raw _SQL_ strings must be `comptime` known. Bind params are normalized as `?` and translated to the appropriate adapter's format. The tuple must always have two elements to signify that this is a raw SQL string.

```zig
.{ "age / paws = ? or age * paws < ?", .{ 2, 10 } }
```

## Triplets

A triplet consistes of three elements:

* Left operand
* Operator
* Right operand

The left and right side can be a column name (as an enum literal), a function (e.g. `jetquery.sql.max(.my_column)`), or any value (which will become a bind param).

The left side can also be a raw _SQL_ string. If the string is `comptime`-known it will be injected directly into the query. To achieve the same behaviour on the right side, use `jetquery.sql.raw("...")`.

The operator must be one of the Comparison Operators listed above.

```zig
.{ "my_sql_function(age)", .eql, 100 }
.{ jetquery.sql.avg(age), .lt, 50 }
.{ "my_sql_function(age)", .eql, jetquery.sql.raw("my_other_sql_function(age)") }
```

## NULL

`IS NULL` conditions are implemented by simply passing `null` as a value:

```zig
.{ .status = null }
```

## Matching Multiple Values

_PostgreSQL_ provides `ANY` which allows us to pass an array directly in order to match on multiple values. In future, other database adapters will use `IN ($1, $2, ...)` where `ANY` is not available in order to provide equivalent functionality.

```zig
.{ .status = [_][]const u8{ "sleeping", "eating" } }
```

Slices are also supported in this context. Array/slice length does not need to be `comptime`-known (unfortunately this does mean that future adapters using `IN` will need to generate this portion of the query at run time).

## Relations

When used in conjunction with `include` or `join`, `WHERE` clause parameters for relations are denoted by nesting arguments in a field named after the relation, as can be seen above by the `homes` field. Nested parameters adhere to the same rules and provide the same functionality as non-nested parameters.

## Type Coercion

_JetQuery_ coerces types where possible. This allows common usage patterns like using a query parameter or URI segment as a numeric ID. In most use cases, parameters can be passed to `where()` without needing to manually coerce to the desired type.

When working with custom types, implement `toJetQuery` to translate to the appropriate type. _JetQuery_ passes a single argument (the desired type to coerce to) to this function if it is defined.

See _Zmpl_'s implementation of this function as reference: [https://github.com/jetzig-framework/zmpl/blob/main/src/zmpl/Data.zig#L999](https://github.com/jetzig-framework/zmpl/blob/main/src/zmpl/Data.zig#L999).
