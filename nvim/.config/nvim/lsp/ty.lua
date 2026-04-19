-- Install with:
-- Mac: brew install ty

local utils = require("utils.root")

local root_markers = {
  { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "pyrightconfig.json", "ty.toml" },
  ".git",
}

---@type vim.lsp.Config
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
}
