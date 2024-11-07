const std = @import("std");
const jetzig = @import("jetzig");

pub const middleware_name = "auth";

/// Define any custom data fields you want to store here. Assigning to these fields in the `init`
/// function allows you to access them in the `beforeRequest` and `afterRequest` functions, where
/// they can also be modified.
user: ?struct { id: i32, email: []const u8 },

const Self = @This();

/// Initialize middleware.
pub fn init(request: *jetzig.http.Request) !*Self {
    const middleware = try request.allocator.create(Self);
    middleware.* = .{ .user = null };
    return middleware;
}

const skip_map = std.StaticStringMap(void).initComptime(.{
    .{ ".png", void },
    .{ ".css", void },
    .{ ".js", void },
    .{ ".jpg", void },
    .{ ".jpeg", void },
});

/// Invoked immediately after the request head has been processed, before relevant view function
/// is processed. This gives you access to request headers but not the request body.
pub fn afterRequest(self: *Self, request: *jetzig.http.Request) !void {
    if (request.path.extension) |extension| {
        if (skip_map.get(extension)) |_| return;
    }
    const user_id = try jetzig.auth.getUserId(.integer, request) orelse return;

    const query = jetzig.database.Query(.User).find(user_id);
    if (try request.repo.execute(query)) |user| {
        self.user = .{ .id = user.id, .email = user.email };
    }
}

/// Invoked after `afterRequest` is called, use this function to do any clean-up.
/// Note that `request.allocator` is an arena allocator, so any allocations are automatically
/// done before the next request starts processing.
pub fn deinit(self: *Self, request: *jetzig.http.Request) void {
    request.allocator.destroy(self);
}
