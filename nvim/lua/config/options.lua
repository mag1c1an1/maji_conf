vim.g.autoformat = false
vim.opt.relativenumber = true

local uname = vim.uv.os_uname().release:lower()
local is_wayland = (vim.env.WAYLAND_DISPLAY ~= nil and vim.env.WAYLAND_DISPLAY ~= "")
  or (vim.env.XDG_SESSION_TYPE or ""):lower() == "wayland"

local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

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
elseif is_wayland then
  -- Wayland
  if executable("wl-copy") and executable("wl-paste") then
    vim.g.clipboard = "wl-copy"
  elseif executable("waycopy") and executable("waypaste") then
    vim.g.clipboard = "wayclip"
  else
    vim.g.clipboard = "unnamedplus"
  end
else
  -- Linux / SSH / remote terminal
  vim.g.clipboard = "unnamedplus"
end
