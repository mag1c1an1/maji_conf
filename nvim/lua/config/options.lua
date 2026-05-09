vim.g.autoformat = false
vim.opt.relativenumber = true

local uname = vim.uv.os_uname().release:lower()

if uname:find("microsoft") or uname:find("wsl") then
  -- WSL
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }

elseif uname:find("orbstack") then
  -- macOS OrbStack
  vim.g.clipboard = "pbcopy"

else
  -- Linux / SSH / remote terminal
  vim.g.clipboard = "osc52"
end
