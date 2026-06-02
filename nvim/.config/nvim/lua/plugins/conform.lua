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
      markdown = { "prettierd", "markdown-cli2", "markdown-toc" },
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
      ["markdown-toc"] = {
        condition = function(_, ctx)
          for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
            if line:find("<!%-%- toc %-%->") then
              return true
            end
          end
        end,
      },
      ["markdownlint-cli2"] = {
        condition = function(_, ctx)
          local diag = vim.tbl_filter(function(d)
            return d.source == "markdownlint"
          end, vim.diagnostic.get(ctx.buf))
          return #diag > 0
        end,
      },
      injected = { options = { ignore_errors = true } },
    },
    -- Show a notification when formatting fails
    notify_on_error = true,
    -- Don't show a notification when no formatter is available for a filetype
    notify_no_formatters = false,
  },
}
