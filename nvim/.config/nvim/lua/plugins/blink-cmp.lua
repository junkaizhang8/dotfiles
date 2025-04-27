return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = function(_, opts)
    opts.keymap = { preset = "default" }
    opts.cmdline = { enabled = true }
  end,
}
