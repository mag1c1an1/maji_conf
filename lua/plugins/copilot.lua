return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  opts = {
    suggestion = { enabled = true, auto_trigger = true },
    panel = { enabled = true },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
}
