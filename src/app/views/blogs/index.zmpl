<div>
    @partial h1("Blog Posts")

    @if ($.is_signed_in)
        @partial link("New Blog Post", "/blogs/new")
        <hr/>
    @end

    <table class="table-fixed p-2">
        <tbody>
            @for (.blogs) |blog| {
                <tr>
                    <td class="p-2">
                        @partial blogs/link(blog.id, blog.title, false)
                    </td>

                    <td class="p-2">
                        {{zmpl.fmt.datetime(blog.get("created_at"), "%Y-%m-%d")}}
                    </td>

                    <td class="p-2">
                        {{blog.author}}
                    </td>

                    @if ($.is_signed_in)
                        <td>
                            @partial blogs/link(blog.id, blog.title, true)
                        </td>
                    @end
                </tr>
            }
        </tbody>
    </table>
</div>
