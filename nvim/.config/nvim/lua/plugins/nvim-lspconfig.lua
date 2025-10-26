return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          -- Disabled keymaps
          { "<leader>ca", false },
          -- New keymaps
          { "<leader>cL", "<Cmd>LspRestart<CR>", desc = "Restart LSP" },
        },
      },
    },
    diagnostics = {
      float = {
        border = "rounded",
      },
    },
  },
}
