@partial h1("Jetzig Web Framework", "text-center")
<div class="mt-2 text-center">
  <img src="/jetzig.png" alt="Jetzig Logo" class="h-24 mx-auto">
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

@zig {
  const jetzig_orange = "#f7931e";
}

<div class="grid grid-cols-1 sm:grid-cols-[10rem_auto] gap-8 mt-8 text-gray-500">
  <h4 class="flex-initial text-xl font-bold text-[{{jetzig_orange}}]"><i class="fa-solid fa-arrows-turn-to-dots fa-fw me-2"></i> Routing</h4>
  <div>
    <p>Simple, file-based routing to
      @partial link("RESTful", "https://en.wikipedia.org/wiki/REST")
      <i>Zig</i> function declarations.
    </p>
  </div>

  <h4 class="flex-initial text-xl font-bold text-[{{jetzig_orange}}]"><i class="fa-solid fa-code fa-fw me-2"></i> HTML</h4>
  <div>
    <p>Templating with
      @partial link(title: "Zmpl", href: "https://github.com/jetzig-framework/zmpl")
      provides <b>layouts</b>, <b>partials</b>, and build-time <b>static content rendering</b>.</p>
  </div>

  <h4 class="flex-initial text-xl font-bold text-[{{jetzig_orange}}]"><i class="fa-solid fa-brackets-curly fa-fw me-2"></i> JSON</h4>
  <div>
    <p>Every view function generates HTML and JSON by default. Template data and JSON data are fully interchangeable, enabling your web application as a front end application and a REST API for free.</p>
  </div>

  <h4 class="flex-initial text-xl font-bold text-[{{jetzig_orange}}]"><i class="fa-solid fa-cookie fa-fw me-2"></i>Cookies</h4>
  <div>
    <p>Cookies, user sessions, and request/response headers out of the box.</p>
  </div>

  <h4 class="flex-initial text-xl font-bold text-[{{jetzig_orange}}]"><i class="fa-solid fa-wrench fa-fw me-2"></i>Tooling</h4>
  <div>
    <p>User-friendly tooling for creating projects and adding new components.</p>
  </div>

  <h4 class="flex-initial text-xl font-bold text-[{{jetzig_orange}}]"><i class="fa-solid fa-gears fa-fw me-2"></i>Middleware</h4>
  <div>
    <p>Hook into and manipulate requests/responses with a custom middleware chain. Built-in middleware for
    @partial link("htmx", "https://htmx.org/")
    .</p>
  </div>

  <h4 class="flex-initial text-xl font-bold text-[{{jetzig_orange}}]"><i class="fa-solid fa-heart fa-fw me-2"></i> Community</h4>
  <div>
    <p>Join us on
    @partial link("Discord", "https://discord.gg/eufqssz7X6")
    &ndash; we're friendly and active.</p>
  </div>

  <h4 class="flex-initial text-xl font-bold text-[{{jetzig_orange}}]"><i class="fa-solid fa-code-pull-request fa-fw me-2"></i> Open Source</h4>
  <div>
    <p>Free, open source, and always will be. <i>Jetzig</i> is
    @partial link("MIT", "https://en.wikipedia.org/wiki/MIT_License")
    licensed.</p>
  </div>
</div>
