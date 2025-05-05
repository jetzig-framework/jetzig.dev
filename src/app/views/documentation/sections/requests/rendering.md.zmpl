# Rendering

_Jetzig_ renders a response when a call to `request.render` is made.

The `render` function receives an _HTTP_ response code as its only argument and the result of this function must be returned immediately (double renders will cause an error).

For example `return request.render(.ok)` will render a `200 OK` response.

To abort a request at any time, use `request.fail`:

```zig
return request.fail(.not_found);
```

This prevents any templates from rendering and immediately returns an error page.

## HTML

_HTML_ rendering is achieved through the _Zmpl_ templating language, a component of the _Jetzig_ framework.

Templates must be named after the view function. For example, the `index` function in `src/app/iguanas.zig` will render a template in `src/app/views/iguanas/index.zmpl`.

If a template cannot be located for an `html` request, a `404 Not Found` response is rendered.

Template data can be created by using the `data` argument to each view function. See the _Zmpl Templates_ and _Data_ documentation for more details.

## JSON

_JSON_ rendering occurs when the appropriate request format is received (see the _Requests_ introduction for full details on request formats).

It _Jetzig_, template data and _JSON_ data are interchangeable. Any values created with the `data` function parameter are automatically rendered when a _JSON_-format request arrives.

See the _Data_ documentation for more details.

## Text

Render text directly using `request.renderText`. Use this option when you have some raw text that can be rendered directly, bypassing the template/JSON layers.

```zig
pub fn index(request: *jetzig.Request) !jetzig.View {
    request.response.content_type = "text/xml";
    return request.renderText("<foo><bar>baz</bar></foo>", .ok);
}
```

## Example

The below example, taken from the `downloads.zig` view of this website shows a complete view function. It is automatically capable of responding to _JSON_ and _HTML_ requests.

Try visiting the following _URL_s to see the view's output:

* [https://jetzig.dev/downloads.html](https://jetzig.dev/downloads.html)
* [https://jetzig.dev/downloads.json](https://jetzig.dev/downloads.json)

```zig
const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request) !jetzig.View {
    var root = try request.data(.object);
    var downloads = try root.put("downloads", .array);

    const file = try std.fs.openFileAbsolute("/var/www/jetzig_downloads.json", .{});
    defer file.close();
    const json = try file.readToEndAlloc(request.allocator, 1024);
    const downloads_data = try std.json.parseFromSlice([]Download, request.allocator, json, .{});

    for (downloads_data.value) |download_datum| {
        try downloads.append(download_datum);
    }

    return request.render(.ok);
}

const Download = struct { title: []const u8, path: []const u8 };
```
