return {
  "mrcjkb/rustaceanvim",
  version = "9.*",
  ft = "rust",
  -- Copied from LazyVim's config
  opts = {
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = { enable = true },
        },
        -- Add clippy lints for Rust if using rust-analyzer
        checkOnSave = true,
        -- Enable diagnostics if using rust-analyzer
        diagnostics = { enable = true },
        procMacro = { enable = true },
        files = {
          exclude = {
            ".direnv",
            ".git",
            ".jj",
            ".github",
            ".gitlab",
            "bin",
            "node_modules",
            "target",
            "venv",
            ".venv",
          },
          -- Avoid Roots Scanned hanging, see https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
          watcher = "client",
        },
      },
    },
  },
  config = function(_, opts)
    local codelldb = require("utils.codelldb")
    opts.dap = {
      adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb.codelldb, codelldb.liblldb),
    }

    vim.g.rustaceanvim = opts or {}
    if vim.fn.executable("rust-analyzer") == 0 then
      vim.notify(
        "rust-analyzer is not installed. Please install it to use rustaceanvim.",
        vim.log.levels.ERROR,
        { title = "rustaceanvim" }
      )
    end
  end,
}
