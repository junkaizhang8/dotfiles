return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>yy",
      "<Cmd>Yazi<CR>",
      desc = "Open yazi at the current file",
      mode = { "n", "v" },
    },
    {
      -- Open in the current working directory
      "<leader>yw",
      "<Cmd>Yazi cwd<CR>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<leader>yt",
      "<Cmd>Yazi toggle<CR>",
      desc = "Resume the last yazi session",
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
  config = function(_, opts)
    require("yazi").setup(opts)

    local wk = require("which-key")

    if not wk then
      return
    end

    wk.add({
      { "<leader>y", group = "+yazi", icon = "󰇥", mode = { "n", "v" } },
    })
  end,
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
