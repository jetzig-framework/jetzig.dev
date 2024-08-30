const jetquery = @import("jetzig").jetquery;

pub fn up(repo: jetquery.Repo) !void {
    try repo.create(.table, .{
        .id = repo.id(.{}),
        .title = repo.string(.{}),
        .content = repo.text(.{}),
        .timestamps = repo.timestamps(.{}),
    });
}
