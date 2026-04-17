-- Install with: npm i -g vscode-langservers-extracted

local utils = require("utils.root")

local root_markers = { "package.json", ".git" }

---@type vim.lsp.Config
return {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
  embeddedLanguages = { css = true, javascript = true },
}
