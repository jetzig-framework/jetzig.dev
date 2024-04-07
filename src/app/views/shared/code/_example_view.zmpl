<pre><code class="language-zig">// src/app/views/root.zig
const jetzig = @import("jetzig");

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var body = try data.object();
    try body.put("message", data.string("Welcome to Jetzig!"));
    return request.render(.ok);
\}</code></pre>
