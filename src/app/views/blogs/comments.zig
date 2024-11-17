const std = @import("std");
const jetzig = @import("jetzig");

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

test "post" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    try app.repo.begin();
    defer app.repo.rollback() catch {};

    try app.repo.insert(.Blog, .{ .id = 1, .title = "Test", .content = "Test", .author = "Bob" });
    const response = try app.request(
        .POST,
        "/blogs/comments",
        .{
            .params = .{
                .name = "Bob",
                .content = "Test message",
                .blog_id = 1,
            },
        },
    );
    try response.expectStatus(.moved_permanently);
}
