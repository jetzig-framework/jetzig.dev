# Object

A _Jetzig_ `Object` behaves similarly to a _Zig_ `std.StringHashMap`.

In accordance with the [JSON specification](https://www.json.org/json-en.html), all keys in an `Object` are strings.

## Member Functions

### `put`

```zig
pub fn put(self: *Object, key: []const u8, value: ?*Value) !void
```

Put a given `*Value` into an `Object` under the fieldname `key`.

### `get`

```zig
pub fn get(self: Object, key: []const u8) ?*Value
```

Gets a value from the `Object`.

Note that a `*Value` is always returned if the key is found in the `Object`. If the value was inserted as `null` then this is translated into a `jetzig.data.NullType`. If they key is not found then a regular _Zig_ `null` is returned. This allows you to determine if a value is missing in the `Object` or if it is present but was inserted as `null`.

This is especially useful when using `request.params()`, which returns a `*jetzig.data.Value`:

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;

    const params = try request.params();

    if (params.get("redirect")) |location| {
        switch (location.*) {
            // Value is `.Null` when param is empty, e.g.:
            // `http://localhost:8080/redirect?redirect`
            .Null => return request.redirect("http://www.example.com/", .moved_permanently),

            // Value is `.string` when param is present, e.g.:
            // `http://localhost:8080/redirect?redirect=https://jetzig.dev/`
            .string => |string| return request.redirect(string.value, .moved_permanently),

            else => unreachable,
        }
    } else {
        return request.render(.ok);
    }
}
```

### `chain`

```zig
pub fn chain(self: Object, keys: []const []const u8) ?*Value
```

Pass an array of `[]const u8` to recursively fetch values from a nested `Object`.

Returns `null` if `Value` is not `object` or if any of the provided keys are not found.

```zig
const cat = object.chain(&[_][]const u8{ "house", "bedroom", "cupboard", "cat" });
```
