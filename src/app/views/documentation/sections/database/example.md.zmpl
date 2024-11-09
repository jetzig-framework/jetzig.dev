# Example

The example below is taken from the [Blog](/blogs) section of this website. You can also view the [complete source code](https://github.com/jetzig-framework/jetzig.dev/blob/main/src/app/views/blogs) for a more detailed example.

```zig
# src/app/views/blogs.zig

const jetzig = @import("jetzig");
const Query = jetzig.database.Query;

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    const query = Query(.Blog)
        .select(.{ .id, .title, .author, .created_at })
        .orderBy(.{ .created_at = .descending });

    const blogs = try request.repo.all(query);

    var root = try data.root(.object);
    try root.put("blogs", blogs);

    return request.render(.ok);
}
```

We can now iterate over the results of our query in a _Zmpl_ template:

```html
<!-- src/app/views/blogs/index.zmpl -->

<div>
  \@partial link("New Blog Post", "/blogs/new")
  <hr/>
  <ul>
  \@for (.blogs) |blog| {
    <li>
      <a href="/blogs/{\{blog.id}}">{\{blog.title}}</a>
      ({\{zmpl.fmt.datetime(blog.get("created_at"), "%c")}})
    </li>
  }
  </ul>
</div>
```
