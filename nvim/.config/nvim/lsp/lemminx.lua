-- Install the binary from https://github.com/redhat-developer/vscode-xml/releases

local utils = require("utils.root")

local root_markers = { ".git" }

---@type vim.lsp.Config
return {
  cmd = { "lemminx" },
  filetypes = { "xml", "xsd", "xsl", "xslt", "xvg" },
  root_dir = function(bufnr, on_dir)
    on_dir(utils.lspconfig.root_pattern(bufnr, root_markers))
  end,
}
