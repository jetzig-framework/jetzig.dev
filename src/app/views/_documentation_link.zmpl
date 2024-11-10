@args title: []const u8, path: []const u8
 <a
  href="#"
  hx-get="/documentation/sections/{{path}}"
  hx-target="#documentation-section"
  hx-swap="innerHTML"
  hx-push-url="true"
  class="documentation-link hover:bg-gray-50 dark:hover:bg-gray-700 dark:hover:text-white block rounded-md py-2 pr-2 pl-9 text-sm leading-6 text-gray-700 dark:text-gray-300 font-bold">{{title}}</a>
