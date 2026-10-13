-- maki-freeflow package declaration (managed GitHub source; ./packages/
-- keeps a local checkout for development — point src back at pack.dir to
-- test local changes). Auto-loaded by config.maki; see lua/config/pack.lua
-- for the shared loader and `data` conventions.
local pack = require("config.pack")

maki.pack.add({
	{
		src = "https://github.com/MrBanh/maki-freeflow",
		data = { module = "freeflow", vendor_subdir = "vendor" },
	},
}, {
	load = pack.load_package,
})
