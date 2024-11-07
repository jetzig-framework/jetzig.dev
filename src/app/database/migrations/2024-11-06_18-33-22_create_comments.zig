const std = @import("std");
const jetquery = @import("jetquery");
const t = jetquery.schema.table;

pub fn up(repo: anytype) !void {
    try repo.createTable(
        "comments",
        &.{
            t.column("blog_id", .integer, .{ .not_null = true, .reference = .{ "blogs", "id" } }),
            t.column("name", .string, .{ .not_null = true }),
            t.column("content", .text, .{ .not_null = true }),
            t.timestamps(.{}),
        },
        .{},
    );
}

pub fn down(repo: anytype) !void {
    try repo.dropTable("comments", .{});
}
