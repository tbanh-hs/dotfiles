require("config.maki").apply()
require("config.autocmds").apply()
require("config.keymaps")

maki.setup({
	ui = {
		splash_animation = false,
		theme = "matugen",
		notifications = "notify",
	},
})
