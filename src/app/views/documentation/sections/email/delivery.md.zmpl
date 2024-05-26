# Email Delivery

Email delivery in _Jetzig_ consists of invoking `request.mail()` with two arguments:

* The name of the _Mailer_, e.g. `iguanas` invokes the _Mailer_ `src/app/mailers/iguanas.zig`.
* `jetzig.mail.MailParams`: a set of parameters that override any default values configured for the _Mailer_. This can be an empty value (`.{}`) if no overrides are needed. In a typical use case, the _Mailer_ provides default values for `from` and `subject` and the _View_ assigns a `to` address array.

## Basic Example

Invoke `request.mail` in a _View_ function to create an email, then call `mail.deliver` and specify a delivery strategy:

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    const mail = request.mail("welcome", .{ .to = &.{"user@example.com"} });
    try mail.deliver(.background, .{});

    return request.render(.ok);
}
```

## Delivery Strategies

Two delivery strategies are available:

* `.background`: Create a _Job_ for the mail delivery, offloading email delivery to the _Job Queue_ and immediately continue processing the request.
* `.now`: Deliver the email inline, blocking the request until the email has been delivered.

## Email Template Data

The template data for an email is identical to the response data for a request. Calling `request.mail` automatically transfers the current response data to the _Mailer_.

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.root(.object);

    try root.put("message", "Welcome to Jetzig!");

    const mail = request.mail("welcome", .{ .to = &.{"user@example.com"} });
    try mail.deliver(.background, .{});

    return request.render(.ok);
}
```

The `message` field can then be used in `html.zmpl` and `text.zmpl`. e.g., `src/app/mailers/iguanas/html.zmpl` might look like this:

```html
<div>{\{.message}}</div>
<div>Thank you for your interest in Jetzig.</div>
```
If you need to customize template data specifically for the _Mailer_, modify the `params` argument in your _Mailer_'s `deliver` function:

```zig
pub fn deliver(
    allocator: std.mem.Allocator,
    mail: *jetzig.mail.MailParams,
    data: *jetzig.data.Data,
    params: *jetzig.data.Value,
    env: jetzig.jobs.JobEnv,
) !void {
    _ = allocator;
    try params.put("message", data.string("Message override"));
    try params.put("token", data.string("secret-token"));

    try env.logger.INFO("Delivering email with subject: '{?s}'", .{mail.get(.subject)});
}
```
