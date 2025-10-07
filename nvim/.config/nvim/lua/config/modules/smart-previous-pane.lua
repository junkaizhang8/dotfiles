-- This module is currently designed with tmux in mind.

local M = {}

local state = {
  last_focus = nil, -- "nvim" or "tmux"
  last_tmux_pane = nil,
  last_nvim_win = nil,
}

local setup_done = false

local api = vim.api

-- Tries to move to the last focused nvim window if possible.
---@return boolean success
local function try_move_nvim()
  if state.last_focus ~= "nvim" or not state.last_nvim_win then
    return false
  end

  local current_win = api.nvim_get_current_win()

  if api.nvim_win_is_valid(state.last_nvim_win) and state.last_nvim_win ~= current_win then
    api.nvim_set_current_win(state.last_nvim_win)
    return true
  end

  return false
end

-- Tries to move to the last focused tmux pane if possible.
---@return boolean success
local function try_move_tmux()
  if not vim.env.TMUX or state.last_focus ~= "tmux" or not state.last_tmux_pane then
    return false
  end

  local current_pane = vim.fn.system("tmux display-message -p '#{pane_id}'"):gsub("\n", "")

  if state.last_tmux_pane ~= current_pane then
    vim.fn.system("tmux select-pane -t " .. state.last_tmux_pane)
    return true
  end

  return false
end

-- Fallback to smart-splits if neither nvim nor tmux movement is possible.
local function fallback()
  local ok, smart_splits = pcall(require, "smart-splits")
  if not ok then
    return
  end
  smart_splits.move_cursor_previous()
end

function M.setup()
  local smart_previous_pane_group = api.nvim_create_augroup("junkaizhang8/smart_previous_pane", { clear = true })
  api.nvim_create_autocmd("FocusGained", {
    group = smart_previous_pane_group,
    callback = function()
      if not vim.env.TMUX then
        return
      end

      -- Slightly delay the execution to ensure tmux has updated its state
      vim.defer_fn(function()
        local current_pane = vim.env.TMUX_PANE
        -- Requires a tmux pane-focus-out hook to set @last_active_pane
        local pane = vim.fn.system("tmux show-option -sv @last_active_pane 2>/dev/null"):gsub("\n", "")

        if vim.v.shell_error ~= 0 then
          return
        end

        if pane and current_pane and pane ~= current_pane then
          local current_window = vim.fn.system("tmux display-message -p '#{window_id}'"):gsub("\n", "")
          -- Requires a tmux pane-focus-out hook to set @last_active_window
          local window = vim.fn.system("tmux show-option -sv -t %s @last_active_window 2>/dev/null"):gsub("\n", "")

          if vim.v.shell_error ~= 0 then
            return
          end

          -- We only want to switch if the last focused pane is in the same window
          if window and current_window and window == current_window then
            state.last_tmux_pane = pane
            state.last_focus = "tmux"
          end
        end
      end, 50)
    end,
  })

  api.nvim_create_autocmd("WinLeave", {
    group = smart_previous_pane_group,
    callback = function()
      state.last_nvim_win = vim.api.nvim_get_current_win()
      state.last_focus = "nvim"
    end,
  })

  setup_done = true
end

--- Moves the cursor to the previously focused pane, either in nvim or tmux.
--- If neither is possible, falls back to smart-splits behavior.
function M.move_cursor_previous()
  -- If setup() was not called or not in tmux, use fallback behavior
  if not setup_done or not vim.env.TMUX then
    return fallback()
  end

  -- The functions are set up so that at most one of them will succeed
  if try_move_nvim() or try_move_tmux() then
    return
  end
  -- Use fallback if neither move was successful
  fallback()
end

return M
