const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request) !jetzig.View {
    var object = try request.data(.object);

    try object.put("url", "https://jetzig.dev/");
    try object.put("title", "Jetzig Website");
    try object.put("message", "Welcome to Jetzig!");

    return request.render(.ok);
}
