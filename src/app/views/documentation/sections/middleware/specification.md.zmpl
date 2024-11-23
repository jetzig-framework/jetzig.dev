# Middleware Specification

Each _middleware_ is a `.zig` file that defines a public interface matching the specification covered in this document. The _Jetzig_ codebase is a good place to start to see example usage patterns.

All interface declarations are optional. _Jetzig_ only attempts to invoke a middleware hook if it is defined. Any declarations that do not match the specification are ignored.

**Important**: Read the `init` specification fully. If `init` is not defined, omit the first argument to the various hooks detailed below.

## `pub const name`

Define a name if your _middleware_ creates data that can be used by other middleware or view functions.

```zig
pub const name = "my_middleware";
```

The value returned by `init` is accessible in all _middleware_ and view functions by passing an enum literal matching the middleware name to `request.middleware`:

```zig
request.middleware(.my_middleware)
```

This website uses _Jetzig_'s [AuthMiddleware](/documentation/sections/middleware/auth) to access the currently-authenticated user:

```zig
const user = request.middleware(.auth).user;
```

## Hooks

### `pub fn init(*jetzig.Request) !*ExampleMiddleware`

`init` is called before any other _middleware_ hook. If required, use this hook to create a pointer to the root struct. If `init` is defined, all _middleware_ hooks receive an extra argument which is the value returned by `init`.

```zig
pub const ExampleMiddleware = @This();

example_value: usize,

pub fn init(request: *jetzig.Request) !*ExampleMiddleware {
    const middleware = try request.allocator.crate(ExampleMiddleware);
    middleware.* = .{ .example_value = 1000 };
    return middleware;
}
```

If you do not define `init` then the examples below operate exactly the same, but without the first `self` argument.

### `pub fn afterRequest(*ExampleMiddleware, *jetzig.Request) !void`

`afterRequest` is invoked immediately after the initial processing of the request, before any view functions are called.

The full request is available, providing access to the request body, params, session, cookies, ec., the same as inside a view function.

If any of the following are invoked during `afterRequest`, no further request processing takes place and the response is returned to the client:

* `request.render`
* `request.redirect`
* `request.fail`

```zig
pub fn afterRequest(self: *ExampleMiddleware, request: *jetzig.http.Request) !void {
    const params = try request.params();
    if (params.getT(.string, "abort")) {
        _ = request.fail(.not_found);
    }

    try request.server.logger.WARN("Request aborted: {}", .{self.example_value});
}
```

### `pub fn beforeResponse(*ExampleMiddleware, *jetzig.Request, *jetzig.Response) !void`

`beforeResponse` is invoked immediately before the response is sent to the client, after any view functions have executed. The request and response can still be modified at this point.

```zig
pub fn beforeResponse(*ExampleMiddleware, *jetzig.Request, *jetzig.Response) !void {
    if (std.mem.eql(u8, request.path.extension, ".xml")) {
        try response.headers.append("content-type", "application/xml");
        try request.server.logger.INFO("XML content type detected ({})", .{self.example_value});
    }
}
```

### `pub fn afterResponse(*ExampleMiddleware, *jetzig.Request, *jetzig.Response) !void`

`afterResponse` is invoked immediately after the response is sent to the client. The request and response are still available for inspection but any modifications will have no impact as the response has already been fully processed.

```zig
pub fn afterResponse(self: *ExampleMiddleware, request: *jetzig.Request, response: *jetzig.Response) !void {
    try request.server.logger.INFO(
        "Finished processing: {s}. Response code: {s}. {}",
        .{ request.path.path, @tagName(response.status_code), self.example_value },
    );
}
```

### `pub fn deinit(self: *ExampleMiddleware) void`

Any resources allocated with the arena allocator `request.allocator` are automatically freed by _Jetzig_, however you may still need to do some clean-up. Use `deinit` for this purpose if required.

```zig
pub fn deinit(self: *ExampleMiddleware, request: *jetzig.Request) void {
    request.allocator.destroy(self);
}
```

## Actions

_Middleware_ can also define _Actions_. This allows middleware to be used selectively in a `before` or `after` action definition in a view, instead of (or as well as) globally applying middleware to all requests.

The relevant functions can be passed directly to the action configuration or, for convenience, passing the entire middleware type (e.g. `ExampleMiddleware`) to `before` and/or `after` automatically selects the appropriate function for each case.

### `beforeRender(*jetzig.Request, jetzig.Route) !void`

Called before the relevant view function (`index`, `get`, `post`, etc.) is invoked.

Just like _Hooks_ defined above, if `beforeRender` renders, redirects, or fails the request, the request processing chain is terminated and the response is returned to the client.

### `afterRender(*jetzig.Request, *jetzig.Response, jetzig.Route) !void`

Called after a view function has finished executing. The response has not yet been sent to the client and can still be modified.

See the [Actions](/documentation/sections/requests/actions) documentation for more information.
