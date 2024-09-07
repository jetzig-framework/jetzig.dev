<div>
  @zig {
    if (zmpl.getT(.array, "blogs")) |blogs| {
      for (blogs.items()) |blog| {
        const title = blog.getT(.string, "title") orelse continue;
        const content = blog.getT(.string, "content") orelse continue;
        <h3>{{title}}</h3>
        <div>{{content}}</div>
      }
    }
  }
</div>
