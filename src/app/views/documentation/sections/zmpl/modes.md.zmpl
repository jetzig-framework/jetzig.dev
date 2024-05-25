# Modes

_Zmpl_ templates use various modes that influence how content inside each mode block is rendered.

Modes are selected by the `@` character followed by the mode name. Mode blocks are delimited by `{` and `}` (see the _Custom Delimiters_ below if braces do not work in your situation).

The following modes are available:

* `html`
* `zig`
* `markdown`

If no mode is specified, the default mode is `html`.

The example below shows how to switch between different modes:

```zig
<div>Some regular HTML</div>

\@zig {
    if (std.crypto.random.int(u1) == 0) {
        <div>Some HTML inside a Zig block</div>
    }
}

\@markdown {
    # Header

    @html {
        <div>Some HTML inside markdown</div>
    }

    1. List item 1
    1. List item 2
}
```

## HTML mode

`html` mode can be set explicitly by using the `@html` pragma. The root document is always in `html` mode by default.

Any _HTML_ can be included in `html` mode blocks and there are no limitations on tag type, etc.

There are two key differences between regular _HTML_ and `html` mode:

1. References are supported anywhere.
1. Mode switches can be used to change the current mode.

```zig
\@html {
    <div>Some HTML</div>
    @zig {
        if (true) {
            <span>true is true</span>
        } else {
            <span>true is false</span>
        }
    }
}
```

## Zig mode

`zig` mode has two simple rules:

1. Any line that starts with `<` (ignoring leading whitespace) is considered as an _HTML_ line.
1. Any other line is considered as _Zig_ code.

Since _Zmpl_ is compiled into _Zig_ functions, any code that you can write inside a function is valid in `zig` mode.

Some convenience values are available in all _Zmpl_ templates which can be used in `zig` mode:

* `std` - _Zig_'s standard library is already imported and in scope.
* `allocator` - an arena allocator scoped to the current request. Use this for any allocations needed by your template and all memory will be freed automatically when the request is completed.
* `jetzig_view` - the current view, e.g. if your view function is defined in `src/app/views/iguanas.zig` then this value will be `iguanas`.
* `jetzig_action` - the current action, e.g. `index`, `get`, `post`, `put`, `patch`, `delete`.
* `zmpl` - the `data` argument used in views. This can be used to operate on data values directly, e.g. iterating over an array.

```zig
\@zig {
    const foo = "hello";
    <span>{\{foo}}</span>
    if (std.mem.eql(u8, foo, "hello")) {
        <span>Foo was "hello"!</span>
    }

    if (std.mem.eql(u8, jetzig_view, "iguanas")) {
        <ul>
            for (zmpl.items(.array), 0..) |item, index| {
                <li>Item number {\{index}} is {\{item}}</li>
            }
        </ul>
    }
}
```

## Markdown mode

`markdown` mode allows you to use _Markdown_ syntax to render _HTML_. This mode is powered by [zmd](https://github.com/jetzig-framework/zmd), a pure-_Zig_ _Markdown_ library authored _Jetzig_ developers.

Just like `html` mode, [references](/documentation/sections/zmpl/references) are fully supported. Internally, all content in `markdown` mode is parsed directly to _Zmpl_'s `html` parser.

```zig
\@markdown {
    Some _very convenient_ markdown.

    References are supported too: {\{.user.email}}
}
```

_Jetzig_ configures _zmd_ automatically, but you can also specify exactly how each _Markdown_ element is rendered in your application's `src/main.zig`.

For example, the `h1` and `block` elements in this document are configured using _zmd_'s two configuration options - either a two-element tuple for close and end tags, or a function that gives you complete control over the content:

```zig
pub const jetzig_options = struct {
    pub const markdown_fragments = struct {
        pub const h1 = .{
            "<h1 class='text-2xl mt-4 mb-3 font-bold'>",
            "</h1>",
        };

        pub fn block(allocator: std.mem.Allocator, node: jetzig.zmd.Node) ![]const u8 {
            return try std.fmt.allocPrint(allocator,
                \\<pre class="font-mono mt-4 ms-3 bg-gray-900 p-2 text-white"><code class="language-{?s}">{s}</code></pre>
            , .{ node.meta, node.content });
        }
    };
};
```

### Dynamic Markdown Routing

While using _Markdown_ in templates can be very convenient, you may find that you have a lot of static _Markdown_ content and setting up a _View_ for each file would be burdensome.

_Jetzig_ allows you to create a `.md` file in any location inside `src/app/views/` and requests matching the given path will automatically translate the _Markdown_ content into _HTML_.

For example, this documentation is powered by a single _View_ which then uses _htmx_ to load the rendered _Markdown_ content.

```html
<a href="#"
   hx-get="/documentation/sections/zmpl/modes"
   hx-target="#documentation-section"
   hx-swap="innerHTML"
   class="text-blue-500 m-5 hover:underline">Modes</a>
```

The text you are reading now is in a file named `src/app/views/documentation/sections/zmpl/modes.md`.

## Custom Delimiters

If you find that the default delimiters `{` and `}` do not work in a given situation, e.g. if you are embedding _Javascript_ inside a mode block, [heredoc](https://en.wikipedia.org/wiki/Here_document)-style delimiters are supported. To use a custom delimiter, replace the opening brace with any string you like, and then close the block with the same string on its own line.

Note that the root mode block (i.e. content that of the template that does not have an explicit mode block) ignores braces and is only delimited by the start end end of the file so, in most cases, you can use `<script>` and `<style>` tags without any concern. e.g., this example (taken from this website's source code) will work fine if not inside a mode block:

```html
<script>
  document.addEventListener("DOMContentLoaded", () => {
    const navbar = document.querySelector("#navbar-default");

    document.querySelector("#burger-menu").addEventListener("click", () => {
      navbar.classList.toggle("hidden"); });

    document.querySelectorAll("#navbar-default a").forEach(element => {
      element.addEventListener("click", () => {
        navbar.classList.add("hidden")
      });
    });
  });
</script>
```

_Zmpl_ does not attempt to parse braces unless:

1. They are the first non-whitespace character on a line
1. They are used inside a `@zig` mode block.

This allows you to use braces within your _HTML_ content without being concerned about how they will impact _Zmpl_'s document structure.

The following example taken from the _Zmpl_ test suite shows how custom delimiters can be used to avoid scenarios where braces are not suitable as delimiters:

```zig
\@markdown MARKDOWN
  # Built-in markdown support

  * [jetzig.dev](https://www.jetzig.dev/)

  @zig ZIG
    if (true) {
      @html HTML
        <script>
          const foo = () => {
            console.log("hello");
          };
        </script>
      HTML
    }
  ZIG
MARKDOWN
```
