const std = @import("std");
const jetquery = @import("jetquery");
const t = jetquery.schema.table;

pub fn up(repo: anytype) !void {
    try repo.createTable(
        "users",
        &.{
            t.primaryKey("id", .{}),
            t.column("email", .string, .{ .not_null = true }),
            t.column("password_hash", .string, .{ .not_null = true }),
            t.timestamps(.{}),
        },
        .{},
    );
}

pub fn down(repo: anytype) !void {
    try repo.dropTable("users", .{});
}
