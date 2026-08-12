return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    current_line_blame_opts = {
      delay = 0,
    },
    preview_config = { border = "rounded" },
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { desc = desc, buffer = bufnr, silent = true })
      end

      Snacks.toggle({
        name = "Inline Blame",
        get = function()
          return require("gitsigns.config").config.current_line_blame
        end,
        set = function(state)
          gs.toggle_current_line_blame(state)
        end,
      }):map("<leader>ub")

      -- stylua: ignore start
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Hunk")
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Hunk")
      map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
      map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
      map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
      map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
      map("x", "<leader>hs", function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, "Stage Hunk")
      map("x", "<leader>hr", function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, "Reset Hunk")
      map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
      map("n", "<leader>hp", gs.preview_hunk_inline, "Preview Hunk Inline")
      map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
      map("n", "<leader>hB", gs.blame, "Blame Buffer")
      map("n", "<leader>hd", gs.diffthis, "Diff This")
      map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff This ~")
      map("n", "<leader>hq", gs.setqflist, "Populate Quickfix List with Hunks (Buffer)")
      map("n", "<leader>hQ", function () gs.setqflist("all") end, "Populate Quickfix List with Hunks (All)")
      map({ "o", "x" }, "ih", gs.select_hunk, "GitSigns Select Hunk")
      -- stylua: ignore end
    end,
  },
}
