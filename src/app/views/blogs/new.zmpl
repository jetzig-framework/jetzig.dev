<div class="max-w-5xl mx-auto px-4 py-8">
  @partial h2("Create a New Blog Post")

  <div class="mt-8">
    <form action="/blogs" method="POST">
      {{context.authenticityFormElement()}}
      <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div class="md:col-span-1">
          <label for="title" class="block text-gray-700 font-medium">Title</label>
        </div>
        <div class="md:col-span-3">
          <input
            id="title"
            class="w-full border border-gray-300 rounded-md p-2 focus:outline-none focus:ring-2 dark:bg-gray-900 focus:ring-[#f7931e]"
            type="text"
            name="title"
            required
          />
        </div>

        <div class="md:col-span-1">
          <label for="content" class="block text-gray-700 font-medium">Content</label>
        </div>
        <div class="md:col-span-3">
          <textarea
            id="content"
            class="w-full border border-gray-300 rounded-md p-2 h-64 resize-none focus:outline-none focus:ring-2 dark:bg-gray-900 focus:ring-[#f7931e]"
            name="content"
            placeholder="Enter content here"
            required
          ></textarea>
        </div>
      </div>

      <div class="mt-6 text-right">
        <button
          type="submit"
          class="inline-block bg-[#f7931e] text-white py-2 px-6 rounded-md hover:bg-[#e6831b] focus:outline-none focus:ring-2 focus:ring-[#f7931e]"
        >
          Submit
        </button>
      </div>
    </form>
  </div>
</div>
