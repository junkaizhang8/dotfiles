return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.image = {
      enabled = true,
      doc = {
        inline = false,
        float = true,
        max_width = 80,
        max_height = 40,
      },
    }
    opts.picker = {
      enabled = true,
      sources = {
        explorer = {
          hidden = true,
        },
        files = {
          hidden = true,
          exclude = { "node_modules", ".git" },
        },
      },
    }
  end,
}
