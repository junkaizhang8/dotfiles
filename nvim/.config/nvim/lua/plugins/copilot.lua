return {
  "zbirenbaum/copilot.lua",
  config = function(_, opts)
    local copilot = require("copilot")

    local is_set_up = false

    if vim.g.copilot_enabled then
      copilot.setup(opts)
      is_set_up = true
    end

    local Snacks = require("snacks")

    Snacks.toggle({
      name = "Copilot Completion",
      get = function()
        if not vim.g.copilot_enabled then
          return false
        end
        return not require("copilot.client").is_disabled()
      end,
      set = function(state)
        if state then
          -- Setting up for the first time
          if not is_set_up then
            copilot.setup(opts)
            is_set_up = true
          end
          require("copilot.command").enable()
          vim.g.copilot_enabled = true
        else
          require("copilot.command").disable()
          vim.g.copilot_enabled = false
        end
      end,
    }):map("<leader>aT")
  end,
}
