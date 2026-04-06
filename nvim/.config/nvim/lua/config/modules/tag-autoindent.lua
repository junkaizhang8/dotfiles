-- Module to enhance auto-indentation when pressing <CR> between opening and
-- closing tags in supported filetypes.
-- Heavily inspired by nvim-autopairs' tag handling, but implemented as a
-- standalone module to avoid conflicts with autopairing plugins and to allow
-- customization of the behavior without modifying plugin settings.

local M = {}

local supported_filetypes = {
  "html",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
  "svelte",
  "xml",
  "php",
  "erb",
  "heex",
  "astro",
}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = supported_filetypes,
    callback = function()
      vim.keymap.set("i", "<CR>", function()
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local col = cursor[2]

        local before_cursor = line:sub(1, col)
        local after_cursor = line:sub(col + 1)

        -- Check if cursor is between an opening tag and its closing tag
        if before_cursor:match(">[%w%s]*$") and after_cursor:match("^%s*</") then
          local spaces_before = before_cursor:match("(%s*)$")
          local spaces_after = after_cursor:match("^(%s*)")
          local delete_before = string.rep("<BS>", #spaces_before)
          local delete_after = string.rep("<Del>", #spaces_after)

          -- 1. <C-G>u: Undo point
          -- 2. Strip spaces around cursor
          -- 3. <CR>: First newline
          -- 4. <CMD>normal! ==<CR>: Re-indent current line
          -- 5. <UP><END>: Move to the end of the opening tag line
          -- 6. <CR>: Second newline to create the middle line
          return "<C-G>u" .. delete_before .. delete_after .. "<CR><Cmd>normal! ==<CR><Up><End><CR>"
        end

        -- Fallback to normal Enter
        return "<CR>"
      end, { buffer = true, expr = true, desc = "Tag autoindent" })
    end,
  })
end

return M
