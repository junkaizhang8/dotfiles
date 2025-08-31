return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#C3CCDC",
      bg = "#112638",
      inactive_bg = "#2C3043",
    }

    local custom_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    local statusline = require("arrow.statusline")

    -- Arrows bookmark index
    table.insert(opts.sections.lualine_x, 3, {
      function()
        return ("[" .. statusline.text_for_statusline_with_icons() .. "]") or ""
      end,
      cond = function()
        return statusline.is_on_arrow_file() ~= nil
      end,
      color = { fg = "#FF9E65" },
    })

    opts.sections.lualine_y = {
      { "progress", padding = { left = 1, right = 1 } },
    }
    opts.sections.lualine_z = {
      { "location", padding = { left = 1, right = 1 } },
    }
    opts.options.theme = custom_theme
  end,

  config = function(_, opts)
    local lualine = require("lualine")
    lualine.setup(opts)

    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermLeave", "BufWinEnter", "ColorScheme" }, {
      callback = function()
        local dashboard_filetypes = {
          alpha = true,
          dashboard = true,
          snacks_dashboard = true,
        }

        local function is_dashboard()
          return dashboard_filetypes[vim.bo.filetype] == true
        end

        local function get_lualine_colors()
          local theme = lualine.get_config().options.theme

          if type(theme) == "string" then
            theme = require("lualine.themes." .. theme)
          end

          return theme.normal.c
        end

        local function set_statusline_highlight()
          local colors = get_lualine_colors()
          vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bg, fg = colors.fg })
        end

        local function hide_statusline_highlight()
          vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", fg = "NONE" })
        end

        local function update_lualine_statusline()
          if is_dashboard() then
            -- Hide lualine when entering dashboard
            hide_statusline_highlight()
          else
            -- Call this to fix weird coloring artifacts in the status line
            set_statusline_highlight()
          end
        end

        vim.schedule(update_lualine_statusline)
      end,
    })
  end,
}
