local M = {}

M.dap = {
  Stopped = { "󰁕", "DiagnosticWarn", "DapStoppedLine" },
  Breakpoint = "",
  BreakpointCondition = "",
  BreakpointRejected = { "", "DiagnosticError" },
  LogPoint = "",
}

M.folding = {
  open = "",
  close = "",
}

M.diagnostics = {
  error = "",
  warn = "",
  hint = "",
  info = "",
}

M.git = {
  added = "",
  modified = "",
  removed = "",
}

M.kinds = {
  Array = "",
  Boolean = "󰨙",
  Class = "",
  Codeium = "󰘦",
  Color = "",
  Control = "",
  Collapsed = "",
  Constant = "󰏿",
  Constructor = "",
  Copilot = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "󰊕",
  Interface = "",
  Key = "",
  Keyword = "",
  Method = "󰊕",
  Module = "",
  Namespace = "󰦮",
  Null = "",
  Number = "󰎠",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "󱄽",
  String = "",
  Struct = "󰆼",
  Supermaven = "",
  TabNine = "󰏚",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "󰀫",
}

-- Miscellaneous icons that don't fit into the above categories
M.misc = {
  bug = "",
  dashed_bar = "┊",
  vertical_bar = "│",
  ellipsis = "…",
  git = "",
  gh = "",
  palette = "󰏘",
  robot = "󰚩",
  search = "",
  terminal = "",
  toolbox = "󰦬",
}

return M
