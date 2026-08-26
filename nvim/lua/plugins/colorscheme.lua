-- Configure LazyVim to load gruvbox
return {
  { "olimorris/onedarkpro.nvim", priority = 1000 },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "latte", -- 浅色: latte,深色: mocha / macchiato / frappe
    },
  },
  {"rose-pine/neovim", name = "rose-pine", lazy=true,},
  {
    "LazyVim/LazyVim",
    opts = {
        colorscheme = "catppuccin",
    },
  },
}
