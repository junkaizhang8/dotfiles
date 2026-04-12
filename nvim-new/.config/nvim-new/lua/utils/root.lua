-- Based on LazyVim's root detection logic:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/root.lua

local M = {}

M.spec = {
  "lsp",
  ".git",
  "cwd",
}

function M.bufpath(buf)
  local name = vim.api.nvim_buf_get_name(assert(buf))
  if name == "" then
    return nil
  end
  return vim.fs.dirname(name)
end

function M.realpath(path)
  if not path or path == "" then
    return nil
  end
  return vim.uv.fs_realpath(path) or path
end

M.detectors = {}

function M.detectors.lsp(buf)
  local bufpath = M.bufpath(buf)
  if not bufpath then
    return {}
  end

  local roots = {}

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    -- Workspace folders (multi-root LSPs)
    local ws = client.config and client.config.workspace_folders
    if ws then
      for _, folder in ipairs(ws) do
        roots[#roots + 1] = vim.uri_to_fname(folder.uri)
      end
    end

    -- Root_dir (single-root LSPs)
    if client.root_dir then
      roots[#roots + 1] = client.root_dir
    end
  end

  -- Filter valid roots for this buffer
  return vim.tbl_filter(function(path)
    path = M.realpath(path)
    if path and bufpath:find(path, 1, true) == 1 then
      return true
    end
    return false
  end, roots)
end

function M.detectors.pattern(buf, patterns)
  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" then
    path = vim.uv.cwd() or ""
  end

  local found = vim.fs.find(function(name)
    for _, p in ipairs(patterns) do
      if name == p then
        return true
      end
    end
    return false
  end, {
    path = path,
    upward = true,
  })[1]

  return found and { vim.fs.dirname(found) } or {}
end

function M.detectors.cwd()
  return { vim.uv.cwd() }
end

function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  end

  if type(spec) == "function" then
    return spec
  end

  return function(buf)
    return M.detectors.pattern(buf, { spec })
  end
end

function M.detect(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  local ret = {}

  for _, spec in ipairs(M.spec) do
    local paths = M.resolve(spec)(buf)
    paths = type(paths) == "table" and paths or { paths }

    local roots = {}

    for _, p in ipairs(paths) do
      local rp = M.realpath(p)
      if rp and not vim.tbl_contains(roots, rp) then
        roots[#roots + 1] = rp
      end
    end

    table.sort(roots, function(a, b)
      return #a > #b
    end)

    if #roots > 0 then
      ret[#ret + 1] = {
        spec = spec,
        paths = roots,
      }

      if opts.all == false then
        break
      end
    end
  end

  return ret
end

M.cache = {}

function M.get(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  if M.cache[buf] then
    return M.cache[buf]
  end

  local roots = M.detect({ buf = buf, all = false })

  local root = roots[1] and roots[1].paths[1] or vim.uv.cwd()

  M.cache[buf] = root
  return root
end

function M.setup()
  vim.api.nvim_create_autocmd({
    "BufEnter",
    "BufWritePost",
    "DirChanged",
    "LspAttach",
  }, {
    callback = function(args)
      M.cache[args.buf] = nil
    end,
  })
end

return M
