return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    {
      "<leader>yy",
      "<Cmd>Yazi<CR>",
      desc = "Open Yazi at the Current File",
      mode = { "n", "v" },
    },
    {
      "<leader>yc",
      "<Cmd>Yazi cwd<CR>",
      desc = "Open Yazi in Current Working Directory",
    },
    {
      "<leader>yt",
      "<Cmd>Yazi toggle<CR>",
      desc = "Resume the Last Yazi Session",
    },
  },
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = "<F1>",
    },
  },
}
