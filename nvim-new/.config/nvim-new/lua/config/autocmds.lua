-- Borrowed from MariaSolOs's dotfiles:
-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/autocmds.lua

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("junkaizhang8/treesitter_folding", { clear = true }),
  desc = "Enable Treesitter Folding",
  callback = function(args)
    local bufnr = args.buf

    -- Enable treesitter folding when not in huge files and if treesitter is
    -- available for the filetype
    if vim.bo[bufnr].filetype ~= "bigfile" and pcall(vim.treesitter.start, bufnr) then
      vim.api.nvim_buf_call(bufnr, function()
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.cmd.normal("zx")
      end)
    end
  end,
})
