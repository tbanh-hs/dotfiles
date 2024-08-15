return {
  "rhysd/git-messenger.vim",
  cmd = "GitMessenger",
  keys = {
    { "<Leader>gm", "<Plug>(git-messenger)", desc = "[G]it [m]essenger" },
  },
  init = function()
    vim.g.git_messenger_include_diff = "current"
    vim.g.git_messenger_no_default_mappings = false
    vim.g.git_messenger_floating_win_opts = { border = "rounded" }
  end,
}
