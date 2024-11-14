const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.root(.object);
    var downloads = try data.array();

    try root.put("downloads", downloads);

    for (try downloadsData(request.allocator, request.server.env.vars)) |download_datum| {
        var download = try data.object();
        try download.put("title", data.string(download_datum.title));
        try download.put("path", data.string(download_datum.path));
        try downloads.append(download);
    }

    return request.render(.ok);
}

const Download = struct { title: []const u8, path: []const u8 };

fn downloadsData(allocator: std.mem.Allocator, vars: jetzig.Environment.Vars) ![]const Download {
    const path = vars.get("DOWNLOADS_PATH") orelse "/var/www/jetzig_downloads.json";
    const file = std.fs.openFileAbsolute(path, .{}) catch |err| {
        switch (err) {
            error.FileNotFound => return &.{},
            else => return err,
        }
    };
    defer file.close();
    const json = try file.readToEndAlloc(allocator, 1024);
    const data = try std.json.parseFromSlice([]Download, allocator, json, .{});
    return data.value;
}
