<div>
@partial h3("Simple, concise view functions", "ms-5")

@markdown MARKDOWN

```zig
const std = @import("std");
const jetzig = @import("jetzig");

pub const layout = "application";

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var object = try data.object();

    try object.put("url", data.string("https://jetzig.dev/"));
    try object.put("title", data.string("Jetzig Website"));
    try object.put("message", data.string("Welcome to Jetzig!"));

    return request.render(.ok);
}
```
MARKDOWN
</div>

<div>
@partial h3("Modal templating with partials, Markdown, and Zig", "ms-5")

@markdown MARKDOWN

```zig
<html>
  <body>
    \@partial header

    \@markdown {
      # {\{.message}}

      [{\{.title}}]({\{.url}})
    }

    \@zig {
      if (10 > 1) {
        <span>10 is greater than 1!</span>
      }
    }

    <p>{\{.message}}</p>

    \@partial link(href: .url, title: .title)

    \@partial footer
  </body>
</html>
```
MARKDOWN
</div>

