return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-mini/mini.pick", -- for file_selector provider mini.pick
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or nvim-mini/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    "HakonHarnes/img-clip.nvim", -- for image upload support
    "MeanderingProgrammer/render-markdown.nvim", -- for markdown rendering
  },
  keys = {
    { "<leader>ax", "<Cmd>AvanteClear<CR>", desc = "avante: clear" },
  },
  opts = {
    instruction_file = "avante.md",
    provider = "copilot",
    providers = {
      copilot = {
        model = "claude-3.7-sonnet",
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 8192,
        },
      },
      openai = {
        endpoint = "https://api.githubcopilot.com",
        model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
        timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
        extra_request_body = {
          temperature = 0,
          max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
          reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
        },
      },
    },
    behaviour = {
      auto_suggestions = false,
    },
  },
  config = function(_, opts)
    require("avante").setup(opts)

    local wk = require("which-key")

    wk.add({
      { "<leader>a", group = "+avante/ai", icon = "", mode = { "n", "v" } },
    })
  end,
}
