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

-- 在 LazyVim 中创建一个函数，当打开的文件符合条件时生成 .clangd 文件
local function create_clangd_config()
  -- 获取当前文件的路径
  local file_path = vim.fn.expand("%:p")
  -- 检查文件扩展名是否为 .c, .cpp, .h, .hpp
  if file_path:match("%.c$") or file_path:match("%.cpp$") or file_path:match("%.h$") or file_path:match("%.hpp$") then
    -- 当前目录路径
    local current_dir = vim.fn.expand("%:p:h")

    -- 检查当前目录下是否已存在 .clangd 文件
    local clangd_config_path = current_dir .. "/.clangd"
    if vim.fn.filereadable(clangd_config_path) == 1 then
      -- 如果 .clangd 文件存在，则不做任何操作
      print(".clangd file already exists in " .. current_dir)
      return
    end

    -- 获取父级目录路径
    local parent_dir = vim.fn.fnamemodify(file_path, ":h")

    -- 检查父级目录中是否包含 "qt" 字段
    if parent_dir:match("qt") then
      -- 创建 .clangd 文件并写入指定内容
      local file = io.open(clangd_config_path, "w")
      if file then
        file:write('CompileFlags:\n CompilationDatabase: "build/Qt_6_4_2_macos-Debug"\n')
        file:close()
        print(".clangd file has been created in " .. current_dir)
      else
        print("Failed to create .clangd file.")
      end
    end
  end
end

-- 在文件打开时调用此函数
vim.api.nvim_create_autocmd("BufRead", {
  pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
  callback = create_clangd_config,
})

-- 在 Neovim 配置中，添加以下 Lua 代码

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    -- 在离开 Insert 模式时切换到英文输入法
    vim.fn.system("osascript -e 'tell application \"System Events\" to keystroke space using {command down}'")
  end,
})
