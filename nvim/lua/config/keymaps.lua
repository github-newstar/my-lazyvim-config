-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set({"n"}, "<leader>t", '<Cmd>ToggleTerm size=35 <CR>')
vim.keymap.set("n", "Q",":q<CR>", {noremap = true, silent = true})
-- 仅在 ToggleTerm 窗口中设置快捷键
function _G.set_terminal_keymaps()
  local opts = { noremap = true, silent = true }
  -- 映射 Ctrl+L 执行 'clear' 命令
  vim.api.nvim_buf_set_keymap(0, 'i', '<C-l>', 'clear<CR>', opts)
end

-- 在终端打开时设置快捷键
vim.cmd([[autocmd! TermOpen * lua set_terminal_keymaps()]])
