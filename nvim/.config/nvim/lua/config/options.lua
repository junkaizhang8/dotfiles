-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Disable all animations
vim.g.snacks_animate = false

-- Enable Copilot by default
vim.g.copilot_enabled = true

-- Don't open Quickfix for warnings in VimTeX
vim.g.vimtex_quickfix_open_on_warning = 0
