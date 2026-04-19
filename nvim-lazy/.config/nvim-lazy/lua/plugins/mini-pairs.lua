return {
  "nvim-mini/mini.pairs",
  enabled = true,
  opts = {
    -- Disable in command mode because it can get annoying
    modes = { insert = true, command = false, terminal = false },
  },
}
