@extend "layouts/application"
<div class="md:flex p-1">
  @partial documentation/sidebar
  <div id="documentation-section" class="lg:w-100 md:w-3/4 sm:w-100 md:px-8 sm:px-1">
    {{zmpl.content}}
  </div>
</div>

<script>
  window.addEventListener("htmx:load", (ev) => {
    Prism.highlightAll();
  });
</script>
