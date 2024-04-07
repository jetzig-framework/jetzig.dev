# Zmpl

_Zmpl_ is a mode-based templating language that compiles to _Zig_ functions at build time. Template logic is implemented using the _Zig_ mode, allowing you to leverage the full power of _Zig_ to implement business logic.

Templates are auto-compiled when you build your _Jetzig_ application and can be used for both _dynamic_ and _static_ routes.

Partial support is provided by the `@partial` pragma. Support is provided for partial arguments and _slots_.

