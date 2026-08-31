local exclude_ft = {
  dashboard = true,
  snacks_dashboard = true,
  alpha = true,
  help = true,
  lazy = true,
  mason = true,
  notify = true,
  checkhealth = true,
  lspinfo = true,
  qf = true,
  terminal = true,
}

return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    local colors = require("tokyonight.colors").setup()

    return {
      chunk = {
        enable = true,
        priority = 15,
        use_treesitter = true,
        straight = false,
        error_sign = true,
        textobject = "ik",
        max_file_size = 1024 * 1024,
        delay = 0,
        duration = 0,
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = "─",
        },
        style = {
          { fg = colors.blue1 },
          { fg = colors.error },
        },
        exclude_filetypes = exclude_ft,
      },

      indent = {
        enable = true,
        priority = 10,
        use_treesitter = false,
        ahead_lines = 8,
        delay = 0,
        exclude_filetypes = exclude_ft,
      },

      line_num = {
        enable = false,
        priority = 10,
        exclude_filetypes = exclude_ft,
      },

      blank = {
        enable = false,
      },
    }
  end,
}
