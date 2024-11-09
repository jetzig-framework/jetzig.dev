const std = @import("std");
const jetzig = @import("jetzig");
const Query = jetzig.database.Query;

pub const layout = "application";

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    const blogs = try Query(.Blog)
        .select(.{})
        .orderBy(.{ .created_at = .descending })
        .all(request.repo);

    var root = try data.root(.object);
    try root.put("blogs", blogs);

    return request.render(.ok);
}

pub fn get(id: []const u8, request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.root(.object);

    const query = Query(.Blog)
        .include(.comments, .{ .order_by = .{ .created_at = .desc } })
        .find(id);

    var blog = try query.execute(request.repo) orelse return request.fail(.not_found);

    blog.content = try jetzig.markdown.render(request.allocator, blog.content, .{});
    try root.put("blog", blog);

    return request.render(.ok);
}

pub fn new(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    return request.render(.ok);
}

pub fn post(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    const user = request.middleware(.auth).user;

    if (user == null) return request.fail(.unauthorized);

    const params = try request.params();
    const title = params.get("title").?;
    const content = params.get("content").?;
    try jetzig.database.Query(.Blog)
        .insert(.{ .title = title, .content = content, .author = user.?.email })
        .execute(request.repo);
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

    try app.repo.begin();
    defer app.repo.rollback() catch {};

    try jetzig.database.Query(.Blog).insert(.{
        .id = 1,
        .title = "Test Blog",
        .content = "Test Content",
        .author = "Bob",
    }).execute(app.repo);

    const response = try app.request(.GET, "/blogs/1", .{});
    try response.expectStatus(.ok);
}
