# Creating Mailers

Use the _Jetzig CLI_ tool to create a _Mailer_:

```console
$ jetzig generate mailer iguanas
```

This command creates the following files:

* `src/app/mailers/iguanas.zig`
* `src/app/mailers/iguanas/text.zmpl`
* `src/app/mailers/iguanas/html.zmpl`

## Mailer

A _Mailer_ (`src/app/mailers/iguanas.zig`) in the above example is a _Zig_ file comprising a `defaults` declaration and a `deliver` function.

When a _Mailer_ renders an email's content, the `text.zmpl` and `html.zmpl` _Zmpl_ templates are rendered before generating the full email body. Both templates are optional, but it is recommended to always send both parts to ensure compatibility with all email clients.

_Mailer_ templates work the same way as _View_ templates: any values added to the `data` argument in a _Request_ are passed to the _Mailer_ as template data, accessible within both templates. See _Delivery_ documentation for more information and examples.

### `defaults`

Use the `defaults` declaration to define default values whenever this _Mailer_ is used. When the _Mailer_ is used in a _Request_, any of these values can be overridden if required (see _Delivery_ for more information).

```zig
pub const defaults: jetzig.mail.DefaultMailParams = .{
    .from = "no-reply@example.com",
    .subject = "Default subject",
};
```

Available fields for default values:

* `subject`: `[]const u8`
* `from`: `[]const u8`
* `to`: `[]const []const u8`
* `html`: `[]const u8`
* `text`: `[]const u8`

`html` and `text` default values always take precedence over _Zmpl_ templates for a given _Mailer_.

### `deliver`

The `deliver` function is invoked immediately before the email is sent and can be used to dynamically override any mail attributes (either defaults or those assigned in a _View_ function). You can think of the `deliver` function as being roughly analogous to a _View_ function (e.g. `index`) for an email delivery.

If you do not need to modify email attributes or perform any tasks before delivery, this function can be left empty.

If the `background` delivery strategy is used, this function is performed asynchronously by a background worker thread. If `now` is used, this function is invoked inline. See _Delivery_ documentation for more information.

```zig
pub fn deliver(
    allocator: std.mem.Allocator,
    mail: *jetzig.mail.MailParams,
    data: *jetzig.data.Data,
    params: *jetzig.data.Value,
    env: jetzig.jobs.JobEnv,
) !void {
    _ = allocator;
    _ = data;
    _ = params;
    mail.to = &.{"user@example.com"}; // Override any specified value for `to`.

    try env.logger.INFO("Delivering email with subject: '{?s}'", .{mail.get(.subject)});
}
```

* `allocator`: Arena allocator for use during the mail delivery process.
* `mail`: Mail parameters. Inspect or override any values assigned when the mail was created.
* `data`: A `*jetzig.data.Data` assigned to the `deliver` function for generating new values, e.g. `data.string("foobar")`.
* `params`: Params assigned to a mail (any values added to `data` in a request). Params can be modified before email delivery.
* `env`: The current _Job_ environment. See _Creating Jobs_ for full documentation on this value.

#### `MailParams`

Note the use of `mail.get(.subject)` in the last line of the `deliver` function above. This resolves the subject that will be used when sending the email, i.e. it inspects both the received email attributes **and** the default mail attributes to determine the actual value.

Use `mail.get()` to inspect attributes, use regular assignment (`mail.subject = "foobar";`) to set attributes.

