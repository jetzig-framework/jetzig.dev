# Email

_Jetzig_ provides a framework for delivering emails. _Text_ and _HTML_ email parts are supported.

A _Mailer_ in _Jetzig_ consists of the following:

* A `.zig` file in `src/app/mailers/`
* A `text.zmpl` template
* A `html.zmpl` template

The `.zig` file (e.g. `src/app/mailers/example.zig`) provides:
* `pub const defaults: jetzig.mail.DefaultMailParams` - a set of default values for the _Mailer_. (e.g. `from` address).
* A `deliver` function which is invoked every time the _Mailer_ is used. This can be used for logging, modifying mail attributes dynamically, assigning email-specific template data, and performing any other tasks needed before the mail is delivered. The email is delivered immediately after this function returns. Depending on the delivery strategy, this function is executed either inline or asynchronously as a _Job_ (see _Delivery_ for more details).

Both _HTML_ and _Text_ email parts are automatically encoded by _Jetzig_ before offloading to _SMTP_.

## Development Environment

By default, emails are not sent in `development` mode. Instead, email output is sent to the server's logger. If email delivery in `development` environment is required, use the following configuration in your project's `src/main.zig`:

```
pub const jetzig_options = struct {
    pub const force_development_email_delivery = true;
};
```

Emails are always delivered to the configured _SMTP_ server in `production` environment. See _Environments_ documentation for more information.
