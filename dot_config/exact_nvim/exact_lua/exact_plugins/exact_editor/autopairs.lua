-- Prefer ultimate-autopair; better defaults and can work in markdown code blocks
--- mini: hello |world -> hello `|world -> hello `world| -> hello `world``
--- nvim-autopairs: (|) 🡒 <BS> 🡒 |)

return {
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {
      close = {
        enable = false, -- doesn't work in multiline
      },
      cr = {
        autoclose = true,
      },
      extensions = {
        filetype = {
          nft = {
            "grug-far",
            "markdown",
            "sidekick_ask",
            "snacks_input",
            "snacks_picker_input",
          },
        },
      },
      fastwarp = {
        map = "<C-)>",
        rmap = "<C-(>",
        cmap = "<C-)>",
        rcmap = "<C-(>",
        nocursormove = false,
      },
      tabout = {
        enable = false, -- doesn't work in multiline
      },
    },
  },
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },
}
