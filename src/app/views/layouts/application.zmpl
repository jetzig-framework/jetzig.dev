<!DOCTYPE html>
<html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jetzig Web Framework</title>
    <link rel="icon" type="image/x-icon" href="/favicon.ico">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/htmx.org@1.7.0/dist/htmx.js"></script>
    <link rel="stylesheet" href="/styles.css" />
    <link rel="stylesheet" href="/prism.css">
    <script src="https://kit.fontawesome.com/030a384a33.js" crossorigin="anonymous"></script>
    <script src="/prism.js" data-manual></script>
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
        <p>&copy; 2023-2024 Jetzig Framework.</p>
      </div>
    </footer>
  </body>
</html>
