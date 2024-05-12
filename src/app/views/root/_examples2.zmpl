<div>
@partial h3("JSON by default on all endpoints", "ms-5")

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

<div class="overflow-x-clip">
@partial h3("Readable development logs", "ms-5")

<img src="/logs.png" alt="Logs" class="ms-5" />

</div>
