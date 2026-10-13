local keymap_prefix = "<leader>a"

return {
  "folke/sidekick.nvim",
  opts = {
    signs = {
      enabled = true, -- enable signs by default
      icon = " ",
    },
    cli = {
      mux = {
        backend = "tmux",
        enabled = vim.fn.executable("tmux") == 1,
      },
      win = {
        keys = {
          prompt = { "<C-a>p", "prompt", mode = "t", desc = "insert prompt or context" },
        },
        wo = {
          scrolloff = 0, -- prevent global scrolloff from shifting terminal view on toggle
        },
        layout = vim.g.floating_terminal and "float" or "right", ---@type "float"|"left"|"bottom"|"top"|"right"
        float = {
          width = 0.6,
          height = 0.6,
        },
        -- Options used when layout is "left"|"bottom"|"top"|"right"
        ---@type vim.api.keyset.win_config
        split = {
          width = 0.5, -- set to 0 for default split width
          height = 0, -- set to 0 for default split height
        },
      },
      tools = {
        opencode = {
          cmd = { "zsh", "-c", 'opencode "$@"; exit', "zsh" },
        },
        maki = {
          cmd = { "zsh", "-c", 'maki "$@"; exit', "zsh" },
          is_proc = "\\<maki\\>",
          continue = { "--resume" },
        },
      },
    },
    nes = {
      enabled = false,
    },
    copilot = {
      status = {
        enabled = false,
      },
    },
  },
  config = function(_, opts)
    -- Prefix the tmux/zellij session name with "sidekick|" and append the cwd
    -- basename (repo/worktree name), e.g. "sidekick|opencode 1a2b3c4d - nvim".
    local Session = require("sidekick.cli.session")
    local original_sid = Session.sid
    ---@diagnostic disable-next-line: duplicate-set-field
    Session.sid = function(o)
      local sid = "[sidekick] " .. original_sid(o)
      -- Derive the suffix from the same normalized cwd the plugin uses. It must
      -- stay deterministic from cwd: on rediscovery sidekick recomputes sid from
      -- a running session's cwd and matches it against the live tmux session name
      -- to re-attach (see cli/session/tmux.lua).
      local cwd = Session.cwd(o):gsub("/+$", "")
      -- tmux rewrites "." and ":" in session names to "_"; mirror that so the
      -- recomputed sid still equals the stored tmux session name.
      local name = vim.fn.fnamemodify(cwd, ":t"):gsub("[.:]", "_")
      if name ~= "" then
        sid = sid .. "  " .. name
      end
      return sid
    end
    require("sidekick").setup(opts)
  end,
  keys = {
    {
      "<c-.>",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      false,
    },
    {
      keymap_prefix .. "f",
      function()
        require("sidekick.cli").focus()
      end,
      desc = "Sidekick Focus",
      mode = { "n", "x" },
    },
    {
      keymap_prefix .. "b",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Send Buffer",
    },
  },
}
