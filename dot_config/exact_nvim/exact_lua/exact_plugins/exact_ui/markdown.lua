local ft = { "md", "markdown" }

return {
  {
    -- Lazy: https://www.lazyvim.org/extras/lang/markdown#render-markdownnvim
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = true,
    ft = ft,
    opts = {
      anti_conceal = {
        enabled = false,
      },
      file_types = ft,
      heading = {
        icons = { "󰼏 ", "󰎨 ", "󰼑 ", "󰎲 ", "󰼓 ", "󰎴 " },
        position = "inline",
        width = "block",
        left_pad = 1,
        right_pad = 1,
      },
      html = {
        comment = {
          conceal = false,
        },
      },
      code = {
        language_border = "",
        language_right = "█",
        language_left = "█",
        border = "thin",
        above = "▄",
        below = "▀",
        sign = false,
      },
      checkbox = {
        enabled = true,
        custom = {
          todo = { raw = "[~]", rendered = "󰡖 ", highlight = "Orange", scope_highlight = "Orange" },
        },
        checked = {
          scope_highlight = "@markup.list.checked",
        },
        unchecked = {
          highlight = "Red",
          scope_highlight = "Red",
        },
      },
      latex = {
        enabled = false,
      },
      yaml = {
        enabled = false,
      },
    },
  },
}
