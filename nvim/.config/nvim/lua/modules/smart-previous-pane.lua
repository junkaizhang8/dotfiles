-- Module to track the last focused pane in both nvim and tmux, allowing for
-- seamless switching between them.
-- This module is currently designed with only tmux in mind.

local M = {}

local state = {
  last_focus = nil, -- "nvim" or "tmux" or "kitty"
  last_tmux_pane = nil,
  last_nvim_win = nil,
}

local executables_cache = {}

local setup_done = false

local api = vim.api

-- Check if we're running inside kitty and if remote control is enabled.
---@return boolean is_in_kitty
local function is_in_kitty()
  return vim.env.KITTY_LISTEN_ON and #vim.env.KITTY_LISTEN_ON > 0
end

local function system(cmd, callback)
  if #cmd == 0 then
    error("No command provided")
  end

  executables_cache[cmd[1]] = executables_cache[cmd[1]] or vim.fn.executable(cmd[1]) == 1
  if not executables_cache[cmd[1]] then
    error("Command not found: " .. cmd[1])
  end

  if callback and type(callback) == "function" then
    vim.system(cmd, { text = true }, callback)
    return
  end
  local result = vim.system(cmd, { text = true }):wait()
  return result.code == 0 and (result.stdout or "") or (result.stderr or ""), result.code
end

local function kitty_exec(args)
  local cmd = vim.deepcopy(args)
  table.insert(cmd, 1, "kitty")
  table.insert(cmd, 2, "@")

  local _, code = system(cmd, { text = true })
  return code
end

-- Try to move to the last focused nvim window if possible.
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

-- Try to move to the last focused tmux pane if possible.
---@return boolean success
local function try_move_tmux()
  if not vim.env.TMUX or state.last_focus ~= "tmux" or not state.last_tmux_pane then
    return false
  end

  local res, code1 = system({ "tmux", "display-message", "-p", "#{pane_id}" })
  if not res or code1 ~= 0 then
    return false
  end

  local current_pane = res:gsub("\n", "")

  if state.last_tmux_pane ~= current_pane then
    local _, code2 = system({ "tmux", "select-pane", "-t", state.last_tmux_pane })
    return code2 == 0
  end

  return false
end

-- Try to move to the last focused kitty window if possible.
---@return boolean success
local function try_move_kitty()
  if not is_in_kitty() or state.last_focus ~= "kitty" then
    return false
  end

  local code = kitty_exec({ "kitten", "last_active_window.py" })
  return code == 0
end

-- Fallback to smart-splits if neither nvim nor tmux movement is possible.
---@return boolean success
local function fallback()
  local ok, smart_splits = pcall(require, "smart-splits")
  if not ok then
    return false
  end

  smart_splits.move_cursor_previous()
  return true
end

-- Initialize state when nvim starts or resumes.
local function on_init()
  io.stdout:write("\x1b]1337;SetUserVar=IS_NVIM=MQo\007")
end

-- Clear state when nvim is suspended or exits.
local function on_exit()
  io.stdout:write("\x1b]1337;SetUserVar=IS_NVIM\007")
end

function M.setup()
  local smart_previous_pane_group = api.nvim_create_augroup("junkaizhang8/smart_previous_pane", { clear = true })

  on_init()
  api.nvim_create_autocmd("VimResume", {
    group = smart_previous_pane_group,
    desc = "Re-initialize state when nvim resumes",
    callback = function()
      on_init()
    end,
  })

  api.nvim_create_autocmd({ "VimSuspend", "VimLeavePre" }, {
    group = smart_previous_pane_group,
    desc = "Clear state when nvim is suspended",
    callback = function()
      on_exit()
    end,
  })

  api.nvim_create_autocmd("FocusGained", {
    group = smart_previous_pane_group,
    desc = "Track the last focused pane when nvim gains focus",
    callback = function()
      if vim.env.TMUX then
        -- Slightly delay the execution to ensure tmux has updated its state
        vim.defer_fn(function()
          local current_pane = vim.env.TMUX_PANE

          if not current_pane then
            return
          end

          -- Requires a tmux pane-focus-out hook to set @last_active_pane
          local res1, code1 = system({ "tmux", "show-option", "-sv", "@last_active_pane" })
          if not res1 or code1 ~= 0 then
            return
          end

          local pane = res1:gsub("\n", "")

          if pane ~= current_pane then
            local res2, code2 = system({ "tmux", "display-message", "-p", "#{window_id}" })
            if not res2 or code2 ~= 0 then
              return
            end

            local current_window = res2:gsub("\n", "")
            -- Requires a tmux pane-focus-out hook to set @last_active_window
            local res3, code3 = system({ "tmux", "show-option", "-svt", "%s", "@last_active_window" })
            if not res3 or code3 ~= 0 then
              return
            end

            local window = res3:gsub("\n", "")

            -- We only want to switch if the last focused pane is in the same window
            if window == current_window then
              state.last_tmux_pane = pane
              state.last_focus = "tmux"
            end
          end
        end, 50)
      elseif is_in_kitty() then
        state.last_focus = "kitty"
      end
    end,
  })

  api.nvim_create_autocmd("WinLeave", {
    group = smart_previous_pane_group,
    callback = function()
      state.last_nvim_win = vim.api.nvim_get_current_win()
      state.last_focus = "nvim"
    end,
  })

  api.nvim_create_autocmd("VimLeave", {
    group = smart_previous_pane_group,
    callback = function()
      state.last_nvim_win = nil
      state.last_focus = nil
    end,
  })

  setup_done = true
end

--- Move the cursor to the previously focused pane, either in nvim or tmux.
--- If neither is possible, fall back to smart-splits behavior.
function M.move_cursor_previous()
  -- If setup() was not called, use fallback behavior
  if not setup_done then
    return fallback()
  end

  -- The functions are set up so that at most one of them will succeed
  return try_move_nvim() or try_move_tmux() or try_move_kitty() or fallback()
end

return M
