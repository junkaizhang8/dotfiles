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

    -- Resizing splits
    map("n", "<M-h>", smart_splits.resize_left, { desc = "Resize Split Left" })
    map("n", "<M-j>", smart_splits.resize_down, { desc = "Resize Split Down" })
    map("n", "<M-k>", smart_splits.resize_up, { desc = "Resize Split Up" })
    map("n", "<M-l>", smart_splits.resize_right, { desc = "Resize Split Right" })

    -- Swapping buffers between windows
    map("n", "<C-M-h>", smart_splits.swap_buf_left, { desc = "Swap Buffer Left" })
    map("n", "<C-M-j>", smart_splits.swap_buf_down, { desc = "Swap Buffer Down" })
    map("n", "<C-M-k>", smart_splits.swap_buf_up, { desc = "Swap Buffer Up" })
    map("n", "<C-M-l>", smart_splits.swap_buf_right, { desc = "Swap Buffer Right" })
  end,
}
