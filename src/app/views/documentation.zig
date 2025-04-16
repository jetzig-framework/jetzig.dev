const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "documentation";

pub fn index(request: *jetzig.Request) !jetzig.View {
    return request.render(.ok);
}

pub fn section(args: []const []const u8, request: *jetzig.Request) !jetzig.View {
    request.setTemplate(try request.joinPaths(&.{ &.{"documentation"}, args }));
    return request.render(.ok);
}
