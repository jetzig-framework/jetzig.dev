<div>
@partial examples_header("Modal templating with partials, Markdown, and Zig")

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
