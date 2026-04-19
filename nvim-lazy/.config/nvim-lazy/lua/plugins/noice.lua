return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      override = {
        -- override the default lsp markdown formatter with Noice
        ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
        -- override the lsp markdown formatter with Noice
        ["vim.lsp.util.stylize_markdown"] = false,
        -- override cmp documentation with Noice (needs the other options to work)
        ["cmp.entry.get_documentation"] = false,
      },
      documentation = {
        opts = {
          lang = "markdown",
          replace = true,
          render = "plaintext",
          format = { "{message}" },
          win_options = { concealcursor = "n", conceallevel = 3 },
          size = { max_height = 15 },
        },
      },
      signature = {
        opts = { size = { max_height = 15 } },
      },
    },
    presets = {
      lsp_doc_border = true,
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = {
            "shell_out",
            "shell_err",
          },
        },
        view = "notify",
      },
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
  },
}
