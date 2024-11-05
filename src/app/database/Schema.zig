const jetquery = @import("jetzig").jetquery;

pub const Blogs = jetquery.Model(
    @This(),
    "blogs",
    struct {
        id: i32,
        title: []const u8,
        content: []const u8,
        created_at: jetquery.DateTime,
        updated_at: jetquery.DateTime,
    },
    .{},
);
