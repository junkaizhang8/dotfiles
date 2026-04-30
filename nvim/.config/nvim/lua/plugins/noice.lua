return {
  "folke/noice.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<C-f>",
      function()
        if not require("noice.lsp").scroll(4) then
          return "<C-f>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll Forward",
      mode = { "i", "n", "s" },
    },
    {
      "<C-b>",
      function()
        if not require("noice.lsp").scroll(-4) then
          return "<C-b>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll Backward",
      mode = { "i", "n", "s" },
    },
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
        ["vim.lsp.util.stylize_markdown"] = false,
      },
      documentation = {
        opts = {
          lang = "markdown",
          replace = true,
          render = "plaintext",
          format = { "{message}" },
          win_options = { concealcursor = "n", conceallevel = 3 },
        },
      },
    },
    routes = {
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
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
      inc_rename = true,
    },
  },
  config = function(_, opts)
    -- HACK: noice shows messages from before it was enabled,
    -- but this is not ideal when Lazy is installing plugins,
    -- so clear the messages in this case.
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
  end,
}
