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
  virtual_text = false,
}

vim.diagnostic.config(config)

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local bufnr = args.buf

    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    local map = vim.keymap.set

    local diagnostic_goto = function(next, severity)
      return function()
        vim.diagnostic.jump({
          count = (next and 1 or -1) * vim.v.count1,
          severity = severity and vim.diagnostic.severity[severity] or nil,
          float = true,
        })
      end
    end

    map("n", "<leader>cL", function()
      local view = vim.fn.winsaveview()

      for _, c in ipairs(vim.lsp.get_clients({ filter = bufnr })) do
        if c.name ~= "copilot" then
          c:stop()
        end
      end

      -- Calling edit centers the cursor, so we need to save and restore the
      -- view to ensure the cursor doesn't move after restarting the LSP clients
      vim.cmd("edit")

      vim.schedule(function()
        vim.fn.winrestview(view)

        vim.notify("LSP Restarted", vim.log.levels.INFO, { title = "LSP" })
      end)
    end, { desc = "Restart LSP" })
    map("n", "<leader>cr", function()
      local inc_rename = require("inc_rename")
      return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
    end, { desc = "LSP Rename", expr = true })
    map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
    map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
    map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
    map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
    map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
    map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
    map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

    vim.bo[bufnr].formatexpr = "v:lua.require('conform').formatexpr()"
  end,
})

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
