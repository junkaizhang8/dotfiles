local function augroup(name)
  return vim.api.nvim_create_augroup("junkaizhang8/" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "grug-far",
    "help",
    "man",
    "qf",
  },
  desc = "Close with 'q'",
  callback = function(args)
    local bufnr = args.buf
    vim.bo[bufnr].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        if args.match == "man" then
          vim.cmd("quit")
        else
          vim.cmd("close")
          pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
        end
      end, {
        buffer = bufnr,
        silent = true,
        desc = "Quit Buffer",
      })
    end)
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  desc = "Resize splits when the Vim window is resized",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "markdown", "gitcommit" },
  desc = "Enable wrapping and spell checking for text files",
  callback = function()
    vim.wo.wrap = true
    vim.wo.spell = true
  end,
})
