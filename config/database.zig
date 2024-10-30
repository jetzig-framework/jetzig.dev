pub const database = .{
    .testing = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5432,
        .username = "postgres",
        .password = "password",
        .database = "jetzig_website_testing",
    },

    .development = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5432,
        .username = "postgres",
        .password = "password",
        .database = "jetzig_website_development",
    },

    .production = .{
        .adapter = .postgresql,
        .database = "jetzig_website",
        .hostname = "localhost",
        .port = 5432,
        .username = "postgres",
        .password = "password",
    },
};
