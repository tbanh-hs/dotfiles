-- Auto-load every autocmd set in lua/config/autocmds (`<name>/init.lua` →
-- require("config.autocmds.<name>")), sorted for deterministic order. Add a
-- set by creating its directory; one failure is logged without stopping
-- the rest.
--
-- NOTE: apply() must be called from init.lua, not self-applied here:
-- required modules load in a sync context where parking APIs (maki.fs.glob)
-- raise "attempt to yield across metamethod/C-call boundary". init.lua's own
-- chunk is async-driven, so the call below may park.
local M = {}

function M.apply()
	local inits, glob_err = maki.fs.glob(
		"*/init.lua",
		{ path = maki.env.config_dir() .. "/lua/config/autocmds", gitignore = false }
	)
	if glob_err ~= nil then
		maki.log.error("config.autocmds: cannot list lua/config/autocmds: " .. tostring(glob_err))
		return
	end
	if #inits == 0 then
		maki.log.debug("config.autocmds: no autocmd sets found")
		return
	end
	table.sort(inits)
	for _, path in ipairs(inits) do
		local name = path:match("([^/]+)/init%.lua$")
		if name ~= nil then
			local ok, req_err = pcall(require, "config.autocmds." .. name)
			if not ok then
				maki.log.error("config.autocmds: require " .. name .. " failed: " .. tostring(req_err))
			end
		end
	end
end

return M
