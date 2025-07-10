return {
  "max397574/better-escape.nvim",
  lazy = true,
  event = "VimEnter",
  config = function()
    require("better_escape").setup()
  end,
}
