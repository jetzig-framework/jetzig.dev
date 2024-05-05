<!DOCTYPE html>
<html lang="en">

  <head>
    <title>Jetzig Web Framework</title>
    <link rel="icon" type="image/x-icon" href="/favicon.ico">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/htmx.org@1.7.0/dist/htmx.js"></script>
    <link rel="stylesheet" href="/styles.css" />
    <link rel="stylesheet" href="/prism.css">
    <script src="https://kit.fontawesome.com/030a384a33.js" crossorigin="anonymous"></script>
    <script src="/prism.js" data-manual></script>
    <script
      type="text/javascript"
      src="https://app.termly.io/resource-blocker/14db3a3d-d477-44ad-8e54-bcd352c8df9e?autoBlock=on">
    </script>
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-2Y6KZDMLMX"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'G-2Y6KZDMLMX');
    </script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Jetzig is a batteries-included web framework written in Zig">
  </head>

  <body class="bg-gray-100">
    <header class="header">
      @partial layouts/application/nav
    </header>

    <main class="container mx-auto mt-8 p-6 bg-white rounded-lg shadow-md">
      <div id="content">
        {{zmpl.content}}
      </div>
    </main>

    <footer class="bg-green-600 text-white py-4 px-6 mt-8 footer">
      <div class="container mx-auto text-center">
        <p>&copy; 2023-2024 Jetzig Framework | <a href="#" class="termly-display-preferences">Consent Preferences</a></p>
      </div>
    </footer>
  </body>
</html>
