<div>
  @partial h2("Contact")

  <p class="text-gray-500 mt-2">If you have any questions, suggestions, or just want to say hi, you can use any of the following contact methods:</p>

  <ul class="text-gray-500 ms-6 leading-6">
    <li><a class="ms-2 me-2" href="https://discord.gg/eufqssz7X6"><img src="/discord.png" /></a></li>
    <li>
      @partial link("hello@jetzig.dev", "mailto:hello@jetzig.dev?subject=Email from jetzig.dev")
    </li>
  </ul>

  <hr class="mt-4" />

  @partial h2("Contact form")

  <div class="mt-4">
    <form action="/contact" method="POST">
      <div class="grid grid-flow-dense grid-cols-4 gap-4">
        @partial h3("Your email address")

        <div class="col-span-3 mt-3">
          <input class="border p-1" type="text" name="from" placeholder="user@example.com" />
        </div>

        @partial h3("Message")

        <div class="col-span-3 mt-3">
          <textarea class="border p-1" cols="30" rows="10" name="message" placeholder="Enter message here"></textarea>
        </div>
      </div>

      <input class="border py-1 px-2 bg-[#f7931e] text-white" type="submit" value="Send Message" />
    </form>
  </div>
</div>
