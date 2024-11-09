@args title: []const u8, path: []const u8
 <a
  href="#"
  hx-get="/documentation/sections/{{path}}"
  hx-target="#documentation-section"
  hx-swap="innerHTML"
  hx-push-url="true"
  class="documentation-link hover:bg-gray-50 block rounded-md py-2 pr-2 pl-9 text-sm leading-6 text-gray-700">{{title}}</a>
