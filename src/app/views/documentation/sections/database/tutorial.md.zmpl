# Tutorial

This tutorial covers the process of integrating a _Jetzig_ application with a database.

Use this guide to ensure that you are familiar with the typical workflow and the available
tooling.

## Setup

### CLI

Visit the [Downloads](/downloads) section to fetch the latest _Jetzig CLI_. Instructions are also provided to build the _CLI_ yourself if you prefer.

### Database

Start a local database. Currently, the only supported database is _PostgreSQL_.

The recommended way to launch a database is with _Docker_, using the following `compose.yml`:

```yaml
# compose.yml
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "password"
    ports:
      - 5432:5432
```

```console
docker compose up
```

## Create a New Project

Create a new project with `jetzig init`. You will be prompted to enter a project name and directory to create the project in.

```console
jetzig init
```

## Configure JetQuery

Edit `config/database.zig` in your new project.

Use the following configuration to get started. If you are running _PostgreSQL_ on a different port/host, adjust the configuration as needed:

```zig
pub const database = .{
    .testing = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5432,
        .username = "postgres",
        .password = "password",
        .database = "myapp_testing",
    },

    .development = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5432,
        .username = "postgres",
        .password = "password",
        .database = "myapp_development",
    },

    .production = .{
        .adapter = .postgresql,
        .hostname = "localhost",
        .port = 5432,
        .username = "postgres",
        .password = "password",
        .database = "myapp_production",
    },
};
```

## Create a Database

From your project directory, use the _CLI_ to create a database:

```console
jetzig database create
```

## Generate a Migration

We will use the extended options for the migration generator to specify our table and columns at the command line. You can omit these options and edit the migration manually if you prefer.

```console
jetzig generate migration create_blogs table:blogs column:title:string column:content:text:optional
```

Open the new migration created it `src/app/database/migrations/`. It should contain this content:

```zig
const std = @import("std");
const jetquery = @import("jetquery");
const t = jetquery.schema.table;

pub fn up(repo: anytype) !void {
    try repo.createTable(
        "blogs",
        &.{
            t.primaryKey("id", .{}),
            t.column("title", .string, .{}),
            t.column("content", .text, .{ .optional = true }),
            t.timestamps(.{}),
        },
        .{},
    );
}

pub fn down(repo: anytype) !void {
    try repo.dropTable("blogs", .{});
}
```

The migration includes two functions: `up()` and `down()`. The former is called when a migration is applied and the latter is called when a migration is rolled back.

The columns we specified at the command line have been added as well as a primary key and `t.timestamps(.{})` which creates two `datetime` columns: `created_at` and `updated_at`. These two columns are automatically updated when a record is created or modified.

If you wish to add or modify any of the columns you can do so before applying the migration.

## Apply the Migration

Run the migration with the _CLI_:

```console
jetzig database migrate
```

The generated _SQL_ to create the table is output and the migration version is saved to the `jetquery_migrations` table, so running `jetzig database migrate` again will not re-apply the migration.

If you want to roll back the migration and make a change before applying it again:

```console
jetzig database rollback
# ... make changes ...
jetzig database migrate
```

## Generate a Schema

A `Schema` must be generated before you can use your database in a _Jetzig_ application. The `Schema` provides _JetQuery_ with all the information it needs to generate queries and type check parameters.

You can either manually create a `Schema` or use the _CLI_ to reflect it from the database:

```console
jetzig database reflect
```

Open the newly-created `src/app/database/Schema.zig`:

```zig
const jetquery = @import("jetzig").jetquery;

pub const Blog = jetquery.Model(@This(), "blogs", struct {
    id: i32,
    title: []const u8,
    content: ?[]const u8,
    created_at: jetquery.DateTime,
    updated_at: jetquery.DateTime,
}, .{});
```

Our `Blog` model is now available for use in a query.

Note that `content` is an optional (`?[]const u8`) because we passed the `.optional = true` option in the migration. By default, a `NOT NULL` constraint is applied to columns, unless `.optional = true` is specified. When a value can return `NULL` the value must be a _Zig_ optional.

## Generate a View

Generate a new _View_ with the _CLI_:

```console
jetzig generate view blogs index get new post
```

### View Functions

Open the newly-created file `src/app/views/blogs.zig` and edit the `index`, `get`, `new`, and `post` functions so they match the following:

```zig
# src/app/views/blogs.zig

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    const query = jetzig.database.Query(.Blog).orderBy(.{ .created_at = .desc });
    const blogs = try request.repo.all(query);

    var root = try data.root(.object);
    try root.put("blogs", blogs);

    return request.render(.ok);
}

pub fn get(id: []const u8, request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    const query = jetzig.database.Query(.Blog).find(id);
    const blog = try request.repo.execute(query) orelse return request.fail(.not_found);

    var root = try data.root(.object);
    try root.put("blog", blog);

    return request.render(.ok);
}

pub fn new(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    return request.render(.ok);
}

pub fn post(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    _ = data;
    const params = try request.params();

    const title = params.getT(.string, "title") orelse {
        return request.fail(.unprocessable_entity);
    };

    const content = params.getT(.string, "content") orelse {
        return request.fail(.unprocessable_entity);
    };

    try request.repo.insert(.Blog, .{ .title = title, .content = content });

    return request.redirect("/blogs", .moved_permanently);
}
```

### Templates

Now open the templates that were created by the view generator:

#### `src/app/views/blogs/index.zmpl`

```html
<div>
  @\for (.blogs) |blog| {
    <a href="/blogs/{\{blog.id}}">{\{blog.title}}</a>
    {\{zmpl.fmt.datetime(blog.get("created_at"), "%Y-%m-%d %H:%M")}}
    <br/>
  }
  <hr/>
  <a href="/blogs/new">New Blog</a>
</div>
```

#### `src/app/views/blogs/new.zmpl`

```html
<div>
  <form action="/blogs" method="POST">
    <label>Title</label>
    <input name="title" />

    <label>Content</label>
    <textarea name="content"></textarea>

    <input type="submit" />
  </form>
</div>
```

#### `src/app/views/blogs/get.zmpl`

```html
<div>
  <h1>{\{.blog.title}}</h1>
  <div>{\{.blog.content}}</div>
</div>
```

## Launch a Server

Launch a local development server with the _CLI_:

```console
jetzig server
```

If you prefer, you can also run:
```console
zig build run
```

## Write a Blog Post

Browse to [http://localhost:8080/blogs](https://localhost:8080/blogs), click the "New Blog" link and submit a new blog post.

You will be redirected to the index page where the new blog post is visible.

Congratulations, you have written a blogging app in _Zig_.
