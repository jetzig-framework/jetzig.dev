<div>
    @zig {
        if (zmpl.getT(.boolean, "is_signed_in") orelse false) {
            @partial link("New Blog Post", "/blogs/new")
        }
    }
    <hr/>
    <table class="table-auto">
        <tbody>
        @for (.blogs) |blog| {
            <tr>
                <td>
                    {{zmpl.fmt.datetime(blog.get("created_at"), "%Y-%m-%d")}}:
                </td>
                <td>
                    @partial blogs/link(blog.id, blog.title)
                </td>
            </tr>
        }
        </tbody>
    </table>
</div>
