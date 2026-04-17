-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

---@type LazySpec
local plugins = "plugins"

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")

require("modules.smart-previous-pane").setup()
require("modules.tag-autoindent").setup()

require("utils.root").setup()

require("lazy").setup(plugins, {
  ui = { border = "rounded" },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = { notify = false },
  install = {
    colorscheme = { "tokyonight" },
  },
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<leader>uu", function()
  require("undotree").open({
    command = math.floor(vim.api.nvim_win_get_width(0) / 3) .. "vnew",
  })
end, { desc = "Toggle Undotree" })
