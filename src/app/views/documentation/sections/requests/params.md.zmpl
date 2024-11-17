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

### Optionals

If a field in `T` is an optional type (e.g. `?u32`) then it is considered as not required by `expectParams()`. If a param for an optional field is not present then it is assigned to `null`.

Default values can also be provided, in which case that value will only be used when the param is not present.

```zig
pub const Params = struct {
	foo: ?[]const u8, // defaults to `null`
	bar: ?[]const u8 = "hello", // defaults to "hello"
	baz: []const u8, // required, no values returned if missing
};
```

### Type Coercion

Since query params are always strings, _Jetzig_ tries to coerce all params to their target type. The string `"123"` will coerce to a `u16` but `"abc"` will not.

If type coercion fails for any param then `expectParams()` returns `null`. Information about the failures is available with `request.paramsInfo()` (see below).

### Example

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

## `paramsInfo()`

After a call to `request.expectParams(T)`, `request.paramsInfo()` returns a hash-like value providing access to information about each param.

The `ParamsInfo` type implements `format()` to assist with debugging:

```zig
std.debug.print("{?}\n", .{try request.paramsInfo()});
```

### Detailed Example

```zig
const T = struct {
	// ...
};

const params = try request.expectParams(T) orelse {
	if (try request.paramsInfo()) |info| {
		if (info.get("foo")) |param| {
			switch (param) {
				.present => |capture| {
					// `capture` is the original param value - this param was
					// parsed correctly into the target type.
				},
				.blank => {
					// This param was not present. A param is marked as `blank`
					// whether it was optional or not therefore does not imply failure.
				},
				.failed => |capture| {
					// This param errored while attempting to coerce to the target type.
                   	// `capture` is a `ParamError` with these fields:
                    // * `err`: The error that occurred during type coercion.
					// * `value`: The original param value (identical to the
                    //            capture payload for `present`).
				},
			}
		}
	}
};

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
