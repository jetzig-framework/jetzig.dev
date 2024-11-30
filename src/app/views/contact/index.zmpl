<div class="max-w-3xl mx-auto px-4 py-8">
  @partial h2("Contact")

  <p class="text-gray-600 mt-4 text-lg">
    If you have any questions, suggestions, or just want to say hi, you can use any of the following contact methods:
  </p>

  <ul class="flex items-center space-x-6 mt-6">
    <li>
      <a href="https://discord.gg/eufqssz7X6">
        <img src="/discord.png" alt="Discord" class="ms-2 me-2" />
      </a>
    </li>
    <li>
      @partial link("hello@jetzig.dev", "mailto:hello@jetzig.dev?subject=Email from jetzig.dev")
    </li>
  </ul>

  <hr class="mt-8 border-gray-300" />

  @partial h2("Contact Form")

  <div class="mt-8">
    <form action="/contact" method="POST">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div class="md:col-span-1">
          @partial h3("Your Email Address")
        </div>
        <div class="md:col-span-3">
          <input
            class="w-full border border-gray-300 rounded-md p-2 dark:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-[#f7931e]"
            type="email"
            name="from"
            placeholder="user@example.com"
            required
          />
        </div>

        <div class="md:col-span-1">
          @partial h3("Message")
        </div>
        <div class="md:col-span-3">
          <textarea
            class="w-full border border-gray-300 rounded-md p-2 h-32 resize-none dark:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-[#f7931e]"
            name="message"
            placeholder="Enter your message here"
            required
          ></textarea>
        </div>
      </div>

      <div class="mt-6 text-right">
        <button
          type="submit"
          class="inline-block bg-[#f7931e] text-white py-2 px-6 rounded-md hover:bg-[#e6831b] focus:outline-none focus:ring-2 focus:ring-[#f7931e]"
        >
          Send Message
        </button>
      </div>
    </form>
  </div>
</div>
