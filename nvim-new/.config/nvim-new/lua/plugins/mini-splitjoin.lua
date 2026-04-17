return {
  "nvim-mini/mini.splitjoin",
  keys = {
    {
      "<leader>cj",
      function()
        require("mini.splitjoin").toggle()
      end,
      desc = "Split/Join Code Block",
    },
  },
  opts = {
    mappings = {
      toggle = "<leader>cj",
    },
  },
}
