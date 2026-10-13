local M = {}

function M.apply()
	-- Disabled defaults: maki.keymap.del only removes your own bindings
	maki.keymap.set("n", "<C-h>", function() end, { desc = "Disabled: show keybindings" })
	maki.keymap.set("n", "<C-j>", function() end, { desc = "Disabled: newline" })
	maki.keymap.set("n", "<C-k>", function() end, { desc = "Disabled: delete to end of line" })

  -- Rebind scroll to bottom: <C-b> disabled, <C-M-g> scrolls to bottom
	maki.keymap.set("n", "<C-b>", function() end, { desc = "Disabled: Scroll to bottom" })
	maki.keymap.set("n", "<C-M-g>", function()
		local view = maki.fn.winsaveview()
		if type(view) ~= "table" then
			return
		end
		maki.fn.winrestview({ topline = view.line_count })
	end, { desc = "Scroll to bottom" })
end

M.apply()
maki.defer_fn(M.apply, 100)

return M
