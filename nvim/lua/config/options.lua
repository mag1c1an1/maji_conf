vim.g.autoformat = false
vim.opt.relativenumber = true

-- 1. 执行 'uname -a' 并捕获输出
local uname_output = vim.fn.trim(vim.fn.system('uname -a'))

-- 2. 使用 string.find() 检查输出是否包含 "orbstack"
--    string.find() 如果找到匹配项，会返回一个非 nil 值 (索引)
if string.find(uname_output, "orbstack") then
  vim.g.clipboard = "pbcopy"
else
  vim.g.clipboard = "osc52"
end
