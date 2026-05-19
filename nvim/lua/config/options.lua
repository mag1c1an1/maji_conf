vim.g.autoformat = false
vim.opt.relativenumber = true

local uname = vim.uv.os_uname().release:lower()

if uname:find("microsoft") or uname:find("wsl") then
  -- WSL
  vim.g.clipboard = "osc52"
  -- vim.g.clipboard = {
  --   name = "win32yank",
  --   copy = {
  --     ["+"] = "win32yank.exe -i --crlf",
  --     ["*"] = "win32yank.exe -i --crlf",
  --   },
  --   paste = {
  --     ["+"] = "win32yank.exe -o --lf",
  --     ["*"] = "win32yank.exe -o --lf",
  --   },
  --   cache_enabled = 0,
  -- }

elseif uname:find("orbstack") then
  -- macOS OrbStack
  vim.g.clipboard = "pbcopy"

elseif vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local osc52 = require("vim.ui.clipboard.osc52")

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = function()
        return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
      end,
      ["*"] = function()
        return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
      end,
    },
  }
else
  -- Linux / SSH / remote terminal
  vim.g.clipboard = "unnamedplus"
end
