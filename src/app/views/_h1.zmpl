@args content: []const u8, class: []const u8 = ""
@zig {
  const jetzig_orange = "#f7931e";
}
<h1 class="text-[{{jetzig_orange}}] mt-2 text-2xl mb-2 {{class}}">{{content}}</h1>
