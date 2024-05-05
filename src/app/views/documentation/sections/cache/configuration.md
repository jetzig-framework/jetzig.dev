# Cache Configuration

The _Cache_ backend can be configured in the `pub const jetzig_options` declaration in your project's `src/main.zig` using the `pub const cache` declaration:

## In-memory cache

The default cache configuration uses _JetKV_'s `memory` backend:

```zig
pub const jetzig_options = struct {
    pub const cache: jetzig.kv.Store.KVOptions = .{ .backend = .memory };
};
```

## File-based cache

Cache can be persisted between server restarts using the `file` backend:

```zig
pub const jetzig_options = struct {
    pub const cache: jetzig.kv.Store.KVOptions = .{
        .backend = .file,
        .file_options = .{ .path = "/path/to/jetkv-cache.db" },
    };
};
```

**Important**: _JetKV_ uses file locking to ensure data integrity. When using the file backend, the same database filename must be distinct from the _Store_ and _Job Queue_ backends.
