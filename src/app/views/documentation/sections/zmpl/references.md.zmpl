# References

_Zmpl_ uses a simple but powerful system for references (also known as "template variables").

References are delimited by `{\{` and `}}`:

```zmpl
\@zig {
    const foobar = "hello";
}

<div>{\{foobar}}</div>
```

If the given value can be safely coerced to a string then the output is rendered accordingly.

Since _Zmpl_ templates are compiled into _Zig_ functions, you get all the benefits of the _Zig_ compiler such as:

* Unrecognized variables result in an error.
* Unused variables also raise an error.
* Backtraces for all errors (note that backtraces come from the compiled _Zmpl_ template, but they generally will give you enough information to solve issues).

There are three main types of data references:

1. Data lookups
1. Variable/constant references
1. _Zig_ code

## Data lookups

If a reference begins with a `.` character then it is considered a data lookup. Use this syntax when you need to access any values added to the `data` argument passed to every _View_ function.

For example:

```zig
const jetzig = \@import("jetzig");

pub fn index(request: *jetzig.Request) !jetzig.View {
    var root = try request.data(.object);
    try root.put("message", "Welcome to Jetzig!");
    try root.put("iguana_count", 100_000);

    return request.render(.ok);
}
```

**Important**: The first call to `request.data()` sets the _root_ value. All data references use this value as their starting point. You should only call this once per request unless you specifically wish to re-initialize the root value.

These values can now be accessed in a _Zmpl_ template:

```zmpl
<div>{\{.message}}</div>
<div>We found {\{.iguana_count}} iguanas!</div>
```

This syntax can also be used to access nested keys:

```zig
const jetzig = @import("jetzig");

pub fn index(request: *jetzig.Request) !jetzig.View {
    var root = try request.data(.object);

    var iguana = try root.put(.object);
    try iguana.put("name", "Ziggy");

    return request.render(.ok);
}
```

The iguana's name can now be accessed in a template:

```zmpl
<div>The iguana is named {\{.iguana.name}}</div>
```

## Variable/constant references

All references that do not begin with `.` are assumed to reference a value in the current scope assigned in one of three ways:

1. By the template code itself in a `zig` mode section.
1. By _Jettzig_ (e.g. the `jetzig_view` and `jetzig_action` constants available in every template).
1. Arguments passed to a partial.

```zmpl
\@zig {
    const red = "#ff0000";
}
<div style="color: {\{color}}">Some red text</div>
```

## Zig code

If needed, arbitrary _Zig_ code can be used inside a reference. Note that this code **must** evaluate to a `[]const u8`:

```zmpl
<div>{\{if (true) "foo" else "bar"}}</div>
```
