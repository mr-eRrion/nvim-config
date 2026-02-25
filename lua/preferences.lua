-- Set Space as the leader keys (must be before any keymaps)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = {noremap = true, silent = true}

-----------------
-- Normal mode --
-----------------
-- Windows navigation
vim.keymap.set('n', '<C-Left>', '<C-w>h', opts)
vim.keymap.set('n', '<C-Down>', '<C-w>j', opts)
vim.keymap.set('n', '<C-Up>', '<C-w>k', opts)
vim.keymap.set('n', '<C-Right>', '<C-w>l', opts)

-- Terminal splits
vim.keymap.set('n', '<Leader>tv', ':vsp term://zsh<CR>', opts)
vim.keymap.set('n', '<Leader>ts', ':split term://zsh<CR>', opts)

-- Diagnostic float
vim.keymap.set('n', '<Leader>sd', vim.diagnostic.open_float, opts)

-------------------
-- Terminal mode --
-------------------
vim.keymap.set('t', '<esc>', '<C-\\><C-n>', opts)

---------
-- set --
---------
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.listchars = "tab:┊ ,space:·"
vim.opt.list = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.splitright = true
vim.opt.expandtab = true
