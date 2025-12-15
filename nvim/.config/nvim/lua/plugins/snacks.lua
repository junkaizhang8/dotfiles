return {
  "folke/snacks.nvim",
  keys = {
    -- Disable some default keymaps
    { "<leader><space>", false },
    { "<leader>/", false },
    { "<leader>fe", false },
    { "<leader>fE", false },
    { "<leader>ff", false },
    { "<leader>fF", false },
    { "<leader>fr", false },
    { "<leader>fR", false },
    { "<leader>sg", false },
    { "<leader>sG", false },
    { "<leader>sw", false },
    { "<leader>sW", false },
    { "<leader>e", false },
    { "<leader>E", false },
    { "<leader>gd", false },
    { "<leader>gf", false },
    -- New keymaps
    {
      "<leader><space>",
      LazyVim.pick("files", { root = false }),
      desc = "Find Files (cwd)",
    },
    {
      "<leader>/",
      LazyVim.pick("grep", { root = false }),
      desc = "Grep (cwd)",
    },
    {
      "<leader>fe",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer Snacks (cwd)",
    },
    {
      "<leader>fE",
      function()
        Snacks.explorer({ cwd = LazyVim.root() })
      end,
      desc = "Explorer Snacks (root dir)",
    },
    {
      "<leader>ff",
      LazyVim.pick("files", { root = false }),
      desc = "Find Files (cwd)",
    },
    {
      "<leader>fF",
      LazyVim.pick("files"),
      desc = "Find Files (root dir)",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent({ filter = { cwd = true } })
      end,
      desc = "Recent (cwd)",
    },
    {
      "<leader>fR",
      LazyVim.pick("oldfiles"),
      desc = "Recent",
    },
    {
      "<leader>sg",
      LazyVim.pick("live_grep", { root = false }),
      desc = "Grep (cwd)",
    },
    {
      "<leader>sG",
      LazyVim.pick("live_grep"),
      desc = "Grep (root dir)",
    },
    {
      "<leader>sw",
      LazyVim.pick("grep_word", { root = false }),
      desc = "Visual selection or word (cwd)",
      mode = { "n", "x" },
    },
    {
      "<leader>sW",
      LazyVim.pick("grep_word"),
      desc = "Visual selection or word (root dir)",
      mode = { "n", "x" },
    },
    {
      "<leader>gD",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git Diff (hunks)",
    },
    {
      "<leader>gF",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git Current File History",
    },
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
      news = {
        width = 0.6,
        height = 0.6,
        border = "rounded",
        wo = {
          spell = false,
          wrap = false,
          signcolumn = "yes",
          statuscolumn = " ",
          conceallevel = 3,
        },
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
        -- Filter out LSP definition notification when no definition found
        if msg == "No information available" then
          return false
        end
        -- Filter out notification from img-clip when pasting
        if msg == "Content is not an image." then
          return false
        end
        -- Disable bugged notification that shows in markdown files when
        -- you press <CR> when blink.cmp ghost text is showing
        if msg:match("ghost_text/utils.lua:%d+: Invalid buffer id") then
          return false
        end
        -- Disable other bugged notifications from blink.cmp
        if msg:match("ghost_text/init.lua:%d+: Invalid 'col': out of range") then
          return false
        end
        if msg:match("lib/text_edits.lua:%d+: attempt to get length of local") then
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
        grep = {
          hidden = true,
        },
        files = {
          hidden = true,
          exclude = { ".git", "node_modules", "__pycache__", ".DS_Store" },
        },
        recent = {
          hidden = true,
        },
        notifications = {
          win = {
            preview = {
              wo = {
                wrap = true,
              },
            },
          },
        },
      },
    }
    -- Override some dashboard keys to use the cwd instead of root dir
    local keys = {
      [1] = {
        icon = " ",
        key = "f",
        desc = "Find File",
        action = ":lua Snacks.dashboard.pick('files', { root = false })",
      },
      [4] = {
        icon = " ",
        key = "g",
        desc = "Find Text",
        action = ":lua Snacks.dashboard.pick('live_grep', { root = false })",
      },
    }
    for i, key in pairs(keys) do
      opts.dashboard.preset.keys[i] = key
    end
  end,
}
