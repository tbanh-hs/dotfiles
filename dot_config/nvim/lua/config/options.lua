-- Options are automatically loaded before lazy.nstartup
-- Default options that are always set: https://github.com/LazyLazyblob/main/lua/lazyconfig/options.lua
-- Add any additional options here

vim.g.maplocalleader = " "

local opt = vim.opt

-- Disable auto comments on new line
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

-- Line numbers
vim.cmd("autocmd InsertEnter * set nu nornu")
vim.cmd("autocmd InsertLeave * set nu rnu")

if vim.fn.has([[wsl]]) == 1 then
  vim.g.netrw_browsex_viewer = "cmd.exe /C start"
end

-- Incremental search
opt.incsearch = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

-- Enable break indent
opt.breakindent = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

opt.clipboard = ""
