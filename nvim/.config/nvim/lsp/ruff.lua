-- Install with:
-- Mac: brew install ruff

local utils = require("utils.root")

local root_markers = {
  { "pyproject.toml", "ruff.toml", ".ruff.toml" },
  ".git",
}

---@type vim.lsp.Config
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
  on_attach = function(client)
    -- Disable hover in favor of ty
    client.server_capabilities.hoverProvider = false
  end,
}
