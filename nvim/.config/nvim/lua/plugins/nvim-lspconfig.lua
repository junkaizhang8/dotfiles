return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      float = {
        border = "rounded",
      },
    },
  },
  init = function()
    -- List of keymaps to disable
    local disabledKeys = {
      "<leader>ca",
    }

    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    for _, key in ipairs(disabledKeys) do
      keys[#keys + 1] = { key, false }
    end
  end,
}
