return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  cond = not vim.g.scrollback_mode,
  event = "VeryLazy",
  branch = "main",
  opts = {
    move = { set_jumps = true },
  },
  config = function(_, opts)
    local ts = require("nvim-treesitter-textobjects")
    ts.setup(opts)

    local keys = {
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
      goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
      goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
    }

    local function has_ts_textobjects(buf)
      local ft = vim.bo[buf].filetype
      local lang = vim.treesitter.language.get_lang(ft) or ft

      local has_parser = vim.treesitter.get_parser(buf, lang) ~= nil

      local has_query = false
      if has_parser then
        local query = vim.treesitter.query.get(lang, "textobjects")
        has_query = query ~= nil
      end

      return has_parser and has_query
    end

    local function attach(buf)
      if not has_ts_textobjects(buf) then
        return
      end

      for method, keymaps in pairs(keys) do
        for key, query in pairs(keymaps) do
          local queries = type(query) == "table" and query or { query }
          local parts = {}
          for _, q in ipairs(queries) do
            local part = q:gsub("@", ""):gsub("%..*", "")
            part = part:sub(1, 1):upper() .. part:sub(2)
            table.insert(parts, part)
          end
          local desc = table.concat(parts, " or ")
          desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
          vim.keymap.set({ "n", "x", "o" }, key, function()
            -- Use the default behavior of ]c and [c in diff mode
            -- (next/prev change)
            if vim.wo.diff and key:find("[cC]") then
              return vim.cmd("normal! " .. key)
            end
            require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
          end, {
            buffer = buf,
            desc = desc,
            silent = true,
          })
        end
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("junkaizhang8/treesitter_textobjects", { clear = true }),
      callback = function(args)
        attach(args.buf)
      end,
    })
    vim.tbl_map(attach, vim.api.nvim_list_bufs())
  end,
}
