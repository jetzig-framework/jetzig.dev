<div>
@partial h3("Easy email delivery with content templating", "ms-5")

@markdown MARKDOWN

```zig
pub fn post(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var object = try data.object();
    const params = try request.params();

    // Set mail template params.
    try object.put("from", params.get("from"));
    try object.put("message", params.get("message"));

    // Create email.
    const mail = request.mail("contact", .{ .to = &.{"hello@jetzig.dev"} });

    // Deliver asynchronously.
    try mail.deliver(.background, .{});

    return request.render(.created);
}
```
MARKDOWN
</div>

<div>
@partial h3("Background jobs", "ms-5")

@markdown MARKDOWN

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    // Prepare a job using `src/app/jobs/example.zig`.
    var job = try request.job("example");

    // Add params to the job.
    try job.params.put("foo", data.string("bar"));
    try job.params.put("id", data.integer(std.crypto.random.int(u32)));

    // Schedule the job for background processing.
    try job.schedule();

    return request.render(.ok);
}
```
MARKDOWN
</div>
