# Data

_Jetzig_ provides a flexible `Data` type that is used throughout the framework. This type allows you to store any _JSON_-compatible value.

## Creating values

Every view function receives a `*jetzig.Data` argument. This type provides functions for creating various generic data types:

* `object`
* `array`
* `string`
* `integer`
* `float`
* `boolean`

The return value of each of the above functions is always `*jetzig.Data.Value`, allowing you to compose complex objects and arrays at runtime without the need to pre-define response data structures.

The example below demonstrates each of the available type creation functions:

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.object();

    try root.put("name", data.string("Bob"));
    try root.put("balloons", data.integer(99));
    try root.put("pi", data.float(3.1415));
    try root.put("enabled", data.boolean(true));
    try root.put("empty", null);

    var nested = try data.object();
    try nested.put("example", data.string("a nested value");

    try root.put("nested", nested);

    var array = try data.array();
    try array.append(data.string("a string in an array"));

    try root.put("array", array);

    return request.render(.ok);
}
```

Inside a _Zmpl_ `zig` mode block in a _Zmpl_ template, the full `*jetzig.Data` value is available as `zmpl`. See the _Member Functions_ section below for full usage instructions.

## Member Functions

### `get`

```zig
pub fn get(self: *Data, key: []const u8) ?*Value
```

If the _Root Value_ is `object`, retrieves the `*Value` for the given key, if present. Otherwise, returns `null`.

```zig
\@zig {
    if (zmpl.get("foobar")) |foobar| {
        {\{foobar}}
    }
}
```

In most cases, the _Reference_ syntax provides a more convenient way of rendering values:
```zig
{\{.foobar}}
```

Use `get` if you need to work with values inside a _Zmpl_ `zig` mode block, e.g. perform conditional logic on the presence/absence of a given key.

### `chain`

```zig
pub fn chain(self: *Data, keys: []const []const u8) ?*Value
```

Pass an array of `[]const u8` to recursively fetch values from a nested `Value`.

Returns `null` if `Value` is not `object` or if any of the provided keys are not found.

```zig
\@zig {
    if (zmpl.chain(&[_][]const u8{ "user", "profile", "height" })) |height| {
          <div>User is {\{height}}cm tall.</div>
    }
}
```

### `items`

```zig
pub fn items(self: *Data, comptime selector: IteratorSelector) []switch (selector) {
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

Use `zmpl.items(.array)` or `zmpl.items(.object)` in a _Zmpl_ template to iterate over the _Root Value_ with a `for` loop:

```zig
\@zig {
  <ul>
  for (zmpl.items(.array)) |value| {
    <li>{\{value}}</li>
  }
  </ul>
}
```

```zig
\@zig {
  <ul>
  for (zmpl.items(.object)) |item| {
    const key = item.key;
    const value = item.value;
    <li>{\{key}}: {\{value}}</li>
  }
  </ul>
}
```

### `toJson`

```zig
pub fn toJson(self: *Data) ![]const u8
```

Converts a `*jetzig.Data` to a _JSON_ string. Since all values stored in `*jetzig.Data` are _JSON_-compatible, this function is guaranteed to always return a valid _JSON_ string.

```zig
const json = try data.toJson();
```

### `fromJson`

```zig
pub fn fromJson(self: *Data, json: []const u8) !void
```

Resets **all** stored values in the current `*Data` and sets a new `*Value` tree from the parsed _JSON_ string.
```zig
try data.fromJson(
    \\{"foo": "bar"}
);
```

### `object`

```zig
pub fn object(self: *Data) !*Value
```

Creates a new `*Value.object`.

### `array`

```zig
pub fn array(self: *Data) !*Value
```

Creates a new `*Value.array`.

### `string`

```zig
pub fn string(self: *Data, value: []const u8) *Value
```

Creates a new `*Value.string`.

### `integer`

```zig
pub fn integer(self: *Data, value: i128) *Value
```

Creates a new `*Value.integer`.

### `float`

```zig
pub fn integer(self: *Data, value: f128) *Value
```

Creates a new `*Value.float`.

### `boolean`

```zig
pub fn boolean(self: *Data, value: bool) *Value
```

Creates a new `*Value.boolean`.
