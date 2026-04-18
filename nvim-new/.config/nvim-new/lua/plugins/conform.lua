return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format()
      end,
      desc = "Format File",
    },
  },
  opts = {
    formatters_by_ft = {
      angular = { "prettierd" },
      css = { "prettierd" },
      html = { "prettierd" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      json = { "prettierd" },
      jsonc = { "prettierd" },
      lua = { "stylua" },
      markdown = { "prettierd" },
      scss = { "prettierd" },
      sh = { "shfmt" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      yaml = { "prettierd" },
      zsh = { "shfmt" },
    },
    default_format_opts = {
      timeout_ms = 500,
      lsp_format = "fallback",
      stop_after_first = true,
    },
    format_on_save = function(bufnr)
      -- Don't format when minifiles is open
      if vim.g.minifiles_active then
        return nil
      end

      -- If auto-formatting is diabled
      if not vim.g.autoformat or vim.b[bufnr].disable_autoformat then
        return nil
      end

      return {}
    end,
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
    -- Show a notification when formatting fails
    notify_on_error = true,
    -- Don't show a notification when no formatter is available for a filetype
    notify_no_formatters = false,
  },
}
