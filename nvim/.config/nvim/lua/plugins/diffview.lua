---@alias HistoryViewType "none"|"file"|"commit"

---@type HistoryViewType
local history_view_type = "none"

local function get_current_view()
  local lib = require("diffview.lib")
  return lib.get_current_view()
end

local function close_current_view()
  vim.cmd("DiffviewClose")
  history_view_type = "none"
end

local function toggle_diffview()
  local view = get_current_view()

  if view then
    if view.class:name() == "DiffView" then
      close_current_view()
      return
    end

    close_current_view()
  end

  vim.cmd("DiffviewOpen")
end

local function toggle_file_history()
  local view = get_current_view()

  if view then
    if view.class:name() == "FileHistoryView" and history_view_type == "file" then
      close_current_view()
      return
    end

    close_current_view()
  end

  vim.cmd("DiffviewFileHistory %")
  history_view_type = "file"
end

local function toggle_commit_history()
  local view = get_current_view()

  if view then
    if view.class:name() == "FileHistoryView" and history_view_type == "commit" then
      close_current_view()
      return
    end

    close_current_view()
  end

  vim.cmd("DiffviewFileHistory")
  history_view_type = "commit"
end

return {
  "dlyongemallo/diffview-plus.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", toggle_diffview, desc = "Open Diffview" },
    { "<leader>gf", toggle_file_history, desc = "File History" },
    { "<leader>gf", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", mode = { "v" }, desc = "Range History" },
    { "<leader>gh", toggle_commit_history, desc = "Commit History" },
    { "<leader>gc", "<Cmd>DiffviewClose<CR>", desc = "Close Diffview" },
  },
  opts = function()
    local actions = require("diffview.actions")

    require("diffview.ui.panel").Panel.default_config_float.border = "rounded"

    return {
      clean_up_buffers = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
      -- stylua: ignore start
      keymaps = {
        -- Borrowed from MariaSolOs's dotfiles:
        -- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/plugin/diffview.lua
        disable_defaults = true,
        view = {
          { "n", "<Tab>",      actions.select_next_entry,             { desc = "Open the Diff for the Next File" } },
          { "n", "<S-Tab>",    actions.select_prev_entry,             { desc = "Open the Diff for the Previous File" } },
          { "n", "[x",         actions.prev_conflict,                 { desc = "Merge-tool: Jump to the Previous Conflict" } },
          { "n", "]x",         actions.next_conflict,                 { desc = "Merge-tool: Jump to the Next Conflict" } },
          { "n", "gf",         actions.goto_file_tab,                 { desc = "Open the File in a New Tabpage" } },
          { "n", "<leader>e",  actions.toggle_files,                  { desc = "Toggle the File Panel" } },
          { "n", "<leader>Go", actions.conflict_choose("ours"),       { desc = "Choose the OURS Version of a Conflict" } },
          { "n", "<leader>Gt", actions.conflict_choose("theirs"),     { desc = "Choose the THEIRS Version of a Conflict" } },
          { "n", "<leader>Gb", actions.conflict_choose("base"),       { desc = "Choose the BASE Version of a Conflict" } },
          { "n", "<leader>Ga", actions.conflict_choose("all"),        { desc = "Choose all the Versions of a Conflict" } },
          { "n", "<leader>Gd", actions.conflict_choose("none"),       { desc = "Delete the Conflict Region" } },
          { "n", "<leader>GO", actions.conflict_choose_all("ours"),   { desc = "Choose the OURS Version of a Conflict for the Whole File" } },
          { "n", "<leader>GT", actions.conflict_choose_all("theirs"), { desc = "Choose the THEIRS Version of a Conflict for the Whole File" } },
          { "n", "<leader>GB", actions.conflict_choose_all("base"),   { desc = "Choose the BASE Version of a Conflict for the Whole File" } },
          unpack(actions.compat.fold_cmds),
        },
        diff2 = {
          { "n", "g?", actions.help { "view", "diff2" }, { desc = "Open the Help Panel" } },
        },
        diff3 = {
          { "n", "g?", actions.help { "view", "diff3" }, { desc = "Open the Help Panel" } },
        },
        file_panel = {
          { "n", "j",          actions.next_entry,                    { desc = "Bring the Cursor to the Next File Entry" } },
          { "n", "k",          actions.prev_entry,                    { desc = "Bring the Cursor to the Previous File Entry" } },
          { "n", "<CR>",       actions.select_entry,                  { desc = "Open the Diff for the Selected Entry" } },
          { "n", "l",          actions.select_entry,                  { desc = "Open the Diff for the Selected Entry" } },
          { { "n", "x" }, "w", actions.toggle_select_entry,           { desc = "Toggle File Selection for Multi-File Operations" } },
          { "n", "C",          actions.clear_select_entries,          { desc = "Clear all File Selections" } },
          { "n", "s",          actions.toggle_stage_entry,            { desc = "Stage / Unstage the Selected Entry" } },
          { "n", "S",          actions.stage_all,                     { desc = "Stage all Entries" } },
          { "n", "U",          actions.unstage_all,                   { desc = "Unstage all Entries" } },
          { "n", "X",          actions.restore_entry,                 { desc = "Restore Entry to the State on the Left Side" } },
          { "n", "L",          actions.open_commit_log,               { desc = "Open the Commit Log Panel" } },
          { "n", "gL",         actions.open_commit_log_file,          { desc = "Open the Commit Log Panel Filtered to the File Under the Cursor" } },
          { "n", "gf",         actions.goto_file_tab,                 { desc = "Open the File in a New Tabpage" } },
          { "n", "zo",         actions.open_fold,                     { desc = "Expand Fold" } },
          { "n", "h",          actions.close_fold,                    { desc = "Collapse Fold" } },
          { "n", "zc",         actions.close_fold,                    { desc = "Collapse Fold" } },
          { "n", "za",         actions.toggle_fold,                   { desc = "Toggle Fold" } },
          { "n", "zR",         actions.open_all_folds,                { desc = "Expand all Folds" } },
          { "n", "zM",         actions.close_all_folds,               { desc = "Collapse all Folds" } },
          { "n", "<C-b>",      actions.scroll_view(-0.25),            { desc = "Scroll the View Up" } },
          { "n", "<C-f>",      actions.scroll_view(0.25),             { desc = "Scroll the View Down" } },
          { "n", "<Tab>",      actions.select_next_entry,             { desc = "Open the Diff for the Next file" } },
          { "n", "<S-Tab>",    actions.select_prev_entry,             { desc = "Open the Diff for the Previous File" } },
          { "n", "i",          actions.listing_style,                 { desc = "Toggle Between 'list' and 'tree' Views" } },
          { "n", "R",          actions.refresh_files,                 { desc = "Update Stats and Entries in the File List" } },
          { "n", "<leader>e",  actions.toggle_files,                  { desc = "Toggle the File Panel" } },
          { "n", "[x",         actions.prev_conflict,                 { desc = "Go to the Previous Conflict" } },
          { "n", "]x",         actions.next_conflict,                 { desc = "Go to the Next Conflict" } },
          { "n", "g?",         actions.help("file_panel"),            { desc = "Open the Help Panel" } },
          { "n", "<leader>GO", actions.conflict_choose_all("ours"),   { desc = "Choose the OURS Version of a Conflict for the Whole File" } },
          { "n", "<leader>GT", actions.conflict_choose_all("theirs"), { desc = "Choose the THEIRS Version of a Conflict for the Whole File" } },
          { "n", "<leader>GB", actions.conflict_choose_all("base"),   { desc = "Choose the BASE Version of a Conflict for the Whole File" } },
          { "n", "<leader>GA", actions.conflict_choose_all("all"),    { desc = "Choose all the Versions of a Conflict for the Whole File" } },
          { "n", "<leader>GD", actions.conflict_choose_all("none"),   { desc = "Delete the Conflict Region for the Whole File" } },
        },
        file_history_panel = {
          { "n", "g!",         actions.options,                    { desc = "Open the Option Panel" } },
          { "n", "<leader>d", actions.open_in_diffview,           { desc = "Open the Entry Under the Cursor in a Diffview" } },
          { "n", "y",         actions.copy_hash,                  { desc = "Copy the Commit Hash of the Entry Under the Cursor" } },
          { "n", "L",         actions.open_commit_log,            { desc = "Show Commit Details" } },
          { "n", "X",         actions.restore_entry,              { desc = "Restore File to the State from the Selected Entry" } },
          { "n", "zo",        actions.open_fold,                  { desc = "Expand Fold" } },
          { "n", "h",         actions.close_fold,                 { desc = "Collapse Fold" } },
          { "n", "zc",        actions.close_fold,                 { desc = "Collapse Fold" } },
          { "n", "za",        actions.toggle_fold,                { desc = "Toggle Fold" } },
          { "n", "zR",        actions.open_all_folds,             { desc = "Expand all Folds" } },
          { "n", "zM",        actions.close_all_folds,            { desc = "Collapse all Folds" } },
          { "n", "j",         actions.next_entry,                 { desc = "Bring the Cursor to the Next File Entry" } },
          { "n", "k",         actions.prev_entry,                 { desc = "Bring the Cursor to the Previous File Entry" } },
          { "n", "<CR>",      actions.select_entry,               { desc = "Open the Diff for the Selected Entry" } },
          { "n", "l",         actions.select_entry,               { desc = "Open the Diff for the Selected Entry" } },
          { "n", "<C-b>",     actions.scroll_view(-0.25),         { desc = "Scroll the View Up" } },
          { "n", "<C-f>",     actions.scroll_view(0.25),          { desc = "Scroll the View Down" } },
          { "n", "<Tab>",     actions.select_next_entry,          { desc = "Open the Diff for the Next File" } },
          { "n", "<S-Tab>",   actions.select_prev_entry,          { desc = "Open the Diff for the Previous File" } },
          { "n", "gf",        actions.goto_file_tab,              { desc = "Open the File in a New Tabpage" } },
          { "n", "<leader>e", actions.toggle_files,               { desc = "Toggle the File Panel" } },
          { "n", "g?",        actions.help("file_history_panel"), { desc = "Open the Help Panel" } },
        },
        option_panel = {
          { "n", "<Tab>", actions.select_entry,         { desc = "Change the Current Option" } },
          { "n", "q",     actions.close,                { desc = "Close the Panel" } },
          { "n", "<Esc>", actions.close,                { desc = "Close the Panel" } },
          { "a", "g?",    actions.help("option_panel"), { desc = "Open the Help Panel" } },
        },
        help_panel = {
          { "n", "q",     actions.close, { desc = "Close Help Menu" } },
          { "n", "<Esc>", actions.close, { desc = "Close Help Menu" } },
        },
        commit_log_panel = {
          { "n", "q",     actions.close, { desc = "Close Commit Log" } },
          { "n", "<Esc>", actions.close, { desc = "Close Help Menu" } },
        },
      },
    }
  end,
}
