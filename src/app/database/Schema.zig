const jetzig = @import("jetzig");

pub const Blogs = jetzig.jetquery.Model(
    @This(),
    "blogs",
    struct {
        id: i32,
        title: []const u8,
        content: []const u8,
        created_at: jetzig.DateTime,
        updated_at: jetzig.DateTime,
    },
    .{},
);
