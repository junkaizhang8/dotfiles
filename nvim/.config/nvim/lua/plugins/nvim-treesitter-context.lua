local function sync_treesitter_context()
  local lualine = require("lualine")

  local theme = lualine.get_config().options.theme
  if type(theme) == "string" then
    theme = require("lualine.themes." .. theme)
  end

  local colors = theme.normal.c
  -- Set background color of treesitter context to match lualine
  vim.api.nvim_set_hl(0, "TreeSitterContext", { bg = colors.bg })
end

return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- Avoid showing a bunch of lines if we're deeply nested
    max_lines = 3,
    -- Only show one context line
    multiline_threshold = 1,
    -- Disable when window is too small
    min_window_height = 20,
  },
  config = function(_, opts)
    require("treesitter-context").setup(opts)
    sync_treesitter_context()

    -- Resync on colorscheme change
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        sync_treesitter_context()
      end,
    })
  end,
}
