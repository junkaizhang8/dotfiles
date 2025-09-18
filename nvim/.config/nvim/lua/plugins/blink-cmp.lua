return {
  "saghen/blink.cmp",
  dependencies = {
    {
      "Kaiser-Yang/blink-cmp-dictionary",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
  },
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    completion = {
      menu = { border = "rounded" },
      documentation = { window = { border = "rounded" } },
    },
    signature = { window = { border = "rounded" } },
    sources = {
      default = { "dictionary" },
      providers = {
        dictionary = {
          name = "Dict",
          module = "blink-cmp-dictionary",
          max_items = 8,
          min_keyword_length = 3,
          -- Make sure it is last in priority so it does not conflict with other sources
          score_offset = -100,
          opts = {
            -- Do not specify a file, just the path, and in the path you need to
            -- have your .txt files
            dictionary_directories = { vim.fn.expand("~/.dotfiles/dictionaries") },
          },
        },
      },
    },
    keymap = { preset = "default" },
  },
}
