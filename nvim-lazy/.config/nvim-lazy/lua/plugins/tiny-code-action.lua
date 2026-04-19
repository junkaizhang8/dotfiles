return {
  "rachartier/tiny-code-action.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  event = "LspAttach",
  keys = {
    {
      "<leader>ca",
      function()
        require("tiny-code-action").code_action({})
      end,
      silent = true,
      desc = "Code Action (Tiny)",
    },
  },
  opts = {
    picker = {
      "buffer",
      opts = {
        hotkeys = true,
        -- Use numeric labels.
        hotkeys_mode = function(titles)
          return vim
            .iter(ipairs(titles))
            :map(function(i)
              return tostring(i)
            end)
            :totable()
        end,
      },
    },
  },
}
