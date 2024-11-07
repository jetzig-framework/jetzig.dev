const std = @import("std");

const jetzig = @import("jetzig");

pub const IdType = enum { string, integer };

pub fn getUserId(comptime id_type: IdType, request: *jetzig.Request) !?switch (id_type) {
    .integer => i32,
    .string => []const u8,
} {
    const session = try request.session();

    return try session.getT(id_type, "_jetzig_user_id");
}

pub fn verifyPassword(
    allocator: std.mem.Allocator,
    hash: []const u8,
    password: []const u8,
) !bool {
    const verify_error = std.crypto.pwhash.argon2.strVerify(
        hash,
        password,
        .{ .allocator = allocator },
    );

    return if (verify_error)
        true
    else |err| switch (err) {
        error.AuthenticationFailed, error.PasswordVerificationFailed => false,
        else => err,
    };
}

pub fn hashPassword(allocator: std.mem.Allocator, password: []const u8) ![]const u8 {
    var buf: [128]u8 = undefined;
    return try std.crypto.pwhash.argon2.strHash(
        password,
        .{
            .allocator = allocator,
            .params = .{ .t = 3, .m = 32, .p = 4 },
        },
        &buf,
    );
}
