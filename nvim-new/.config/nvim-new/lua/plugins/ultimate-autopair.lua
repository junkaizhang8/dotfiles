return {
  "altermo/ultimate-autopair.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  branch = "v0.6",
  config = function()
    local opts = {
      bs = { delete_from_end = false },
      extensions = { surround = false },
      config_internal_pairs = {
        { "'", "'", nft = { "markdown", "gitcommit" } },
        { '"', '"', nft = { "vim" } },
      },
    }

    -- Plugin does not work for Lua strings, so we manually add pairs with a
    -- condition to avoid triggering inside Lua strings
    local pairs = {
      { "[", "]" },
      { "{", "}" },
      { "(", ")" },
      { '"', '"' },
      { "'", "'" },
      { "`", "`" },
    }

    local function in_lua_string()
      local node = vim.treesitter.get_node()

      if node then
        return node:type() == "string" or node:type() == "string_content"
      end

      return false
    end

    local function key_of(p)
      return p[1] .. "\0" .. p[2]
    end

    local function merge_unique(list, extra)
      local set = {}
      local out = {}

      for _, v in ipairs(list or {}) do
        if not set[v] then
          set[v] = true
          table.insert(out, v)
        end
      end

      for _, v in ipairs(extra or {}) do
        if not set[v] then
          set[v] = true
          table.insert(out, v)
        end
      end

      return out
    end

    local existing = {}
    for _, p in ipairs(opts.config_internal_pairs or {}) do
      existing[key_of(p)] = p
    end

    local merged_internal = {}

    for _, p in ipairs(pairs) do
      local k = key_of(p)
      local entry

      if existing[k] then
        entry = existing[k]

        entry.nft = merge_unique(entry.nft, { "lua" })
      else
        entry = {
          p[1],
          p[2],
          nft = { "lua" },
        }
      end

      table.insert(merged_internal, entry)
    end

    -- Disable the specified internal pairs for Lua, since we will be handling
    -- them ourselves
    opts.config_internal_pairs = merged_internal

    -- Insert pairs with a condition to avoid triggering inside Lua strings
    for _, p in ipairs(pairs) do
      table.insert(opts, {
        p[1],
        p[2],
        cond = function()
          return not in_lua_string()
        end,
        ft = { "lua" },
      })
    end

    require("ultimate-autopair").setup(opts)
  end,
}
