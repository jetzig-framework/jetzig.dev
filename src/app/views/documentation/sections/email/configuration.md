# Email Configuration

_Jetzig_ supports _SMTP_ for email delivery, using [Karl Seguin](https://github.com/karlseguin/)'s [smtp_client.zig](https://github.com/karlseguin/smtp_client.zig).

Although _TLS 1.3_ is available, it should be used with the following understandings:

* _Zig_'s _TLS_ implementation is still new and has not been battle-tested.
* _AWS SES_ claims to support _TLS 1.3_ but this does not appear to be true (yet).

For the above reasons, at the time of writing, it is recommended to run a local _SMTP_ forwarder. For example, [https://github.com/juanluisbaptiste/docker-postfix](Juan Luis Baptiste)'s [docker-postfix](https://github.com/juanluisbaptiste/docker-postfix) provides a very simple way to run a local _SMTP_ server capable of forwarding mails securely to an external _SMTP_ service.

## SMTP Configuration

Configure _SMTP_ settings with the `pub const jetzig_options` declaration in your project's `src/main.zig`:

```zig
pub const jetzig_options = struct {
    pub const smtp: jetzig.mail.SMTPConfig = .{
        .port = 25,
        .encryption = .none, // .insecure, .none, .tls, .start_tls
        .host = "localhost",
        .username = null,
        .password = null,
    };

    pub const force_development_email_delivery = false;
};
```

Set `force_development_email_delivery` to force email delivery in `development` environment, otherwise emails are sent to the _Jetzig_ server's logger for inspection.
