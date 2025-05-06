# Command Line Tools

_Jetzig_ provides various command line utilities to make managing a _Jetzig_ application easier. The `jetzig database` command provides specific tools for managing a database and migrations.

Run `jetzig database --help` and `jetzig database <command> --help` to see usage instructions from your command line.

All of the following commands operate on the `development` database by default. Pass `-e <environment>` to use a different environment:

```console
$ jetzig -e development database create
```

Supported environments are: `development`, `testing`, `production`.

As with most _Jetzig_ command line commands, the command can be abbreviated to the first letter, i.e. `jetzig d create` is identical to `jetzig database create`.

## `jetzig database create`

Create the database configured in your application's `config/database.zig`.

Ensure that the user credential defined in your configuration is authorized to create databases. If you are running _PostgreSQL_ in _Docker_ (example [compose.yml](https://github.com/jetzig-framework/jetquery/blob/main/compose.yml)), this should work using the following configuration:

```zig
# config/database.zig

pub const database = .{
    .development = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5432,
        .username = "postgres",
        .password = "password",
        .database = "my_jetzig_app_development",
    },

    .testing = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5432,
        .username = "postgres",
        .password = "password",
        .database = "my_jetzig_app_testing",
    },

    .production = .{
        .adapter = .postgresql,
        // See Database Configuration documentation for environment variable information.
    },
};
```

## `jetzig database drop`

Drop the database. When using this command in the `production` environment the environment variable `JETZIG_DROP_PRODUCTION_DATABASE` must be set to the name of the production database.

## `jetzig database migrate`

Run all pending migrations and update the `jetquery_migrations` table.

## `jetzig database seed`

Run all pending seeders to set up your application with some initial data.

## `jetzig database rollback`

Roll back the last migration and update the `jetquery_migrations` table.

## `jetzig database reflect`

Read metadata from the database and generate a [Schema](/documentation/sections/database/schema).

Run this command any time you apply or roll back a database migration unless you prefer to manually manage your `Schema` file.

## `jetzig generate migration`

Generate a new migration file in `src/app/database/migrations/` timestamped to the current time and date.

This command requires at least one argument (the name of the migration):

```zig
$ jetzig g migration create_cats

info: Saved migration: /home/bob/dev/zig/jetzig.dev/src/app/database/migrations/2024-11-10_20-42-30_create_cats.zig
```

An placeholder migration is created:

```zig
# src/app/database/migrations/2024-11-10_20-42-30_create_cats.zig

const std = @import("std");
const jetquery = @import("jetquery");
const t = jetquery.schema.table;

pub fn up(repo: anytype) !void {
    try repo.createTable(
        "my_table",
        &.{
            t.primaryKey("id", .{}),
            t.column("my_string", .string, .{}),
            t.column("my_integer", .integer, .{}),
            t.timestamps(.{}),
        },
        .{},
    );
}

pub fn down(repo: anytype) !void {
    try repo.dropTable("my_table", .{});
}
```

Modify this file to suit your requirements before applying the migrations with `jetzig database migrate`.

See the [Migrations](/documentation/sections/database/migrations) documentation for more details.

### Migration Options

The `jetzig generate migration` command also accepts a number of options for quickly generating common patterns. All of these options act as shortcuts to writing familiar boilerplate and can be ignored if preferred. In most cases the initial boilerplate can be created from the command line and then edited as required.

The below examples taken from _JetQuery_'s test's give a general idea of the available options:

```console
$ jetzig g migration table:create:cats column:name:string:index:unique column:paws:integer column:human_id:index:reference:humans.id

$ jetzig g migration drop:cats

$ jetzig g migration table:alter:cats column:color:string:index:unique \
                                      column:rename:paws:feet \
                                      column:drop:name \
                                      rename:dogs
```

Note that (as in the last example) it is possible to generate migrations that may not be compatible with your database. For example, in _PostgreSQL_ it is forbidden to rename multiple columns in a single _DDL_ command. _JetQuery_ does not attempt to prevent this kind of migration from being created or applied and instead allows the database to reject invalid migrations.

## `jetzig generate seeder`

Generate a new seeder file in `src/app/database/seeders/` timestamped to the current time and date.

This command requires at least one argument (the name of the seeder):

```zig
# src/app/database/seeders/2024-11-10_20-42-30_my_table.zig

const std = @import("std");

pub fn run(repo: anytype) !void {
    try repo.insert(
        .User,
        .{
            .email = "iguana@jetzig.dev",
            .password_hash = "not_secure",
        },
    );

    try repo.insert(
        .User,
        .{
            .email = "admin@jetzig.dev",
            .password_hash = "do_not_use",
        },
    );
}
```

Modify this file to suit your requirements before applying the migrations with `jetzig database seed`.

See the [Seeders](/documentation/sections/database/seeders) documentation for more details.

