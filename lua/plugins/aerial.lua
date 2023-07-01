return {
  "stevearc/aerial.nvim",
  lazy = true,
  opts = {},
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Aerial",
  keys = { { "<leader>o", "<cmd>AerialToggle<cr>", desc = "Outline" } },
  config = true,
}
