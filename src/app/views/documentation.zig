const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "documentation";

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    return request.render(.ok);
}

pub fn section(args: []const []const u8, request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    request.setTemplate(try request.joinPaths(&.{ &.{"documentation"}, args }));
    return request.render(.ok);
}
