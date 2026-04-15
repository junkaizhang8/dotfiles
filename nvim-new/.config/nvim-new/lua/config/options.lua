local icons = require("config.icons")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Autoformat on save
vim.g.autoformat = true

-- Enable Copilot
vim.g.copilot_enabled = true

-- Indentation
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.smartindent = true

-- Relative line numbers
vim.o.relativenumber = true

-- Show whitespace
vim.o.list = true

-- Show line numbers
vim.o.number = true

-- Highlight the current line
vim.o.cursorline = true

-- Enable mouse support
vim.o.mouse = "a"

-- Disable wrapping long lines at word boundaries (wrap must be enabled for linebreak to work)
vim.o.wrap = false
vim.o.linebreak = true

-- Folding
vim.o.foldcolumn = "0"
vim.o.foldlevelstart = 99
vim.o.foldmethod = "indent"
vim.o.foldtext = ""

vim.opt.fillchars = {
  foldopen = icons.folding.open,
  foldclose = icons.folding.close,
  fold = " ",
  foldsep = " ",
  diff = "-",
  eob = " ",
}

-- Rounded borders for floating windows
vim.o.winborder = "rounded"

-- Minimum window width
vim.o.winminwidth = 5

-- Sync with system clipboard if not in ssh
vim.o.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"

-- Save undo history
vim.o.undofile = true

-- Limit undo history to 1000 changes to prevent excessive memory usage
vim.o.undolevels = 1000

-- Case-insensitive searching, unless search pattern contains uppercase letters
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable sign column to show diagnostic signs and other markers
vim.o.signcolumn = "yes"

-- Update times and timeouts
vim.o.updatetime = 200
vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 10

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.o.pumheight = 10
vim.o.pumblend = 10
vim.o.pumborder = "rounded"

-- Keep at least 4 lines visible above and below the cursor when scrolling
vim.o.scrolloff = 4

-- Keep at least 8 columns visible to the left and right of the cursor when scrolling horizontally
vim.o.sidescrolloff = 8

-- Splits
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.splitkeep = "screen"

-- Status column
vim.o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

-- Status line
vim.o.laststatus = 3

-- Disable ruler since we have a status line
vim.o.ruler = false

-- Disable showing mode since we have a status line
vim.o.showmode = false

-- Allow cursor to move freely in visual block mode
vim.o.virtualedit = "block"

-- Confirm before closing unsaved buffers
vim.o.confirm = true

-- Format options
vim.o.formatoptions = "jcroqlnt"

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Jump options
vim.o.jumpoptions = "view"

-- Session options
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Command-line completion
vim.opt.wildmode = { "longest:full", "full" }

-- Short messages
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Disable cursor blinking in terminal mode.
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor"

-- Use ripgrep for :grep command (skip ignored files and hidden files)
vim.o.grepprg = "rg --vimgrep"

-- Enable true color support in the terminal
vim.o.termguicolors = true
