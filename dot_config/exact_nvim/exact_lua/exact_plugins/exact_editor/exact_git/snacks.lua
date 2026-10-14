-- Workaround: snacks picker's set_buf() doesn't re-apply buffer-local keymaps
-- when swapping to a non-scratch buffer (e.g. gh:// with filetype markdown.gh).
-- Calling win:map() ensures preview keymaps stay bound after the buffer swap.
local function gh_remap_preview_keys(picker)
  vim.schedule(function()
    if picker.preview and picker.preview.win:valid() then
      picker.preview.win:map()
    end
  end)
end

local function open_commit(_, item)
  if item and item.commit then
    local utils = require("user.utils")
    utils.open_commit_in_browser(item.commit)
  end
end

local function make_yank_commit(register)
  return function(_, item)
    if item and item.commit then
      vim.fn.setreg(register, item.commit)
    end
  end
end

local git_log_source_opts = {
  actions = {
    open_commit = open_commit,
    yank_commit = make_yank_commit('"'),
    yank_commit_clipboard = make_yank_commit("+"),
  },
  win = {
    input = {
      keys = {
        ["<c-g>"] = { "open_commit", mode = { "n", "i" } },
        ["y"] = { "yank_commit", mode = { "n" } },
        ["<leader>y"] = { "yank_commit_clipboard", mode = { "n" } },
      },
    },
    list = {
      keys = {
        ["<c-g>"] = { "open_commit" },
        ["y"] = { "yank_commit", mode = { "n" } },
        ["<leader>y"] = { "yank_commit_clipboard", mode = { "n" } },
      },
    },
  },
}

return {
  "folke/snacks.nvim",
  opts = {
    ---@class snacks.lazygit.Config: snacks.terminal.Opts
    lazygit = {
      configure = false, -- don't use neovim's colorscheme for snacks lazygit
      win = {
        style = {
          width = 0,
          height = 0,
        },
      },
    },
    picker = {
      layouts = {
        fullscreen = {
          layout = {
            box = "horizontal",
            width = 0,
            min_width = 120,
            height = 0,
            {
              box = "vertical",
              border = true,
              title = "{title}",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
            { win = "preview", title = "{preview}", border = true, width = 0.75 },
          },
        },
      },
      sources = {
        gh_actions = {},
        gh_diff = {
          layout = { preset = "fullscreen", fullscreen = true },
          on_change = gh_remap_preview_keys,
          formatters = { file = { filename_only = true } },
          focus = "list",
        },
        git_diff = {
          layout = { preset = "default", fullscreen = true },
          focus = "list",
        },
        git_log = git_log_source_opts,
        git_log_file = git_log_source_opts,
        git_log_line = git_log_source_opts,
      },
    },
  },
  keys = {
    {
      "<leader>gF",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "LazyGit File Log",
    },

    -- Open in browser
    {
      "<leader>go",
      "",
      desc = "Open in browser",
      mode = { "n", "v" },
    },
    {
      "<leader>gob",
      function()
        Snacks.gitbrowse({
          what = "branch",
        })
      end,
      desc = "Git Open Branch",
      mode = { "n", "v" },
    },
    {
      "<leader>goc",
      function()
        Snacks.gitbrowse({
          what = "commit",
        })
      end,
      desc = "Git Open Commit on cursor",
      mode = { "n", "v" },
    },
    {
      "<leader>gof",
      function()
        Snacks.gitbrowse({
          what = "file",
        })
      end,
      desc = "Git Open File",
      mode = { "n", "v" },
    },
    {
      "<leader>gol",
      function()
        Snacks.gitbrowse({
          what = "permalink",
        })
      end,
      desc = "Git Open Permalink",
      mode = { "n", "v" },
    },
    {
      "<leader>gop",
      function()
        vim.system({ "gh", "pr", "view", "--json", "url", "-q", ".url" }, { text = true }, function(out)
          vim.schedule(function()
            local url = vim.trim(out.stdout or "")
            if out.code ~= 0 or url == "" then
              Snacks.notify.warn("No PR found for current branch", { title = "GitHub" })
              return
            end
            vim.ui.open(url)
          end)
        end)
      end,
      desc = "Git Open PR (current branch)",
      mode = { "n", "v" },
    },
  },
}
