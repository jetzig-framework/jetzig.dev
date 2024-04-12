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
