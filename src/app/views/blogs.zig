const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    const query = request.query(.Blogs).select(&.{ .id, .title });
    var result = try request.repo.execute(query);

    var root = try data.root(.object);
    try root.put("blogs", try result.all(query));

    return request.render(.ok);
}

pub fn get(id: []const u8, request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    const query = request.query(.Blogs).select(&.{ .id, .title, .content }).where(.{ .id = id }).limit(1);
    var result = try request.repo.execute(query);

    var root = try data.root(.object);
    if (try result.next(query)) |blog| {
        try root.put("blog", blog);
    } else {
        return request.render(.not_found);
    }
    return request.render(.ok);
}

pub fn new(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    return request.render(.ok);
}

pub fn post(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    const params = try request.params();
    const title = params.get("title").?;
    const content = params.get("content").?;
    const query = request.query(.Blogs).insert(.{ .title = title, .content = content });
    _ = try request.repo.execute(query);
    return request.redirect("/blogs", .moved_permanently);
}

test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/blogs", .{});
    try response.expectStatus(.ok);
}

test "get" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/blogs/example-id", .{});
    try response.expectStatus(.ok);
}
