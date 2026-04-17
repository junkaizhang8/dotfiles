-- Install with: npm i -g yaml-language-server

local utils = require("utils.root")

local root_markers = { ".git" }

---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
  settings = {
    redhat = { telemetry = { enable = false } },
    yaml = {
      format = { enabled = true },
      -- Disable built-in schema store and use schemastore.nvim instead
      schemaStore = { enable = false, url = "" },
      schemas = { require("schemastore").yaml.schemas() },
    },
  },
}
