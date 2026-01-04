-- Use Vim's config
vim.opt.runtimepath:prepend '~/.vim'
vim.opt.runtimepath:append '~/.vim/after'
vim.opt.packpath = vim.opt.runtimepath:get()
vim.cmd.source '~/.vimrc'

-- Neovim specific settings
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.inccommand = 'split'
-- Might not work in all terminals, eg tmux.
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = '' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = '' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = '' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = '' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Fetch all plugins from the ./lua/plugins/*.lua files
require('lazy').setup 'plugins'
