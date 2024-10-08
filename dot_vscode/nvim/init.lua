-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- OPTIONS --

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Disable auto comments on new line
vim.cmd 'autocmd BufEnter * set formatoptions-=cro'
vim.cmd 'autocmd BufEnter * setlocal formatoptions-=cro'

-- Line number
vim.cmd 'autocmd InsertEnter * set nu nornu'
vim.cmd 'autocmd InsertLeave * set nu rnu'

-- Incremental search
vim.opt.incsearch = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- KEYMAPS --

local set = vim.keymap.set
local opts = { noremap = true, silent = true }

set({ 'n', 'v' }, 'H', '^', opts)
set({ 'n', 'v' }, 'L', '$', opts)

-- Set highlight on search, but clear on pressing <Esc> in normal mode
set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Paste without overwriting
set('v', 'p', 'P', opts)

-- Do not overwrite register when changing
set('n', 'c', [["_c]], opts)
set('v', 'c', [["_c]], opts)

-- move text up and down
set('v', 'J', ':m .+1<CR>==', opts)
set('v', 'K', ':m .-2<CR>==', opts)
set('x', 'J', ":move '>+1<CR>gv-gv", opts)
set('x', 'K', ":move '<-2<CR>gv-gv", opts)

-- Joins without cursor moving
set('n', 'J', 'mzJ`z')

-- yank to system clipboard
set({ 'n', 'v' }, '<leader>y', '"+y', opts)

-- paste from system clipboard
set({ 'n', 'v' }, '<leader>p', '"+p', opts)

-- Moving past folds
local function moveCursor(direction)
  if vim.fn.reg_recording() == '' and vim.fn.reg_executing() == '' then
    return ('g' .. direction)
  else
    return direction
  end
end

set('n', 'k', function()
  return moveCursor 'k'
end, { expr = true, remap = true })
set('n', 'j', function()
  return moveCursor 'j'
end, { expr = true, remap = true })

if vim.g.vscode then
  set({ 'n', 'x', 'i' }, '<C-m>', function()
    require('vscode-multi-cursor').addSelectionToNextFindMatch()
  end)

  local vscode = require 'vscode'

  set({ 'n' }, 'gr', function()
    vscode.call 'editor.action.referenceSearch.trigger'
  end, opts)

  set({ 'n' }, 'gt', function()
    vscode.call 'editor.action.goToTypeDefinition'
  end, opts)

  -- undo / redo
  set({ 'n' }, 'u', function()
    vscode.call 'undo'
  end, opts)
  set({ 'n' }, '<C-r>', function()
    vscode.call 'redo'
  end, opts)

  -- diagnostics
  set({ 'n' }, ']d', function()
    vscode.call 'editor.action.marker.next'
  end)
  set({ 'n' }, '[d', function()
    vscode.call 'editor.action.marker.prev'
  end)

  -- git changes
  set({ 'n' }, ']h', function()
    vscode.call 'workbench.action.editor.nextChange'
  end, opts)
  set({ 'n' }, '[h', function()
    vscode.call 'workbench.action.editor.previousChange'
  end, opts)
end

-- PLUGINS --
require('lazy').setup {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }
    end,
  },
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    'michaeljsmith/vim-indent-object',
  },
  {
    'inkarkat/vim-ReplaceWithRegister',
    keys = {
      { 'r', '<Plug>ReplaceWithRegisterOperator', desc = 'Replace with register' },
      { 'r', '<Plug>ReplaceWithRegisterVisual', desc = 'Replace with register visual', mode = 'x' },
      { 'rr', '<Plug>ReplaceWithRegisterLine', desc = 'Riplace with register line' },
    },
  },
  { 'kana/vim-textobj-entire', dependencies = { 'kana/vim-textobj-user' } },
  {
    'vscode-neovim/vscode-multi-cursor.nvim',
    event = 'VeryLazy',
    cond = not not vim.g.vscode,
    opts = {
      default_mappings = false,
    },
  },
}
