# Headers

_Jetzig_ provides `jetzig.http.Headers` for both _request_ and _response_ headers.

In a view function both sets of headers are available as:

* `request.headers`
* `request.response.headers`

## Example

The below example translates an incoming request header `example-header` and outputs its value in the response headers as `x-example-header`:

```zig
pub fn index(request: *jetzig.Request) !jetzig.View {
    if (request.headers.getFirstValue("example-header")) |value| {
        try request.response.headers.append("x-example-header", value);
    }

    return request.render(.ok);
}
```

## Member Functions

### `get`

```zig
pub fn get(self: *Headers, name: []const u8) ?[]const u8
```

Fetch the value for the **first** header matching `name`, in the order that the headers were received/appended. If no headers match, return `null`.

In accordance with the [HTTP specification](https://www.rfc-editor.org/rfc/rfc9110.html#name-field-names), header name matching is **case-insensitive**.

Use `getAll` to fetch all matching headers.

### `getAll`

```zig
pub fn getAll(self: Headers, name: []const u8) []const []const u8
```

Fetch the values for **all** headers matching `name`. If no headers match, return an empty array.

Just like `get`, matching is **case-insensitive**.

### `append`

```zig
pub fn append(self: *Headers, name: []const u8, value: []const u8) !void
```

Append a header to the end of the headers array. Names do not need to be unique.

The maximum number of headers allowed is `25`. Appending beyond this limit will return `error.JetzigTooManyHeaders`.

### `remove`

```zig
pub fn remove(self: *Headers, name: []const u8) void
```

Remove **all** matching headers from the headers array. As with `get` and `getAll`, matching is **case-insensitive**.

### `iterator`

```zig
pub fn iterator(self: Headers) Iterator
```

Return an `Iterator` which implements `next()`. Calls to `next()` return either `Header` or `null`.

```zig
const Header = struct {
    name: []const u8,
    value: []const u8,
};
```

```zig
pub fn index(request: *jetzig.Request) !jetzig.View {
    var root = try request.data(.object);
    var it = request.headers.iterator();
    while (it.next()) |header| try root.put(header.name, header.value);
    return request.render(.ok);
}
```
