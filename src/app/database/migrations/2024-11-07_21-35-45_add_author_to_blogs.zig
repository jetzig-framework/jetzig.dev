const std = @import("std");
const jetquery = @import("jetquery");
const t = jetquery.schema.table;

pub fn up(repo: anytype) !void {
    try repo.alterTable("blogs", .{
        .columns = .{
            .add = &.{
                t.column("author", .string, .{}),
            },
        },
    });
}

pub fn down(repo: anytype) !void {
    _ = repo;
}
