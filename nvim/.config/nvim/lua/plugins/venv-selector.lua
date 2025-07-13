return {
  "linux-cultist/venv-selector.nvim",
  branch = "regexp", -- This is the regexp branch, use this for the new version
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
