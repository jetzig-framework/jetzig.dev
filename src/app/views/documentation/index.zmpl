<div class="md:flex">
  <>{^documentation/sidebar}</>
  <div class="w-100 md:w-3/4 px-8">
    <>{^h2(content: "Quickstart")}</>
    <p class="text-gray-500 mt-4 mb-4">Full documentation is in the works. In the meantime, use this quickstart guide to get up and running.</p>

    <p class="text-gray-500 mt-4 mb-4">This website is a <i>Jetzig</i> application, feel free to {^link(title: "browse the source code", href: "https://github.com/jetzig-framework/jetzig.dev.zig", target: "_blank")} to see how a full application is put together. There is also a {^link(href: "https://github.com/jetzig-framework/jetzig/tree/main/demo", title: "demo project")} inside the <i>Jetzig</i> repository which showcases many of the available features.</p>

    <p class="text-gray-500 mt-4 mb-4">You can also watch a {^link(title: "screencast", href: "https://www.youtube.com/watch?v=qeaO_MwfUII", target: "_blank")} on our official {^link(title: "YouTube Channel", href: "https://www.youtube.com/@JetzigWebFramework", target: "_blank")}.</p>

    <>{^h3(content: "1. Download a binary")}</>

    <p class="text-gray-500 mt-4 mb-4">Visit the {^link(title: "downloads", href: "/downloads.html")} page and download the appropriate pre-compiled binary for your operating system.</p>

    <>{^h3(content: "2. Create a new project")}</>

    <p class="text-gray-500 mt-4 mb-4">Use the interactive command line tool to generate a new project. You will be prompted with a few options to choose how to initialize your project.</p>

    <pre><code class="language-bash">$ jetzig init</code></pre>

    <>{^h3(content: "3. Launch a server")}</>

    <p class="text-gray-500 mt-4 mb-4">The command line tool also provides a server launcher that reloads the server when changes are detected. This is a simple wrapper around {^snippet(content: "zig build run")}.</p>

    <pre><code class="language-bash">$ jetzig server</code></pre>

    <>{^h3(content: "4. Generate a view")}</>

    <p class="text-gray-500 mt-4 mb-4">Use the command line tool again to generate a view for the {^snippet(content: "/iguanas")} endpoint with an {^snippet(content: "index")} function:</p>

    <pre><code class="language-bash">$ jetzig generate view iguanas index</code></pre>

    <p class="text-gray-500 mt-4 mb-4">A default view is provided for the root path: {^snippet(content: "/")}. This view is named {^snippet(content: "root.zig")}. Other routes are mapped to the name of the view.</p>

    <p class="text-gray-500 mt-4 mb-4">For example, the {^snippet(content: "index")} function in {^snippet(content: "src/app/views/iguanas.zig")} maps to the following endpoints:</p>

    <ul class="list-disc text-gray-500 ms-6 leading-8">
      <li>{^snippet(content: "/iguanas")}
      <li>{^snippet(content: "/iguanas.html")}
      <li>{^snippet(content: "/iguanas.json")}
    </ul>

    <p class="text-gray-500 mt-4 mb-4">All views in <i>Jetzig</i> automatically provide <i>JSON</i> endpoints, and any view function with a corresponding template will render <i>HTML</i>.</p>

    <p class="text-gray-500 mt-4 mb-4"><i>Jetzig</i> uses its own templating language {^link(title: "Zmpl", href: "https://github.com/jetzig-framework/zmpl")}. The template for the {^snippet(content: "/iguanas.html")} endpoint is located in {^snippet(content: "src/app/views/iguanas/index.zmpl")}</p>

    <p class="text-gray-500 mt-4 mb-4">The default response format is {^snippet(content: "html")}, but this can be overridden by specifying one of the following:</p>

    <ul class="list-disc text-gray-500 ms-6 leading-8">
      <li>{^snippet(content: ".json")} extension in the URL</li>
      <li>{^snippet(content: "Accept: application/json")} request header</li>
      <li>{^snippet(content: "Content-Type: application/json")} request header</li>
    </ul>

    <>{^h3(content: "5. Create some data")}</>

    <p class="text-gray-500 mt-4 mb-4">A core concept to <i>Jetzig</i> is its handling of response data. All view functions receive a {^snippet(content: "data")} argument. This argument provides a set of functions for creating data that can be used in templates and exposed as <i>JSON</i>. In <i>Jetzig</i>, template data and <i>JSON</i> data are one in the same. Simply add data to your response and it is automatically available in templates and <i>JSON</i> endpoints.</p>

    <p class="text-gray-500 mt-4 mb-4">The first call to {^snippet(content: "data.object()")} <b>or</b> {^snippet(content: "data.array()")} becomes the root data object. Add values to root object and use them in your templates or iew them as <i>JSON</i>. Here's an example:</p>

    <#>
    <pre><code class="language-zig">// src/app/views/iguanas.zig
const jetzig = @import("jetzig");

pub fn index(request: *jetzig.Request, data: *jetzig.Data) !jetzig.View {
    var root = try data.object();
    try root.put("message", data.string("Welcome to Jetzig!"));
    try root.put("iguana_count", data.integer(100_000));

    return request.render(.ok);
}</code></pre>
    </#>

    <p class="text-gray-500 mt-4 mb-4">You can now use <i>Zmpl</i>'s data lookup syntax to access these values in your template:</p>

    <#>
    <pre><code class="language-zig">// src/app/views/iguanas/index.zmpl
&lt;div&gt;Message: {.message}&lt;/div&gt;
&lt;div&gt;{.iguana_count} iguanas!&lt;/div&gt;
</code></pre>
    </#>

    <p class="text-gray-500 mt-4 mb-4">Browse to {^snippet(content: "http://localhost:8080/iguanas.html")} to see your rendered <i>HTML</i> (the {^snippet(content: ".html")} exnension is optional) or visit {^snippet(content: "http://localhost:8080/iguanas.json")} to see the raw <i>JSON</i> data.</p>

    <>{^h3(content: "6. Generate a layout")}</>

    <p class="text-gray-500 mt-4 mb-4">To avoid having to copy and paste the same page layout repeatedly and to help keep your templates focused and concise, <i>Jetzig</i> provides layout templates.</p>

    <p class="text-gray-500 mt-4 mb-4">Use the command line tool again to create a layout named {^snippet(content: "custom_layout")}:</p>

    <pre><code class="language-bash">$ jetzig generate layout custom_layout</code></pre>

    <p class="text-gray-500 mt-4 mb-4">Then add the following line of code anywhere in {^snippet(content: "src/app/views/iguanas.zig")}:</p>

    <pre><code class="language-zig">pub const layout = "custom_layout";</code></pre>

    <p class="text-gray-500 mt-4 mb-4">All <i>HTML</i> output for view functions in the {^snippet(content: "/iguanas")} route will now be enclosed inside the content in {^snippet(content: "src/app/views/layouts/custom_layout.zmpl")}.</p>
  </div>
</div>

<#>
<script>
  Prism.highlightAll();
</script>
</#>
