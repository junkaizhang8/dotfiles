return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      dir_path = "assets/images",
      embed_image_as_base64 = false,
      prompt_for_file_name = false,
      drag_and_drop = {
        insert_mode = true,
      },
      -- Need to set to true for Windows users
      use_absolute_path = false,
    },
  },
  keys = {
    { "<M-p>", "<Cmd>PasteImage<CR>", desc = "Paste image from system clipboard" },
  },
}
