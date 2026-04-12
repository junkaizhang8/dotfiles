-- Based on LazyVim's root detection logic:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/root.lua

local M = {}

M.spec = {
  "lsp",
  { ".git", "lua" },
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
    return nil
  end

  local best = nil

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    local root = M.realpath(client.root_dir)

    if root and bufpath:find(root, 1, true) == 1 then
      if not best or #root > #best then
        best = root
      end
    end
  end

  return best
end

function M.detectors.pattern(buf, patterns)
  patterns = type(patterns) == "table" and patterns or { patterns }
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

  return found and vim.fs.dirname(found) or nil
end

function M.detectors.cwd()
  return vim.uv.cwd()
end

function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  end

  if type(spec) == "function" then
    return spec
  end

  return function(buf)
    return M.detectors.pattern(buf, spec)
  end
end

function M.detect(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  local ret = {}

  for _, spec in ipairs(M.spec) do
    local path = M.resolve(spec)(buf)
    local rp = M.realpath(path)

    if rp then
      ret[#ret + 1] = {
        spec = spec,
        path = rp,
      }

      if opts.all == false then
        break
      end
    end
  end

  return ret
end

local cache = {}

function M.get(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  if cache[buf] then
    return cache[buf]
  end

  local roots = M.detect({ buf = buf, all = false })

  local root = roots[1] and roots[1].path or vim.uv.cwd()

  cache[buf] = root
  return root
end

M.lspconfig = {}

function M.lspconfig.root_pattern(...)
  local patterns = vim.iter(...):flatten():totable()

  return function(startpath)
    startpath = startpath or vim.api.nvim_buf_get_name(0)

    if not startpath or startpath == "" then
      return nil
    end

    -- Normalize and strip any subpath (if required by your logic)
    startpath = M.realpath(startpath) or startpath -- Resolve symlinks, etc.

    for _, pattern in ipairs(patterns) do
      local match = vim.fs.find(pattern, { path = startpath, upward = true })[1]
      if match then
        local real = vim.uv.fs_realpath(match)
        local real_dir = vim.fs.dirname(real or match)
        return real_dir or match -- fallback to original if realpath fails
      end
    end
    return nil -- No match found
  end
end

function M.setup()
  vim.api.nvim_create_autocmd({
    "BufEnter",
    "BufWritePost",
    "DirChanged",
    "LspAttach",
  }, {
    callback = function(args)
      cache[args.buf] = nil
    end,
  })
end

return M
