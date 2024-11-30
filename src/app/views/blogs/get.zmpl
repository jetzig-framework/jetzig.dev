<div class="max-w-5xl mx-auto px-4 py-8">
  @if ($.is_signed_in)
    @partial blogs/link($.blog.id, $.blog.title, true)
  @end
  @partial blogs/title($.blog.title, $.blog.author)

  <h4 class="text-[#f7931e] text-lg mt-4">
    {{zmpl.fmt.datetime(zmpl.ref("blog.created_at"), "%Y-%m-%d")}}
  </h4>

  @if ($.blog.created_at != $.blog.updated_at)
    <p class="text-gray-500 text-sm">
      (Edited: {{zmpl.fmt.datetime(zmpl.ref("blog.updated_at"), "%Y-%m-%d %H:%M")}})
    </p>
  @end

  <div class="mt-6 prose prose-lg dark:prose-dark">
    {{zmpl.fmt.raw(zmpl.ref("blog.content"))}}
  </div>

  <hr class="mt-8 border-gray-300" />

  <!-- Start of narrower comments section -->
  <div class="max-w-3xl mx-auto">
    @zig {
      if (zmpl.ref("blog.comments")) |comments| {
        if (comments.count() > 0) {
          @partial h3("Comments")
        }
      }
    }

    @for ($.blog.comments) |comment| {
      @partial blogs/comment(comment.name, comment.content)
    }

    @partial h3("Leave a Comment")
    <form action="/blogs/comments" method="POST">
      <div class="grid grid-cols-1 mt-4 gap-4">
        {{context.authenticityFormElement()}}
        <input type="hidden" name="blog_id" value="{{.blog.id}}" />
        <input
          class="border border-gray-300 rounded-md p-2 dark:bg-gray-900 w-full focus:outline-none focus:ring-2 focus:ring-[#f7931e]"
          type="text"
          name="name"
          placeholder="Your name here..."
          required
        />
        <textarea
          class="border border-gray-300 rounded-md p-2 dark:bg-gray-900 w-full h-32 resize-none focus:outline-none focus:ring-2 focus:ring-[#f7931e]"
          name="content"
          placeholder="Enter comment here..."
          required
        ></textarea>
        <div class="text-right">
          <button
            type="submit"
            class="bg-[#f7931e] text-white py-2 px-6 rounded-md hover:bg-[#e6831b] focus:outline-none focus:ring-2 focus:ring-[#f7931e]"
          >
            Submit
          </button>
        </div>
      </div>
    </form>
  </div>
  <!-- End of narrower comments section -->
</div>
