<div>
  @partial h1(.blog.title)
  @partial h2(.blog.author)

  <div>
    {{.blog.content}}
  </div>

  @for (.blog.comments) |comment| {
    <div>
      <span>Name: {{comment.name}}</span>
      <div>Message: {{comment.content}}</div>
    </div>
  }

  <div class="grid grid-flow-dense grid-cols-4 gap-4">
    <form action="/blogs/comments" method="POST">
      <input type="hidden" name="blog_id" value="{{.blog.id}}" />
      <input type="text" name="name" placeholder="Your name here" />
      <textarea name="content" placeholder="Enter comment here..."></textarea>
      <input class="border py-1 px-2 bg-[#f7931e] text-white" type="submit" value="Submit" />
    </form>
  </div>
</div>
