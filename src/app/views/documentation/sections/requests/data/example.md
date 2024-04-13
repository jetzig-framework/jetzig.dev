# Example

The below example creates a root `object` and then adds various nested values to that object.

See each section in the _Data_ documentation to learn more about how each `Value` type works.

```zig
// src/app/views/example.zig

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.object();

    var user = try data.object();
    try root.put("user", user);

    var user_profile = try data.object();
    try user.put("profile", user_profile);

    try user.put("email", data.string("user@example.com"));
    try user.put("name", data.string("Example User"));

    var pets = try data.array();
    try user_profile.put("pets", pets);

    var cat = try data.object();
    try cat.put("name", data.string("Garfield"));
    try cat.put("animal", data.string("cat"));

    var dog = try data.object();
    try dog.put("name", data.string("Pluto"));
    try dog.put("animal", data.string("Dog"));

    try pets.append(cat);
    try pets.append(dog);

    return request.render(.ok);
}
```

## JSON

A `json` request to this endpoint provides the following output:

```console
$ curl http://localhost:8080/example.json
```

```json
{
  "user": {
    "profile": {
      "pets": [
        {
          "animal": "cat",
          "name": "Garfield"
        },
        {
          "animal": "Dog",
          "name": "Pluto"
        }
      ]
    },
    "name": "Example User",
    "email": "user@example.com"
  }
}
```

Note that _JSON_ output is always pretty-printed in development mode. In production mode (see _Server Options_), _JSON_ is rendered in compact form.

## HTML

The template below is named `src/app/views/example/index.zmpl` and is automatically located by the `index` function in `src/app/views/example.zig`.

## Template

```zig
<h2>User</h2>

<h3>Name</h3>
{{.user.name}}

<h3>Email</h3>
{{.user.email}}

<h2>Pets</h2>

@zig {
  if (zmpl.chain(&[_][]const u8{ "user", "profile", "pets" })) |pets| {
    <ul>
    for (pets.items(.array)) |pet| {
      const name = pet.get("name");
      const animal = pet.get("animal");
      <li>{{name}} the {{animal}}</li>
    }
    </ul>
  }
}
```

## Rendered HTML

```console
$ curl http://localhost:8080/example.html
```

(Note that the `.html` extension is optional as `html` is the default request format).

```html
<h2>User</h2>

<h3>Name</h3>
Example User

<h3>Email</h3>
user@example.com

<h2>Pets</h2>
    <ul>
      <li>Garfield the cat</li>
      <li>Pluto the Dog</li>
    </ul>
```
