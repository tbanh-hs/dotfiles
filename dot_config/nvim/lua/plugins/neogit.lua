return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = "Neogit",
  keys = {
    { "<Leader>gc", ":Neogit commit<CR>", desc = "[G]it [c]ommit" },
    { "<Leader>gf", ":Neogit fetch<CR>", desc = "[G]it [f]etch" },
    { "<Leader>gp", ":Neogit pull<CR>", desc = "[G]it [p]ull" },
    { "<Leader>gP", ":Neogit push<CR>", desc = "[G]it [P]ush" },
    { "<Leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
    { "<Leader>gb", ":Telescope git_branches<CR>", desc = "[G]it [b]ranches" },
  },
  opts = {
    disable_signs = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = true,
    signs = {
      section = { ">", "v" },
      item = { ">", "v" },
      hunk = { "", "" },
    },
    integrations = {
      diffview = true,
    },
  },
}
