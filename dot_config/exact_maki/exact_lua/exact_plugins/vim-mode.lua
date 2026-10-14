-- maki-vim-mode package declaration (managed GitHub source; ./packages/
-- keeps a local checkout for development — point src back at pack.dir to
-- test local changes). Auto-loaded by config.maki; see lua/config/pack.lua
-- for the shared loader and `data` conventions.
local pack = require("config.pack")

maki.pack.add({
	{
		src = "https://github.com/MrBanh/maki-vim-mode",
		data = {
			module = "vim-mode",
			config = {
				escape_sequence = "jk",
				langmap = { H = "^", L = "$" },
				normal_leader = "space",
				enter_submit = true,
				insert_after_submit = true,
				clipboard = "yank",
			},
		},
	},
}, {
	load = pack.load_package,
})
