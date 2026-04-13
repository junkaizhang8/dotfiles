return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall", "TSHealth" },
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
  config = function(_, opts)
    require("nvim-treesitter.config").setup(opts)

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
      "lua",
      "luadoc",
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

    require("nvim-treesitter").install(ensure_installed)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        -- Enable treesitter highlighting
        pcall(vim.treesitter.start)
        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
