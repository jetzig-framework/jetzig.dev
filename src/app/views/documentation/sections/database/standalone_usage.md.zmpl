# Standalone Usage

_JetQuery_ works out of the box with _Jetzig_ with minimal configuration. However, it has been designed with standalone usage in mind and can be used with any other framework or standalone application.

[JetQuery GitHub](https://github.com/jetzig-framework/jetquery)

## Setup

The below steps assume familarity with _JetQuery_'s [Schema](/documentation/sections/database/schema) implementation.

### Configuration File

By default, _JetQuery_ expects a file named `jetquery.config.zig` to exist in the project root. This path can be set by the build argument `-Djetquery_config_path`.

```console
zig build -Djetquery_config_path=/path/to/config.zig
```

When this file exists, _JetQuery_ can be auto-loaded with `Repo.loadConfig`:

```zig
var repo = try jetquery.Repo(.postgresql, Schema).loadConfig(allocator, .development, .{});
```

This will load the parameters defined in the `development` section of the configuration file. The configuration file format is identical to _Jetzig_, so you can use the [Configuration](/documentation/sections/database/configuration) guide as reference.

### Manual Configuration

Alternatively, a `Repo` can be created by calling `init` and passing the required configuration:

```zig
var repo = try Repo(.postgresql, Schema).init(
    allocator,
    .{
        .adapter = .{
            .database = "postgres",
            .username = "postgres",
            .hostname = "127.0.0.1",
            .password = "password",
            .port = 5432,
        },
    },
);

defer repo.deinit();
```

## Usage

All of the documentation for _Jetzig_'s interface to _JetQuery_ can be used as a guide for general _JetQuery_ usage. There is one key difference between the interface with _Jetzig_ abstracts from the user but otherwise the interface is identical.

Generating a query in _Jetzig_ is achieved by calling `jetzig.database.Query(.ModelName)`. When using _JetQuery_ independently, you must pass the adapter name and `Schema` to the query:

```zig
const query = jetquery.Query(.postgresql, Schema, .Cat).findBy(.{ .name = "Hercules" });
const cat = try repo.execute(query);
// or
const cat = try query.execute(&repo);
defer repo.free(cat);
```

This difference can easily be hidden by writing your own `Query` function:

```zig
pub fn Query(comptime model: anytype) type {
    return jetquery.Query(.postgresql, Schema, model);
}
```

This is almost identical to the implementation that _Jetzig_ uses: [src/jetzig/database.zig](https://github.com/jetzig-framework/jetzig/blob/main/src/jetzig/database.zig).

## Events

Whenever _JetQuery_ executes a statement in the database, a default event callback is triggered. This callback receives a `jetquery.events.Event` which contains various information about the event.

Pass a function with the following signature to the `eventCallback` option on `Repo` initialization:

```zig
fn callbackFn(event: jetquery.events.Event) !void
```

The format of the event data is likely to change but should stabilize in future releases and changes should be easy to adapt to as they will express the same data in a more coherent structure.

## Lazy Connect

The `lazy_connect` option (default: `false`) defers connecting to the database to the first time a query is issued, otherwise the connection pool is initialized as soon as the `Repo` is created.

## Migrations

_Jetzig_ provides some extra command line tooling for generating and running migrations, but the heavy lifting is done by _JetQuery_.

Create migrations in a directory named `migrations` (configure with `-Djetquery_migrations_path`) and then execute them with the following code:

```zig
const Migrate = @import("jetquery_migrate").Migrate;
const MigrateSchema = @import("jetquery_migrate").MigrateSchema;

var repo = try jetquery.Repo(.postgresql, MigrateSchema).loadConfig(allocator, .development, .{});

try Migrate(config.adapter).init(&repo).migrate();
```

Roll back a migration:

```zig
try Migrate(config.adapter).init(&repo).rollback();
```

See the [Migrations](/documentation/sections/database/migrations) documentation for details on how to define migration files.
