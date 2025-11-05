-- Neovim init.lua (macOS) - lazy.nvim + vimtex configured for Skim
-- Path: ~/.config/nvim/init.lua

-- 1) Set vimtex globals BEFORE plugins load so vimtex sees them early.
--    Adjust these if you prefer a different PDF viewer or compiler.
vim.g.vimtex_view_method     = 'skim'     -- use Skim on macOS
vim.g.vimtex_compiler_method = 'latexmk'  -- recommended compiler

-- Optional Skim-specific tweaks (enable SyncTeX/activate Skim on view)
-- These are commonly used; remove if undesired.
vim.g.vimtex_view_skim_sync     = 1
vim.g.vimtex_view_skim_activate = 1

-- 2) Bootstrap lazy.nvim if missing
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3) Plugins: lazy-load vimtex for TeX files
require('lazy').setup({
  {
    'lervag/vimtex',
    ft = 'tex', -- load when editing TeX files
    config = function()
      -- Post-load: enable filetype plugins and syntax highlighting
      vim.cmd('filetype plugin indent on')
      vim.cmd('syntax enable')

      -- Optional: a small helper keymap (uncomment to enable)
      -- vim.api.nvim_set_keymap('n', '<leader>ll', '<cmd>VimtexCompile<CR>', { noremap = true, silent = true })
      -- vim.api.nvim_set_keymap('n', '<leader>lv', '<cmd>VimtexView<CR>', { noremap = true, silent = true })
    end,
  },

  -- Add other plugins below as needed
})
