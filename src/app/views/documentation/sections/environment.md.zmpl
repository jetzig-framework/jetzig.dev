# Environment

_Jetzig_ provides configuration options from command line arguments and environment variables for controlling various server behaviours.

All runtime options are available by passing `--help` to your compiled _Jetzig_ application, or by using `zig build run -- --help`. (_Zig_'s build system passes all arguments after `--` to the compiled application).

## Environment Mode

The environment mode for an application is defined by the `-Denvironment` build option:
```console
$ zig build -Denvironment=production
```
Available options are: `development`, `testing`, `production`.

The selected option is available as `jetzig.environment` which is comptime-known and can be used to select configuration options in `src/main.zig`. This option also controls which database configuration is selected from `config/database.zig`.

## Options

The following sections refer to command-line options that can be passed to your application at launch. For example, the `--log` option can be passed in either of the following two forms:

```console
$ zig build run -- --log /tmp/jetzig.log
```

```console
$ zig build install
$ zig-out/bin/myapp --log /tmp/jetzig.log
```

Where available, the short-hand command-line argument is also provided, e.g. `-h` is identical to `--help`.

### `-h`, `--help`

Output all available options and usage information.

### `detach`

Daemonize the server - run the server in the background and detach `stdin`, `stdout`, and `stderr`. Use this option to run your application as a service (e.g. in deployment).

### `-b`, `--bind`

Bind the server to the given _IP_ address, e.g. `127.0.0.1` (default), `0.0.0.0`, etc.

### `-p`, `--port`

Bind the server to the given port (default: `8080`).

### `--log`

Path to log file. Use `-` for `stdout`. Default is to log to `stdout`.

### `--log-error`

Path to log file only for errors. Default is to log to the same location as `--log`.

### `--log-level`

Log events below this value are ignored, e.g. if set to `INFO`, `DEBUG` and `TRACE` events are not logged.

Must be one of:

* `TRACE`
* `DEBUG`
* `INFO`
* `WARN`
* `ERROR`
* `FATAL`

Defaults to `DEBUG` in `development` environment, `INFO` in `production` environment.

### `log-format`

Set the output log format. `json` format is typically used with an external log aggregator/consumer (e.g. _Logstash_).

Must be either `development` or `json` (default: `development`).
