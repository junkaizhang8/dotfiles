return {
  "zbirenbaum/copilot.lua",
  config = function(_, opts)
    require("copilot").setup(opts)

    local Snacks = require("snacks")

    Snacks.toggle({
      name = "Copilot Completion",
      get = function()
        return not require("copilot.client").is_disabled()
      end,
      set = function(state)
        if state then
          require("copilot.command").enable()
        else
          require("copilot.command").disable()
        end
      end,
    }):map("<leader>aT")
  end,
}
