# Requests

_Jetzig_ handles requests by routing an incoming _HTTP_ request to a view function and then rendering the response in one of two formats:

* `html`
* `json`

The response format is determined by one of the following, in order of precedence:

* The extension of the URI (i.e. ending in `.html` or `.json`)
* An `Accept` header (`text/html` or `application/json`)
* A `Content-Type` header (`text/html` or `application/json`)

The default response format is `html`.

## Request Types

There are two types of requests:

* _dynamic_ - content is rendered at run time as each request is processed
* _static_ - content is rendered at build time and served directly to a matching request

To use a _static_ request, simply change the `*jetzig.Request` argument in a view function to `*jetzig.StaticRequest`.

See the _Static Requests_ documentation section for more information on static rendering.

## Allocator

Every request provides an arena allocator, allowing each view function to allocate memory as needed. Any allocations are then freed when the request has finished processing.

Use the `request.allocator` field to perform allocations in a view function.

## Member Functions

### `render`

```zig
pub fn render(self: *Request, status_code: jetzig.http.status_codes.StatusCode) jetzig.views.View
```

Render a response and assign a response status code. View functions should immediately return the result of `render`. Multiple calls to `render` (or `redirect`) in the same request will result in an error.

`jetzig.http.status_codes.StatusCode` is an `enum` of named status codes. Some common examples include:

* `ok`
* `not_found`
* `created`
* `unauthorized`
* `unprocessable_entity`

The complete list is available in the [source code](https://github.com/jetzig-framework/jetzig/blob/main/src/jetzig/http/status_codes.zig).

### `redirect`

```zig
pub fn redirect(self: *Request, location: []const u8, redirect_status: enum { moved_permanently, found }) jetzig.views.View
```

Issue a redirect to the given `location` (a relative or absolute _URI_ - _Jetzig_ passes this value directly into the `Location` header).

`redirect_status` must be either `.moved_permanently` or `.found`.

As with `render`, view functions should immediately return the result of `redirect` and any subsequent calls to `render` or `redirect` for the same request will result in an error.

### `params`

```zig
pub fn params(self: *Request) !*jetzig.data.Value
```

Parses the request body **or** the _URI_ query param string (request body takes precedence).

When the request type is `json`, attempts to parse the request body as _JSON_, returning `400 Bad Request` on failure.

### `queryParams`

```zig
pub fn queryParams(self: *Request) !*jetzig.data.Value
```

The same as `params` but is guaranteed to only parse the query string. Use this when you need disambiguate between request body and query string, otherwise `params` is preferred.
