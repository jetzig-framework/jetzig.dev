<div>
  @partial h2("Downloads")
  <p class="text-gray-500 mt-2">Download the latest <i>Jetzig</i> command line tooling for your operating system.</p>

  <p class="text-gray-500 mt-2">The command line tooling provides commands to initialize a new project and generate components such as views, middleware, and templates.</p>

  <p class="text-gray-500 mt-2">This page is updated daily with the latest builds from the
  @partial code("main")
  branch.</p>

  <div>
    <ul class="list-disc text-gray-500 ms-6 leading-8">
    @zig {
        if (zmpl.getT(.array, "downloads")) |downloads| {
          for (downloads.items()) |download| {
              const title = download.getT(.string, "title") orelse continue;
              const path = download.getT(.string, "path") orelse continue;
              <li>
                @partial link(title, path)
              </li>
          }
        }
    }
    </ul>
  </div>

  @partial h3("Setup")

  <ul class="list-disc text-gray-500 ms-6 leading-8">
    <li>Download the appropriate zip file for your operating system and unzip.</li>
    <li>(Linux/OSX): Set executable permissions on the unzipped program:
      @partial code("chmod +x jetzig")
    </li>
    <li>Optionally copy the executable into a directory in your
      @partial code("PATH")
      , e.g.
      @partial code("/usr/local/bin")
    </li>
    <li>Run
      @partial code("jetzig --help")
      to see detailed usage instructions.</li>
  </ul>

  @partial h3("Advanced Setup")

  <p class="text-gray-500 mt-2">You may prefer to compile the CLI tool yourself. Follow these steps to do so:</p>

  <ul class="list-disc text-gray-500 ms-6 leading-8">
    <li>Clone the repository:
      @partial code("git clone https://github.com/jetzig-framework/jetzig")
    </li>
    <li>Change to the CLI sub-project directory:
      @partial code("cd jetzig/cli")
    </li>
    <li>Compile:
      @partial code("zig build install")
    </li>
    <li>Run the compiled executable:
      @partial code("zig-out/bin/jetzig --help")
    </li>
  </ul>
</div>
