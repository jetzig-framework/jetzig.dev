# Value

The generic data type used throughout _Jetzig_ is `*jetzig.data.Value`.

This type is used for _Zmpl_ template values, _JSON_ output, request parameters, and will soon be used for cache and background jobs.

```zig
pub const Value = union(enum) {
    object: Object,
    array: Array,
    float: Float,
    integer: Integer,
    boolean: Boolean,
    string: String,
    Null: NullType,

    // ...
};
```

`*Value` provides a number of member functions that delegate to the relevant underlying data type. This allows you to primarily operate on the `*Value` type directly, without needing to `switch` to identify the active field. e.g. `Value.get` returns `null` if `Value.object` is not active.

## Member Functions

### `get`

```zig
pub fn get(self: *Value, key: []const u8) ?*Value
```

Returns a `*Value` when the given key is found in a `Value.object`. If `Value.object` is not active, returns `null`. If key is not found, returns `null`.

If key is present but was set to `null`, `Value.Null` is returned. This allows you to switch on the returned value and identify keys that exist but have no value.

For example, `request.params()` returns a `*Value` and allows detection of query params that have no value, or a _JSON_ request body with `null` values:

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

### `getT`

```zig
pub fn getT(self: *Data, comptime T: ValueType, key: []const u8) ?switch (T) {
    .object => *Object,
    .array => *Array,
    .string => []const u8,
    .float => f128,
    .integer => i128,
    .boolean => bool,
    .Null => null,
}
```

Returns the underlying type of the `*Value` matching the given key. Returns `null` if a match is found but with the wrong type.

`getT` can significantly reduce boilerplate by removing the need to `switch` on `Value`.

Note that the following example is not identical to the example given for `get` as it does not detect when the `redirect` query param is provided but with no value. If this functionality is required, `get` must be used with `switch`.

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;

    const params = try request.params();

    if (params.getT(.string, "redirect")) |location| {
        return request.redirect(location, .moved_permanently);
    } else {
        return request.render(.ok);
    }
}
```

### `chain`

```zig
pub fn chain(self: *Value, keys: []const []const u8) ?*Value
```

Pass an array of `[]const u8` to recursively fetch values from a nested `Object`.

Returns `null` if `Value.object` is not active or if any of the provided keys are not found.

### `put`

```zig
pub fn put(self: *Value, key: []const u8, value: ?*Value) !void
```

Put a given `*Value` into a `Value.object` under the fieldname `key`.

### `append`

```zig
pub fn append(self: *Value, value: ?*Value) !void
```

Appends a `*Value` to a `Value.array`. When `value` is `null`, `Value.Null` is appended.

### `count`

```zig
pub fn count(self: *Value) usize
```

Returns the current number of items in a a `Value.array` or `Value.object`.

### `items`

```zig
pub fn items(self: *Value, comptime selector: IteratorSelector) []switch (selector) {
    .array => *Value,
    .object => Item,
}
```

Receives a selector which must be `.array` or `.object`.

When selector is `.array`, returns an array of `*Value`.

When selector is `.object`, returns an array of `Item`:

```zig
const Item = struct {
    key: []const u8,
    value: *Value,
};
```
