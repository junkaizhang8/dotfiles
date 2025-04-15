return {
  "saghen/blink.cmp",
  event = { "InsertEnter" },
  -- optional: provides snippets for the snippet source
  dependencies = {
    "L3MON4D3/LuaSnip", -- snippet engine
    "rafamadriz/friendly-snippets", -- useful snippets
  },
  -- use a release tag to download pre-built binaries
  version = "1.*",

  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (c-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- all presets have the following mappings:
    -- c-space: open menu or open docs if already open
    -- c-n/c-p or up/down: select next/previous item
    -- c-e: hide menu
    -- c-k: toggle signature help (if signature.enabled = true)
    --
    -- see :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "default",
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      -- show documentation in a floating window
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = true,
      },
    },

    snippets = {
      preset = "luasnip",
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          name = "lsp",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          score_offset = 90,
        },
        path = {
          name = "path",
          enabled = true,
          module = "blink.cmp.sources.path",
          score_offset = 25,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = true,
          },
        },
        buffer = {
          name = "buffer",
          enabled = true,
          max_items = 3,
          module = "blink.cmp.sources.buffer",
          score_offset = 15,
        },
        snippets = {
          name = "snippets",
          enabled = true,
          max_items = 15,
          module = "blink.cmp.sources.snippets",
          score_offset = 85,
        },
      },
    },

    -- (default) rust fuzzy matcher for typo resistance and significantly better performance
    -- you may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- see the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
