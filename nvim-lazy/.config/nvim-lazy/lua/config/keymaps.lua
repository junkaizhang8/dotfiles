-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

-- Disable global keymaps
local disabledKeys = {
  { "n", "<leader>|" },
  { "n", "<C-h>" },
  { "n", "<C-j>" },
  { "n", "<C-k>" },
  { "n", "<C-l>" },
}

for _, mapping in ipairs(disabledKeys) do
  local modes, key = mapping[1], mapping[2]
  keymap.del(modes, key)
end

-- Disable Meta-a which is the prefix key for tmux
keymap.set({ "i", "n", "v" }, "<M-a>", "<Nop>", { silent = true })

-- Disable middle click
for _, mode in ipairs({ "n", "i" }) do
  for i = 1, 4 do
    local click = (i == 1) and "<MiddleMouse>" or ("<" .. i .. "-MiddleMouse>")
    keymap.set(mode, click, "<Nop>", { silent = true })
  end
end

-- Delete character without yanking
keymap.set("n", "x", '"_x', { desc = "Delete Character Under Cursor Without Yanking" })
keymap.set("n", "X", '"_X', { desc = "Delete Character Before Cursor Without Yanking" })

-- Clear line (preserves any white space at the start of the line)
keymap.set("n", "dc", "^D", { desc = "Clear Line" })

-- Go to the start of the line while in insert mode
keymap.set({ "i", "c" }, "<C-h>", "<C-o>I", { desc = "Go to Start of Line" })

-- Go to the end of the line while in insert mode
keymap.set({ "i", "c" }, "<C-l>", "<C-o>A", { desc = "Go to End of Line" })

-- Windows
keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split Window Below", remap = true })
keymap.set("n", "<leader>\\", "<C-w>v", { desc = "Split Window Right", remap = true })

local smart_splits = require("smart-splits")

-- Resizing splits
keymap.set("n", "<C-M-h>", smart_splits.resize_left, { desc = "Resize Split Left" })
keymap.set("n", "<C-M-j>", smart_splits.resize_down, { desc = "Resize Split Down" })
keymap.set("n", "<C-M-k>", smart_splits.resize_up, { desc = "Resize Split Up" })
keymap.set("n", "<C-M-l>", smart_splits.resize_right, { desc = "Resize Split Right" })

-- Moving between splits
keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Move to Split Left" })
keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Move to Split Down" })
keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Move to Split Up" })
keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Move to Split Right" })
keymap.set(
  "n",
  "<C-\\>",
  require("config.modules.smart-previous-pane").move_cursor_previous,
  { desc = "Move to Previous Split" }
)

-- Swapping buffers between windows
keymap.set("n", "<leader><C-h>", smart_splits.swap_buf_left, { desc = "Swap Buffer Left" })
keymap.set("n", "<leader><C-j>", smart_splits.swap_buf_down, { desc = "Swap Buffer Down" })
keymap.set("n", "<leader><C-k>", smart_splits.swap_buf_up, { desc = "Swap Buffer Up" })
keymap.set("n", "<leader><C-l>", smart_splits.swap_buf_right, { desc = "Swap Buffer Right" })

local wk = require("which-key")

wk.add({
  { "<leader>a", group = "+ai", icon = "", mode = { "n", "v" } },
})
