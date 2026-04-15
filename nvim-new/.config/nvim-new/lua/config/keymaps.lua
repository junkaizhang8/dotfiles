local map = vim.keymap.set

-- Lazy
map("n", "<leader>l", "<Cmd>Lazy<CR>", { desc = "Lazy" })

-- Remap j and k to move by visual lines when no count is provided
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Splitting windows
map("n", "<leader>-", "<C-w>s", { desc = "Split Window Below" })
map("n", "<leader>\\", "<C-w>v", { desc = "Split Window Right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Close Current Window" })

-- Buffer navigation
map("n", "<S-h>", "<Cmd>bprevious<CR>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "[b", "<Cmd>bprevious<CR>", { desc = "Prev Buffer" })
map("n", "]b", "<Cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<Cmd>e #<CR>", { desc = "Switch to Other Buffer" })

-- Keep the cursor centered
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll Downwards" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll Upwards" })

-- Make n always search forward and N always search backward, regardless of the search direction.
-- Also ensure that the view is centered on the search result
map("n", "n", "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zzzv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Indent while remaining in visual mode.
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Enhance escape to clear search highlights and stop snippet sessions
map({ "i", "s", "n" }, "<Esc>", function()
  if require("luasnip").expand_or_jumpable() then
    require("luasnip").unlink_current()
  end
  vim.cmd("noh")
  return "<Esc>"
end, { desc = "Escape, Clear hlsearch, and Stop Snippet Session", expr = true })

-- LSP
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Go to the start of the line while in insert mode
map({ "i", "c" }, "<C-h>", "<C-o>I", { desc = "Go to Start of Line" })

-- Go to the end of the line while in insert mode
map({ "i", "c" }, "<C-l>", "<C-o>A", { desc = "Go to End of Line" })

-- Add undo breakpoints
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", ";", ";<C-g>u")
