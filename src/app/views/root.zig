const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request) !jetzig.View {
    return request.render(.ok);
}
