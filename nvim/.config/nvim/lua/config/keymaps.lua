-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

-- Disable global keymaps
local disabledKeys = {
  { "n", "<leader>|" },
}

for _, mapping in ipairs(disabledKeys) do
  local modes, key = mapping[1], mapping[2]
  vim.keymap.del(modes, key)
end

-- Disable Meta-a which is the prefix key for tmux
keymap.set({ "i", "n", "v" }, "<M-a>", "<Nop>", { noremap = true, silent = true })

-- Disable middle click
for _, mode in ipairs({ "n", "i" }) do
  for i = 1, 4 do
    local click = (i == 1) and "<MiddleMouse>" or ("<" .. i .. "-MiddleMouse>")
    keymap.set(mode, click, "<Nop>", { noremap = true, silent = true })
  end
end

-- Delete character without yanking
keymap.set("n", "x", '"_x', { desc = "Delete Character Without Yanking" })

-- Clear line (preserves any white space at the start of the line)
keymap.set("n", "X", "^D", { desc = "Clear Line" })

-- Windows
keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split Window Below", remap = true })
keymap.set("n", "<leader>\\", "<C-w>v", { desc = "Split Window Right", remap = true })

keymap.set("n", "<C-w><Left>", "<C-w><", { desc = "Decrease Window Width" })
keymap.set("n", "<C-w><Right>", "<C-w>>", { desc = "Increase Window Width" })
keymap.set("n", "<C-w><Up>", "<C-w>+", { desc = "Increase Window Height" })
keymap.set("n", "<C-w><Down>", "<C-w>-", { desc = "Decrease Window Height" })
