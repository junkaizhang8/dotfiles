local root = require("utils.root")

local function get_selection_or_word()
  local mode = vim.fn.mode()
  local query

  if mode == "v" or mode == "V" or mode == "\22" then
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")

    -- We only allow one line selection for simplicity
    if start_pos[2] ~= end_pos[2] then
      vim.notify("Multi-line selection is not supported for search", vim.log.levels.WARN, { title = "FFF" })
      return
    end

    -- Ensure start_pos is before end_pos
    if start_pos[3] > end_pos[3] then
      start_pos, end_pos = end_pos, start_pos
    end

    local line = vim.fn.getline(start_pos[2])

    if mode == "V" then
      -- Line-wise visual mode: use the entire line
      query = line:match("^%s*(.-)%s*$") -- strip leading/trailing whitespace
    else
      -- Character-wise visual mode: use the selected text
      query = line:sub(start_pos[3], end_pos[3]):match("^%s*(.-)%s*$") -- strip leading/trailing whitespace
    end
  else
    query = vim.fn.expand("<cword>")
  end

  return query
end

return {
  "dmtrKovalenko/fff.nvim",
  lazy = false,
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  keys = {
    {
      "<leader><space>",
      function()
        require("fff").find_files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>/",
      function()
        require("fff").live_grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>ff",
      function()
        require("fff").find_files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fF",
      function()
        local root_dir = root.get()
        if root_dir == nil then
          vim.notify("Could not determine project root", vim.log.levels.WARN, { title = "FFF" })
          return
        end
        require("fff").find_files_in_dir(root_dir)
      end,
      desc = "Find Files (root)",
    },
    {
      "<leader>fc",
      function()
        local raw_path = "~/.dotfiles"

        local config_path = vim.fn.expand(raw_path)

        if vim.fn.isdirectory(config_path) == 0 then
          vim.notify("Could not determine config directory", vim.log.levels.WARN, { title = "FFF" })
          return
        end

        require("fff").find_files_in_dir(config_path)
      end,
      desc = "Find Config Files",
    },
    {
      "<leader>sg",
      function()
        require("fff").live_grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>sG",
      function()
        local root_dir = root.get()
        if root_dir == nil then
          vim.notify("Could not determine project root", vim.log.levels.WARN, { title = "FFF" })
          return
        end
        require("fff").live_grep({ cwd = root_dir })
      end,
      desc = "Live Grep (root)",
    },
    {
      "<leader>sw",
      function()
        local query = get_selection_or_word()

        require("fff").live_grep({ query = query })
      end,
      desc = "Visual Selection or Word",
      mode = { "n", "x" },
    },
    {
      "<leader>sW",
      function()
        local root_dir = root.get()
        if root_dir == nil then
          vim.notify("Could not determine project root", vim.log.levels.WARN, { title = "FFF" })
          return
        end

        local query = get_selection_or_word()

        require("fff").live_grep({ cwd = root_dir, query = query })
      end,
      desc = "Visual Selection or Word (root)",
      mode = { "n", "x" },
    },
  },
  opts = {
    prompt = " ",
    title = "Files",
    prompt_vim_mode = true,
    wrap_around = true,
    follow_symlinks = true,
    layout = {
      prompt_position = "top",
    },
    keymaps = {
      move_up = { "<Up>", "<C-p>", "<C-k>" },
      move_down = { "<Down>", "<C-n>", "<C-j>" },
    },
    hl = {
      matched = "Special",
    },
    debug = {
      enabled = false,
      show_scores = false,
    },
  },
}
