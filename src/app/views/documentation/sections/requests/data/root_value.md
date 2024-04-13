# Root Value

The first call to **either** `data.object()` or `data.array()` sets the root object.

The root object in a _Jetzig_ view function is:

* The basis for all _Zmpl_ template references (e.g. `{{.message}}` will look for a `message` key in the root value)
* The returned value for all _JSON_ requests.

It is strongly recommended to always use `data.object()` instead of `data.array()` as the root value, even if you only need to output a single array of items, so that you can always add more keys in future. This is advised rather than enforced to allow users to write _API_s that are compatible with existing consumers.

## Example

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.object();

    var array = try data.array();
    try root.put("array", array);

    try array.append(data.integer(1));
    try array.append(data.integer(2));
    try array.append(data.integer(3));

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
