# Iteration

Iteration is always available by entering `@zig` mode inside a template, but _Zmpl_ provides a couple of tools to try to make iteration a bit more straightforward when working with _Zmpl_ data types.

## `\@for` loop constructor

`\@for` can be used simply as a short-hand for creating a for loop without entering `@zig` mode, but it also provides some extra support for translating _Zmpl_ data types.

For example:

```zmpl
<div>
	\@for ($.blog.comments) |comment| {
		\@partial blogs/comment(comment)
	}
</div>
```

This saves manually looking up and unpacking the value reference `$.blog.comments`.

## `coerceArray`

If you simply want to get a data ref as an interable value inside a `@zig` block, use `zmpl.coerceArray`:

```zmpl
\@zig {
    const array = try zmpl.coerceArray(".blog.comments");
    for (array) |item| {
	    <div>{\{item}}</div>
    }
}
```
