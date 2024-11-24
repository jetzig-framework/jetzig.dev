const std = @import("std");
const jetzig = @import("jetzig");
const Query = jetzig.database.Query;

pub const layout = "application";

pub fn index(request: *jetzig.Request) !jetzig.View {
    const query = Query(.Blog)
        .select(.{ .id, .title, .author, .content, .created_at })
        .orderBy(.{ .created_at = .descending });

    const blogs = try request.repo.all(query);

    var root = try request.data(.object);
    try root.put("blogs", blogs);
    try root.put("is_signed_in", request.middleware(.auth).user != null);

    return request.render(.ok);
}

pub fn edit(id: []const u8, request: *jetzig.Request) !jetzig.View {
    const blog = try Query(.Blog).find(id).execute(request.repo) orelse {
        return request.fail(.not_found);
    };

    var root = try request.data(.object);
    try root.put("blog", blog);
    return request.render(.ok);
}

pub fn patch(id: []const u8, request: *jetzig.Request) !jetzig.View {
    std.debug.print("here\n", .{});
    const Params = struct { title: []const u8, content: []const u8 };
    const params = try request.expectParams(Params) orelse {
        return request.fail(.unprocessable_entity);
    };

    var blog = try Query(.Blog).find(id).execute(request.repo) orelse {
        return request.fail(.not_found);
    };

    blog.content = params.content;
    blog.title = params.title;

    try request.repo.save(blog);

    return request.redirect(
        try request.joinPath(.{ "/blogs", id }),
        .moved_permanently,
    );
}

pub fn get(id: []const u8, request: *jetzig.Request) !jetzig.View {
    var root = try request.data(.object);

    try root.put("is_signed_in", request.middleware(.auth).user != null);

    const query = Query(.Blog)
        .include(.comments, .{ .order_by = .{ .created_at = .desc } })
        .find(id);

    var blog = try query.execute(request.repo) orelse {
        return request.fail(.not_found);
    };

    blog.content = try jetzig.markdown.render(
        request.allocator,
        blog.content,
        .{},
    );
    try root.put("blog", blog);

    return request.render(.ok);
}

pub fn new(request: *jetzig.Request) !jetzig.View {
    return request.render(.ok);
}

pub fn post(request: *jetzig.Request) !jetzig.View {
    const user = request.middleware(.auth).user;

    if (user == null) return request.fail(.unauthorized);

    const Params = struct { title: []const u8, content: []const u8 };
    const params = try request.expectParams(Params) orelse {
        return request.fail(.unprocessable_entity);
    };

    try jetzig.database.Query(.Blog)
        .insert(.{
        .title = params.title,
        .content = params.content,
        .author = user.?.email,
    }).execute(request.repo);

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
