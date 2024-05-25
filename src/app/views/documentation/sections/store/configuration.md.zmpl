# Configuration

The _Store_ is automatically configured for all _Jetzig_ applications using _JetKV_'s in-memory backend.

To use a persistent, file-based backend, add the following to the `pub const jetzig_options` declaration in your project's `src/main.zig`:

```zig
pub const jetzig_options = struct {
    pub const store: jetzig.kv.Store.KVOptions = .{
        .backend = .file,
        .file_options = .{ .path = "/path/to/jetkv-store.db" },
    };
};
```

**Important**: _JetKV_ uses file locking to ensure data integrity. When using the file backend, the same database filename must be distinct from the _Job Queue_ and _Cache_ backends.

The `file_options` field accepts the following configuration options:

## `path`

The path to the _JetKV_ database. This file is created on startup if it does not exist, but the destination directory must already exist.

## `truncate`

Defaults to `false`.

When `true`, truncate (i.e. empty) the database file on startup.

## `address_space_size`

The number of bytes used for the file's hash table. This value must be exactly divisible by _JetKV_'s address size. Use `jetzig.jetkv.JetKV.FileBackend.addressSpace` to calculate a valid value:

```zig
pub const jetzig_options = struct {
    pub const store: jetzig.kv.Store.KVOptions = .{
        .backend = .file,
        .file_options = .{
            .path = "/path/to/jetkv-store.db",
            .address_space_size = jetzig.jetkv.JetKV.FileBackend.addressSpace(4096),
        },
    };
};
```

The default address space size allows `4096` addresses. Hash collisions are managed by _JetKV_ as linked lists. If you are storing a very large number of keys you may want to increase this value. For most use cases, the default configuration should be sufficent.
