# Redirects

Redirects are issued by calling `request.redirect` in a view function. This function accepts two arguments:

1. The redirect _URI_ (`[]const u8`).
1. The redirect type (`enum { moved_permanently, found }`)

A request can only call `redirect` or `render` once. Multiple calls to either will result in an error.

## Example

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
  _ = data;
  return request.redirect("http://www.example.com/", .moved_permanently);
}
```
