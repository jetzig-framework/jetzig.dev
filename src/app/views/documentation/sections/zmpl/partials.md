# Partials

Partials in _Zmpl_ are templates that can be rendered from another template, allowing you to re-use common template code. They have the same functionality as a regular template but with a few key differences:

* Partial template filenames must be prefixed with an underscore, e.g. `src/app/views/_my_partial.zmpl`.
* Partials can specify an `@args` pragma to define arguments that can be passed to the partial.
* A partial pragma can have an optional block delimited by `{` and `}` which provides _slots_.

## Syntax

The below example shows the four forms of partial invocation:

1. Partial with no arguments
1. Partial with positional arguments
1. Partial with keyword arguments - keyword arguments can be passed in any order
1. Partial with slots

```zig
<div>
  @partial example_partial

  @partial user/info("user@example.com")

  @partial user/info(email: "user@example.com")

  @partial user/info(email: "user@example.com") {
    <li>Slot 1</li>
    <li>Slot 2</li>
    <li>Slot 3</li>
  }
</div>
```

## Partial arguments

A partial template can have an optional `@args` pragma which defines arguments that can be passed to it.

The `@args` pragma is simply a comma-separated list of argument names and types, just like in a _Zig_ function (internally, partials are compiled into _Zig_ functions and the `@args` pragma defines the arguments each function receives).

Arguments can be any type, including the provided `*ZmplValue` type which allows passing in values from the _Zmpl_ `data` object.

```zig
@args email: *ZmplValue, subject: []const u8

<a href="mailto:{{email}}?subject={{subject}}">Send an email to {{email}}</a>
```

Note that `*ZmplValue` coerces to a string and can be used just like any data reference or string-compatible _Zig_ value.

If we have the following view function:

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.object();
    var user = try data.object();

    try user.put("email", data.string("user@example.com"));
    try root.put("user", user);

    return request.render(.ok);
}
```

Assuming the above partial is named `src/app/views/_email_link.zmpl`, it can be invoked from the template using the following:

```zig
<div>
  @partial email_link(email: .user.email, subject: "Hello!");
</div>
```

### Default arguments

Default values for arguments can be specified using the `=` operator:

```zig
@args href: []const u8, title: []const u8, target: []const u8 = "_self"

<a href="{{href}}" target="{{target}}">{{title}}</a>
```

If the above partial is named `_link.zmpl` it can now be invoked with any of the following:

```zig
@partial link("https://jetzig.dev/", "Jetzig Website")
```
```zig
@partial link("https://jetzig.dev/", "Jetzig Website", "_blank")
```
```zig
@partial link(title: "Jetzig Website", href: "https://jetzig.dev/")
```
```zig
@partial link(title: "Jetzig Website", href: "https://jetzig.dev/", target: "_blank")
```

## Slots

A _slot_ is a chunk of _HTML_ that can be passed to any partial. All partials have a `slots` value available as an array of `[]const u8`. Slots can include any references which are rendered into strings before being passed to the partial function.

Slots are defined by passing a block to the `@partial` pragma, where each line within the block is a separate slot. This feature is sometimes known as `children` in other frameworks.

To use the slots passed to a partial, iterate over the `slots` array using a `for` loop in `zig` mode.:

### Template

```zig
<div>
  @partial partial_with_slots {
    <span>slot 1</span>
    <span>slot 2</span>
    <span>slot 3</span>
  }
</div>
```

### Partial

```zig
<div>
  <h2>A partial with slots</h2>

  @zig {
    for (slots, 0..) |slot, slot_index| {
      <h3>The content of slot number {{slot_index}} is:</h3>
      <div>{{slot}}</div>
    }
  }
</div>
```

The `slots` value is just a `[][]const u8`, and _Zmpl_ is capable of rendering this type directly from a _Reference_ by joining the elements as a line-separated string.

If you don't need to wrap each slot in any extra markup, render the whole array directly using this short-hand:

```zig
<div>
  <h2>A partial with slots</h2>

  {{slots}}
</div>
```
