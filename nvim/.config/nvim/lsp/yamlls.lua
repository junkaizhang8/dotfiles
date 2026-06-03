-- Install with: npm i -g yaml-language-server

local utils = require("utils.root")

local root_markers = { ".git" }

---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
  settings = {
    redhat = { telemetry = { enable = false } },
    yaml = {
      keyOrdering = false,
      format = { enabled = true },
      validate = true,
      -- Disable built-in schema store and use schemastore.nvim instead
      schemaStore = { enable = false, url = "" },
    },
  },
  before_init = function(_, new_config)
    ---@diagnostic disable: inject-field
    new_config.settings.yaml.schemas =
      vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
  on_init = function(client)
    --- https://github.com/neovim/nvim-lspconfig/pull/4016
    --- Since formatting is disabled by default if you check
    --- `client:supports_method('textDocument/formatting')` during `LspAttach`
    --- it will return `false`. This hack sets the capability to `true` to
    --- facilitate autocmd's which check this capability
    client.server_capabilities.documentFormattingProvider = true
  end,
}
