# Scheduling Jobs

_Jobs_ can be scheduled from any _View_ function using `request.job("job_name")`:

The argument passed to `request.job` is the filename of the _Job_ in `src/app/jobs/` without the `.zig` extension.

`request.job("example")` refers to the job defined in `src/app/jobs/example.zig`.

## Assign job params

The return value of `request.job()` provides a `params` field which is a `*jetzig.data.Value`, the same as the type returned by `data.object()` in a _View_ function.

Use `job.params.put(key, value)` to set params exactly the same as setting _Zmpl_ template/_JSON_ response data values.

```zig
var job = try request.job("example");
try job.params.put("foo", data.string("bar");
```

## Schedule a job

Scheduling a job means immediately adding it to the job queue, allowing the _View_ function to continue processing while the job runs in the background.

One of _Jetzig_'s job worker threads will process the job when it is detected in the queue.

```zig
var job = try request.job("example");
try job.schedule();
```

## Example

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    // Prepare a job using `src/app/jobs/example.zig`.
    var job = try request.job("example");

    // Add a param `foo` to the job.
    try job.params.put("foo", data.string("bar"));
    try job.params.put("id", data.integer(std.crypto.random.int(u32)));

    // Schedule the job for background processing.
    try job.schedule();

    return request.render(.ok);
}
```

## Interoperability

_Jetzig_'s _Data_ concept is used throughout the framework, giving convenient interoperability between _Zmpl_ template/_JSON_ response data, request params, key-value store, and cache values.

The below example shows how a _View_ function can parse request params and use the same values seamlessly in response data and _Job_ params:

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.root(.object);

    const params = try request.params();
    const message = params.get("message");

    try root.put("message", message);

    var job = try request.job("example");
    try job.params.put("message", message);

    try job.schedule();

    return request.render(.ok);
}
```

In the _Job_'s `run` function, the `message` param is now accessible:

```zig
const jetzig = @import("jetzig");
const std = @import("std");

pub fn run(allocator: std.mem.Allocator, params: *jetzig.data.Value, env: jetzig.jobs.JobEnv) !void {
    _ = allocator;

    if (params.getT(.string, "message")) |message| {
        try env.logger.INFO("Job received param `message`: '{s}'", .{message});
    }
}
```

```console
INFO  [2024-05-06 13:29:30] [2.232ms/GET/200 OK] /example.json?message=hello
INFO  [2024-05-06 13:29:30] Job received param `message`: 'hello'
INFO  [2024-05-06 13:29:30] [worker-0] Job completed: example
```
