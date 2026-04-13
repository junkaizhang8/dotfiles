return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      angular = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      scss = { "prettier" },
      sh = { "shfmt" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      yaml = { "prettier" },
    },
    format_on_save = function()
      -- Don't format when minifiles is open
      if vim.g.minifiles_active then
        return nil
      end

      -- If auto-formatting is diabled
      if not vim.g.autoformat then
        return nil
      end

      return {
        timeout_ms = 500,
        lsp_format = "fallback",
      }
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
