@args title: []const u8, href: []const u8
@zig {
  const jetzig_green = "text-[#39b54a]";
  // TODO: Default partial args:
  const target = "_self";
}
<a class="font-bold {{jetzig_green}}" href="{{href}}" target="{{target}}">{{title}}</a>
