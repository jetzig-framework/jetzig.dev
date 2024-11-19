const jetquery = @import("jetzig").jetquery;

pub const Blog = jetquery.Model(
    @This(),
    "blogs",
    struct {
        id: i32,
        title: []const u8,
        content: []const u8,
        created_at: jetquery.DateTime,
        updated_at: jetquery.DateTime,
        author: []const u8,
    },
    .{
        .relations = .{
            .comments = jetquery.hasMany(.Comment, .{}),
        },
    },
);

pub const Comment = jetquery.Model(
    @This(),
    "comments",
    struct {
        blog_id: i32,
        name: []const u8,
        content: []const u8,
        created_at: jetquery.DateTime,
        updated_at: jetquery.DateTime,
    },
    .{},
);

pub const User = jetquery.Model(@This(), "users", struct {
    id: i32,
    email: []const u8,
    password_hash: []const u8,
    created_at: jetquery.DateTime,
    updated_at: jetquery.DateTime,
}, .{});
