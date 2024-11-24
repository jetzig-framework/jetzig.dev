<div>
    @if ($.is_signed_in)
        @partial blogs/link($.blog.id, $.blog.title, true)
    @end
    @partial blogs/title($.blog.title, $.blog.author)

    <h4 class="text-jetzig-orange">{{zmpl.fmt.datetime(zmpl.ref("blog.created_at"), "%Y-%m-%d")}}</h4>

    @if ($.blog.created_at != $.blog.updated_at)
    (Edited: {{zmpl.fmt.datetime(zmpl.ref("blog.updated_at"), "%Y-%m-%d %H:%M:%S")}})
    @end

    <div>
    {{zmpl.fmt.raw(zmpl.ref("blog.content"))}}
    </div>

    <hr/>

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

    <form action="/blogs/comments" method="POST">
        <div class="grid grid-flow-dense w-100 md:w-1/2 mt-4 grid-cols-1 gap-4">
            {{context.authenticityFormElement()}}
            <input type="hidden" name="blog_id" value="{{.blog.id}}" />
            <input class="border p-1 dark:bg-gray-800 m-2" type="text" name="name" placeholder="Your name here..." />
            <textarea class="border p-1 dark:bg-gray-800 m-2" cols="30" rows="10" name="content" placeholder="Enter comment here..."></textarea>
            <input class="border py-1 px-2 bg-[#f7931e] text-white m-2" type="submit" value="Submit" />
        </div>
    </form>
</div>
