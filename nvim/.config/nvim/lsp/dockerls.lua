-- Install with: npm i -g dockerfile-language-server-nodejs

local utils = require("utils.root")

local root_markers = { "Dockerfile" }

---@type vim.lsp.Config
return {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
}
