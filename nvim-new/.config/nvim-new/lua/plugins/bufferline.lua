return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
    { "<S-l>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
    { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
    { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
    { "[B", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer prev" },
    { "]B", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer next" },
    { "<leader>bj", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
  },
  opts = {
    options = {
      close_command = function(bufnr)
        Snacks.bufdelete(bufnr)
      end,
      right_mouse_command = function(bufnr)
        Snacks.bufdelete(bufnr)
      end,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = require("config.icons").diagnostics
        local indicator = (diag.error and icons.error .. " " .. diag.error .. " " or "")
          .. (diag.warning and icons.warn .. " " .. diag.warning or "")
        return vim.trim(indicator)
      end,
      offsets = {
        {
          filetype = "snacks_layout_box",
        },
      },
    },
  },
}
