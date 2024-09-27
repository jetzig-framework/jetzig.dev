<div>
  @partial link("New Blog Post", "/blogs/new")
  <hr/>
  <ul>
  @for (.blogs) |blog| {
    <li><a href="/blogs/{{blog.id}}">{{blog.title}}</a> ({{try zmpl.fmt.datetime(blog.created_at, "%c")}})</li>
  }
  </ul>
</div>
