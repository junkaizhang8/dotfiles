-- Install with: npm i -g @typescript/native-preview

local utils = require("utils.root")

local root_markers = {
  { "tsconfig.json", "jsconfig.json", "package.json", "pnpm-lock.yaml", "yarn.lock", "tsconfig.base.json" },
  ".git",
}

---@type vim.lsp.Config
return {
  cmd = { "tsgo", "--lsp", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
}
