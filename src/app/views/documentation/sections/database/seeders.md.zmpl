# Seeders

_JetQuery_ provides a framework for managing database seeders, just like [migrations](/documentation/sections/database/migrations).

The details below cover how seeders work and the structure of the seeder file. It is recommended to use the [Command Line Tools](/documentation/sections/database/command_line_tools) to create and run seeders.

## Seeder Format

A seeder is a file named with a timestamp prefix followed by an underscore and an arbitrary string with a `.zig` extension. _Jetzig_ seeders are located in `src/app/database/seeders/`.

A seeder file contains only one _Zig_ function, `run`. This function receives a `Repo` which is then used to populate the database with some initial data required to run and use the application.

These functions can be used anywhere that you have access to a `Repo`. It is recommended that you limit seeders to populate the database with only data, but there are no hard restrictions on how you use the `Repo` within a seeder.

### `run`

The `run` function is called when a seeder is executed. Use this function to populate the database with initial data.

### Example Seeder

The following example is taken from this jetzig's [demo repository](https://github.com/jetzig-framework/jetzig/blob/main/demo/src/app/database/seeders/2025-03-10_01-36-58_create_users.zig):

This example creates two users when the seeder is executed

```zig
const std = @import("std");

pub fn run(repo: anytype) !void {
    try repo.insert(
        .User,
        .{
            .email = "iguana@jetzig.dev",
            .password_hash = "not_secure",
        },
    );

    try repo.insert(
        .User,
        .{
            .email = "admin@jetzig.dev",
            .password_hash = "do_not_use",
        },
    );
}
```
