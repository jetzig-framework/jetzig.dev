# Anti-CSRF

Cross-site request forgery protection is implemented as _middleware_ by storing a randomly-generated value in the encrypted user session cookie which is then compared with a query param for the following _HTTP_ verbs:

* `POST`
* `PUT`
* `PATCH`
* `DELETE`

## Middleware

Enable the anti-CSRF middleware:

```zig
// src/main.zig

pub const jetzig_options = struct {
    pub const middleware: []const type = &.{
        jetzig.middleware.AntiCsrfMiddleware,
    };
};
```

## Actions

If you prefer to only enable the middleware for selected views, use the _Anti-CSRF_ middleware's provided [Actions](/documentation/sections/requests/actions):

```zig
// src/app/views/contact.zig

pub const actions = .{
    .before = .{jetzig.middleware.AntiCsrfMiddleware},
};

pub const index(request: *jetzig.Request) !jetzig.View {
    // ...
}
```

## Authenticity Token

An authenticity token is generated when one of the _Zmpl_ template helpers are invoked. The value is automatically stored in the user's session when it is generated.

Two helpers are available in templates:

* `context.authenticityToken()`: Returns only the token and nothing else.
* `context.authenticityFormElement()`: Returns a hidden `<input />` field that can be included directly in a form.

```zmpl
<form action="/contact" method="POST">
    {\{context.authenticityFormElement()}}
    <input name="email" type="text" />
    <textarea name="message"></textarea>
    <input type="submit" />
</form>
```

You can test this functionality by manually deleting the `_jetzig_session` cookie after loading the form. Requests without a valid token render `403 Forbidden`.
