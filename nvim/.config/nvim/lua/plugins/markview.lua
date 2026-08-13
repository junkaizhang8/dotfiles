return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  keys = {
    { "MM", "<Cmd>Markview<CR>", desc = "Toggle Markview Preview" },
    { "Ms", "<Cmd>Markview splitToggle<CR>", desc = "Toggle Markview Splitview" },
    { "Mh", "<Cmd>Markview hybridToggle<CR>", desc = "Toggle Markview Hybrid Mode" },
  },
  ---@class markview.config
  opts = {
    preview = {
      hybrid_modes = { "n" },
      enable_hybrid_mode = false,
    },
  },
}
