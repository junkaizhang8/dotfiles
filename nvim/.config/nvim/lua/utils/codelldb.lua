local M = {}

local extension_path = vim.fn.expand("$XDG_DATA_HOME/codelldb/extension/")
local lib_ext = io.popen("uname"):read("*l") == "Linux" and "so" or "dylib"

M.codelldb = extension_path .. "adapter/codelldb"
M.liblldb = extension_path .. "lldb/lib/liblldb." .. lib_ext

function M.get_adapter()
  return {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
      command = M.codelldb,
      args = { "--liblldb", M.liblldb, "--port", "${port}" },
    },
  }
end

return M
