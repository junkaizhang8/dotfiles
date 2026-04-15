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
        local source = diag.source and string.gsub(diag.source, "%.+$", "") .. ": " or ""
        return source .. diag.message .. " [" .. diag.code .. "]"
      end,
      override_open_float = true,
    },
  },
  config = function(_, opts)
    require("tiny-inline-diagnostic").setup(opts)
  end,
}
