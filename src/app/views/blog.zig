const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    const query = request.query(.Blogs).select(&.{ .id, .title, .content });
    defer query.deinit();

    var result = try request.repo.execute(query);
    defer result.deinit();

    var root = try data.root(.object);
    var blogs = try data.array();
    try root.put("blogs", blogs);

    while (try result.next(query)) |row| try blogs.append(row);

    return request.render(.ok);
}

pub fn get(id: []const u8, request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    _ = id;
    return request.render(.ok);
}

test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/news", .{});
    try response.expectStatus(.ok);
}

test "get" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/news/example-id", .{});
    try response.expectStatus(.ok);
}
