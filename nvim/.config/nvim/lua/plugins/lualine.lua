return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- Set an empty statusline until lualine loads
      vim.o.statusline = " "
    else
      -- Hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#C3CCDC",
      bg = "#112638",
      secondary_bg = "#224C70",
      inactive_bg = "#2C3043",
    }

    local custom_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.secondary_bg, fg = colors.blue },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.secondary_bg, fg = colors.green },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.secondary_bg, fg = colors.violet },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.secondary_bg, fg = colors.yellow },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.secondary_bg, fg = colors.red },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.bg, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.fg },
        c = { bg = colors.inactive_bg, fg = colors.fg },
      },
    }

    local dashboard_filetypes = {
      "alpha",
      "dashboard",
      "ministarter",
      "snacks_dashboard",
    }

    -- Get the project root
    local function get_root()
      local root = require("utils.root").get()
      if root then
        return root
      end
      return vim.uv.cwd()
    end

    local function root_dir()
      local show_cond = {
        cwd = false,
        subdirectory = true,
        parent = true,
        other = true,
      }

      local function get()
        local cwd = vim.uv.cwd()
        local root = get_root()
        local name = vim.fs.basename(root)

        if cwd == nil or root == nil then
          return nil
        elseif root == cwd then
          return show_cond.cwd and name
        elseif root:find(cwd, 1, true) == 1 then
          return show_cond.subdirectory and name
        elseif cwd:find(root, 1, true) == 1 then
          return show_cond.parent and name
        else
          return show_cond.other and name
        end
      end

      return {
        function()
          local name = get()
          return name and ("󱉭 " .. name) or ""
        end,
        cond = function()
          return get() ~= nil
        end,
        color = function()
          return "Special"
        end,
      }
    end

    local function apply_hl(group, text)
      return "%#" .. group .. "#" .. text .. "%*"
    end

    local function pretty_path()
      -- Max number of directories to show
      local max_directories = 2

      return {
        function()
          -- Get the full path of the current file
          local path = vim.fn.expand("%:p")
          if path == "" then
            return ""
          end

          -- Relative path
          local base = vim.fn.fnamemodify(path, ":~:.")
          -- Split the path into parts
          local parts = vim.split(base, "[/\\]")

          -- Truncate if too long
          if #parts > max_directories then
            parts = { parts[1], "…", unpack(parts, #parts - max_directories + 1, #parts) }
          end

          -- Apply modified / readonly
          local filename = parts[#parts]
          if vim.bo.modified then
            filename = apply_hl("LualineFilenameModified", filename)
          else
            filename = apply_hl("LualineFilename", filename)
          end
          if vim.bo.readonly then
            filename = filename .. " "
          end
          parts[#parts] = filename

          return table.concat(parts, "/")
        end,
        padding = { left = 0, right = 1 },
      }
    end

    local icons = require("config.icons")

    vim.o.laststatus = vim.g.lualine_laststatus

    local status_colors = {
      ok = "Special",
      error = "DiagnosticError",
      pending = "DiagnosticWarn",
    }

    local function copilot_status()
      local clients = package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
      if #clients > 0 then
        local status = require("copilot.status").data.status
        return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
      end
    end

    local opts = {
      options = {
        theme = custom_theme,
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = dashboard_filetypes },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "branch", icon = { "" } } },
        lualine_c = {
          root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.error .. " ",
              warn = icons.diagnostics.warn .. " ",
              info = icons.diagnostics.info .. " ",
              hint = icons.diagnostics.hint .. " ",
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          pretty_path(),
        },
        lualine_x = {
          Snacks.profiler.status(),
          {
            function()
              return icons.kinds.Copilot
            end,
            cond = function()
              return copilot_status() ~= nil
            end,
            color = function()
              return { fg = Snacks.util.color(status_colors[copilot_status()]) or colors.ok }
            end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          -- stylua: ignore
          {
            function() return " " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function()
              return { fg = Snacks.util.color("Special") }
            end,
          },
          {
            "diff",
            symbols = {
              added = icons.git.added .. " ",
              modified = icons.git.modified .. " ",
              removed = icons.git.removed .. " ",
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            function()
              return require("arrow.statusline").text_for_statusline_with_icons() or ""
            end,
            cond = function()
              return require("arrow.statusline").is_on_arrow_file() ~= nil
            end,
            color = { fg = "#FF9E65" },
          },
        },
        lualine_y = {
          { "progress", padding = { left = 1, right = 1 } },
        },
        lualine_z = {
          { "location", padding = { left = 1, right = 1 } },
        },
      },
    }

    return opts
  end,

  config = function(_, opts)
    local lualine = require("lualine")
    lualine.setup(opts)

    vim.api.nvim_set_hl(0, "LualineFilename", { fg = "#CBE0F0", bold = true })
    vim.api.nvim_set_hl(0, "LualineFilenameModified", { fg = "#FF9E65", bold = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermLeave", "BufWinEnter", "ColorScheme" }, {
      callback = function()
        local dashboard_filetypes = {
          alpha = true,
          dashboard = true,
          snacks_dashboard = true,
        }

        local function is_dashboard()
          return dashboard_filetypes[vim.bo.filetype] ~= nil
        end

        local function get_lualine_colors()
          local theme = lualine.get_config().options.theme

          if type(theme) == "string" then
            theme = require("lualine.themes." .. theme)
          end

          return theme.normal.c
        end

        local function set_statusline_highlight()
          local colors = get_lualine_colors()
          vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bg, fg = colors.fg })
        end

        local function hide_statusline_highlight()
          vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", fg = "NONE" })
        end

        local function update_lualine_statusline()
          if is_dashboard() then
            -- Hide lualine when entering dashboard
            hide_statusline_highlight()
          else
            -- Call this to fix weird coloring artifacts in the status line
            set_statusline_highlight()
          end
        end

        vim.schedule(update_lualine_statusline)
      end,
    })
  end,
}
