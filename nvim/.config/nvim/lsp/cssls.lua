-- Install with: npm i -g vscode-langservers-extracted

local utils = require("utils.root")

local root_markers = { "package.json", ".git" }

---@type vim.lsp.Config
return {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}
