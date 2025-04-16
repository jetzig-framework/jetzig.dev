<pre><code class="language-zig">// src/app/views/root.zig
const jetzig = @import("jetzig");

pub fn index(request: *jetzig.Request) !jetzig.View {
    var root = try request.data(.object);
    try root.put("message", "Welcome to Jetzig!");
    return request.render(.ok);
\}</code></pre>
