# Params

Request params are processed transparently for a request body or a query parameter string in a _URI_. In both cases, a call to `request.params()` returns `*jetzig.data.Value`.

When the request type is `json`, the request body is automatically parsed. If a parsing error occurs, `400 Bad Request` is automatically returned.

The request body always takes precedence over query params and _Jetzig_ does not attempt to merge the two sources if both are present.

When you need to access the query params exclusively, use `request.queryParams()` which is guaranteed to parse only the query string.

## Example

The below example shows how to switch on different data types (for query params, `string` is always the active field, unless no value is present, in which case `Null` is active).

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    const params = try request.params();

    if (params.get("redirect")) |location| {
        switch (location.*) {
            // Value is `.Null` when param is empty, e.g.:
            // `http://localhost:8080/example?redirect`
            .Null => return request.redirect("http://www.example.com/", .moved_permanently),

            // Value is `.string` when param is present, e.g.:
            // `http://localhost:8080/example?redirect=https://jetzig.dev/`
            .string => |string| return request.redirect(string.value, .moved_permanently),

            else => return request.render(.unprocessable_entity),
        }
    } else {
        try data.put("message", data.string("No redirect requested"));
        return request.render(.ok);
    }
}
```
