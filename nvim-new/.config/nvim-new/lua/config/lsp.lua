local icons = require("config.icons")

local config = {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.error .. " ",
      [vim.diagnostic.severity.WARN] = icons.diagnostics.warn .. " ",
      [vim.diagnostic.severity.INFO] = icons.diagnostics.info .. " ",
      [vim.diagnostic.severity.HINT] = icons.diagnostics.hint .. " ",
    },
  },
}

vim.diagnostic.config(config)

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    -- Extend Neovim's client capabilities with the completion ones
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })

    local servers = vim
      .iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
      :map(function(file)
        return vim.fn.fnamemodify(file, ":t:r")
      end)
      :totable()
    vim.lsp.enable(servers)
  end,
})
