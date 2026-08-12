return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    linters_by_ft = {
      dockerfile = { "hadolint" },
      markdown = { "markdownlint-cli2" },
    },
  },
  config = function(_, opts)
    local lint = require("lint")
    -- We need to set linters_by_ft here, otherwise it uses the plugin defaults
    lint.linters_by_ft = opts.linters_by_ft

    local md_config = vim.fs.joinpath(vim.fn.stdpath("config"), "linters", "markdownlint.yaml")
    if vim.uv.fs_stat(md_config) then
      lint.linters["markdownlint-cli2"].args = { "--config", md_config, "-" }
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("junkaizhang8/nvim-lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })

    -- https://github.com/mfussenegger/nvim-lint/issues/559#issuecomment-2263995711
    vim.api.nvim_create_user_command("LintInfo", function()
      local filetype = vim.bo.filetype
      local linters = require("lint").linters_by_ft[filetype]

      if linters then
        print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
      else
        print("No linters configured for filetype: " .. filetype)
      end
    end, {})
  end,
}
