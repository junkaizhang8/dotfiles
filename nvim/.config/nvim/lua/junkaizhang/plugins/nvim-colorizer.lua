return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {},
  config = function()
    require("colorizer").setup({
      user_default_options = {
        RGB = true,
        RGBA = true,
        RRGGBB = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
      },
    })
  end,
}
