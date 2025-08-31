return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", vim.fn.stdpath("config") .. "/linter_config/global.markdown-cli2.jsonc", "--" },
      },
    },
  },
}
