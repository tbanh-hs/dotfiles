-- Shared helpers for per-file package declarations in lua/plugins/
-- (e.g. lua/plugins/vim-mode.lua), following the Neovim convention where
-- each file declares one plugin. Every declaration file calls maki.pack.add
-- with its spec; the custom loader below runs once per package, as that
-- package's owner, so require() resolves inside the package checkout.
--
-- Pure function definitions only (no parking calls at load time), so this
-- helper is safe to require() from anywhere, including sync contexts.
-- The loader itself runs async, like any package entry point.
local M = {}

-- Local package sources. Keep a future GitHub repo name identical to the
-- directory name here and the derived package name (plus lockfile +
-- approvals) carries over; only `src` changes. (A package cannot name
-- itself: plugin.toml holds only min_maki_version + permissions.)
M.dir = maki.env.config_dir() .. "/packages"

-- Conventions for the spec `data` table:
--   module (string, required): module to require; must export setup().
--   config (table, optional): passed to setup() as-is.
--   vendor_subdir (string, optional): setup() gets config plus vendor_dir =
--     package.path .. "/" .. vendor_subdir (for packages with a vendor tree).
function M.load_package(package)
	local data = package.spec.data
	local opts = data.config
	if type(data.vendor_subdir) == "string" then
		local merged = { vendor_dir = package.path .. "/" .. data.vendor_subdir }
		if type(opts) == "table" then
			for k, v in pairs(opts) do
				if merged[k] == nil then
					merged[k] = v
				end
			end
		end
		opts = merged
	end
	require(data.module).setup(opts)
end

return M
