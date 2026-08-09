return {
  "danymat/neogen",
  dependencies = { "L3MON4D3/LuaSnip" },
  keys = {
    {
      "<leader>cn",
      function()
        require("neogen").generate()
      end,
      desc = "Generate Annotations",
    },
  },
  opts = {
    snippet_engine = "luasnip",
  },
}
