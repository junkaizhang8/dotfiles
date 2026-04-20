return {
  "iamcco/markdown-preview.nvim",
  ft = "markdown",
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    {
      "<leader>cp",
      ft = "markdown",
      "<Cmd>MarkdownPreviewToggle<CR>",
      desc = "Markdown Preview",
    },
  },
}
