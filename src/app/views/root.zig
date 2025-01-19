const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request) !jetzig.View {
    try request.server.logger.WARN("WIZARD", .{});
    var root = try request.data(.object);
    try root.put("hello", "XYZ");
    return request.render(.ok);
}
