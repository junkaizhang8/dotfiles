return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<M-p>",
      "<Cmd>PasteImage<CR>",
      desc = "Paste Image from System Clipboard",
    },
  },
  opts = {
    default = {
      use_absolute_path = false,
      relative_to_current_file = true,
      dir_path = "assets/images",
      file_name = "%y%m%d-%H%M%S",
    },
  },
}
