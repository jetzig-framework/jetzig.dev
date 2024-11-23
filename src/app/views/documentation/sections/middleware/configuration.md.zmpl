# Middleware Configuration

Configure _middleware_ for your application by defining `pub const middleware` inside the `jetzig_options` struct defined in `src/main.zig`.

_Middleware_ are invoked in the order they are defined:

```zig
// src/main.zig

pub const jetzig_options = struct {
    pub const middleware: []const type = &.{
        jetzig.middleware.AntiCsrfMiddleware,
        jetzig.middleware.AuthMiddleware,
        jetzig.middleware.HtmxMiddleware,
        @import("app/middleware/MyCustomMiddleware.zig"),
    };
};
```
