<div class="mt-4">
  <form action="/blogs/{{$.blog.id}}/_PATCH" method="POST">
    {{context.authenticityFormElement()}}
    <div class="grid grid-flow-dense grid-cols-4 gap-4">
      <label>Title</label>
      <div class="col-span-3 mt-3">
        <input class="border p-1 dark:bg-gray-800" type="text" name="title" value="{{$.blog.title}}" />
      </div>

      <label>Content</label>
      <div class="col-span-3 mt-3">
        <textarea class="border p-1 dark:bg-gray-800" cols="30" rows="10" name="content" placeholder="Enter content here">{{$.blog.content}}</textarea>
      </div>
    </div>

    <input class="border py-1 px-2 bg-[#f7931e] text-white dark:bg-gray-800" type="submit" value="Submit" />
  </form>
</div>
