local cmp = require("cmp")

return { -- Autocompletion
  "hrsh7th/nvim-cmp",
  opts = {
    completion = {
      completeopt = "menu,menuone,noinsert,noselect",
    },
    mapping = cmp.mapping.preset.insert({
      ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    }),
  },
}
