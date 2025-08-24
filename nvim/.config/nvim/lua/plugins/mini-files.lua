-- Configuration is from MariaSolOs's dotfiles:
-- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/plugins/minifiles.lua

local api = vim.api

-- Maps a key to split the window and open the file in the new split.
---@param buf_id number Buffer ID of the mini.files buffer
---@param lhs string Left-hand side of the mapping
---@param direction string Direction to split the window
local function map_split(buf_id, lhs, direction)
  local minifiles = require("mini.files")

  local function rhs()
    local window = minifiles.get_explorer_state().target_window

    -- Noop if the explorer isn't open or the cursor is on a directory
    if window == nil or minifiles.get_fs_entry().fs_type == "directory" then
      return
    end

    -- Make a new window and set it as target
    local new_target_window
    api.nvim_win_call(window, function()
      vim.cmd(direction .. " split")
      new_target_window = api.nvim_get_current_win()
    end)

    minifiles.set_target_window(new_target_window)

    -- Go in and close the explorer
    minifiles.go_in({ close_on_file = true })
  end

  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = "Split " .. string.sub(direction, 12) })
end

return {
  {
    "echasnovski/mini.files",
    lazy = "VeryLazy",
    keys = {
      {
        "<leader>e",
        function()
          local bufname = api.nvim_buf_get_name(0)
          local path = vim.fn.fnamemodify(bufname, ":p")

          -- Noop if the buffer isn't valid
          if path and vim.uv.fs_stat(path) then
            require("mini.files").open(bufname, false)
          end
        end,
        desc = "File Explorer",
      },
      {
        "<leader>E",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "File Explorer (cwd)",
      },
    },
    opts = {
      mappings = {
        show_help = "?",
        go_in_plus = "<CR>",
        go_out_plus = "<Tab>",
        synchronize = "s",
        reset = ",",
        reveal_cwd = ".",
      },
      content = {
        -- Ignore .DS_Store files
        filter = function(entry)
          return entry.fs_type ~= "file" or entry.name ~= ".DS_Store"
        end,
        sort = function(entries)
          local function compare_alphanumerically(e1, e2)
            -- Put directories first
            if e1.is_dir and not e2.is_dir then
              return true
            end
            if not e1.is_dir and e2.is_dir then
              return false
            end
            -- Order numerically based on digits if the text before them is equal
            if e1.pre_digits == e2.pre_digits and e1.digits ~= nil and e2.digits ~= nil then
              return e1.digits < e2.digits
            end
            -- Otherwise order alphabetically ignoring case
            return e1.lower_name < e2.lower_name
          end

          local sorted = vim.tbl_map(function(entry)
            local pre_digits, digits = entry.name:match("^(%D*)(%d+)")
            if digits ~= nil then
              digits = tonumber(digits)
            end

            return {
              fs_type = entry.fs_type,
              name = entry.name,
              path = entry.path,
              lower_name = entry.name:lower(),
              is_dir = entry.fs_type == "directory",
              pre_digits = pre_digits,
              digits = digits,
            }
          end, entries)
          table.sort(sorted, compare_alphanumerically)
          -- Keep only the necessary fields
          return vim.tbl_map(function(x)
            return { name = x.name, fs_type = x.fs_type, path = x.path }
          end, sorted)
        end,
      },
      windows = {
        preview = true,
        width_nofocus = 30,
        width_focus = 30,
        width_preview = 80,
      },
      -- Move stuff to the minifiles trash instead of it being gone forever
      options = { permanent_delete = false },
    },
    config = function(_, opts)
      local minifiles = require("mini.files")

      minifiles.setup(opts)

      -- Keep track of when the explorer is open to disable format on save
      local minifiles_explorer_group = api.nvim_create_augroup("junkaizhang8/minifiles_explorer", { clear = true })
      api.nvim_create_autocmd("User", {
        group = minifiles_explorer_group,
        pattern = "MiniFilesExplorerOpen",
        callback = function()
          vim.g.minifiles_active = true
        end,
      })
      api.nvim_create_autocmd("User", {
        group = minifiles_explorer_group,
        pattern = "MiniFilesExplorerClose",
        callback = function()
          vim.g.minifiles_active = false
        end,
      })

      -- HACK: Notify LSPs that a file got renamed or moved.
      -- Borrowed this from snacks.nvim.
      api.nvim_create_autocmd("User", {
        desc = "Notify LSPs that a file was renamed",
        pattern = { "MiniFilesActionRename", "MiniFilesActionMove" },
        callback = function(args)
          local changes = {
            files = {
              {
                oldUri = vim.uri_from_fname(args.data.from),
                newUri = vim.uri_from_fname(args.data.to),
              },
            },
          }
          local will_rename_method, did_rename_method =
            vim.lsp.protocol.Methods.workspace_willRenameFiles, vim.lsp.protocol.Methods.workspace_didRenameFiles
          local clients = vim.lsp.get_clients()
          for _, client in ipairs(clients) do
            if client:supports_method(will_rename_method) then
              local res = client:request_sync(will_rename_method, changes, 1000, 0)
              if res and res.result then
                vim.lsp.util.apply_workspace_edit(res.result, client.offset_encoding)
              end
            end
          end

          for _, client in ipairs(clients) do
            if client:supports_method(did_rename_method) then
              client:notify(did_rename_method, changes)
            end
          end
        end,
      })

      api.nvim_create_autocmd("User", {
        desc = "Add minifiles split keymaps",
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          map_split(buf_id, "-", "belowright horizontal")
          map_split(buf_id, "\\", "belowright vertical")
        end,
      })
    end,

    -- Custom user command for emptying the mini.files trash
    api.nvim_create_user_command("MiniFilesEmptyTrash", function()
      local trash_dir = vim.fn.stdpath("data") .. "/mini.files/trash"

      -- Check if trash exists
      if vim.fn.isdirectory(trash_dir) == 0 then
        vim.notify("mini.files trash does not exist", vim.log.levels.INFO)
        return
      end

      local choice = vim.fn.confirm("Are you sure you want to empty the mini.files trash?", "&Yes\n&No", 2)

      -- If the user didn't choose "Yes", abort
      if choice ~= 1 then
        return
      end

      -- Remove all contents inside the trash directory
      local ok, err = pcall(function()
        for _, entry in ipairs(vim.fn.readdir(trash_dir)) do
          local entry_path = trash_dir .. "/" .. entry
          vim.fn.delete(entry_path, "rf")
        end
      end)

      if ok then
        vim.notify("Emptied mini.files trash", vim.log.levels.INFO)
      else
        vim.notify("Error emptying mini.files trash: " .. err, vim.log.levels.ERROR)
      end
    end, { desc = "Empty mini.files trash" }),
  },
}
