-- PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
-- Ahxar's Neovim Configuration
-- Main module initialization file
-- PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

local M = {}

-- Configuration modules to load
local modules = {
	"ahxar.options",
	"ahxar.keymaps",
	"ahxar.autocmds",
	"ahxar.lazy",
}

-- Safe require function with error handling
local function safe_require(module)
	local ok, err = pcall(require, module)
	if not ok then
		vim.notify("Error loading " .. module .. ": " .. err, vim.log.levels.ERROR)
		return false
	end
	return true
end

-- Initialize all modules
function M.setup()
	for _, module in ipairs(modules) do
		safe_require(module)
	end
end

-- Health check function
function M.health()
	vim.health.start("Ahxar Config Health Check")

	-- Check if all modules load successfully
	for _, module in ipairs(modules) do
		local ok = safe_require(module)
		if ok then
			vim.health.ok(module .. " loaded successfully")
		else
			vim.health.error(module .. " failed to load")
		end
	end

	-- Check plugin manager
	if vim.fn.isdirectory(vim.fn.stdpath("data") .. "/lazy") == 1 then
		vim.health.ok("Lazy.nvim plugin directory exists")
	else
		vim.health.error("Lazy.nvim plugin directory not found")
	end

	-- Check essential plugins (only if lazy is available)
	local lazy_available = safe_require("lazy")
	if lazy_available then
		vim.health.ok("Lazy plugin manager is available")

		local essential_plugins = {
			{ "blink.cmp", "Completion engine" },
			{ "lspconfig", "LSP configuration" },
			{ "nvim-treesitter.configs", "TreeSitter" },
			{ "conform", "Code formatting" },
		}

		for _, plugin_info in ipairs(essential_plugins) do
			local plugin, desc = plugin_info[1], plugin_info[2]
			if safe_require(plugin) then
				vim.health.ok(desc .. " (" .. plugin .. ") loaded")
			else
				vim.health.warn(desc .. " (" .. plugin .. ") not loaded (may be lazy-loaded)")
			end
		end
	else
		vim.health.warn("Lazy plugin manager not available")
	end

	-- Check LSP servers
	local clients = vim.lsp.get_clients()
	if #clients > 0 then
		vim.health.ok("LSP servers active: " .. #clients)
		for _, client in ipairs(clients) do
			vim.health.info("  - " .. client.name)
		end
	else
		vim.health.warn("No LSP servers currently active")
	end

	-- Check TreeSitter parsers
	local ts_available = safe_require("nvim-treesitter")
	if ts_available then
		local ts_info = safe_require("nvim-treesitter.info")
		if ts_info and type(ts_info) == "table" and type(ts_info.installed_parsers) == "function" then
			local success, installed = pcall(ts_info.installed_parsers)
			if success and installed and type(installed) == "table" and #installed > 0 then
				vim.health.ok("TreeSitter parsers installed: " .. #installed)
			else
				vim.health.warn("No TreeSitter parsers installed")
			end
		else
			vim.health.info("TreeSitter available but info module not accessible")
		end
	else
		vim.health.warn("TreeSitter not available")
	end

	-- Check key executables
	local executables = {
		{ "git", "Git version control" },
		{ "node", "Node.js for LSP servers" },
		{ "python3", "Python for some formatters" },
		{ "rg", "Ripgrep for searching" },
	}

	for _, exec in ipairs(executables) do
		if vim.fn.executable(exec[1]) == 1 then
			vim.health.ok(exec[2] .. " (" .. exec[1] .. ") available")
		else
			vim.health.warn(exec[2] .. " (" .. exec[1] .. ") not found")
		end
	end
end

-- Reload configuration function for development
function M.reload()
	-- Clear package cache for our modules
	for _, module in ipairs(modules) do
		package.loaded[module] = nil
	end

	-- Reload init.lua
	dofile(vim.env.MYVIMRC)
	vim.notify("Configuration reloaded!", vim.log.levels.INFO)
end

-- Clean up and optimize configuration
function M.cleanup()
	vim.notify("Starting configuration cleanup...", vim.log.levels.INFO)

	-- Clean up unused buffers
	local buffers = vim.api.nvim_list_bufs()
	local cleaned = 0

	for _, buf in ipairs(buffers) do
		if
			vim.api.nvim_buf_is_valid(buf)
			and not vim.bo[buf].modified
			and vim.api.nvim_buf_get_name(buf) == ""
			and vim.bo[buf].buftype == ""
		then
			vim.api.nvim_buf_delete(buf, { force = true })
			cleaned = cleaned + 1
		end
	end

	-- Force garbage collection
	collectgarbage("collect")

	vim.notify(string.format("Cleanup complete! Removed %d unused buffers", cleaned), vim.log.levels.INFO)
end

-- Update all plugins and tools
function M.update()
	vim.notify("Updating all plugins and tools...", vim.log.levels.INFO)

	-- Update lazy plugins
	if safe_require("lazy") then
		vim.cmd("Lazy update")
	end

	-- Update TreeSitter parsers
	if safe_require("nvim-treesitter") then
		vim.cmd("TSUpdate")
	end

	-- Update Mason tools
	if safe_require("mason") then
		vim.cmd("MasonUpdate")
	end
end

-- Show configuration info
function M.info()
	local info = {
		"📊 Ahxar's Neovim Configuration Info",
		"",
		"📂 Config Path: " .. vim.fn.stdpath("config"),
		"📦 Data Path: " .. vim.fn.stdpath("data"),
		"🔧 Version: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch,
		"",
		"🔌 Loaded Plugins:",
	}

	-- Get loaded plugins
	if safe_require("lazy") then
		local lazy = require("lazy")
		local plugins = lazy.plugins()
		table.insert(info, "  Total: " .. #plugins .. " plugins")

		-- Count loaded plugins
		local loaded = 0
		for _, plugin in pairs(plugins) do
			if plugin._.loaded then
				loaded = loaded + 1
			end
		end
		table.insert(info, "  Loaded: " .. loaded .. " plugins")
	end

	-- Add LSP info
	local lsp_clients = vim.lsp.get_clients()
	if #lsp_clients > 0 then
		table.insert(info, "")
		table.insert(info, "🌐 Active LSP Servers: " .. #lsp_clients)
		for _, client in ipairs(lsp_clients) do
			table.insert(info, "  • " .. client.name)
		end
	end

	-- Show in floating window
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, info)
	vim.bo[buf].filetype = "markdown"

	local width = 60
	local height = #info + 4
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
		title = " Config Info ",
		title_pos = "center",
	})

	-- Close with q
	vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
end

-- Export functions for command line use
vim.api.nvim_create_user_command("AhxarHealth", M.health, { desc = "Run Ahxar config health check" })
vim.api.nvim_create_user_command("AhxarReload", M.reload, { desc = "Reload Ahxar configuration" })
vim.api.nvim_create_user_command("AhxarCleanup", M.cleanup, { desc = "Clean up configuration" })
vim.api.nvim_create_user_command("AhxarUpdate", M.update, { desc = "Update all plugins and tools" })
vim.api.nvim_create_user_command("AhxarInfo", M.info, { desc = "Show configuration info" })

return M
