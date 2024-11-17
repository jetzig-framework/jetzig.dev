<div>
  @partial blogs/title(.blog.title, .blog.author)

  <div>
    {{zmpl.fmt.raw(zmpl.ref("blog.content"))}}
  </div>

  @for ($.blog.comments) |comment| {
    @partial blogs/comment(comment.name, comment.content)
  }

  <div class="grid grid-flow-dense grid-cols-4 gap-4">
    <form action="/blogs/comments" method="POST">
      <input type="hidden" name="blog_id" value="{{.blog.id}}" />
      <input class="border p-1 dark:bg-gray-800" type="text" name="name" placeholder="Your name here..." />
      <textarea class="border p-1 dark:bg-gray-800" cols="30" rows="10" name="content" placeholder="Enter comment here..."></textarea>
      <input class="border py-1 px-2 bg-[#f7931e] text-white" type="submit" value="Submit" />
    </form>
  </div>
</div>
