---@module "atlas.config"
return {
  {
    "emrearmagan/atlas.nvim",
    dependencies = {
      "esmuellert/codediff.nvim",
    },
    cmd = {
      "Atlas",
    },
    ---@type AtlasConfig
    opts = {
      providers = {
        ---@type AtlasGitHubConfig
        github = {
          cache_ttl = 300, -- Set to 0 to disable caching.
        },
      },
      pulls = {
        repo_config = {
          paths = {
            ["banh-me/*"] = "~/src/*",
            ["banh-me/dotfiles"] = "~/.local/share/chezmoi",
          },
        },
        git_transport = "ssh", -- "https" or "ssh" for Atlas-managed Git remotes.
        diff = {
          layout = "side-by-side", -- "inline" or "side-by-side".
          lsp = {
            enabled = true,
          },
          explorer = {
            preview = true, -- Show a file as soon as the explorer cursor moves onto it.
            focus_on_select = false, -- Move into the diff after selecting a file.
          },
        },
        ---@type AtlasGitHubPullsConfig
        github = {
          views = {
            {
              name = "My Pull Requests",
              key = "1",
              search = "is:pr author:@me is:open",
              current_repo = true,
            },
            {
              name = "Needs My Review",
              key = "2",
              search = "is:pr review-requested:@me is:open",
              current_repo = true,
            },
            {
              name = "Involved",
              key = "3",
              search = "is:pr -author:@me involves:@me is:open",
              current_repo = true,
            },
            {
              name = "All (recent 2 weeks)",
              key = "4",
              search = "is:pr is:open updated:>=" .. os.date("%Y-%m-%d", os.time() - 14 * 24 * 60 * 60),
              current_repo = true,
            },
          },
        },
      },
      issues = {
        ---@type AtlasGitHubIssuesConfig
        github = {
          views = {
            {
              name = "My Issues",
              key = "1",
              search = "author:@me is:open",
              current_repo = true,
            },
            {
              name = "Assigned",
              key = "2",
              search = "assignee:@me is:open",
              current_repo = true,
            },
            {
              name = "Involved",
              key = "3",
              search = "involves:@me -author:@me is:open",
              current_repo = true,
            },
          },
        },
      },
    },
    keys = {
      { "<leader>gA", ":Atlas<CR>", desc = "Atlas", mode = { "n" } },
      { "<leader>gi", ":Atlas issues<CR>", desc = "Issues", mode = { "n" } },
      { "<leader>gp", ":Atlas pulls<CR>", desc = "Pull Requests", mode = { "n" } },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>gi",
        false,
      },
      {
        "<leader>gI",
        false,
      },
      {
        "<leader>gp",
        false,
      },
      {
        "<leader>gP",
        false,
      },
    },
  },
}
