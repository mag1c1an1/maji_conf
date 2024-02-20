-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local lazyterm = function()
  Util.terminal.open(nil, { cwd = Util.root.get() })
end

map("t", "<c-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("n", "<c-\\>", lazyterm, { desc = "Terminal (root dir)" })
map(
  "n",
  "<leader>ci",
  "<cmd>lua vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())<cr>",
  { desc = "toggle inlay hints" }
)
