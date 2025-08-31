return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    -- List of keymaps to disable
    local disabledKeys = {
      "<leader>ca",
    }

    -- List of keymaps to add
    local newKeys = {
      { "<leader>cL", "<Cmd>LspRestart<CR>", desc = "Restart LSP" },
    }

    for _, key in ipairs(disabledKeys) do
      keys[#keys + 1] = { key, false }
    end

    for _, mapping in ipairs(newKeys) do
      keys[#keys + 1] = mapping
    end

    opts.diagnostics = {
      float = {
        border = "rounded",
      },
    }
  end,
}
