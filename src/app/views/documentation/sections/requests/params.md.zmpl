# Params

Request params are processed transparently for a request body or a query parameter string in a _URI_. In both cases, a call to `request.params()` returns `*jetzig.data.Value`.

When the request type is `json`, the request body is automatically parsed. If a parsing error occurs, `400 Bad Request` is automatically returned.

The request body always takes precedence over query params and _Jetzig_ does not attempt to merge the two sources if both are present.

When you need to access the query params exclusively, use `request.queryParams()` which is guaranteed to parse only the query string.

## `expectParams()`

The recommended way to access request params is with `request.expectParams()`.

`request.expectParams()` receives a `struct` argument `T` and returns either `null` or a new instance of `T`.

`null` is returned in the following cases:

* One or more non-optional fields defined in `T` were not found in the request params.
* One or more fields errored during type coercion to the target type defined by a field in `T`.

After a call to `request.expectParams()`, `request.paramsInfo()` can be called to inspect the specific state of each parameter.

The following example from this website's [blogs/comments.zig](https://github.com/jetzig-framework/jetzig.dev/blob/main/src/app/views/blogs/comments.zig) view shows how parameters from a form are translated and used to insert a record into the database:

```zig
pub fn post(request: *jetzig.Request) !jetzig.View {
    const Comment = struct {
        name: []const u8,
        content: []const u8,
        blog_id: u32,
    };

    const params = try request.expectParams(Comment) orelse {
        return request.fail(.unprocessable_entity);
    };

    const query = jetzig.database.Query(.Comment).insert(.{
        .name = params.name,
        .content = params.content,
        .blog_id = params.blog_id,
    });
    try request.repo.execute(query);

    return request.redirect(
        try request.joinPath(.{ "/blogs", params.blog_id }),
        .moved_permanently,
    );
}
```

## Accessing Params Directly

In some cases it may be required to access parameters directly without using `expectParams`.

The below example shows how to switch on different data types (for query params, `string` is always the active field, unless no value is present, in which case `null` is active).

```zig
pub fn index(request: *jetzig.Request) !jetzig.View {
    const params = try request.params();

    if (params.get("redirect")) |location| {
        switch (location.*) {
            // Value is `.null` when param is empty, e.g.:
            // `http://localhost:8080/example?redirect`
            .null => return request.redirect("http://www.example.com/", .moved_permanently),

            // Value is `.string` when param is present, e.g.:
            // `http://localhost:8080/example?redirect=https://jetzig.dev/`
            .string => |string| return request.redirect(string.value, .moved_permanently),

            else => return request.render(.unprocessable_entity),
        }
    } else {
        var root = try request.data(.object);
        try root.put("message", "No redirect requested");
        return request.render(.ok);
    }
}
```
