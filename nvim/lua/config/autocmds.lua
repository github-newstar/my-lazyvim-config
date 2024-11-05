-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

if vim.g.neovide then
  vim.g.neovide_transparency = 0.8
  vim.g.transparency = 0.6
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
        local template = vim.fn.readfile('/home/jo/Templates/template.c')
        -- 替换占位符
        local file_name = vim.fn.expand("%:t")
        local date = os.date("%Y-%m-%d")
        for i, line in ipairs(template) do
            template[i] = line:gsub("%%FILE_NAME%%", file_name):gsub("%%DATE%%", date)
        end
        -- 插入模板到缓冲区
        vim.api.nvim_buf_set_lines(0, 0, 0, false, template)
    end
})-- 针对 Makefile 的模板
vim.api.nvim_create_autocmd("BufNewFile", {
    group = "FileTemplates",
    pattern = "makefile",
    callback = function()
        -- 读取模板内容
        local template = vim.fn.readfile('/home/jo/Templates/makefile')
        local project_name = vim.fn.expand("%:p:h:t")  -- 当前目录名作为项目名称
        -- 替换占位符
        for i, line in ipairs(template) do
            template[i] = line:gsub("%%PROJECT_NAME%%", project_name)
        end
        -- 插入模板到缓冲区
        vim.api.nvim_buf_set_lines(0, 0, 0, false, template)
    end
})
vim.cmd("packadd termdebug")

