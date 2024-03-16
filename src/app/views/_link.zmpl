const jetzig_green = "text-[#39b54a]";
const target = try zmpl.getValue("target") orelse zmpl.string("_self");
<a class="font-bold {:jetzig_green}" href="{.href}" target="{target}">{.title}</a>
