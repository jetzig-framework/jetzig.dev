<div>
  <>{^h2(content: "About")}</>

  <p class="text-gray-500 mt-2">
    <i>Jetzig</i> is a "batteries-included"
    <>{^link(title: "MIT", href: "https://github.com/jetzig-framework/jetzig/blob/main/LICENSE")}</>
    <>licensed web framework written in {^link(title: "Zig", href: "https://ziglang.org/")}.</>
  </p>

  <>{^h4(content: "Supported Operating Systems:")}</>

  <ul class="text-gray-500 mt-4">
    <li><i class="fa-brands fa-linux fa-fw"></i> Linux</li>
    <li><i class="fa-brands fa-apple fa-fw"></i> OS X</li>
    <li><i class="fa-brands fa-windows fa-fw"></i> Windows</li>
  </ul>

  <p class="text-gray-500 mt-2">The project borrows ideas from the many web frameworks that the authors have worked with over the years, as well as bringing some new ideas of its own. We aim to bring a developer-friendly experience to <i>Zig</i> to make web development accessible and enjoyable.</p>

  <p class="text-gray-500 mt-2">If you are looking for a <i>Zig</i> web framework comparable to {^link(href: "https://rubyonrails.org/", title: "Rails")} then you have come to the right place.</p>

  <p class="text-gray-500 mt-2">Visit our {^link(title: "YouTube Channel", href: "https://www.youtube.com/@JetzigWebFramework", target: "_blank")} to watch our screencasts.</p>

  <>{^h3(content: "Philosophy")}</>

  <ul class="list-disc text-gray-500 ms-4 space-y-4">
    <li><i>Jetzig</i> will always be free to <b>use</b>, <b>modify</b>, and <b>distribute</b> in <b>any context</b>. The {^link(title: "MIT License", href: "https://github.com/jetzig-framework/jetzig/blob/main/LICENSE")} allows users to freely use this software however they choose.</li>
    <li><i>Jetzig</i> does not ask for funding. Any donations should go to the {^link(title: "Zig Software Foundation", href: "https://ziglang.org/zsf/")} or another good cause of your choosing.</li>
    <li>We will never ship with a dependency that is not pure <i>Zig</i>. Users can choose to leverage <i>Zig</i>'s powerful {^link(title: "build system", href: "https://ziglang.org/learn/build-system/")} to integrate <i>C</i> dependencies, but the framework itself will always be <b>100% <i>Zig</i></b>.
    <li><b>Developer experience</b> is the top priority. Features should always be easy to understand and use. The framework provides tooling to help developers create and manage projects, debug their applications, and integrate framework components. A new project should require <b>zero configuration</b> to get up and running, with sensible defaults that can be customized as needed.</li>
    <li>As members of the open source community, we advocate <b>promotion of other open source projects</b>. See {^link(title: "Alternatives", href: "#alternatives")} for other tools that may benefit you, and {^link(title: "contact us", href: "/contact.html")} if your web-related project is not listed here, we will be happy to include it.</li>
  </ul>

  <>{^h3(content: "Roadmap")}</>
  <p class="text-gray-500 mt-2">The <i>Jetzig</i> roadmap is always growing. Check back here to see updates and feel free to {^link(title: "contact us", href: "/contact.html")} if you want to suggest an addition to the roadmap.</p>

  <div class="grid grid-cols-2 gap-4">
    <div>
      <>{^h4(content: "<i class=\"fa-sharp fa-light fa-check fa-fw be-2\"></i> Completed")}</>
      <ul class="list-disc text-gray-500 ms-6 leading-8">
        <li>File system-based routing</li>
        <li>HTML and JSON responses</li>
        <li>JSON-compatible response data builder</li>
        <li>HTML templating</li>
        <li>Per-request arena allocator</li>
        <li>Sessions</li>
        <li>Cookies</li>
        <li>Error handling</li>
        <li>Static content from /public director.</li>
        <li>Request/response headers</li>
        <li>Stack trace output on error</li>
        <li>Build-time static content rendering</li>
        <li>Param/JSON payload parsing/abstracting</li>
        <li>Static content parameter definitions</li>
        <li>Middleware interface</li>
        <li>MIME type inference</li>
        <li>CLI tool with generators/scaffolding</li>
        <li>{^link(title: "htmx", href: "https://htmx.org/")} middleware</li>
      </ul>
    </div>

    <div>
      <>{^h4(content: "<i class=\"fa-sharp fa-light fa-clock fa-fw be-2\"></i> Pending")}</>
      <ul class="list-disc text-gray-500 ms-6 leading-8">
        <li>Environment configurations (development, staging, production, etc.)</li>
        <li>Production server readiness (daemonization, file logging)</li>
        <li>Development mode debug page</li>
        <li>Background jobs</li>
        <li>{^link(title: "Tailwind", href: "https://tailwindcss.com/")} middleware</li>
        <li>General purpose cache</li>
        <li>Custom (non-RESTful) routing</li>
        <li>HTTP {^snippet(content: "keep-alive")}</li>
        <li>Websockets</li>
        <li>Email delivery</li>
        <li>Email receipt (via AWS SES, Sendgrid, etc.)</li>
      </ul>
    </div>
  </div>

  <>{^h3(content: "Alternatives")}</>
  <a name="alternatives">
  <p class="text-gray-500 mt-2">The below list is a set of alternative or related projects. Please {^link(title: "contact us", href: "/contact.html")} if you would like your project to be listed here.</p>
  <ul class="list-disc text-gray-500 ms-6 leading-8">
    <li>{^link(title: "Zap", href: "https://github.com/zigzap/zap", target: "_blank")}: <i>blazingly fast backends in zig</i></li>
    <li>{^link(title: "http.zig", href: "https://github.com/karlseguin/http.zig", target: "_blank")}: <i>An HTTP/1.1 server for Zig.</i></li>
    <li>{^link(title: "tokamak", href: "https://github.com/cztomsik/tokamak", target: "_blank")}: <i>Server-side framework for Zig</i></li>
    <li>{^link(title: "zig-router", href: "https://github.com/Cloudef/zig-router", target: "_blank")}: <i>Straightforward HTTP-like request routing.</i></li>
    <li>{^link(title: "zig-webui", href: "https://github.com/webui-dev/zig-webui/", target: "_blank")}: <i>Allows you to use any web browser as a GUI, with your preferred language in the backend and HTML5 in the frontend.</i></li>
    <li>{^link(title: "ZTS", href: "https://github.com/zigster64/zts", target: "_blank")}: <i>Zig Templates made Simple</i></li>
  </ul>
</div>
