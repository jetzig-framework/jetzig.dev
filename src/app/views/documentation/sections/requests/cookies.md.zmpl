# Cookies

Cookies in _Jetzig_ are accessible via the `cookies` method on a `Request` within a view function:

```zig
pub fn index(request: *jetzig.Request) !jetzig.View {
    var cookies = try request.cookies();
    try cookies.put(.{ .name = "foo", .value = "bar", .same_site = .lax });
    const cookie = cookies.get("foo");
    // ...
}
```

The `Cookie` type provides the following fields which can be passed to `put`:

```zig
name: []const u8,
value: []const u8,
secure: bool,
http_only: bool,
partitioned: bool,
domain: ?[]const u8,
path: ?[]const u8,
same_site: ?SameSite,
expires: ?i64,
max_age: ?i64,
```

The `same_site` field is an optional `enum`:

```zig
const SameSite = enum { strict, lax, none };
```

## Global Configuration

Default values for most cookie fields can be specified by the `cookies` declaration in your application's `jetzig_options` (in `src/main.zig`).

For example:

```zig
pub const cookies: jetzig.http.Cookies.CookieOptions = switch (jetzig.environment) {
    .development, .testing => .{
        .domain = "localhost",
        .path = "/",
    },
    .production => .{
        .same_site = .lax,
        .secure = true,
        .http_only = true,
        .path = "/",
    },
};
```

## Cookie Store Operations

### `get`

```zig
pub fn get(self: *Cookies, key: []const u8) ?*Cookie
```

Return a `Cookie` if found in the cookie store, `null` otherwise.

#### Example

```zig
pub fn index(request: *jetzig.Request) !jetzig.View {
    var root = try request.data(.object);

    var cookies = try request.cookies();

    if (cookies.get("country-code")) |cookie| {
        try root.put("location", cookie.value);
    } else {
        try root.put("location", null);
    }

    return request.render(.ok);
}
```

### `put`

```zig
pub fn put(self: *Cookies, cookie: Cookie) !void
```

Add a cookie to the cookie store. See `Cookie` field specification above for available struct initialization parameters.

#### Example

```zig
pub fn index(request: *jetzig.Request) !jetzig.View {
    var cookies = try request.cookies();
    const random_number = try std.fmt.allocPrint(request.allocator, "{}", std.crypto.random.int(u16));
    try cookies.put(.{
        .name = "random-number",
        .value = random_number,

    return request.render(.ok);
}
```

### `delete`

```zig
pub fn delete(self: *Cookies, key: []const u8) !void
```

Delete a cookie.

Note that deletion is implemented by setting a cookie whose value is an empty string and whose expiry is in the past (`0`, i.e. Unix epoch).

#### Example

```zig
pub fn index(request: *jetzig.Request) !jetzig.View {
    var cookies = try request.cookies();
    try cookies.delete("temporary-token");

    return request.render(.ok);
}
```
