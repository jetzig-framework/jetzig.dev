# Root Value

The root value in a request is created by calling `request.data(.object)` or `request.data(.array)`.

The root object in a _Jetzig_ view function is:

* The basis for all _Zmpl_ template references (e.g. `{\{.message}}` will look for a `message` key in the root value)
* The returned value for all _JSON_ requests.

It is strongly recommended to always use `request.data(.object)` instead of `request.data(.array)` as the root value, even if you only need to output a single array of items, so that you can always add more keys in future. This is advised rather than enforced to allow users to write _API_s that are compatible with existing consumers.

## Type Inference

`put` and `append` use type inference and coercion to convert an input type to a compatible value. A compile error is raised if an incompatible value is used. In such cases, you must manually convert the type. In many use cases, _Jetzig_'s type system will manage provided inputs, including query results from _JetQuery_, deeply nested structs, native `datetime` support (`jetzig.DateTime`), and any _JSON_-compatible value.

## Nesting Objects

Pass the enum literal `.object` or `.array` to `put()` or `append()` to create a nested object/array. When using this call format, both functions return a new value.

```zig
var root = try request.data(.object);

var nested_object = try root.put("foo", .object);
try nested_object.put("bar", "baz");

var nested_array = try root.put("qux", .array);
try nested_array.append("quux");
```

## Example

```zig
pub fn index(request: *jetzig.Request) !jetzig.View {
    var root = try request.data(.object);

    var array = try root.put("array", .array);

    try array.append(1);
    try array.append(2);
    try array.append(3);

    return request.render(.ok);
}
```

A `json` request to this endpoint will render this output:

```json
{
  "array": [
    1,
    2,
    3
  ]
}
```
