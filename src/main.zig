const std = @import("std");

pub const jetzig = @import("jetzig");
pub const routes = @import("routes");
const zmd = @import("zmd");

pub const jetzig_options = struct {
    pub const middleware: []const type = &.{
        jetzig.middleware.HtmxMiddleware,
    };

    pub const force_development_email_delivery = false;

    pub const job_worker_threads: usize = 4;

    pub const smtp: jetzig.mail.SMTPConfig = .{
        .port = 1025,
        .encryption = .none, // .insecure, .none, .tls, .start_tls
        .host = "localhost",
        .username = null,
        .password = null,
    };

    pub const Schema = @import("app/database/Schema.zig");
    pub const database: jetzig.database.DatabaseOptions = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5432,
        .username = "postgres",
        .password = "password",
        .database = "jetzig_website",
    };

    pub const markdown_fragments = struct {
        pub const root = .{
            "<div class='md:p-5 sm:p-1'>",
            "</div>",
        };
        pub const h1 = .{
            "<h1 class='text-2xl mt-4 mb-3 font-bold'>",
            "</h1>",
        };
        pub const h2 = .{
            "<h2 class='text-xl mt-5 mb-3 font-bold'>",
            "</h2>",
        };
        pub const h3 = .{
            "<h3 class='text-lg mt-5 mb-3 font-bold'>",
            "</h3>",
        };
        pub const h4 = .{
            "<h4 class='text-base mt-5 mb-3 font-bold'>",
            "</h4>",
        };
        pub const paragraph = .{
            "<p class='p-3'>",
            "</p>",
        };
        pub const code = .{
            "<span class='whitespace-nowrap font-mono bg-sky-100 px-2 py-1 text-sky-800 rounded'>",
            "</span>",
        };

        pub const unordered_list = .{
            "<ul class='list-disc ms-8 leading-8'>",
            "</ul>",
        };

        pub const ordered_list = .{
            "<ul class='list-decimal ms-8 leading-8'>",
            "</ul>",
        };

        pub fn block(allocator: std.mem.Allocator, node: zmd.Node) ![]const u8 {
            return try std.fmt.allocPrint(allocator,
                \\<pre class="font-mono mt-4 ms-3 sm:ms-0 bg-gray-900 p-2 sm:p-0 text-white"><code class="language-{?s}">{s}</code></pre>
            , .{ node.meta, node.content });
        }

        pub fn link(allocator: std.mem.Allocator, node: zmd.Node) ![]const u8 {
            return try std.fmt.allocPrint(allocator,
                \\<a class="underline text-sky-500 decoration-sky-500" href="{0s}" title={1s}>{1s}</a>
            , .{ node.href.?, node.title.? });
        }
    };
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();

    var app = try jetzig.init(allocator);
    defer app.deinit();

    app.route(.GET, "/documentation/:args*", @import("app/views/documentation.zig"), .section);

    try app.start(routes, .{});
}
