-- Install with: npm i -g @stylelint/language-server

local utils = require("utils.root")

local root_markers = {
  {
    "package-lock.json",
    "yarn.lock",
    "pnpm-lock.yaml",
    "bun.lockb",
    "bun.lock",
  },
  ".git",
}

---@type vim.lsp.Config
return {
  cmd = { "stylelint-language-server", "--stdio" },
  filetypes = { "astro", "css", "html", "less", "scss", "vue" },
  root_dir = function(bufnr, on_dir)
    -- Exclude Deno projects
    if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
      return
    end

    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
  on_attach = function(client, bufnr)
    vim.keymap.set("n", "<leader>cF", function()
      client:request("workspace/executeCommand", {
        command = "stylelint.applyAutoFix",
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = vim.lsp.util.buf_versions[bufnr],
          },
        },
      }, nil, bufnr)
    end, { desc = "Fix All Stylelint Errors", buffer = bufnr })
  end,
  settings = {
    stylelint = {
      validate = { "css", "postcss" },
      snippet = { "css", "postcss" },
    },
  },
}
