return { -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "mollerhoj/telescope-recent-files.nvim" },
  },
  keys = {
    {
      "<leader>sf",
      function()
        require("telescope").extensions["recent-files"].recent_files({})
      end,
      desc = "Search files",
    },
    {
      "<leader>sB",
      function()
        require("telescope.builtin").builtin()
      end,
      { desc = "[s]earch [B]uiltin Telescope" },
    },
    {
      "<leader>s.",
      function()
        local builtin = require("telescope.builtin")
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[s]earch [.]config",
    },
  },
}
