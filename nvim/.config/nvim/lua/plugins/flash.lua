return {
  "folke/flash.nvim",
  opts = {
    search = {
      mode = "search",
    },
    modes = {
      -- Disable matching next/previous character using f, t, F, T
      char = {
        char_actions = function()
          return {
            [";"] = "next", -- set to `right` to always go right
            [","] = "prev", -- set to `left` to always go left
          }
        end,
      },
    },
  },
}
