-- Based on LazyVim's root detection logic:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/root.lua

local M = {}

M.spec = {
  "lsp",
  { "lua", ".git" },
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
  return vim.fs.root(buf, patterns)
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

---Find the root directory for a buffer with the given markers(s).
---
---Intended to be used for configuring the `root_dir` configuration for LSP servers.
---@param bufnr integer
---@param marker string|(string|fun(name: string, path: string):boolean|string[])[]|fun(name: string, path: string):boolean
---@return string?
function M.lspconfig.root_pattern(bufnr, marker)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  return (function(startpath)
    return vim.fs.root(startpath, marker) or vim.uv.cwd()
  end)(fname)
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
