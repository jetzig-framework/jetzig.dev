# KV Store

_Jetzig_ provides a key-value store (powered by [JetKV](https://github.com/jetzig-framework/jetkv)) for storing `*jetzig.data.Value`. See the _Data_ section for more information on this type.

All values are automatically serialized and deserialized when they are added to/fetched from the store.

The _Store_ is available in all _View_ functions as `request.store` and in all _Jobs_ as `env.store`.

## Request Store Member Functions

Inside a _View_ function, `request.store` provides a `RequestStore`, a thin wrapper around the underlying _JetKV_ store that provides automated memory management and _JSON_ serialization/deserialization.

### `get`

```zig
pub fn get(self: RequestStore, key: []const u8) !?*jetzig.data.Value
```

Fetch a value from the store. `null` if the key is not found, or if the key is occupied by an array.

### `put`

```zig
pub fn put(self: RequestStore, key: []const u8, value: *jetzig.data.Value) !void
```

Put a value into the store, overwriting any value **or** array value already present in the store.

### `remove`

```zig
pub fn remove(self: RequestStore, key: []const u8) !void
```

Remove a value from the store. Does not remove array values (i.e. values created with `append` or `prepend`).

### `fetchRemove`

```zig
pub fn fetchRemove(self: RequestStore, key: []const u8) !?*jetzig.data.Value
```

Fetch a value from the store, remove it if present. `null` if the key is not found.

### `append`

```zig
pub fn append(self: RequestStore, key: []const u8, value: *jetzig.data.Value) !void
```

Append a value to the end of an an array in the store. Creates a new array if not present.

### `prepend`

```zig
pub fn prepend(self: RequestStore, key: []const u8, value: *jetzig.data.Value) !void
```

Prepend a value to the start of an an array in the store. Creates a new array if not present.

### `pop`

```zig
pub fn pop(self: RequestStore, key: []const u8) !?*jetzig.data.Value
```

Pop a value from the end of an array in the store. `null` if no array found or if the array is empty.

### `popFirst`

```zig
pub fn popFirst(self: RequestStore, key: []const u8) !?*jetzig.data.Value
```

Pop a value from the start of an array in the store. `null` if no array found or if the array is empty.
