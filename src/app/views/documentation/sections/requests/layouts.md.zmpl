# Layouts

A _Layout_ in _Jetzig_ is a _Zmpl_ template that can be applied to all rendered _HTML_ responses in a given view.

Layouts simplify view templates by moving all common boilerplate like `<html>` and `<head>` elements into a single file and re-using the same boilerplate for any views that are configured to use them.

For example, this website uses a layout to render the navigation bar on every page, as well as adding all the common `<script>` and `<link>` tags in the `<head>` element.

There are only two differences between a layout and any other _Zmpl_ template:

1. Layouts are located in `src/app/views/layouts/`, a special directory exclusively for layouts.
1. The value `zmpl.content` is available, which represents the rendered _HTML_ from each view function's template.

To configure a layout saved as `src/app/views/layouts/example.zmpl`, add the following line anywhere in your view module.

```zig
pub const layout = "example";
```

_Jetzig_ will now render the rendered view function's content inside the `example` layout.

Here's an example of that layout might look like:

```html
<html>
  <head>
    <script>
      console.log("Initializing my application!");
      // ...
    </script>
    <link rel="stylesheet" href="/styles.css">
  </head>

  <body>
    <main>
      {\{zmpl.content}}
    </main>
  </body>
</html>
```
