const std = @import("std");
const jetquery = @import("jetquery");
const t = jetquery.schema.table;

pub fn up(repo: anytype) !void {
    try repo.createTable(
        "blogs",
        &.{
            t.primaryKey("id", .{}),
            t.column("title", .string, .{ .not_null = true }),
            t.column("content", .text, .{ .not_null = true }),
            t.timestamps(.{}),
        },
        .{},
    );
}

pub fn down(repo: anytype) !void {
    try repo.dropTable("blogs", .{});
}
