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
                    @partial blogs/link(blog)
                </td>
                <td>
                    {{zmpl.fmt.datetime(blog.get("created_at"), "%Y-%m-%d")}}
                </td>
            </tr>
        }
        </tbody>
    </table>
</div>
