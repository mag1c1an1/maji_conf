-- Terminal Mappings
vim.keymap.set("n", "<c-\\>", function() Snacks.terminal() end, { desc = "Terminal (Terminal (cwd))" })
vim.keymap.set("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
