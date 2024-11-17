<div>
@partial examples_header("Background jobs")

@markdown MARKDOWN

```zig
pub fn index(request: *jetzig.Request) !jetzig.View {
    // Prepare a job using `src/app/jobs/example.zig`.
    var job = try request.job("example");

    // Add params to the job.
    try job.params.put("foo", "bar");
    try job.params.put("id", std.crypto.random.int(u32));

    // Schedule the job for background processing.
    try job.schedule();

    return request.render(.ok);
}
```
MARKDOWN
</div>
