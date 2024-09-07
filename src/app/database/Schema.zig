const jetzig = @import("jetzig");

pub const Blogs = jetzig.jetquery.Table(
    "blogs",
    struct { id: usize, title: []const u8, content: []const u8 },
    .{},
);
