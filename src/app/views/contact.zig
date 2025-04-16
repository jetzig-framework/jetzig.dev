const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request) !jetzig.View {
    return request.render(.ok);
}

pub fn post(request: *jetzig.Request) !jetzig.View {
    var object = try request.data(.object);
    const Params = struct { from: []const u8, message: []const u8 };
    const params = try request.expectParams(Params) orelse {
        return request.fail(.unprocessable_entity);
    };

    try object.put("from", params.from);
    try object.put("message", params.message);

    const mail = request.mail("contact", .{ .to = &.{.{ .email = "hello@jetzig.dev" }} });
    try mail.deliver(.background, .{});

    return request.render(.created);
}
