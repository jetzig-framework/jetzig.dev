# Database

_Jetzig_'s database layer is provided by [JetQuery](https://github.com/jetzig-framework/jetquery).

_Jetzig_ provides some shortcuts for accessing _JetQuery_'s functionality but it can also be used standalone in any application. See the [Standalone Usage](/documentation/sections/database/standalone_usage) section for more information.

All _SQL_ queries are generated at compile time using _Zig_'s `comptime` functionality. Queries can then be passed to a _JetQuery_ repository to be executed with a database adapter.

Currently only _PostgreSQL_ support is provided, but more adapters are planned to be released soon. The _PostgreSQL_ adapter is built on top of _Karl Seguin_'s [pg.zig](https://github.com/karlseguin/pg.zig).

Many aspects _JetQuery_'s functionality are inspired by [Ecto](https://hexdocs.pm/phoenix/ecto.html) and [ActiveRecord](https://guides.rubyonrails.org/active_record_basics.html). If you are already familiar with similar frameworks then you should find picking up _JetQuery_'s semantics quite straightforward.
