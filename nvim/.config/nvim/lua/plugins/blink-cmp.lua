return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = function(_, opts)
    opts.keymap = { preset = "default" }
    opts.cmdline = { enabled = true }
    opts.completion = {
      menu = { border = "rounded" },
      documentation = { window = { border = "rounded" } },
    }
    opts.signature = { window = { border = "rounded" } }
  end,
}
