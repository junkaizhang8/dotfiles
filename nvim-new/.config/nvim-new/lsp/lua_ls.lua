-- Install with:
-- mac: brew install lua-language-server

local utils = require("utils.root")

local root_markers = {
  { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" },
  ".git",
}

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      format = {
        enable = false,
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}
