# Actions

Use _actions_ to specify code that should be executed `before` or `after` a view is rendered.

Configure _actions_ by declaring `pub const actions` anywhere in the top level of a view.

An action can refer to either:

1. A function that exists in the current scope.
1. A type that implements `beforeRender` or `afterRender`.

This allows defining functions within a view (or imported from elsewhere) as well as passing a middleware type which can provide extended functionality for specific views.

If any `before` action renders (this includes `redirect` and `fail`) then no further processing takes place.

Any number of actions can be configured for each context. Actions are called in the same order as they appear in each `before` or `after` configuration.

## Example

```zig
// src/app/views/example.zig

const jetzig = @import("jetzig");

pub const actions = .{
    .before = .{before},
    .after = .{after},
};

fn before(request: *jetzig.Request, route: jetzig.Route) !void {
    if (route.action == .index) {
        _ = request.fail(.forbidden);
    }
}

fn after(request: *jetzig.Request, response: *jetzig.Response, route: jetzig.Route) !void {
    if (route.action == .index) {
        try request.server.logger.DEBUG(
            "Response code was: {s}",
            .{@tagName(response.status_code)},
        );
    }
}


pub fn index(request: *jetzig.Request) !jetzig.View {
    return request.render(.ok);
}
```
