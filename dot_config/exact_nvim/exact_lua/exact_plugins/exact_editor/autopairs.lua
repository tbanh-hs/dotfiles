-- Prefer ultimate-autopair
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
