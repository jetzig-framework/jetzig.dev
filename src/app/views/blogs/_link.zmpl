@args id: i32, title: []const u8, edit: bool = false
@if (edit)
 <a class="font-bold text-jetzig-green" href="/blogs/{{id}}/edit">Edit</a>
@else
 <a class="font-bold text-jetzig-green" href="/blogs/{{id}}">{{title}}</a>
@end
