<div class="max-w-5xl mx-auto px-4 py-8">
  @partial h1("Blog Posts")

  @if ($.is_signed_in)
    <div class="flex justify-between items-center mt-6 mb-4">
      <a
        href="/blogs/new"
        class="inline-block bg-[#f7931e] text-white py-2 px-4 rounded-md hover:bg-[#e6831b] focus:outline-none focus:ring-2 focus:ring-[#f7931e]"
      >
        New Blog Post
      </a>
    </div>
    <hr class="border-gray-300" />
  @end

  <!-- Mobile Card Layout -->
  <div class="mt-6 md:hidden space-y-4">
    @for (.blogs) |blog| {
      <div class="bg-white dark:bg-gray-700 shadow-md rounded-md overflow-hidden">
        <div class="p-4">
          <h3 class="text-lg font-semibold text-gray-800 dark:text-white">
            @partial blogs/link(blog.id, blog.title, false)
          </h3>
          <p class="text-sm text-gray-500 mt-1">
            {{blog.author}} &middot; {{zmpl.fmt.datetime(blog.get("created_at"), "%Y-%m-%d")}}
          </p>
        </div>
        @if ($.is_signed_in)
          <div class="border-t border-gray-200 dark:border-gray-700 p-4 flex justify-end">
            @partial blogs/link(blog.id, "Edit", true)
          </div>
        @end
      </div>
    }
  </div>

  <!-- Desktop Table Layout -->
  <div class="hidden md:block overflow-x-auto">
    <table class="min-w-full divide-y divide-gray-200 mt-6">
      <thead class="bg-gray-50 dark:bg-gray-700">
        <tr>
          <th
            scope="col"
            class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-100 uppercase tracking-wider"
          >
            Title
          </th>
          <th
            scope="col"
            class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-100 uppercase tracking-wider"
          >
            Date
          </th>
          <th
            scope="col"
            class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-100 uppercase tracking-wider"
          >
            Author
          </th>
          @if ($.is_signed_in)
            <th class="px-6 py-3"></th>
          @end
        </tr>
      </thead>
      <tbody class="bg-white dark:bg-gray-900 divide-y divide-gray-200 dark:divide-gray-700">
        @for (.blogs) |blog| {
          <tr>
            <td class="px-6 py-4 whitespace-nowrap">
              @partial blogs/link(blog.id, blog.title, false)
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{zmpl.fmt.datetime(blog.get("created_at"), "%Y-%m-%d")}}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{blog.author}}
            </td>
            @if ($.is_signed_in)
              <td class="px-6 py-4 whitespace-nowrap">
                @partial blogs/link(blog.id, "Edit", true)
              </td>
            @end
          </tr>
        }
      </tbody>
    </table>
  </div>
</div>
