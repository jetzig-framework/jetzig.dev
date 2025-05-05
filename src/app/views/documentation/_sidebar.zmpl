<div class="md:hidden">
  <button class="ms-2 text-right" id="toggle-sidebar-button"><i class="fa-solid fa-ellipsis-stroke-vertical"></i></button>
</div>

<div id="sidebar" class="hidden md:block flex grow flex-col gap-y-5 overflow-y-auto border-r border-gray-200 dark:border-gray:900 bg-white dark:bg-gray-800 dark:text-white px-6">
  <div class="flex h-16 shrink-0 items-center">
    <img class="h-8 w-auto" src="/jetzig.png" alt="Your Company">
  </div>
  <nav class="flex flex-1 flex-col">
    <ul role="list" class="flex flex-1 flex-col gap-y-7">
      <li>
        <ul role="list" class="-mx-2 space-y-1">
          <li>
            @partial documentation_header("Quickstart", "quickstart", false)
          </li>

          <li>
            <div>
              @partial documentation_header_expandable("Requests")
              <ul class="sub-menu px-2" id="sub-menu-requests">
                <li>
                  @partial documentation_link("Introduction", "requests/introduction")
                </li>
                <li>
                  @partial documentation_link("Routing", "requests/routing")
                </li>
                <li>
                  @partial documentation_link("Params", "requests/params")
                </li>
                <li>
                  @partial documentation_link("Headers", "requests/headers")
                </li>
                <li>
                  @partial documentation_link("Cookies", "requests/cookies")
                </li>
                <li>
                  @partial documentation_link("Rendering", "requests/rendering")
                </li>
                <li>
                  @partial documentation_link("Redirects", "requests/redirects")
                </li>
                <li>
                  @partial documentation_link("Layouts", "requests/layouts")
                </li>
                <li>
                  @partial documentation_link("Actions", "requests/actions")
                </li>
                <li>
                  @partial documentation_link("Anti-CSRF", "requests/anti_csrf")
                </li>
              </ul>
            </div>
          </li>

          <li>
            <div>
              @partial documentation_header_expandable("Data")
              <ul class="sub-menu px-2" id="sub-menu-data">
                <li>
                  @partial documentation_link("Introduction", "data/introduction")
                </li>
                <li>
                  @partial documentation_link("Root Value", "data/root_value")
                </li>
                <li>
                  @partial documentation_link("Value", "data/value")
                </li>
                <li>
                  @partial documentation_link("Complete Example", "data/example")
                </li>
              </ul>
            </div>
          </li>

          <li>
            <div>
              @partial documentation_header_expandable("Zmpl Templates")
              <ul class="sub-menu px-2" id="sub-menu-zmpl">
                <li>
                  @partial documentation_link("Introduction" , "zmpl/introduction")
                </li>
                <li>
                  @partial documentation_link("Modes", "zmpl/modes")
                </li>
                <li>
                  @partial documentation_link("References", "zmpl/references")
                </li>
                <li>
                  @partial documentation_link("Partials", "zmpl/partials")
                </li>
                <li>
                  @partial documentation_link("Iteration", "zmpl/iteration")
                </li>
                <li>
                  @partial documentation_link("If Statements", "zmpl/if_statements")
                </li>
              </ul>
            </div>
          </li>

          <li>
            <div>
              @partial documentation_header_expandable("Middleware")
              <ul class="sub-menu px-2" id="sub-menu-middleware">
                <li>
                  @partial documentation_link("Introduction" , "middleware/introduction")
                </li>
                <li>
                  @partial documentation_link("Configuration" , "middleware/configuration")
                </li>
                <li>
                  @partial documentation_link("Specification" , "middleware/specification")
                </li>
                <li>
                  @partial documentation_link("HtmxMiddleware" , "middleware/htmx")
                </li>
                <li>
                  @partial documentation_link("AuthMiddleware" , "middleware/auth")
                </li>
                <li>
                  @partial documentation_link("AntiCsrfMiddleware" , "middleware/anti_csrf")
                </li>
                <li>
                  @partial documentation_link("CompressionMiddleware" , "middleware/compression")
                </li>
              </ul>
            </div>
          </li>

          <li>
            <div>
              @partial documentation_header("Environment", "environment", false)
            </div>
          </li>

          <li>
            <div>
              @partial documentation_header_expandable("Jobs")
              <ul class="sub-menu px-2" id="sub-menu-jobs">
                <li>
                  @partial documentation_link("Introduction", "jobs/introduction", true)
                </li>
                <li>
                  @partial documentation_link("Configuration", "jobs/configuration")
                </li>
                <li>
                  @partial documentation_link("Creating Jobs", "jobs/create")
                </li>
                <li>
                  @partial documentation_link("Scheduling Jobs", "jobs/schedule")
                </li>
              </ul>
            </div>
          </li>

          <li>
            <div>
              @partial documentation_header_expandable("KV Store")
              <ul class="sub-menu px-2" id="sub-menu-store">
                <li>
                  @partial documentation_link("Introduction", "store/introduction")
                </li>
                <li>
                  @partial documentation_link("Configuration", "store/configuration")
                </li>
                <li>
                  @partial documentation_link("Usage", "store/usage")
                </li>
                <li>
                  @partial documentation_link("Example", "store/example")
                </li>
              </ul>
            </div>
          </li>

          <li>
            <div>
              @partial documentation_header_expandable("Cache")
              <ul class="sub-menu px-2" id="sub-menu-cache">
                <li>
                  @partial documentation_link("Introduction", "cache/introduction")
                </li>
                <li>
                  @partial documentation_link("Configuration", "cache/configuration")
                </li>
                <li>
                  @partial documentation_link("Example", "cache/example")
                </li>
              </ul>
            </div>
          </li>

          <li>
            <div>
              @partial documentation_header_expandable("Email")
              <ul class="sub-menu px-2" id="sub-menu-email">
                <li>
                  @partial documentation_link("Introduction", "email/introduction")
                </li>
                <li>
                  @partial documentation_link("Configuration", "email/configuration")
                </li>
                <li>
                  @partial documentation_link("Creating Mailers", "email/create")
                </li>
                <li>
                  @partial documentation_link("Delivery", "email/delivery")
                </li>
                <li>
                  @partial documentation_link("Example", "email/example")
                </li>
              </ul>
            </div>
          </li>

          <li>
            <div>
              @partial documentation_header_expandable("Database")
              <ul class="sub-menu px-2" id="sub-menu-database">
                <li>
                  @partial documentation_link("Introduction", "database/introduction")
                </li>
                <li>
                  @partial documentation_link("Example", "database/example")
                </li>
                <li>
                  @partial documentation_link("Tutorial", "database/tutorial")
                </li>
                <li>
                  @partial documentation_link("Configuration", "database/configuration")
                </li>
                <li>
                  @partial documentation_link("Schema", "database/schema")
                </li>
                <li>
                  @partial documentation_link("Models", "database/models")
                </li>
                <li>
                  @partial documentation_link("Query Interface", "database/query_interface")
                </li>
                <li>
                  @partial documentation_link("Where Clauses", "database/where_clauses")
                </li>
                <li>
                  @partial documentation_link("Executing Queries", "database/executing_queries")
                </li>
                <li>
                  @partial documentation_link("Migrations", "database/migrations")
                </li>
                <li>
                  @partial documentation_link("Command Line Tools", "database/command_line_tools")
                </li>
                <li>
                  @partial documentation_link("Standalone Usage", "database/standalone_usage")
                </li>
              </ul>
            </div>
          </li>

          <li>
            <div>
              @partial documentation_header("Testing", "testing", false)
            </div>
          </li>

        </ul>
      </li>
    </ul>
  </nav>
</div>

<script>
  (() => {
    document.querySelectorAll(".sub-menu").forEach(elem => elem.classList.add("hidden"));

    document.querySelectorAll(".expand-button").forEach(elem => {
      if (elem.classList.contains("initialized")) return;

      elem.classList.add("initialized");
      elem.addEventListener("click", () => {
        elem.querySelector(".expand-icon").classList.toggle("rotate-90");
        elem.querySelector(".expand-icon").classList.toggle("text-gray-500");
        elem.querySelector(".expand-icon").classList.toggle("text-gray-400");
        elem.parentElement.querySelector(".sub-menu").classList.toggle("hidden");
      });
    });

    document.querySelectorAll(".documentation-link").forEach(elem => {
      elem.addEventListener("click", () => {
        document.querySelector("#sidebar").classList.add("hidden");
      });
    });

    document.querySelector("#toggle-sidebar-button").addEventListener("click", () => {
      document.querySelector("#sidebar").classList.toggle("hidden");
    });
  })();
</script>
