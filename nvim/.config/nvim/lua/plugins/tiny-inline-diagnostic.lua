return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  opts = {
    options = {
      show_source = {
        enabled = true,
      },
      format = function(diag)
        local ret = (diag.source and string.gsub(diag.source, "%.+$", "") .. ": " or "") .. diag.message
        if diag.code and diag.code ~= vim.NIL then
          ret = ret .. " [" .. diag.code .. "]"
        end
        return ret
      end,
      override_open_float = true,
    },
  },
  config = function(_, opts)
    require("tiny-inline-diagnostic").setup(opts)
  end,
}
