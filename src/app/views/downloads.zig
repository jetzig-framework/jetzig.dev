const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.object();
    var downloads = try data.array();

    try root.put("downloads", downloads);

    const file = try std.fs.openFileAbsolute("/var/www/jetzig_downloads.json", .{});
    defer file.close();
    const json = try file.readToEndAlloc(request.allocator, 1024);
    const downloads_data = try std.json.parseFromSlice([]Download, request.allocator, json, .{});

    for (downloads_data.value) |download_datum| {
        var download = try data.object();
        try download.put("title", data.string(download_datum.title));
        try download.put("path", data.string(download_datum.path));
        try downloads.append(download);
    }

    return request.render(.ok);
}

const Download = struct { title: []const u8, path: []const u8 };
