<div>
    @if ($.is_signed_in)
        @partial link("New Blog Post", "/blogs/new")
    @end
    <hr/>
    <table class="table-auto">
        <tbody>
        @for (.blogs) |blog| {
            <tr>
                <td>
                    {{zmpl.fmt.datetime(blog.get("created_at"), "%Y-%m-%d")}}:
                </td>
                <td>
                    @partial blogs/link(blog.id, blog.title, false)
                </td>
                <td>
                    @if ($.is_signed_in)
                        @partial blogs/link(blog.id, blog.title, true)
                    @end
                </td>
            </tr>
        }
        </tbody>
    </table>
</div>
