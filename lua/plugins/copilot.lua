return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  opts = {
    suggestion = { enabled = true, auto_trigger = true, keymap = {
      accept = "<C-l>",
    } },
    panel = { enabled = true },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
}
