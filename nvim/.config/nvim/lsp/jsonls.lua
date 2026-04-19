-- Install with: npm i -g vscode-langservers-extracted

local utils = require("utils.root")

local root_markers = { ".git" }

---@type vim.lsp.Config
return {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
  settings = {
    json = {
      validate = { enable = true },
      schemas = { require("schemastore").json.schemas() },
    },
  },
}
