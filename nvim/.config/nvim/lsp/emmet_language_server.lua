-- Install with: npm i -g @olrtg/emmet-language-server

local utils = require("utils.root")

local root_markers = { ".git" }

---@type vim.lsp.Config
return {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = {
    "astro",
    "css",
    "eruby",
    "html",
    "htmlangular",
    "htmldjango",
    "javascriptreact",
    "less",
    "sass",
    "scss",
    "svelte",
    "typescriptreact",
    "vue",
  },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
}
