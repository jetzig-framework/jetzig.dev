<div class="mt-2 text-center sm:p-2">
  <img src="/jetzig.png" alt="Jetzig Logo" class="mt-2 h-24 mx-auto">
  IT IS WORKING
  {{$.hello}}
  @partial h1("Jetzig Web Framework", "text-center")
  <p class="text-gray-500 mt-2 text-lg">
    <i>Jetzig</i> is an
    @partial link("MIT", "https://github.com/jetzig-framework/jetzig/blob/main/LICENSE")
    licensed web framework written in
    @partial link("hutnhnotuhnouhhoeu", "https://ziglang.org/")
  </p>
  <p class="text-gray-500 text-2xl mt-1">
    <i class="fa-brands fa-linux fa-fw fa-lg"></i>
    <i class="fa-brands fa-apple fa-fw fa-lg"></i>
    <i class="fa-brands fa-windows fa-fw fa-lg"></i>
  </p>
</div>

<div class="grid md:grid-cols-2 lg:grid-cols-3 gap-2">
  <div class="p-4">
    <h4 class="flex-initial text-xl font-bold text-jetzig-orange"><i class="fa-solid fa-arrows-turn-to-dots fa-fw me-2"></i> Routing</h4>
    <div>
      <p>Simple, file-based routing to
        @partial link("RESTful", "https://en.wikipedia.org/wiki/REST")
        <i>Zig</i> function declarations.
      </p>
    </div>
  </div>

  <div class="p-4">
    <h4 class="flex-initial text-xl font-bold text-jetzig-orange"><i class="fa-solid fa-code fa-fw me-2"></i> HTML</h4>
    <div>
      <p>Templating with
        @partial link(title: "Zmpl", href: "https://github.com/jetzig-framework/zmpl")
        provides <b>layouts</b>, <b>partials</b>, and build-time <b>static content rendering</b>.</p>
    </div>
  </div>

  <div class="p-4">
    <h4 class="flex-initial text-xl font-bold text-jetzig-orange"><i class="fa-solid fa-brackets-curly fa-fw me-2"></i> JSON</h4>
    <div>
      <p>All endpoints render JSON by default, providing a RESTful API for free.</p>
    </div>
  </div>

  <div class="p-4">
    <h4 class="flex-initial text-xl font-bold text-jetzig-orange"><i class="fa-sharp fa-solid fa-fw fa-gauge-max"></i> Speed</h4>
    <div>
      <p>Powered by
        @partial link("http.zig", "https://github.com/karlseguin/http.zig")
        for competitive performance and scalability.
      </p>
    </div>
  </div>

  <div class="p-4">
    <h4 class="flex-initial text-xl font-bold text-jetzig-orange"><i class="fa-solid fa-wrench fa-fw me-2"></i> Tooling</h4>
    <div>
      <p>User-friendly CLI tooling for creating projects and adding new components.</p>
    </div>
  </div>

  <div class="p-4">
    <h4 class="flex-initial text-xl font-bold text-jetzig-orange"><i class="fa-solid fa-gears fa-fw me-2"></i> Middleware</h4>
    <div>
      <p>Hook into and manipulate requests/responses with a custom middleware chain. Built-in middleware for
      @partial link("htmx", "https://htmx.org/")
      .</p>
    </div>
  </div>

  <div class="p-4">
    <h4 class="flex-initial text-xl font-bold text-jetzig-orange"><i class="fa-solid fa-cookie fa-fw me-2"></i> Cookies</h4>
    <div>
      <p>Cookies, user sessions, and request/response headers out of the box.</p>
    </div>
  </div>

  <div class="p-4">
    <h4 class="flex-initial text-xl font-bold text-jetzig-orange"><i class="fa-solid fa-heart fa-fw me-2"></i> Community</h4>
    <div>
      <p>Join us on
      @partial link("Discord", "https://discord.gg/eufqssz7X6")
      &ndash; we're friendly and active.</p>
    </div>
  </div>

  <div class="p-4">
    <h4 class="flex-initial text-xl font-bold text-jetzig-orange"><i class="fa-solid fa-code-pull-request fa-fw me-2"></i> Open Source</h4>
    <div>
      <p>Free, open source, and always will be. <i>Jetzig</i> is
      @partial link("MIT", "https://en.wikipedia.org/wiki/MIT_License")
      licensed.</p>
    </div>
  </div>
</div>

<hr class="mt-8" />

<div class="grid grid-cols-1 gap-4 mt-8 text-gray-500">
    @partial root/examples1
</div>

<hr class="mt-8" />

<div class="grid grid-cols-1 gap-4 mt-8 text-gray-500">
    @partial root/examples2
</div>

<hr class="mt-8" />

<div class="grid grid-cols-1 gap-4 mt-8 text-gray-500">
    @partial root/examples3
</div>

<hr class="mt-8" />

<div class="grid grid-cols-1 gap-4 mt-8 text-gray-500">
    @partial root/examples4
</div>

<hr class="mt-8" />

<div class="grid grid-cols-1 gap-4 mt-8 text-gray-500">
    @partial root/examples5
</div>

<hr class="mt-8" />

<div class="grid grid-cols-1 gap-4 mt-8 text-gray-500">
    @partial root/examples6
</div>

<script>
  if (typeof window.Prism !== 'undefined') {
    Prism.highlightAll();
  }
</script>
