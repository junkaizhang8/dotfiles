-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Disable certain defaults
local disabledKeys = {
  "<leader>|",
}

for _, key in ipairs(disabledKeys) do
  keymap.del("n", key)
end

-- Disable Meta-a which is the prefix key for tmux
keymap.set({ "i", "n", "v" }, "<M-a>", "<Nop>", opts)

-- Disable middle click
for _, mode in ipairs({ "n", "i" }) do
  for i = 1, 4 do
    local click = (i == 1) and "<MiddleMouse>" or ("<" .. i .. "-MiddleMouse>")
    keymap.set(mode, click, "<Nop>", { silent = true })
  end
end

-- Delete character without yanking
keymap.set("n", "x", '"_x', { desc = "Delete Character Without Yanking" })

-- Increment/decrement numbers
keymap.set("n", "+", "<C-a>", { desc = "Increment Number" }) -- increment
keymap.set("n", "-", "<C-x>", { desc = "Decrement Number" }) -- decrement

-- Select all
keymap.set({ "n", "v" }, "<C-a>", "ggVG", { desc = "Select All" })

-- Copy text from system clipboard to yank register
keymap.set("n", "<leader>Y", "<cmd>let @0 = @+<cr>", { desc = "Copy Text from System Clipboard to Yank Register" })

-- Paste last yanked text
keymap.set("n", "<leader>p", '"0p', { desc = "Paste Last Yanked Text After the Cursor" })
keymap.set("n", "<leader>P", '"0P', { desc = "Paste Last Yanked Text Before the Cursor" })

-- Windows
keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split Window Below", remap = true })
keymap.set("n", "<leader>\\", "<C-w>v", { desc = "Split Window Right", remap = true })

keymap.set("n", "<C-w><left>", "<C-w><", { desc = "Decrease Window Width" })
keymap.set("n", "<C-w><right>", "<C-w>>", { desc = "Increase Window Width" })
keymap.set("n", "<C-w><up>", "<C-w>+", { desc = "Increase Window Height" })
keymap.set("n", "<C-w><down>", "<C-w>-", { desc = "Decrease Window Height" })
