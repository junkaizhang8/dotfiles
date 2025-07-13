return {
  "otavioschwanck/arrow.nvim",
  -- enabled = false,
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    -- or if using `mini.icons`
    -- { "echasnovski/mini.icons" },
  },
  opts = {
    show_icons = true,
    leader_key = "<leader>;",
    buffer_leader_key = "<leader>'", -- Per Buffer Mappings
    index_keys = "afghjkl;'wrtyuiopzxcvbm,./ASDFGHJKLQWERTYUIOPZXVBNM1234567890",
    mappings = {
      edit = "e",
      delete_mode = "d",
      clear_all_items = "C",
      toggle = "s", -- used as save if separate_save_and_remove is true
      open_vertical = "\\",
      open_horizontal = "-",
      quit = "q",
      remove = "x", -- only used if separate_save_and_remove is true
      next_item = "]",
      prev_item = "[",
    },
  },
}
