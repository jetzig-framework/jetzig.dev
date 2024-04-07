<div class="md:flex">
  <>{^documentation/sidebar}</>
  <div id="documentation-section" class="w-100 md:w-3/4 px-8">
    <div hx-get="/documentation/sections/quickstart.html" hx-trigger="load"></div>
  </div>
</div>

<#>
<script>
  window.addEventListener("htmx:load", (ev) => {
    Prism.highlightAll();
  });
</script>
</#>
