-- Terminal Mappings
vim.keymap.set("i", "JJ", "<esc>", {silent = true})
vim.keymap.set("n", "<c-\\>", function() Snacks.terminal() end, { desc = "Terminal (Terminal (cwd))" })

