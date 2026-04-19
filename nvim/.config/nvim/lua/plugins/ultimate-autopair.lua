return {
  "altermo/ultimate-autopair.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  branch = "v0.6",
  config = function()
    local function string_autopair_guard(fn, o, closing_char)
      local in_string = fn.in_node({ "string", "raw_string" })
      if not in_string then
        return true
      end
      if closing_char == nil then
        return false
      end
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local _, _, er, ec = in_string:range()
      if er + 1 ~= row then
        return false
      end
      local str_char = o.line:sub(ec, ec)
      if col + 1 == ec and str_char == closing_char then
        return true
      end
      return false
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
