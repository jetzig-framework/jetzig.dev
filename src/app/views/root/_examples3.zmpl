<div>
@partial examples_header("Easy email delivery with content templating")

@markdown MARKDOWN

```zig
pub fn post(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var object = try data.root(.object);
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
