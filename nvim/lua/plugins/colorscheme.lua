-- Configure LazyVim to load gruvbox
return {
  { "olimorris/onedarkpro.nvim", priority = 1000 },
  {"rose-pine/neovim", name = "rose-pine", lazy=true,},
  {
    "LazyVim/LazyVim",
    opts = {
        colorscheme = "tokyonight-night",
      -- colorscheme = "rose-pine-dawn",
    },
  },
}
