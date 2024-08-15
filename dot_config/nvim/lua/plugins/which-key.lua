-- https://www.lazyvim.org/plugins/editor#which-keynvim
return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "g?", group = "Debug Print" },
      },
    },
  },
}
