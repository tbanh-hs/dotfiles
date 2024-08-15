-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local del = vim.keymap.del
local set = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Delete/Override Lazy
del("n", "<leader>K")
set("n", "<leader>L", ":LazyExtras<CR>", { desc = "LazyExtras" })

-- floating terminal
local lazyterm = function()
  LazyVim.terminal(nil, { border = "rounded", size = { width = 0.8, height = 0.8 } })
end
set("n", "<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
set("n", "<leader>fT", function()
  LazyVim.terminal()
end, { desc = "Terminal (cwd)" })
set("n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" })
set("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- My keymaps
set({ "n", "v" }, "H", "^", opts)
set({ "n", "v" }, "L", "$", opts)

-- Paste without overwriting
set("v", "p", "P", opts)

-- Do not overwrite when using change command
set("n", "c", [["_c]], opts)
set("v", "c", [["_c]], opts)

-- Yank to clipboard
set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[Y]ank selected to clipboard" })

-- Jump up/down while keeping cursor centered
set("n", "<C-u>", "<C-u>zz")
set("n", "<C-d>", "<C-d>zz")

-- Joins without cursor moving
set("n", "J", "mzJ`z")

set("i", "jk", "<Esc>", opts)

-- regex helpers
set("c", [[\\*]], [[\(.*\)]])
set("c", [[\\-]], [[\(.\{-}\)]])
