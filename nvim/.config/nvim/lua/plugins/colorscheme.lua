---@class ColorScheme
---@field none string
---@field bg string
---@field bg_dark string
---@field bg_float string
---@field bg_highlight string
---@field bg_popup string
---@field bg_search string
---@field bg_sidebar string
---@field bg_statusline string
---@field bg_visual string
---@field border string
---@field fg string
---@field fg_dark string
---@field fg_float string
---@field fg_gutter string
---@field fg_sidebar string

local transparent = true -- globally scoped to allow toggling

local function apply_tokyonight()
  local bg = "#011628"
  local bg_dark = "#011423"
  local bg_highlight = "#143652"
  local bg_search = "#0A64AC"
  local bg_visual = "#275378"
  local fg = "#CBE0F0"
  local fg_dark = "#B4D0E9"
  local fg_gutter = "#627E97"
  local border = "#547998"

  require("tokyonight").setup({
    style = "night",
    transparent = transparent,
    styles = {
      sidebars = transparent and "transparent" or "dark",
      floats = transparent and "transparent" or "dark",
    },

    -- We add an annotation to prevent the LSP from throwing a bunch of warnings
    ---@param colors ColorScheme
    on_colors = function(colors)
      colors.bg = bg
      colors.bg_dark = transparent and colors.none or bg_dark
      colors.bg_float = transparent and colors.none or bg_dark
      colors.bg_highlight = bg_highlight
      colors.bg_popup = bg_dark
      colors.bg_search = bg_search
      colors.bg_sidebar = transparent and colors.none or bg_dark
      colors.bg_statusline = transparent and colors.none or bg_dark
      colors.bg_visual = bg_visual
      colors.border = border
      colors.fg = fg
      colors.fg_dark = fg_dark
      colors.fg_float = fg
      colors.fg_gutter = fg_gutter
      colors.fg_sidebar = fg_dark
    end,
  })

  vim.cmd("colorscheme tokyonight")
end

local function toggle_transparency()
  transparent = not transparent
  apply_tokyonight()
  vim.notify("Transparency: " .. (transparent and "ON" or "OFF"), vim.log.levels.INFO, { title = "Transparency" })
end

return {
  "folke/tokyonight.nvim",
  config = function()
    apply_tokyonight()
  end,
  keys = {
    { "<leader>ut", toggle_transparency, desc = "Toggle Transparency" },
  },
}
