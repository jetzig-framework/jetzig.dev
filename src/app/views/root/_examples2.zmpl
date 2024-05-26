<div>
@partial examples_header("JSON by default on all endpoints")

@markdown MARKDOWN

```console
$ curl http://localhost:8080/example.json
```

```json
{
  "url": "https://jetzig.dev/",
  "message": "Welcome to Jetzig!",
  "title": "Jetzig Website"
}
```

MARKDOWN

<p class="p-5">
@partial link(href: "/example.json", title: "Live Example (JSON)", target: "_blank")
<br/>
@partial link(href: "/example.html", title: "Live Example (HTML)", target: "_blank")
</p>

</div>
