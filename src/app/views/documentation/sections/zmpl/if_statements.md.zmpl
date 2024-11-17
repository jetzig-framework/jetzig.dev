# If Statements

Most templates will need at least some control flow to display or hide various parts of the page depending on values passed to the template by a _View_ function.

Using `\@zig` mode gives ultimate control for template logic - in this mode you can write any _Zig_ code you like to control how the template is rendered.

However, a simple `if` statement is such a common thing, and comparing _Zmpl_ types with _Zig_ primitives is not always very convenient, so _Zmpl_ provides `\@if` to make things easier.

## `\@if`

`\@if` works almost identically to _Zig_'s `if` statements (in fact, it leverages _Zig_'s [AST](https://ziglang.org/documentation/master/std/#std.zig.Ast) to parse the input and generate the syntax tree, ensuring that very complex boolean logic can be used).

`\@if` is delimited by `\@end` and supports `\@else`, `\@else if` and payload capture (`\@if ($.foo) |foo|`).

### Comparison Opreators

_Zmpl_ replaces comparison operators (`==`, `!=`, `<`, `<=`, `>`, `>=`) with calls to an internal comparison function that primarily does two things:

* Comparison of _Zmpl_ values with _Zig_ primitives (`$.foo.bar == 1`).
* Short-hand string equality/inequality checks for _Zmpl_ types and any other type (`$.foo.baz == "qux"` or `foo != "qux"`).

### Example

See the example below taken from _Zmpl_'s test suite to see how it works:

```zig
\@if ($.foo.bar == 999 and $.foo.baz >= 5 and $.foo.qux.quux < 3)
    unexpected here
\@else if ($.foo.bar == 1 and $.foo.baz == 3 and $.foo.qux.quux == 4)
    expected here
    \@if ($.foo.bar == 1)
        nested expected here
        foo.bar is {\{$.foo.bar}}
        \@if ($.foo.qux.quux != 999)
            double nested expected here
            foo.qux.quux is {\{$.foo.qux.quux}}
        \@end
    \@end
\@else
    unexpected here
\@end

\@if ($.foo.bar) |bar|
  bar is {\{bar}}
\@end

\@if ($.foo.missing) |missing|
  unexpected: {\{missing}}
\@else
  expected: `missing` is not here
\@end

\@if ($.foo.corge == "I am corge")
  corge says "{\{$.foo.corge}}"
\@end

\@if ($.foo.corge != "I am not corge")
  corge confirms "{\{$.foo.corge}}"
\@end

\@if (false)
  \@if (true)
    unexpected
  \@end
\@else if (false)
  unexpected
\@else
  expected: else
\@end
```
