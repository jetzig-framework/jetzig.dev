const std = @import("std");
const jetzig = @import("jetzig");

pub const defaults: jetzig.mail.DefaultMailParams = .{
    .from = .{ .name = "Jetzig Contact Form", .email = "hello@jetzig.dev" },
    .subject = "Message from Jetzig website",
    .to = &.{.{ .email = "hello@jetzig.dev" }},
};

pub fn deliver(
    allocator: std.mem.Allocator,
    mail: *jetzig.mail.MailParams,
    params: *jetzig.data.Value,
    env: jetzig.jobs.JobEnv,
) !void {
    _ = env;
    _ = mail;
    _ = allocator;
    _ = params;
}
