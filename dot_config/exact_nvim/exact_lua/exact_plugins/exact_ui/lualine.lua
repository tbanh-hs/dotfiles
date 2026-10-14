local disabled_filetypes = {
  "atlas-ui",
  "Diffview*",
  "Trouble",
  "checkhealth",
  "dap-repl",
  "dap-view",
  "help",
  "leetcode.nvim",
  "netrw",
  "noice",
  "qf",
  "sidekick_terminal",
  "snacks_dashboard",
  "toggleterm",
  "undotree",
}

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = LazyVim.config.icons

      -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
      local theme = require("lualine.themes.auto")
      local lualine_modes = { "normal", "inactive" }
      for _, field in ipairs(lualine_modes) do
        if theme[field] and theme[field].c then
          theme[field].c.bg = "NONE"
        end
      end

      opts.options.theme = theme

      opts.options.disabled_filetypes.winbar = disabled_filetypes

      -- separators
      local l_separator = ""
      local r_separator = ""

      opts.options.component_separators = ""
      opts.options.section_separators = { left = r_separator, right = l_separator }

      -- sections: https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#available-components
      opts.sections.lualine_c = {
        LazyVim.lualine.root_dir({
          ---@diagnostic disable-next-line: assign-type-mismatch
          cwd = true,
        }),
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path({
          relative = "root",
          length = 5,
        }) },
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
      }
      opts.sections.lualine_z = {}

      -- winbar
      opts.winbar = {
        lualine_a = {},
        lualine_b = {
          {
            "filetype",
            icon_only = true,
          },
          {
            "filename",
            file_status = false,
            symbols = {},
          },
        },
        lualine_c = {
          function()
            return require("lspsaga.symbol.winbar").get_bar() or ""
          end,
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }

      opts.inactive_winbar = {
        lualine_a = {},
        lualine_b = {
          {
            "filetype",
            icon_only = true,
            padding = 1,
            color = { bg = "None" },
          },
          {
            "filename",
            file_status = false,
            symbols = {},
            color = { bg = "None" },
            padding = {
              left = 1,
              right = 2,
            },
            separator = {
              right = " ",
            },
          },
        },
        lualine_c = {
          function()
            return require("lspsaga.symbol.winbar").get_bar() or ""
          end,
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }

      return opts
    end,
  },
}
