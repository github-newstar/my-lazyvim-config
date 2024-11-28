-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- 文件路径：lua/clang_format.lua
local config = {
  BasedOnStyle = "Google",
  IndentWidth = 4,
  TabWidth = 4,
  UseTab = "Never",
}

-- 生成 clang-format 配置文件
local config_path = vim.fn.stdpath("config") .. "/.clang-format"
local file = io.open(config_path, "w")

if file then
  for k, v in pairs(config) do
    file:write(string.format("%s: %s\n", k, v))
  end
  file:close()
end
