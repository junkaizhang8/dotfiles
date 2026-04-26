return {
  "altermo/ultimate-autopair.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  branch = "v0.6",
  config = function()
    local function string_autopair_guard(fn, _, closing_char)
      local in_string = fn.in_node({ "string", "raw_string" })
      if not in_string then
        return true
      end
      if closing_char == nil then
        return false
      end
      local line = vim.api.nvim_get_current_line()
      -- The character may be a multibyte character, so we need to use
      -- strcharpart to get the correct character.
      -- Likewise, we need to use charcol to get the correct character
      -- index.
      local char = vim.fn.strcharpart(line, vim.fn.charcol(".") - 1, 1)
      return char == closing_char
    end

    local opts = {
      bs = { delete_from_end = false },
      extensions = {
        surround = false,
      },
      config_internal_pairs = {
        {
          "[",
          "]",
          cond = function(fn, o)
            return string_autopair_guard(fn, o)
          end,
          fly = true,
          dosuround = true,
          newline = true,
          space = true,
        },
        {
          "(",
          ")",
          cond = function(fn, o)
            return string_autopair_guard(fn, o)
          end,
          fly = true,
          dosuround = true,
          newline = true,
          space = true,
        },
        {
          "{",
          "}",
          cond = function(fn, o)
            return string_autopair_guard(fn, o)
          end,
          fly = true,
          dosuround = true,
          newline = true,
          space = true,
        },
        {
          '"',
          '"',
          suround = true,
          cond = function(fn, o)
            return string_autopair_guard(fn, o, '"')
          end,
          multiline = false,
          nft = { "vim" },
        },
        {
          "'",
          "'",
          suround = true,
          cond = function(fn, o)
            return not fn.in_lisp() and string_autopair_guard(fn, o, "'")
          end,
          alpha = true,
          multiline = false,
          nft = { "tex", "rust", "markdown", "gitcommit" },
        },
        {
          "`",
          "`",
          cond = function(fn, o)
            return not fn.in_lisp() and string_autopair_guard(fn, o, "`")
          end,
          multiline = false,
          nft = { "tex" },
        },
      },
    }

    require("ultimate-autopair").setup(opts)
  end,
}
