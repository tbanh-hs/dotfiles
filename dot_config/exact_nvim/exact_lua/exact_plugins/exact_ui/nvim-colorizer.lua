return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    filetypes = {
      "*",
      "!atlas-ui.repository",
      "!grug-far",
      "!lazy",
      "!sidekick_terminal",
      "!snacks_input",
      "!snacks_picker_input",
      "!snacks_terminal",
    },
    buftypes = {},
    user_commands = true,
    lazy_load = false,
    options = {
      parsers = {
        css = true,
        css_fn = true,
        names = {
          enable = false,
        },
        hex = {
          default = true,
          rrggbbaa = true,
          aarrggbb = true,
        },
        tailwind = {
          enable = true,
          update_names = true,
          lsp = true,
        },
        sass = { enable = true, parsers = { css = true } },
      },
      display = {
        mode = "virtualtext",
        virtualtext = {
          char = "󱓻",
          position = "before",
          hl_mode = "foreground",
        },
      },
      always_update = true,
    },
  },
  config = function(_, opts)
    require("colorizer").setup(opts)
  end,
}
