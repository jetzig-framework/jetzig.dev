# Schema

_JetQuery_ requires a `Schema` in order to function. Unlike _ActiveRecord_ (but more like _Ecto_), _JetQuery_ does not reflect the database automatically. Defining a `comptime`-known `Schema` allows _JetQuery_ to provide powerful type checking and dynamic result types.

Instead of detecting invalid _SQL_ at run time, _JetQuery_ will trigger compile errors for selecting/updating/inserting columns not defined in the `Schema` and accessing fields in results that are not selected/defined.

For example, if we take the following query:

```zig
const query = jetzig.database.Query(.Blog)
    .select(.{.id})
    .findBy(.{ .title = "JetQuery" });
```

We can compile this code without any problems:

```zig
if (try request.repo.execute(query)) |blog| {
    std.debug.print("Blog ID: {}\\n", .{blog.id});
}
```

But the following will fail, because we did not select `content`:

```zig
if (try request.repo.execute(query)) |blog| {
    std.debug.print("Blog content: {s}\\n", .{blog.content});
}
```

```
error: no field named 'content' in struct ...
```

## Schema Definition

A _Jetzig_ application's schema is defined in `src/app/database/Schema.zig`.

The schema is imported in `jetzig_options` in your application's `src/main.zig`:

```zig
pub const jetzig_options = struct {
    pub const Schema = @import("Schema");
};
```

Note that the `@import` uses the `Schema` module defined automatically by _Jetzig_'s build setup - you must use this module and not the direct path to your `src/app/database/Schema.zig`.

The `Schema` itself is a `struct` containing a series of `Model` declarations:

```zig
# src/app/database/Schema.zig

const jetquery = @import("jetzig").jetquery;

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

To make the schema generation process easier, _Jetzig_ provides a command line utility for reflecting the database schema as needed:

```console
$ jetzig database reflect
```

Run this command at any time to sync your `Schema` with your database. See the [Command Line Tools](/documentation/sections/database/command_line_tools) section for more information on available commands.

Any relations defined are transfered to the new `Schema` and the order of existing models is preserved so you can use this command liberally.
