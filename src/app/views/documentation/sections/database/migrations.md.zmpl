# Migrations

_JetQuery_ provides a framework for managing database migrations.

The table `jetquery_migrations` is used to track pending/applied migrations. This table is automatically created the first time you run a migration.

The details below cover how migrations work and the structure of a migration file. It is recommended to use the [Command Line Tools](/documentation/database/command_line_tools) to create and run migrations.

## Migration Format

A migration is file named with a timestamp prefix followed by an underscore and an arbitrary string with a `.zig` extension. _Jetzig_ migrations are located in `src/app/database/migrations/`.

A migration file contains two _Zig_ functions:

* `up`
* `down`

Both functions receive a `Repo` which is then used to issue _Data Definition Language_ (_DDL_) commands.

These functions can be used anywhere that you have access to a `Repo`. It is recommended that you limit migrations to _DDL_ commands but there are no hard restrictions on how you use the `Repo` within a migration.

### `up`

The `up` function is called when a migration is applied. Use this function to create tables and indexes.

### `down`

The `down` function is called when a migration is rolled back. This function should undo the changes introduced by `up`, e.g. if you create a table in `up` then you should drop the table in `down`.

### Example Migration

The following example is taken from this website's migrations:

```zig
const std = @import("std");
const jetquery = @import("jetquery");
const t = jetquery.schema.table;

pub fn up(repo: anytype) !void {
    try repo.createTable(
        "blogs",
        &.{
            t.primaryKey("id", .{}),
            t.column("title", .string, .{ .unique = true }),
            t.column("content", .text, .{}),
            t.timestamps(.{}),
        },
        .{},
    );
}

pub fn down(repo: anytype) !void {
    try repo.dropTable("blogs", .{});
}
```

### `createTable`

```zig
pub fn createTable(
    self: *AdaptedRepo,
    comptime name: []const u8,
    comptime columns: []const jetquery.schema.Column,
    comptime options: jetquery.CreateTableOptions,
) !void
```

Pass a table name, a slice of column definitions, and options.

#### Options

```zig
pub const CreateTableOptions = struct { if_not_exists: bool = false };
```

### `column`

```zig
pub fn column(
    name: []const u8,
    column_type: Column.Type,
    options: Column.Options,
) Column
```

#### Options

```zig
pub const Options = struct {
    optional: bool = false, // Specify a `NOT NULL` constraint when `false`
    index: bool = false, // Create an index when `true`
    index_name: ?[]const u8 = null, // Override auto-generated index name
    unique: bool = false, // Apply a unique constraint when `true`
    reference: ?Reference = null, // Create a foreign key, e.g. `.{"blogs", "id"}`
    length: ?u16 = null, // Specify column length (string columns default to `255`)
    default: ?[]const u8 = null, // Specify a default value for the column, e.g. `"42"`, `"now()"`, or `"true"`
};
```

### `dropTable`

```zig
pub fn dropTable(
    self: *AdaptedRepo,
    comptime name: []const u8,
    comptime options: jetquery.DropTableOptions,
) !void
```

#### Options

```zig
pub const DropTableOptions = struct { if_exists: bool = false };
```

### `alterTable`

```zig
pub fn alterTable(
    self: *AdaptedRepo,
    comptime name: []const u8,
    comptime options: jetquery.AlterTableOptions,
) !void
```

#### Options

```zig
pub const AlterTableOptions = struct {
    columns: AlterTableColumnOptions = .{},
    rename: ?[]const u8 = null,

    pub const AlterTableColumnOptions = struct {
        add: []const schema.Column = &.{},
        drop: []const []const u8 = &.{},
        rename: ?RenameColumn = null,

        pub const RenameColumn = struct { from: []const u8, to: []const u8 };
    };
};
```

### `createDatabase`

```zig
pub fn createDatabase(
    self: *AdaptedRepo,
    comptime name: []const u8,
    options: struct {},
) !void
```

### `dropDatabase`

```zig
pub fn dropDatabase(
    self: *AdaptedRepo,
    comptime name: []const u8,
    options: jetquery.DropDatabaseOptions,
) !void
```

#### Options

```zig
pub const DropDatabaseOptions = struct { if_exists: bool = false };
```
