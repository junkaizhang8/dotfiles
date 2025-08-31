return {
  "linux-cultist/venv-selector.nvim",
  branch = "main", -- VenvSelect is using `main` as the updated branch again
  opts = function()
    return {
      search = {
        pyenv = {
          command = "fd '^python$' $(pyenv root)/versions -t l",
        },
      },
    }
  end,
}
