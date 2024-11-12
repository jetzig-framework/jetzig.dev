@zig {
  const button_classes =
    \\block
    \\py-2
    \\px-3
    \\text-gray-900
    \\rounded
    \\hover:bg-gray-100
    \\md:hover:bg-transparent
    \\md:border-0
    \\md:hover:text-blue-700
    \\md:p-0
    \\dark:text-white
    \\md:dark:hover:text-blue-500
    \\dark:hover:bg-gray-700
    \\dark:hover:text-white
    \\md:dark:hover:bg-transparent
    ;

  const links = .{
    .{ .href = "/", .title = "Home" },
    .{ .href = "/about.html", .title = "About" },
    .{ .href = "/documentation.html", .title = "Documentation" },
    .{ .href = "/downloads.html", .title = "Downloads" },
    .{ .href = "/contact.html", .title = "Contact" },
    .{ .href = "/blogs.html", .title = "Blog" },
  };
}

<nav class="bg-white border-gray-200 dark:bg-gray-900">
  <div class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4">
    <a href="/"><img src="/jetzig.png" alt="Jetzig Logo" class="h-8"></a>

    <a href="https://github.com/jetzig-framework/jetzig" target="_blank" title="GitHub"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/jetzig-framework/jetzig"></a>

    <button
      id="burger-menu"
      data-collapse-toggle="navbar-default"
      data-collapse="navbar-default"
      type="button"
      class="inline-flex
             items-center
             p-2
             w-10
             h-10
             justify-center
             text-sm
             text-gray-500
             rounded-lg
             md:hidden
             hover:bg-gray-100
             focus:outline-none
             focus:ring-2
             focus:ring-gray-200
             dark:text-gray-400
             dark:hover:bg-gray-700
             dark:focus:ring-gray-600"
      aria-controls="navbar-default"
      aria-expanded="false"
    >
        <span class="sr-only">Open main menu</span>
        <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 17 14">
          <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 1h15M1 7h15M1 13h15"/>
        </svg>
    </button>
    <div class="hidden w-full md:block md:w-auto" id="navbar-default">
      <ul class="font-medium
               flex
               flex-col
               p-4
               md:p-0
               mt-4
               border
               border-gray-100
               rounded-lg
               bg-gray-50
               md:flex-row
               md:space-x-8
               rtl:space-x-reverse
               md:mt-0 md:border-0
               md:bg-white
               dark:bg-gray-800
               md:dark:bg-gray-900
               dark:border-gray-700">
        @zig {
          inline for (links) |link| {
            <li>
              <a href="{{link.href}}"
                 hx-get="{{link.href}}"
                 hx-target="#content"
                 hx-push-url="true"
                 hx-swap="innerHTML"
                 class="{{button_classes}}" aria-current="page">{{link.title}}</a>
            </li>
          }
        }
        <li>
          <a
             href="https://github.com/jetzig-framework/jetzig"
             target="_blank"
             class="{{button_classes}}">Source Code</a>
        </li>
        <li>
          <a
             href="https://discord.gg/eufqssz7X6"
             target="_blank">
             <img class="ms-2 sm:ms-0" src="/discord.png">
          </a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<script>
  document.addEventListener("DOMContentLoaded", () => {
    const navbar = document.querySelector("#navbar-default");

    document.querySelector("#burger-menu").addEventListener("click", () => {
      navbar.classList.toggle("hidden"); });

    document.querySelectorAll("#navbar-default a").forEach(element => {
      element.addEventListener("click", () => {
        navbar.classList.add("hidden")
      });
    });
  });
</script>
