const std = @import("std");
const jetquery = @import("jetquery");
const t = jetquery.schema.table;

pub fn up(repo: anytype) !void {
    try repo.createTable(
        "my_table",
        &.{
            t.primaryKey("id", .{}),
            t.column("my_string", .string, .{}),
            t.column("my_integer", .integer, .{}),
            t.timestamps(.{}),
        },
        .{{}},
    );
}

pub fn down(repo: anytype) !void {
    try repo.dropTable("my_table", .{});
}
