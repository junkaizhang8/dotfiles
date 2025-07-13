-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermLeave", "BufWinEnter" }, {
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
      local lualine = require("lualine")
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

    local function update_lualine_statusline()
      if is_dashboard() then
        -- Hide lualine when entering dashboard
        vim.o.laststatus = 0
      else
        -- Restore lualine
        vim.o.laststatus = 3
        -- Call this to fix weird coloring artifacts in the status line
        set_statusline_highlight()
      end
    end

    vim.schedule(update_lualine_statusline)
  end,
})
