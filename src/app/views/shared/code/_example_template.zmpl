<pre><code class="language-html">// src/app/views/users/get.zmpl
\@zig {
  if (std.crypto.random.int(u1) == 1) {
    &lt;span&gt;Message: {\{message\}}&lt;/span&gt;
  \}
\}
</code></pre>
