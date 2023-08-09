return {
  "zbirenbaum/copilot.lua",
  enabled = false,
  cmd = "Copilot",
  build = ":Copilot auth",
  enabled = false,
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
