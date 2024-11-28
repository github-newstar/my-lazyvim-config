-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

if vim.g.neovide then
  vim.g.neovide_transparency = 1
  vim.g.transparency = 1
  vim.g.neovide_refresh_rate = 180
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_no_idle = true
  vim.g.neovide_borderless = true
end

-- 定义自动命令组
vim.api.nvim_create_augroup("FileTemplates", { clear = true })

-- 当新建 .c 文件时插入模板
vim.api.nvim_create_autocmd("BufNewFile", {
  group = "FileTemplates",
  pattern = "*.c",
  callback = function()
    -- 读取模板内容
    local template = vim.fn.readfile("/home/jo/Templates/template.c")
    -- 替换占位符
    local file_name = vim.fn.expand("%:t")
    local date = os.date("%Y-%m-%d")
    for i, line in ipairs(template) do
      template[i] = line:gsub("%%FILE_NAME%%", file_name):gsub("%%DATE%%", date)
    end
    -- 插入模板到缓冲区
    vim.api.nvim_buf_set_lines(0, 0, 0, false, template)
  end,
}) -- 针对 Makefile 的模板
vim.api.nvim_create_autocmd("BufNewFile", {
  group = "FileTemplates",
  pattern = "makefile",
  callback = function()
    -- 读取模板内容
    local template = vim.fn.readfile("/home/jo/Templates/makefile")
    local project_name = vim.fn.expand("%:p:h:t") -- 当前目录名作为项目名称
    -- 替换占位符
    for i, line in ipairs(template) do
      template[i] = line:gsub("%%PROJECT_NAME%%", project_name)
    end
    -- 插入模板到缓冲区
    vim.api.nvim_buf_set_lines(0, 0, 0, false, template)
  end,
})
vim.cmd("packadd termdebug")
vim.o.foldmethod = "syntax" -- 使用语法折叠
vim.o.foldenable = true -- 启用折叠

-- 自动格式化保存的设置
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
-- 定义一个 autocmd，在打开 .c 或 .cpp 文件时执行检查
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.c", "*.cpp" },
  callback = function()
    -- 获取当前文件的目录
    local file_dir = vim.fn.expand("%:p:h")
    local clang_format_path = file_dir .. "/.clang-format"

    -- 检查 .clang-format 文件是否存在
    if vim.fn.filereadable(clang_format_path) == 0 then
      -- 定义默认的 .clang-format 内容
      local config_content = [[
BasedOnStyle: Google
IndentWidth: 4
TabWidth: 4
UseTab: Never
]]
      -- 创建并写入 .clang-format 文件
      local file = io.open(clang_format_path, "w")
      if file then
        file:write(config_content)
        file:close()
        print(".clang-format 文件已创建在 " .. clang_format_path)
      else
        print("无法创建 .clang-format 文件")
      end
    end
  end,
})
-- 自定义函数：将当前行滚动到屏幕顶部以下 20 行的位置
local function scroll_to_top_plus_20()
  local current_line = vim.fn.line(".") -- 获取当前行号
  local target_line = current_line - 20 -- 计算目标行位置，使其位于屏幕顶部下方 20 行

  if target_line < 1 then
    target_line = 1 -- 确保目标行在合法范围内
  end

  vim.fn.winrestview({ topline = target_line }) -- 滚动窗口，使当前行位于顶部以下 20 行
end

-- 将自定义函数映射到 'zt' 键
vim.keymap.set("n", "zt", scroll_to_top_plus_20, { noremap = true, silent = true })
