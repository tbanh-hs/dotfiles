-- Auto-load every module in lua/plugins (`foo.lua` or `foo/init.lua` →
-- require("plugins.foo")), sorted for deterministic order. Dropping a file
-- here enables it on next reload; one failure is logged without stopping
-- the rest. (Anything that needs config or its own repo becomes a package
-- in packages/ instead.)
local M = {}

-- NOTE: apply() must be called from init.lua, not self-applied here:
-- required modules load in a sync context where parking APIs (maki.fs.glob)
-- raise "attempt to yield across metamethod/C-call boundary". init.lua's own
-- chunk is async-driven, so the call below may park.
function M.apply()
	local plugin_files, glob_err = maki.fs.glob(
		{ "*.lua", "*/init.lua" },
		{ path = maki.env.config_dir() .. "/lua/plugins", gitignore = false }
	)
	if glob_err ~= nil then
		maki.log.error("config.maki: cannot list lua/plugins: " .. tostring(glob_err))
		return
	end
	if #plugin_files == 0 then
		maki.log.debug("config.maki: no modules found in lua/plugins")
		return
	end
	table.sort(plugin_files)
	for _, path in ipairs(plugin_files) do
		local name = path:match("([^/]+)%.lua$")
		if name == "init" then
			name = path:match("([^/]+)/init%.lua$")
		end
		if name ~= nil then
			local ok, req_err = pcall(require, "plugins." .. name)
			if not ok then
				maki.log.error("config.maki: require plugins." .. name .. " failed: " .. tostring(req_err))
			end
		end
	end
end

return M
