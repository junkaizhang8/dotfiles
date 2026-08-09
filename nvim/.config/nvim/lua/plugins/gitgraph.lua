local function gitgraph_draw()
  if vim.bo.filetype == "gitgraph" then
    return
  end
  vim.cmd("tab split")
  require("gitgraph").draw({}, { all = true, max_count = 5000 })
end

local function gitgraph_close()
  if vim.bo.filetype == "gitgraph" then
    vim.cmd("tabclose")
  else
    return
  end
end

local function gitgraph_toggle()
  if vim.bo.filetype == "gitgraph" then
    gitgraph_close()
  else
    gitgraph_draw()
  end
end

return {
  "isakbm/gitgraph.nvim",
  dependencies = { "dlyongemallo/diffview-plus.nvim" },
  keys = {
    { "<leader>gl", gitgraph_toggle, desc = "Commit Graph" },
  },
  opts = {
    symbols = {
      merge_commit = "",
      commit = "",
      merge_commit_end = "",
      commit_end = "",

      -- Advanced symbols
      GVER = "",
      GHOR = "",
      GCLD = "",
      GCRD = "╭",
      GCLU = "",
      GCRU = "",
      GLRU = "",
      GLRD = "",
      GLUD = "",
      GRUD = "",
      GFORKU = "",
      GFORKD = "",
      GRUDCD = "",
      GRUDCU = "",
      GLUDCD = "",
      GLUDCU = "",
      GLRDCL = "",
      GLRDCR = "",
      GLRUCL = "",
      GLRUCR = "",
    },
    format = {
      timestamp = "%b %d %Y %H:%M",
    },
    hooks = {
      -- <CR> on a commit: show that commit's own changes
      on_select_commit = function(commit)
        vim.cmd("DiffviewOpen " .. commit.hash .. "^!")
      end,
      -- <CR> over a visual range: diff the whole selected range
      on_select_range_commit = function(from, to)
        vim.cmd("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
      end,
    },
  },
}
