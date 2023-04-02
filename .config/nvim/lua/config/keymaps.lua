-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "\\ll", "<cmd>VimtexCompile<cr>", {
  noremap = true,
  silent = true,
})

vim.api.nvim_set_keymap("n", "\\w", '<cmd>execute "normal! \\<leader>cf"<CR>:w<CR>', {
  noremap = true,
  silent = true,
})
