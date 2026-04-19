return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      -- Avoid showing a bunch of lines if we're deeply nested
      max_lines = 3,
      -- Only show one context line
      multiline_threshold = 1,
      -- Disable when window is too small
      min_window_height = 20,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)

      vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#112638" })
    end,
  },
  config = function()
    local ensure_installed = {
      "bash",
      "c",
      "cpp",
      "css",
      "gitcommit",
      "glsl",
      "go",
      "html",
      "java",
      "javascript",
      "json",
      "json5",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "regex",
      "rust",
      "scss",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      "zsh",
    }

    -- Install the parsers asynchronously
    -- Call :wait() for synchronous installation (not recommended)
    require("nvim-treesitter").install(ensure_installed)

    local function has_ts_indent(ft)
      local lang = vim.treesitter.language.get_lang(ft)
      if not lang then
        return false
      end

      return vim.treesitter.query.get(lang, "indents") ~= nil
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("junkaizhang8/treesitter", { clear = true }),
      callback = function(args)
        -- Start treesitter highlighting
        local ok = pcall(vim.treesitter.start, args.buf)
        if not ok then
          return
        end

        -- Enable treesitter-based indentation if treesitter supports it
        if has_ts_indent(vim.bo.filetype) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        local bufnr = args.buf

        -- Enable treesitter folding when not in huge files
        if vim.bo[bufnr].filetype ~= "bigfile" then
          vim.api.nvim_buf_call(bufnr, function()
            vim.wo[0][0].foldmethod = "expr"
            vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.cmd.normal("zx")
          end)
        end
      end,
    })
  end,
}
