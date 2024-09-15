<div>
  <ul>
  @for (.blogs) |blog| {
    <li><a href="/blogs/{{blog.id}}">{{blog.title}}</a></li>
  }
  </ul>
</div>
