return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  opts = {
    options = {
      multilines = {
        enabled = true,
        always_show = false,
      },
      show_source = { enabled = true },
      format = function(diag)
        local ret = diag.message
        if diag.code and diag.code ~= vim.NIL then
          ret = ret .. " [" .. diag.code .. "]"
        end
        if diag.source then
          ret = ret .. " (" .. string.gsub(diag.source, "%.+$", "") .. ")"
        end
        return ret
      end,
      override_open_float = true,
      show_diags_only_under_cursor = false,
    },
  },
  config = function(_, opts)
    require("tiny-inline-diagnostic").setup(opts)
    vim.diagnostic.config({ virtual_text = false })
  end,
}
