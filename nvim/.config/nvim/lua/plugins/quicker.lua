return {
  -- TODO: abc
  "stevearc/quicker.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>qq",
      function()
        require("quicker").toggle()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>ql",
      function()
        require("quicker").toggle({ loclist = true })
      end,
      desc = "Location List",
    },
  },
  opts = {
    keys = {
      {
        "<leader>>",
        function()
          require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = "Expand Context",
      },
      {
        "<leader><",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse Context",
      },
    },
  },
}
