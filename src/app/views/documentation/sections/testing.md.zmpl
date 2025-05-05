# Testing

A test framework is included with all _Jetzig_ applications. The test framework provides the following components:

* Custom test runner.
* Full Jetzig app for executing requests.
* Various matchers (e.g. response code, headers, JSON content, etc.).

## Test Runner

Invoke the _Jetzig_ test runner using the CLI:

```console
jetzig test
```

If you prefer not to use the _Jetzig_ CLI tool, invoke the test step directly:

```console
zig build -Denvironment=testing jetzig:test
```

## Test App

Tests in view functions are automatically generated when using the `jetzig generate view` command. Use the default tests as a template to add further tests to your application as needed.


### Requests

Issue a request first by creating a new test app and then invoke `request` with the appropriate parameters:

```zig
test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/horses", .{});
    try response.expectStatus(.ok);
}
```

`request` expects the following parameters:

1. The HTTP verb as an enum (`.GET`, `.POST`, `.PATCH`, etc.)
1. The target request path.
1. Request options.

#### Request Options

The following options are supported:

* `headers` - HTTP headers to inclued in the request.
* `json` - a struct to be serialized into a JSON string and sent as the request body.
* `params` - a struct to be serialized into an HTTP query string and appended to the request path.
* `body` - a raw string to be sent as the request body.

Full example using all options (note that only one of `json`, `body` should be specified):

```zig
const response = try app.request(.GET, "/foo", .{
    .headers = .{
        .@"content-type" = "application/json",
        .accept = "application/json"
    },
    .json = .{
        .foo = .{ 1, 2, 3 },
        .bar = .{ .baz = "qux" }
    },
    .params = .{ .foo = "bar", .baz = "qux" },
    .body = "foobarbazqux",
});
```

## Matchers

Each `jetzig.testing.TestResponse` (returned from `app.request`) provides the following methods to simplify common web application expectations.

### expectStatus

Expect a response to have the provided HTTP status code.

```zig
test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/horses", .{});
    try response.expectStatus(.ok);
}
```

### expectBodyContains

Expect a given text string inside raw response body.

```zig
test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/horses", .{});
    try response.expectBodyContains("<h1>A List of Horses</h1>");
}
```

### expectJson

Pass a `Data` path and a value that should be found at that path inside the decoded _JSON_ response body.

For example, with the following _JSON_ response body:

```json
{
   "app" : {
      "horses" : [
         "Mr. Horse"
      ]
   }
}
```

... the following expectation passes:

```zig
test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/horses", .{});
    try response.expectJson("$.app.horses.0", "Mr. Horse");
}
```

### expectHeader

Expect at least one response header with the given name to match the given value. `null` is permitted as an expected value (i.e. the header is not present in the response).

```zig
test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/horses", .{});
    try response.expectHeader("Content-Type", "text/html");
}
```

### expectRedirect

Expect that the response has a status of `301` or `302` and that the `Location` header contains the given value.

```zig
test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/ponies", .{});
    try response.expectRedirect("/horses");
}
```

### expectJob

Expect that, during the rendering of a request, a job with the specified name and params was added to the job queue.

Note that the actual params must only be a superset of the expected params - any extra params used to create the job that are not specified in the expectation are ignored. This avoids issues where e.g. random data is added to a job's params.

```zig
pub fn get(request: *jetzig.Request, id: []const u8) !jetzig.View {
    var job = try request.job("feed_horse");
    try job.params.put("horse", id);
    try job.params.put("random-number", data.integer(std.crypto.random.int(u32)));
    try job.schedule();

    return request.render(.ok);
}

test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/horses/harry-the-horse", .{});
    try response.expectJob("feed_horse", .{ .horse = "harry-the-horse" });
}
```
