const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;

    return request.render(.ok);
}

pub fn post(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    const params = try request.params();

    const email = params.getT(.string, "email") orelse {
        return request.fail(.unprocessable_entity);
    };
    const password = params.getT(.string, "password") orelse {
        return request.fail(.unprocessable_entity);
    };

    const query = jetzig.database.Query(.User).findBy(.{ .email = email });
    const user = try request.repo.execute(query) orelse return request.fail(.unauthorized);

    if (try jetzig.auth.verifyPassword(request.allocator, user.password_hash, password)) {
        try jetzig.auth.signIn(request, user.id);
    } else {
        return request.fail(.unauthorized);
    }

    var root = try data.root(.object);
    try root.put("email", user.email);

    return request.render(.created);
}

test "index" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    const response = try app.request(.GET, "/auth", .{});
    try response.expectStatus(.ok);
}

test "post" {
    var app = try jetzig.testing.app(std.testing.allocator, @import("routes"));
    defer app.deinit();

    try app.repo.begin();
    defer app.repo.rollback() catch {};

    const hash = try jetzig.auth.hashPassword(std.testing.allocator, "password123");
    defer std.testing.allocator.free(hash);

    try app.repo.insert(
        .User,
        .{
            .email = "bob@jetzig.dev",
            .password_hash = hash,
        },
    );
    const response = try app.request(
        .POST,
        "/auth",
        .{ .params = .{ .email = "bob@jetzig.dev", .password = "password123" } },
    );
    try response.expectStatus(.created);
}
