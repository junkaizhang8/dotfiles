return {
  "nvim-mini/mini.splitjoin",
  keys = {
    {
      "<leader>cj",
      function()
        require("mini.splitjoin").toggle()
      end,
      desc = "Split/join code block",
    },
  },
  opts = {
    mappings = {
      toggle = "<leader>cj",
    },
  },
}
