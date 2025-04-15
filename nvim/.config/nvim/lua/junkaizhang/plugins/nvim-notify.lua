return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      stages = "fade_in_slide_out",
      max_width = 50,
    })
    vim.notify = require("notify")

    local keymap = vim.keymap

    -- Set up keymaps for notifications
    keymap.set(
      "n",
      "<leader>cn",
      "<cmd>lua require('notify').dismiss({ silent = true, pending = true })<CR>",
      { desc = "Clear all notifications" }
    )
  end,
}

