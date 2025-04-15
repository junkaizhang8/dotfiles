return {
  "windwp/nvim-ts-autotag",
  config = function()
    local autotag = require("nvim-ts-autotag")

    autotag.setup({
      opts = {
        -- Defaults
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    })
  end,
}

