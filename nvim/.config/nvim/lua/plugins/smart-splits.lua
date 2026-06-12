return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = {
    -- Moving between windows
    {
      "<C-h>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      desc = "Go to Left Window",
    },
    {
      "<C-j>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      desc = "Go to Lower Window",
    },
    {
      "<C-k>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      desc = "Go to Upper Window",
    },
    {
      "<C-l>",
      function()
        require("smart-splits").move_cursor_right()
      end,
      desc = "Go to Right Window",
    },
    -- Resizing splits
    {
      "<M-h>",
      function()
        require("smart-splits").resize_left()
      end,
      desc = "Resize Split Left",
    },
    {
      "<M-j>",
      function()
        require("smart-splits").resize_down()
      end,
      desc = "Resize Split Down",
    },
    {
      "<M-k>",
      function()
        require("smart-splits").resize_up()
      end,
      desc = "Resize Split Up",
    },
    {
      "<M-l>",
      function()
        require("smart-splits").resize_right()
      end,
      desc = "Resize Split Right",
    },
    -- Swapping buffers between windows
    {
      "<C-M-h>",
      function()
        require("smart-splits").swap_buf_left()
      end,
      desc = "Swap Buffer Left",
    },
    {
      "<C-M-j>",
      function()
        require("smart-splits").swap_buf_down()
      end,
      desc = "Swap Buffer Down",
    },
    {
      "<C-M-k>",
      function()
        require("smart-splits").swap_buf_up()
      end,
      desc = "Swap Buffer Up",
    },
    {
      "<C-M-l>",
      function()
        require("smart-splits").swap_buf_right()
      end,
      desc = "Swap Buffer Right",
    },
  },
}
