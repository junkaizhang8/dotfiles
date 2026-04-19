local icons = require("config.icons")

local function inside_comment_block()
  if vim.api.nvim_get_mode().mode ~= "i" then
    return false
  end
  local node_under_cursor = vim.treesitter.get_node()
  local parser = vim.treesitter.get_parser(nil, nil, { error = false })
  local query = vim.treesitter.query.get(vim.bo.filetype, "highlights")
  if not parser or not node_under_cursor or not query then
    return false
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  for id, node, _ in query:iter_captures(node_under_cursor, 0, row, row + 1) do
    if query.captures[id]:find("comment") then
      local start_row, start_col, end_row, end_col = node:range()
      if start_row <= row and row <= end_row then
        if start_row == row and end_row == row then
          if start_col <= col and col <= end_col then
            return true
          end
        elseif start_row == row then
          if start_col <= col then
            return true
          end
        elseif end_row == row then
          if col <= end_col then
            return true
          end
        else
          return true
        end
      end
    end
  end
  return false
end

return {
  "saghen/blink.cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    {
      "Kaiser-Yang/blink-cmp-dictionary",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    "fang2hou/blink-copilot",
  },
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    keymap = { preset = "default" },
    completion = {
      list = {
        selection = { preselect = true, auto_insert = true },
      },
      menu = {
        scrollbar = true,
        draw = {
          gap = 1,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = true,
      },
    },
    sources = {
      default = function()
        local result = { "copilot", "lazydev", "lsp", "path", "snippets", "buffer" }
        if
          -- Turn on dictionary in markdown or text file
          vim.tbl_contains({ "markdown", "text" }, vim.bo.filetype)
          -- Or turn on dictionary if cursor is in a comment block
          or inside_comment_block()
        then
          table.insert(result, "dictionary")
        end
        return result
      end,
      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        dictionary = {
          name = "Dict",
          module = "blink-cmp-dictionary",
          max_items = 5,
          min_keyword_length = 3,
          -- Make sure it is last in priority so it does not conflict with other sources
          score_offset = -100,
          opts = {
            -- Do not specify a file, just the path, and in the path you need to
            -- have your .txt files
            dictionary_directories = { vim.fn.expand("~/.dotfiles/dictionaries") },
          },
        },
      },
    },
    snippets = { preset = "luasnip" },
    appearance = {
      kind_icons = icons.kinds,
    },
    cmdline = {
      completion = {
        list = { selection = { preselect = true } },
        menu = {
          auto_show = function()
            return vim.fn.getcmdtype() == ":"
          end,
        },
        ghost_text = { enabled = true },
      },
      keymap = { preset = "inherit" },
    },
  },
}
