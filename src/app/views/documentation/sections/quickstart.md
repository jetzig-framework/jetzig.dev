# Quickstart

## Download

Visit the [downloads](/downloads.html) page and follow the instructions download the appropriate pre-compiled binary for your operating system.

## Create a new project

Use the interactive command line tool to generate a new project. You will be prompted with a few options to choose how to initialize your project.

```console
$ jetzig init
```

## Launch a server

The command line tool also provides a server launcher that reloads the server when changes are detected. This is a simple wrapper around zig build run.

```console
$ jetzig server
```

## Generate a view

Use the command line tool again to generate a view for the `/iguanas` endpoint with an index function:

```zig
$ jetzig generate view iguanas index
```

A default view is provided for the root path: `/`. This view is named `root.zig`. Other routes are mapped to the name of the view.

For example, the index function in `src/app/views/iguanas.zig` maps to the following endpoints:

* `/iguanas`
* `/iguanas.html`
* `/iguanas.json`

All views in Jetzig automatically provide _JSON_ endpoints, and any view function with a corresponding template will render _HTML_.

_Jetzig_ uses its own templating language: [Zmpl](https://github.com/jetzig-framework/zmpl). The template for the `/iguanas.html` endpoint is located in `src/app/views/iguanas/index.zmpl`.

The default response format is `html`, but this can be overridden by specifying one of the following:

* `.json` extension in the URL
* `Accept: application/json` request header
* `Content-Type: application/json` request header

## Create some data

A core concept to _Jetzig_ is its handling of response data. All view functions receive a `data` argument. This argument provides a set of functions for creating data that can be used in templates and exposed as _JSON_. In _Jetzig_, template data and _JSON_ data are one and the same. Simply add data to your response and it is automatically available in templates and _JSON_ endpoints.

The first call to `data.object()` or `data.array()` becomes the root data object. Add values to the root object and use them in your templates or view them as _JSON_. Here's an example:

```zig
// src/app/views/iguanas.zig
const jetzig = @import("jetzig");

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.object();
    try root.put("message", data.string("Welcome to Jetzig!"));
    try root.put("iguana_count", data.integer(100_000));

    return request.render(.ok);
}
```

You can now use _Zmpl_'s data lookup syntax to access these values in your template:

```html
// src/app/views/iguanas/index.zmpl
<div>Message: {{.message}}</div>
<div>{{.iguana_count}} iguanas!</div>
```

Browse to [http://localhost:8080/iguanas.html](http://localhost:8080/iguanas.html) to see your rendered _HTML_ (the `.html` exnension is optional) or visit [http://localhost:8080/iguanas.json](http://localhost:8080/iguanas.json) to see the raw _JSON_ data.

## Generate a layout

To avoid having to copy and paste the same page layout repeatedly and to help keep your templates focused and concise, _Jetzig_ provides layout templates.

Use the command line tool again to create a layout named `custom_layout`:

```console
$ jetzig generate layout custom_layout
```

Then add the following line of code anywhere in `src/app/views/iguanas.zig`:

```zig
pub const layout = "custom_layout";
```

All HTML output for view functions in the `/iguanas` route will now be enclosed inside the content in `src/app/views/layouts/custom_layout.zmpl`.
