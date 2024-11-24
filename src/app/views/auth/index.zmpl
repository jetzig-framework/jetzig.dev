<div>
  <form action="/auth" method="POST">
    {{context.authenticityFormElement()}}
    <label>Email</label>
    <input class="dark:bg-gray-800" type="email" name="email" />

    <label>Password</label>
    <input class="dark:bg-gray-800" type="password" name="password" />

    <input class="dark:bg-gray-800" type="submit" />
  </form>
</div>
