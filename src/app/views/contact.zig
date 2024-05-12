const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    return request.render(.ok);
}

pub fn post(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var object = try data.object();
    const params = try request.params();

    try object.put("from", params.get("from"));
    try object.put("message", params.get("message"));

    const mail = request.mail("contact", .{ .to = &.{"hello@jetzig.dev"} });
    try mail.deliver(.background, .{});

    return request.render(.created);
}
