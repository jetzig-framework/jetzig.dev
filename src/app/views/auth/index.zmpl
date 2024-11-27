<div class="max-w-md mx-auto px-4 py-8">
  @partial h2("Sign In")

  <div class="mt-8">
    <form action="/auth" method="POST">
      {{context.authenticityFormElement()}}
      <div class="grid grid-cols-1 gap-6">
        <div>
          <label for="email" class="block text-gray-700 font-medium">Email</label>
          <input
            id="email"
            class="w-full border border-gray-300 rounded-md p-2 mt-1 focus:outline-none focus:ring-2 focus:ring-[#f7931e] dark:bg-gray-800 dark:border-gray-700 dark:text-white"
            type="email"
            name="email"
            required
          />
        </div>

        <div>
          <label for="password" class="block text-gray-700 font-medium">Password</label>
          <input
            id="password"
            class="w-full border border-gray-300 rounded-md p-2 mt-1 focus:outline-none focus:ring-2 focus:ring-[#f7931e] dark:bg-gray-800 dark:border-gray-700 dark:text-white"
            type="password"
            name="password"
            required
          />
        </div>

        <div class="text-right">
          <button
            type="submit"
            class="bg-[#f7931e] text-white py-2 px-6 rounded-md hover:bg-[#e6831b] focus:outline-none focus:ring-2 focus:ring-[#f7931e]"
          >
            Sign In
          </button>
        </div>
      </div>
    </form>
  </div>
</div>
