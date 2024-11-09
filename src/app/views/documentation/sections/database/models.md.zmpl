# Models

A model defines the underlying table name, available columns and types, and configuration options such as `relations`:

```zig
pub fn Model(Schema: type, comptime table_name: []const u8, T: type, options: anytype) type
```

When defining field types, take care to represent the database accurately. For example, if a column does not have a `NOT NULL` constraint, the field must be an optional type, e.g. `?[]const u8`.

After a model has been added to the schema, it becomes available as a parameter to `jetzig.database.Query`:

```zig
jetzig.database.Query(.Blog)
```

Note that models should be named as singulars, i.e. `Comment` instead of `Comments`. This allows automatic foreign key inference when setting up relations.

All models default to `id` as their primary key (used for relations and `find` operations). This can be overridden with the `primary_key` option:

```
pub const Blog = jetquery.Model(
    @This(),
    "blogs",
    struct {
        // ...
    },
    .{
        .primary_key = "unique_id",
    },
);

### Relations

Relations provide the ability to link one table to another. When a relation has been configured, results can be fetched from multiple tables at once with very little extra syntax.

See [Query Interface](/documentation/sections/query_interface) for detailed usage instructions.

When defining a relation, the following optional parameters can be configured:

* `primary_key: []const u8`
* `foreign_key: []const u8`

If these values are not specified, the following rules are used to generate them:

* `primary_key`: Defaults to the primary key defined for the model (default: `id`).
* `foreign_key` with `belongsTo`: Defaults to the **name of the relation** suffixed by `_id`.
* `foreign_key` with `hasMany`: Defaults to the **name of the associated model** suffixed by `_id`.

Note that both columns do not need to be defined as primary or foreign keys in the database, any columns with compatible types can be used.

To override the default values, use the following syntax:

```zig
jetquery.belongsTo(.Blog, .{ .primary_key = "blog_id", .foreign_key = "comment_id" })
jetquery.hasMany(.Comment, .{ .primary_key = "commment_id", .foreign_key = "blog_id" })
```

The examples below highlight the default values used in each case for clarity.

#### Belongs To

```zig
pub const Comment = jetquery.Model(
    @This(),
    "comments",
    struct {
        blog_id: i32,
        name: []const u8,
        content: []const u8,
        created_at: jetquery.DateTime,
        updated_at: jetquery.DateTime,
    },
    .{
        .relations = .{
            .blog = jetquery.belongsTo(.Blog, .{}),
        },
    },
);
```

Default values:
```zig
.{ .primary_key = "id", .foreign_key = "blog_id" }
```

Note that the default `foreign_key` value `blog_id` is inferred by the name of the relation (`blog`) and not the associated model name (`Blog`). If the relation were named `blog_post` then the default value would be `blog_post_id`.

#### Has Many

```zig
pub const Blog = jetquery.Model(
    @This(),
    "blogs",
    struct {
        id: i32,
        title: []const u8,
        content: []const u8,
        created_at: jetquery.DateTime,
        updated_at: jetquery.DateTime,
        author: []const u8,
    },
    .{
        .relations = .{
            .comments = jetquery.hasMany(.Comment, .{}),
        },
    },
);
```

Default values:
```zig
.{ .primary_key = "id", .foreign_key = "blog_id" }
```

In both cases, the `primary_key` refers to `blogs.id` and the foreign key refers to `comments.blog_id`.
