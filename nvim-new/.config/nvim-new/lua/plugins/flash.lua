return {
  "folke/flash.nvim",
  event = "VeryLazy",
  -- stylua: ignore
  keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
  opts = {
    modes = {
      char = {
        -- Disable char mode for now as it breaks macros that use char motions
        enabled = false,
        -- Disable matching next/previous character using f, t, F, T
        char_actions = function()
          return {
            [";"] = "next", -- set to `right` to always go right
            [","] = "prev", -- set to `left` to always go left
          }
        end,
        -- Disable dimming when using char mode
        highlight = { backdrop = false },
      },
    },
  },
}
