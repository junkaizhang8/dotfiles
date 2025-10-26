return {
  "folke/flash.nvim",
  opts = {
    search = {
      mode = "search",
    },
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
