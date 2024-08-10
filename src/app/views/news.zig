const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

const Schema = struct {
    pub const NewsItems = jetzig.jetquery.Table(
        "news_items",
        struct { id: usize, title: []const u8, content: []const u8 },
        .{},
    );
};

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var repo = try getRepo(request.allocator);
    const query = jetzig.jetquery.Query(Schema.NewsItems).init(request.allocator).select(&.{ .id, .title, .content });
    defer query.deinit();

    var result = try repo.execute(query);
    defer result.deinit();

    var root = try data.root(.object);

    while (try result.next()) |row| {
        defer row.deinit();
        try root.put("title", row.get([]const u8, "title"));
        try root.put("content", row.get([]const u8, "content"));
    }

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

fn getRepo(allocator: std.mem.Allocator) !jetzig.jetquery.Repo {
    return try jetzig.jetquery.Repo.init(
        allocator,
        .{
            .postgresql = .{
                .database = "jetzig",
                .username = "postgres",
                .hostname = "127.0.0.1",
                .password = "password",
                .port = 5432,
            },
        },
    );
}
