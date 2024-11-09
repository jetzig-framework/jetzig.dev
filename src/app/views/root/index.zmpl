<div class="mt-2 text-center sm:p-2">
  <img src="/jetzig.png" alt="Jetzig Logo" class="mt-2 h-24 mx-auto">
  @partial h1("Jetzig Web Framework", "text-center")
  <p class="text-gray-500 mt-2 text-lg">
    <i>Jetzig</i> is an
    @partial link("MIT", "https://github.com/jetzig-framework/jetzig/blob/main/LICENSE")
    licensed web framework written in
    @partial link("Zig", "https://ziglang.org/")
  </p>
  <p class="text-gray-500 text-2xl mt-1">
    <i class="fa-brands fa-linux fa-fw fa-lg"></i>
    <i class="fa-brands fa-apple fa-fw fa-lg"></i>
    <i class="fa-brands fa-windows fa-fw fa-lg"></i>
  </p>
</div>

<div class="grid md:grid-cols-2 lg:grid-cols-3 gap-2">
  <div class="p-4">
    @partial headline("arrows-turn-to-dots", "Routing")
    <div>
      <p>Simple, file-based routing to
        @partial link("RESTful", "https://en.wikipedia.org/wiki/REST")
        <i>Zig</i> function declarations. Custom routes are also available.
      </p>
    </div>
  </div>

  <div class="p-4">
    @partial headline("code", "HTML")
    <div>
      <p>Templating with
        @partial link(title: "Zmpl", href: "https://github.com/jetzig-framework/zmpl")
        provides <b>layouts</b>, <b>partials</b>, <b>inheritance</b>, and build-time <b>static content rendering</b>.</p>
    </div>
  </div>

  <div class="p-4">
    @partial headline("brackets-curly", "JSON")
    <div>
      <p>All endpoints render JSON by default, providing a RESTful API for free.</p>
    </div>
  </div>

  <div class="p-4">
    @partial headline("gauge-max", "Speed")
    <div>
      <p>Powered by
        @partial link("http.zig", "https://github.com/karlseguin/http.zig")
        for competitive performance and scalability.
      </p>
    </div>
  </div>

  <div class="p-4">
    @partial headline("wrench", "Tooling")
    <div>
      <p>User-friendly CLI tooling for creating projects and adding new components.</p>
    </div>
  </div>

  <div class="p-4">
    @partial headline("gears", "Middleware")
    <div>
      <p>Hook into and manipulate requests/responses with a custom middleware chain. Built-in middleware for
      @partial link("htmx", "https://htmx.org/")
      .</p>
    </div>
  </div>

  <div class="p-4">
    @partial headline("cookie", "Sessions")
    <div>
      <p>Cookies, user sessions, and request/response headers out of the box.</p>
    </div>
  </div>

  <div class="p-4">
    @partial headline("heart", "Community")
    <div>
      <p>Join us on
      @partial link("Discord", "https://discord.gg/eufqssz7X6")
      &ndash; we're friendly and active.</p>
    </div>
  </div>

  <div class="p-4">
    @partial headline("code-pull-request", "Open Source")
    <div>
      <p>Free, open source, and always will be. <i>Jetzig</i> is
      @partial link("MIT", "https://en.wikipedia.org/wiki/MIT_License")
      licensed.</p>
    </div>
  </div>

  <div class="p-4">
  </div>

  <div class="p-4">
    @partial headline("database", "Database")
    <div>
      Powerful and flexible database layer provided by
        @partial link("JetQuery", "/documentation/sections/database/introduction")
        .
    </div>
  </div>

  <div class="p-4">
  </div>


  <div class="p-4">
  </div>

  <div class="p-4">
    View some
    @partial link("Examples", "/examples")
    or visit the
    @partial link("Documentation", "/documentation")
    to get started.
  </div>

  <div class="p-4">
  </div>
</div>
