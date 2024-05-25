# Example

The example below shows how to store and fetch a string using the _Store_, and how to use arrays.

As with all _Jetzig_ _Data_ usage, any _JSON_-compatible value can be saved to the _Store_, including complex, arbitrarily-nested objects and arrays.

```zig
pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.object();

    // Fetch and remove string from the KV store. If it exists, store it in the root data object,
    // otherwise store a string value to be picked up by the next request.
    if (try request.store.fetchRemove("example-key")) |capture| {
        try root.put("stored_string", capture);
    } else {
        try root.put("stored_string", null);
        try request.store.put("example-key", data.string("example-value"));
    }

    // Left-pop an item from an array and store it in the root data object. This will empty the
    // array after multiple requests.
    // If the array is empty or not found, append some new values to the array.
    if (try request.store.popFirst("example-array")) |value| {
        try root.put("popped", value);
    } else {
        // Store some values in an array in the KV store.
        try request.store.append("example-array", data.string("hello"));
        try request.store.append("example-array", data.string("goodbye"));
        try request.store.append("example-array", data.string("hello again"));

        try root.put("popped", null);
    }

    return request.render(.ok);
}
```

## Output

```console
$ curl 'http://localhost:8080/example.json'
```

```json
{
  "stored_string": null,
  "popped": null
}
```

```console
$ curl 'http://localhost:8080/example.json'
```

```json
{
  "stored_string": "example-value",
  "popped": "hello"
}
```

```console
$ curl 'http://localhost:8080/example.json'
```

```json
{
  "stored_string": "example-value",
  "popped": "goodbye"
}
```

```console
$ curl 'http://localhost:8080/example.json'
{
  "stored_string": "example-value",
  "popped": "hello again"
}
```
