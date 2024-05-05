# Jobs Configuration

The job queue is powered by [JetKV](https://github.com/jetzig-framework/jetkv) which is bundled with all _Jetzig_ applications and requires zero configuration.

If the default behaviour does not suit your requirements, the following configuration options can be added to the `pub const jetzig_options` declaration in your project's `src/main.zig`.

## Worker threads

Adjust the number of background worker threads to launch on startup.

```zig
pub const jetzig_options = struct {
    pub const job_worker_threads: usize = 4;
};
```

## Queue backend

The _JetKV_ backend defaults to using an in-memory queue but can also be configured to use a file-based allocator which allows persisting the job queue between server restarts.

### In-memory backend (default)

```zig
pub const jetzig_options = struct {
    pub const job_queue: jetzig.kv.Store.KVOptions = .{
        .backend = .memory,
    };
};
```

### File-based backend

```zig
pub const jetzig_options = struct {
    pub const job_queue: jetzig.kv.Store.KVOptions = .{
        .backend = .file,
        .file_options = .{ .path = "/path/to/jetkv-queue.db" },
    };
};
```

**Important**: _JetKV_ uses file locking to ensure data integrity. When using the file backend, the database file must not be shared by other processes, including the _Cache_ and _Store_ configurations.
