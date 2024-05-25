@args title: []const u8, path: []const u8
<a
  href="#"
  hx-get="/documentation/sections/{{path}}"
  hx-target="#documentation-section"
  hx-swap="innerHTML"
  hx-push-url="true"
  class="text-blue-500 m-5 hover:underline">{{title}}</a>
