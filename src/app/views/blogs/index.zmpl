<div class="max-w-5xl mx-auto px-4 py-8">
  @partial h1("Blog Posts")

  @if ($.is_signed_in)
    <div class="flex justify-between items-center mt-6 mb-4">
      <div>
        @partial link("New Blog Post", "/blogs/new")
      </div>
    </div>
    <hr class="border-gray-300" />
  @end

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
              @partial blogs/link(blog.id, blog.title, true)
            </td>
          @end
        </tr>
      }
    </tbody>
  </table>
</div>
