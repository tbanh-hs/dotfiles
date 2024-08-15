-- https://github.com/epwalsh/obsidian.nvim

return {
  "epwalsh/obsidian.nvim",
  lazy = false,
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "Notes",
        path = "/mnt/c/Users/tonyb/Desktop/Notes",
      },
    },

    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },

    log_level = vim.log.levels.INFO,

    daily_notes = {
      folder = "Journal",
      date_format = "%Y-%m-%d",
      template = "daily-template.md",
    },

    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    mappings = {
      -- Smart action depending on context, either follow link or toggle checkbox.
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },

    disable_frontmatter = true,

    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return suffix
    end,

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart({ "open", url }) -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
    end,

    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
      name = "telescope.nvim",
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      mappings = {},
    },

    -- Optional, sort search results by "path", "modified", "accessed", or "created".
    -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
    -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
    sort_by = "modified",
    sort_reversed = true,

    -- Specify how to handle attachments.
    attachments = {
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      img_folder = "assets/images",
    },
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    vim.keymap.set("n", "gd", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<CR>"
      else
        return "gd"
      end
    end, { noremap = false, expr = true })

    vim.keymap.set({ "n", "v" }, "<leader>nd", "<cmd>ObsidianDailies -7 3<CR>", { desc = "Daily notes" })
    vim.keymap.set({ "n", "v" }, "<leader>ng", "<cmd>ObsidianSearch<CR>", { desc = "Search notes with grep" })

    vim.api.nvim_create_user_command("ObsidianNewFromTemplate", function()
      vim.cmd("ObsidianNew")
      vim.cmd("normal! gg") -- go to end of file
      vim.cmd("ObsidianTemplate")
    end, {})
    vim.keymap.set({ "n", "v" }, "<leader>nn", "<cmd>ObsidianNewFromTemplate<CR>", { desc = "New note from template" })

    vim.keymap.set(
      { "n", "v" },
      "<leader>ns",
      "<cmd>ObsidianQuickSwitch<CR>",
      { desc = "Search and switch to another note" }
    )

    vim.keymap.set({ "n", "v" }, "<leader>nt", "<cmd>ObsidianToday<CR>", { desc = "Today's notes" })
    vim.keymap.set({ "n", "v" }, "<leader>no", "<cmd>ObsidianOpen<CR>", { desc = "Open current note in Obsidian app" })
  end,
}
