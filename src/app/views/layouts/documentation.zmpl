@inherit "layouts/application"
<div class="md:flex">
  @partial documentation/sidebar
  <div id="documentation-section" class="w-100 md:w-3/4 px-8">
    {{zmpl.content}}
  </div>
</div>

<script>
  window.addEventListener("htmx:load", (ev) => {
    Prism.highlightAll();
  });
</script>
