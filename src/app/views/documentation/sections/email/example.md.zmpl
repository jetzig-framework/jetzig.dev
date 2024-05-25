# Email Example

The example below provides a full _Mailer_ setup, _View_ function, and _HTML_ and _Text_ part _Zmpl_ templates.

Use `jetzig generate view` and `jetzig generate mailer` to generate the majority of this code automatically.

## View

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.object();
    try root.put("message", data.string("Welcome to Jetzig!"));

    const params = try request.params();

    if (params.getT(.string, "email")) |recipient| {
        const mail = request.mail("welcome", .{ .to = &.{recipient} });
        try mail.deliver(.background, .{});

        return request.render(.ok);
    } else {
        return request.render(.unprocessable_entity);
    }
}
```

## Mailer

Since we refer to `request.mail("welcome", ...)` above, the mailer below should be named `src/app/mailers/welcome.zig`.

The mailer was scheduled using the `.background` delivery strategy, so everything in the `deliver` function is executed by a background thread:

```zig
const std = @import("std");
const jetzig = @import("jetzig");

pub const defaults: jetzig.mail.DefaultMailParams = .{
    .from = "no-reply@example.com",
    .subject = "Default subject",
};

pub fn deliver(
    allocator: std.mem.Allocator,
    mail: *jetzig.mail.MailParams,
    data: *jetzig.data.Data,
    params: *jetzig.data.Value,
    env: jetzig.jobs.JobEnv,
) !void {
    _ = allocator;

    if (std.mem.eql(u8, mail.get(.from), "debug@example.com")) {
        // Override the mail subject in certain scenarios.
        mail.subject = "DEBUG EMAIL";
    }

    try params.put("token", data.string("secret-token"));
    try env.logger.INFO("Delivering email with subject: '{?s}'", .{mail.get(.subject)});
}
```

## HTML template

Following the `welcome` naming convention, this template should be named `src/app/mailers/welcome/html.zmpl`.

Note that both `.message` (assigned in the _View_ function) and `.token` (assigned in the `deliver` function) are available:

```html
<div>Hello! Here is an important message: {\{.message}}</div>

<div>Your secret token is: {\{.token}}</div>
```

## Text template

To ensure that your email is readable by all email clients, the _Text_ part of the email should include a simplified version of the output without any _HTML_. Both _HTML_ and _Text_ parts receive identical template data.

The _Text_ template should be named `src/app/mailers/welcome/text.zmpl`.

```
Hello! Here is an important message: {\{.message}}

Your secret token is: {\{.token}}
```

This concludes everything you need to know about email delivery in _Jetzig_.
