return {
  "folke/snacks.nvim",
  keys = {
    -- Disable Snacks explorer
    { "<leader>e", false },
    { "<leader>E", false },
  },
  opts = function(_, opts)
    opts.scroll = {
      enabled = true,
      animate = {
        duration = { step = 10, total = 80 },
        easing = "linear",
      },
      animate_repeat = {
        delay = 50,
        duration = { step = 3, total = 20 },
        easing = "linear",
      },
    }
    opts.styles = {
      snacks_image = {
        relative = "editor",
        col = -1,
      },
    }
    opts.image = {
      enabled = true,
      doc = {
        inline = false,
        float = true,
        max_width = 60,
        max_height = 30,
      },
    }
    opts.notifier = {
      enabled = true,
      filter = function(notif)
        local msg = notif.msg
        -- Filter out notification from img-clip when pasting
        if msg == "Content is not an image." then
          return false
        end
        -- Disable bugged notification that shows in markdown files when
        -- you press <enter> when ghost text is showing
        if msg:match("ghost_text/utils.lua:%d+: Invalid buffer id") then
          return false
        end
        return true
      end,
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

    local Snacks = require("snacks")
    local copilot_exists = pcall(require, "copilot")

    if copilot_exists then
      Snacks.toggle({
        name = "Copilot Completion",
        color = {
          enabled = "azure",
          disabled = "orange",
        },
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
    end
  end,
}
