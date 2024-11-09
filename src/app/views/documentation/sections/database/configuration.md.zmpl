# Configuration

_Jetzig_ generates a database configuration file in `config/database.zig`.

This configuration file specifies database settings in the three available environments:

* `development`
* `testing`
* `production`

Each environment section supports the same settings. By default, the `null` database adapter is configured. This allows a _Jetzig_ application to function entirely without a database. If a database event occurs, the `null` adapter causes an error.

The example below is taken from this website's `config/database.zig`:

```zig
pub const database = .{
    .testing = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5432,
        .username = "postgres",
        .password = "password",
        .database = "jetzig_website_testing",
    },

    .development = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5432,
        .username = "postgres",
        .password = "password",
        .database = "jetzig_website_development",
    },

    .production = .{
        .adapter = .postgresql,
        .database = "jetzig_website",
    },
};
```

## Configuration from Environment Variables

In the example above, the `production` section does not contain all of the parameters used by the application. All configuration parameters, except `adapter`, can be specified by environment variables. `adapter` must be `comptime`-known in order to generate the appropriate queries during the compilation phase.

To configure _JetQuery_ with environment variables, upper-case the configuration option and prefix with `JETQUERY_`. i.e.:

* `JETQUERY_HOSTNAME`
* `JETQUERY_PORT`
* `JETQUERY_USERNAME`
* `JETQUERY_PASSWORD`
* `JETQUERY_DATABASE`
