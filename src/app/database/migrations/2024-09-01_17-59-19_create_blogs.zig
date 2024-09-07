const std = @import("std");
const jetquery = @import("jetquery");
const t = jetquery.table;

pub fn up(repo: *jetquery.Repo) !void {
    try repo.createTable(
        "blogs",
        &.{
            t.primaryKey("id", .{}),
            t.column("title", .string, .{}),
            t.column("content", .text, .{}),
            t.timestamps(.{}),
        },
        .{},
    );
}

pub fn down(repo: *jetquery.Repo) !void {
    try repo.dropTable("blogs", .{});
}
