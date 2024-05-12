<html>
  <body>
    @partial example/header

    @markdown {
      # {{.message}}

      [{{.title}}]({{.url}})
    }

    @zig {
      if (10 > 1) {
        <span>10 is greater than 1!</span>
      }
    }

    <p>{{.message}}</p>

    @partial link(href: .url, title: .title)

    @partial example/footer
  </body>
</html>
