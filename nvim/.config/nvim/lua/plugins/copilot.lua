return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "BufReadPost",
  opts = {
    suggestion = {
      -- We disable inline suggestions since we have blink.cmp handling that
      enabled = false,
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
  config = function(_, opts)
    local copilot = require("copilot")

    local is_set_up = false

    local function ensure_setup()
      if not is_set_up then
        copilot.setup(opts)
        is_set_up = true
      end
    end

    if vim.g.copilot_enabled then
      ensure_setup()
    end

    Snacks.toggle({
      name = "Copilot Completion",
      get = function()
        return not require("copilot.client").is_disabled()
      end,
      set = function(state)
        if state then
          ensure_setup()

          require("copilot.command").enable()
        else
          require("copilot.command").disable()
        end
      end,
    }):map("<leader>uc")
  end,
}
