return {
  "neanias/everforest-nvim",
  version = false,
  lazy = true,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require("everforest").setup({
      ---Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
      ---Default is "medium".
      background = "hard",
      ---How much of the background should be transparent. 2 will have more UI
      ---components be transparent (e.g. status line background)
      transparent_background_level = 2,
      ---Whether italics should be used for keywords and more.
      italics = false,
      ---Disable italic fonts for comments. Comments are in italics by default, set
      ---this to `true` to make them _not_ italic!
      disable_italic_comments = false,
      ---By default, the colour of the sign column background is the same as the as normal text
      ---background, but you can use a grey background by setting this to `"grey"`.
      sign_column_background = "none",
      ---The contrast of line numbers, indent lines, etc. Options are `"high"` or
      ---`"low"` (default).
      ui_contrast = "low",
      ---Dim inactive windows. Only works in Neovim. Can look a bit weird with Telescope.
      ---
      ---When this option is used in conjunction with show_eob set to `false`, the
      ---end of the buffer will only be hidden inside the active window. Inside
      ---inactive windows, the end of buffer filler characters will be visible in
      ---dimmed symbols. This is due to the way Vim and Neovim handle `EndOfBuffer`.
      dim_inactive_windows = false,
      ---Some plugins support highlighting error/warning/info/hint texts, by
      ---default these texts are only underlined, but you can use this option to
      ---also highlight the background of them.
      diagnostic_text_highlight = false,
      ---Which colour the diagnostic text should be. Options are `"grey"` or `"coloured"` (default)
      diagnostic_virtual_text = "coloured",
      ---Some plugins support highlighting error/warning/info/hint lines, but this
      ---feature is disabled by default in this colour scheme.
      diagnostic_line_highlight = false,
      ---By default, this color scheme won't colour the foreground of |spell|, instead
      ---colored under curls will be used. If you also want to colour the foreground,
      ---set this option to `true`.
      spell_foreground = false,
      ---Whether to show the EndOfBuffer highlight.
      show_eob = true,
      ---Style used to make floating windows stand out from other windows. `"bright"`
      ---makes the background of these windows lighter than |hl-Normal|, whereas
      ---`"dim"` makes it darker.
      ---
      ---Floating windows include for instance diagnostic pop-ups, scrollable
      ---documentation windows from completion engines, overlay windows from
      ---installers, etc.
      ---
      ---NB: This is only significant for dark backgrounds as the light palettes
      ---have the same colour for both values in the switch.
      float_style = "bright",
      ---Inlay hints are special markers that are displayed inline with the code to
      ---provide you with additional information. You can use this option to customize
      ---the background color of inlay hints.
      inlay_hints_background = "none", -- or "dimmed"
      -- https://github.com/neanias/everforest-nvim/blob/main/lua/everforest/colours.lua
      on_highlights = function(hl, palette)
        local highlights = {
          ColorColumn = { bg = palette.bg_green },
          NormalFloat = { bg = palette.none },
          FloatBorder = { bg = palette.none },
          Pmenu = { bg = palette.none },
          PmenuSel = { bg = palette.bg_green, fg = palette.none },

          NonText = { link = "Comment" },
          TSParameter = { fg = palette.purple },
          LspSignatureActiveParameter = { bg = palette.bg1 },

          TreesitterContext = { bg = palette.none },
          TreesitterContextLineNumber = { fg = palette.yellow },

          DiffChange = { bg = palette.none },
          GitConflictCurrent = { bg = palette.bg_blue },
          GitConflictCurrentLabel = { link = "GitConflictCurrent" },

          LspReferenceText = { bg = palette.bg1 },
          LspReferenceRead = { link = "LspReferenceText" },
          LspCodeLens = { fg = palette.grey1, bg = palette.none, dim = true, italic = true },

          SnacksDiffContextLineNr = {
            bg = palette.none,
            fg = palette.fg,
          },

          RenderMarkdownH1Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH2Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH3Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH4Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH5Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH6Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownHeadingBG = { bg = palette.bg_blue },

          -- conflict-marker.nvim
          ConflictOurs = { bg = palette.bg_blue },
          ConflictTheirs = { bg = palette.bg_green },

          -- cursortab.nvim
          -- CursorTabCompletion 	fg = "#80899c" 	Foreground for completion text
          -- CursorTabJumpSymbol 	fg = "#373b45" 	Jump indicator symbol
          -- CursorTabJumpText 	bg = "#373b45", fg = "#bac1d1" 	Jump indicator text
          CursorTabDeletion = {
            bg = palette.bg_red,
          },
          CursorTabAddition = {
            bg = palette.bg_green,
          },
          CursorTabModification = {
            bg = palette.bg_dim,
          },
          CursorTabJumpSymbol = {
            fg = palette.orange,
          },
          CursorTabJumpText = {
            bg = palette.orange,
            fg = palette.bg_dim,
          },

          -- haunt.nvim
          HauntAnnotation = {
            fg = palette.grey2,
            italic = true,
          },
        }

        for group, opts in pairs(highlights) do
          hl[group] = opts
        end
      end,
      colours_override = function(palette)
        local overrides = require("user.colors.everforest")
        for color, value in pairs(overrides) do
          palette[color] = value
        end
      end,
    })
  end,
}

--[[
---@type Everforest.PaletteBackgrounds
local hard_background = {
  dark = {
    bg_dim = "#1e2326",
    bg0 = "#272e33",
    bg1 = "#2e383c",
    bg2 = "#374145",
    bg3 = "#414b50",
    bg4 = "#495156",
    bg5 = "#4f5b58",
    bg_visual = "#4c3743",
    bg_red = "#493b40",
    bg_green = "#3c4841",
    bg_blue = "#384b55",
    bg_yellow = "#45443c",
    bg_purple = "#463f48",
  },
  light = {
    bg_dim = "#f2efdf",
    bg0 = "#fffbef",
    bg1 = "#f8f5e4",
    bg2 = "#f2efdf",
    bg3 = "#edeada",
    bg4 = "#e8e5d5",
    bg5 = "#bec5b2",
    bg_visual = "#f0f2d4",
    bg_red = "#ffe7de",
    bg_green = "#f3f5d9",
    bg_blue = "#ecf5ed",
    bg_yellow = "#fef2d5",
    bg_purple = "#fceced",
  },
}

---@type Everforest.PaletteBackgrounds
local medium_background = {
  dark = {
    bg_dim = "#232a2e",
    bg0 = "#2d353b",
    bg1 = "#343f44",
    bg2 = "#3d484d",
    bg3 = "#475258",
    bg4 = "#4f585e",
    bg5 = "#56635f",
    bg_visual = "#543a48",
    bg_red = "#514045",
    bg_green = "#425047",
    bg_blue = "#3a515d",
    bg_yellow = "#4d4c43",
    bg_purple = "#4a444e",
  },
  light = {
    bg_dim = "#efebd4",
    bg0 = "#fdf6e3",
    bg1 = "#f4f0d9",
    bg2 = "#efebd4",
    bg3 = "#e6e2cc",
    bg4 = "#e0dcc7",
    bg5 = "#bdc3af",
    bg_visual = "#eaedc8",
    bg_red = "#fde3da",
    bg_green = "#f0f1d2",
    bg_blue = "#e9f0e9",
    bg_yellow = "#faedcd",
    bg_purple = "#fae8e2",
  },
}

---@type Everforest.PaletteBackgrounds
local soft_background = {
  dark = {
    bg_dim = "#293136",
    bg0 = "#333c43",
    bg1 = "#3a464c",
    bg2 = "#434f55",
    bg3 = "#4d5960",
    bg4 = "#555f66",
    bg5 = "#5d6b66",
    bg_visual = "#5c3f4f",
    bg_red = "#59464c",
    bg_green = "#48584e",
    bg_blue = "#3f5865",
    bg_yellow = "#55544a",
    bg_purple = "#4e4953",
  },
  light = {
    bg_dim = "#e5dfc5",
    bg0 = "#f3ead3",
    bg1 = "#eae4ca",
    bg2 = "#e5dfc5",
    bg3 = "#ddd8be",
    bg4 = "#d8d3ba",
    bg5 = "#b9c0ab",
    bg_visual = "#e1e4bd",
    bg_red = "#fadbd0",
    bg_green = "#e5e6c5",
    bg_blue = "#e1e7dd",
    bg_yellow = "#f1e4c5",
    bg_purple = "#f1ddd4",
  },
}

---@type table<Everforest.Backgrounds, Everforest.PaletteBase>
local base_palette = {
  light = {
    fg = "#5c6a72",
    red = "#f85552",
    orange = "#f57d26",
    yellow = "#dfa000",
    green = "#8da101",
    aqua = "#35a77c",
    blue = "#3a94c5",
    purple = "#df69ba",
    grey0 = "#a6b0a0",
    grey1 = "#939f91",
    grey2 = "#829181",
    statusline1 = "#93b259",
    statusline2 = "#708089",
    statusline3 = "#e66868",
    none = "NONE",
  },
  dark = {
    fg = "#d3c6aa",
    red = "#e67e80",
    orange = "#e69875",
    yellow = "#dbbc7f",
    green = "#a7c080",
    aqua = "#83c092",
    blue = "#7fbbb3",
    purple = "#d699b6",
    grey0 = "#7a8478",
    grey1 = "#859289",
    grey2 = "#9da9a0",
    statusline1 = "#a7c080",
    statusline2 = "#d3c6aa",
    statusline3 = "#e67e80",
    none = "NONE",
  },
}
]]
