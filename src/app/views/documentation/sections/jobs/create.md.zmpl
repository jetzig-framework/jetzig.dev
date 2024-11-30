# Creating Jobs

Jobs can be created using the _Jetzig CLI_ tool:

```console
$ jetzig generate job iguanas
```

The above command creates a file `src/app/jobs/iguanas.zig` with a single function declaration:

```zig
const jetzig = @import("jetzig");
const std = @import("std");

pub fn run(allocator: std.mem.Allocator, params: *jetzig.data.Value, env: jetzig.jobs.JobEnv) !void {
    _ = allocator;
    _ = params;
    // Job execution code goes here. Add any code that you would like to run in the background.
    try env.logger.INFO("Running a job.", .{});
}
```

## Job Arguments

All jobs receive the same arguments, each of which is covered in the sections below.

### `allocator`

An arena allocator scoped to each invocation of each job. Use this allocator as needed during the job execution. All allocated memory is freed when the job finishes processing.

### `params`

A flexible data structure containing arbitrary _JSON_-compatible data. Params are passed to a job when the job is scheduled (see _Scheduling_).

See the _Data_ section of this documentation for more information on this data type.

### `env`

The `env` argument provides access to a number of useful _Jetzig_ internals:

```zig
/// Environment passed to all jobs.
pub const JobEnv = struct {
    /// The Jetzig server logger
    logger: jetzig.loggers.Logger,
    /// The current server environment, `enum { development, production }`
    environment: jetzig.Environment.EnvironmentName,
    /// All routes detected by Jetzig on startup
    routes: []*const jetzig.Route,
    /// All mailers detected by Jetzig on startup
    mailers: []const jetzig.MailerDefinition,
    /// All jobs detected by Jetzig on startup
    jobs: []const jetzig.JobDefinition,
    /// Global key-value store
    store: *jetzig.kv.Store,
    /// Global cache
    cache: *jetzig.kv.Store,
    /// Database repo
    repo: *jetzig.database.Repo,
    /// Global mutex - use with caution if it is necessary to guarantee thread safety/consistency
    /// between concurrent job workers
    mutex: *std.Thread.Mutex,
};
```
