/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/app/views/**/*.{zmpl,html,js}", "./src/main.zig"],
  theme: {
    extend: {
      colors: {
        "jetzig-green": "#39b54a",
        "jetzig-orange": "#f7931e",
      },
    }
  },
  plugins: [],
}

