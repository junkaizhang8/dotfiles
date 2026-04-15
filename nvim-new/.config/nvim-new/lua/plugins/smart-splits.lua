return {
  "mrjones2014/smart-splits.nvim",
  opts = {},
  config = function(_, opts)
    require("smart-splits").setup(opts)
    local smart_splits = require("smart-splits")

    local map = vim.keymap.set

    -- Moving between windows
    map("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Go to Left Window" })
    map("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Go to Lower Window" })
    map("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Go to Upper Window" })
    map("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Go to Right Window" })
  end,
}
