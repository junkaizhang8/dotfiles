local M = {}

---@class BulletType
local BulletType = {
  number = "number",
  unordered = "unordered",
  todo = "todo",
}

---@class Mode
local Mode = {
  normal = "n",
  insert = "i",
}

local api = vim.api

-- Default options
local defaults = {
  mappings = {
    toggle_checkbox = "<M-x>",
  },
}

-- Merges user options with default options.
---@param opts table|nil User-provided options
---@return table # Merged options
local function merge_opts(opts)
  return vim.tbl_deep_extend("force", {}, defaults, opts or {})
end

-- Parses a bullet line and returns a table containing the parsed contents.
-- If the line is not a bullet line, a nil value is returned.
---@param line string The current line in the buffer
---@return table|nil # A table containing bullet type, bullet, and content or nil if not a bullet line
local function parse_bullet_line(line)
  local type, bullet, content

  -- Ordered list (numbered)
  if line:match("^%s*%d+[%.%)]%s+") then
    type = BulletType.number
    bullet, content = line:match("^%s*(%d+)[%.%)]%s+(.*)")
  -- Todo list
  elseif line:match("^%s*[*+%-] %[[ xX-]%]%s+") then
    type = BulletType.todo
    bullet, content = line:match("^%s*([*+%-]) %[[ xX-]%]%s+(.*)")
    -- Normalize to unchecked box
    bullet = bullet .. " [ ]"
  -- Unordered list
  elseif line:match("^%s*[*+%-]%s+") then
    type = BulletType.unordered
    bullet, content = line:match("^%s*([*+%-])%s+(.*)")
  end

  if type then
    return {
      type = type,
      bullet = bullet,
      content = content or "",
    }
  end

  return nil
end

--- Renumber an ordered list starting from a specific line and number.
--- @param start_line number The line number (0-indexed) to start renumbering from
--- @param start_num number The number to start renumbering from
local function renumber_list(start_line, start_num)
  local buf = 0
  local lines = api.nvim_buf_get_lines(buf, start_line, -1, false)

  local expected = start_num

  for i, line in ipairs(lines) do
    local indent, num, content = line:match("^(%s*)(%d+)[%.%)]%s+(.*)")
    if not num then
      -- We consider an empty line as the end of the list
      if line == "" then
        break
      end
    else
      -- Replace with corrected number
      lines[i] = string.format("%s%d. %s", indent, expected, content or "")
      expected = expected + 1
    end
  end

  -- Write back the changed lines
  api.nvim_buf_set_lines(buf, start_line, start_line + #lines, false, lines)
end

-- Returns a new bullet line based on the current bullet data in the specified mode.
---@param bullet_data table The bullet data containing bullet type, bullet, and content
---@param mode string The mode in which the new bullet is being inserted. If not specified, defaults to "insert"
---@return string # A new bullet line formatted according to the bullet type
local function insert_new_bullet(bullet_data, mode)
  if mode ~= Mode.normal and mode ~= Mode.insert then
    mode = Mode.insert
  end

  local clear_line = "cc"

  if mode == Mode.insert then
    clear_line = "<Esc>" .. clear_line
  end

  if bullet_data.content == "" then
    return clear_line
  end

  if bullet_data.type == BulletType.number then
    local next_bullet = tonumber(bullet_data.bullet) + 1
    local row, _ = unpack(api.nvim_win_get_cursor(0))

    vim.schedule(function()
      renumber_list(row, next_bullet)
    end)

    if mode == Mode.insert then
      return string.format("\n%d. ", next_bullet)
    else
      return string.format("o%d. ", next_bullet)
    end
  end

  if mode == Mode.insert then
    return string.format("\n%s ", bullet_data.bullet)
  else
    return string.format("o%s ", bullet_data.bullet)
  end
end

-- Handles newline insertion.
-- If the current line is a bullet line, it inserts a new bullet line.
-- Otherwise, it falls back to the default newline behavior.
---@return string # The string to be executed for the newline action
local function on_insert()
  local mode = vim.fn.mode()

  local line = api.nvim_get_current_line()
  local bullet_data = parse_bullet_line(line)

  local newline = "o"

  if mode == Mode.insert then
    newline = "<CR>"
  end

  -- If not a bullet line, just fallback to default newline behavior
  if not bullet_data then
    return newline
  end

  return insert_new_bullet(bullet_data, mode)
end

-- Toggles checkboxes in the specified line range.
-- If any checkbox is unchecked, all will be checked.
-- If all checkboxes are checked, all will be unchecked.
---@param start_line number The starting line number (0-indexed) of the range
---@param end_line number The ending line number (0-indexed, exclusive) of the range
local function toggle_checkbox(start_line, end_line)
  local lines = api.nvim_buf_get_lines(0, start_line, end_line, false)
  local has_unchecked = false

  -- Check if there's at least one unchecked box
  for _, line in ipairs(lines) do
    if line:match("^%s*[*+%-] %[ %]%s+") then
      has_unchecked = true
      break
    end
  end

  -- Toggle checkboxes in the selected range
  for i = start_line, end_line - 1 do
    local content = api.nvim_buf_get_lines(0, i, i + 1, false)[1]
    if has_unchecked then
      content = content:gsub("^(%s*[*+%-]) %[ %] ", "%1 [x] ", 1)
    else
      content = content:gsub("^(%s*[*+%-]) %[[xX]%] ", "%1 [ ] ", 1)
    end
    api.nvim_buf_set_lines(0, i, i + 1, false, { content })
  end
end

function M.setup(opts)
  opts = merge_opts(opts)

  -- Command to toggle checkboxes in the selected range
  api.nvim_create_user_command("ToggleCheckbox", function(args)
    toggle_checkbox(args.line1 - 1, args.line2)
  end, { range = true, desc = "Toggle Checkbox" })

  api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()
      vim.keymap.set("i", "<CR>", on_insert, { expr = true, buffer = true })
      vim.keymap.set("n", "o", on_insert, { expr = true, buffer = true })

      -- Toggle checkbox mapping
      vim.keymap.set({ "n", "x" }, opts.mappings.toggle_checkbox, function()
        local start_line, end_line

        -- Normal mode: toggle current line
        if vim.fn.mode() == Mode.normal then
          start_line = vim.fn.line(".") - 1
          end_line = start_line + 1
        -- Visual mode: toggle selected lines
        else
          start_line = vim.fn.line("v") - 1
          end_line = vim.fn.line(".")
        end

        -- Ensure start_line is less than end_line
        if start_line >= end_line then
          start_line, end_line = end_line - 1, start_line + 1
        end

        toggle_checkbox(start_line, end_line)
      end, { buffer = true, desc = "Toggle Checkbox" })
    end,
  })
end

return M
