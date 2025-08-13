-- ══════════════════════════════════════════════════════════════════════════════
-- Utility Functions
-- Helper functions for configuration and plugin management
-- ══════════════════════════════════════════════════════════════════════════════

local M = {}

-- ══════════════════════════════════════════════════════════════════════════════
-- File & Path Utilities
-- ══════════════════════════════════════════════════════════════════════════════

-- Check if a file exists
function M.file_exists(path)
	local stat = vim.loop.fs_stat(path)
	return stat and stat.type == "file"
end

-- Check if a directory exists
function M.dir_exists(path)
	local stat = vim.loop.fs_stat(path)
	return stat and stat.type == "directory"
end

-- Get the directory of the current file
function M.get_current_dir()
	return vim.fn.expand("%:p:h")
end

-- Join path components
function M.join_paths(...)
	local parts = {...}
	return table.concat(parts, "/"):gsub("//+", "/")
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Plugin Management Utilities
-- ══════════════════════════════════════════════════════════════════════════════

-- Safe require with error handling and optional return value
function M.safe_require(module, default)
	local ok, result = pcall(require, module)
	if not ok then
		if default ~= nil then
			return default
		end
		vim.notify("Failed to load module: " .. module .. "\nError: " .. result, vim.log.levels.WARN)
		return nil
	end
	return result
end

-- Check if a plugin is loaded
function M.is_plugin_loaded(plugin_name)
	return package.loaded[plugin_name] ~= nil
end

-- Get plugin installation path
function M.get_plugin_path(plugin_name)
	local lazy_path = vim.fn.stdpath("data") .. "/lazy/" .. plugin_name
	return M.dir_exists(lazy_path) and lazy_path or nil
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Configuration Utilities
-- ══════════════════════════════════════════════════════════════════════════════

-- Deep merge tables (useful for configuration merging)
function M.merge_tables(target, source)
	for key, value in pairs(source) do
		if type(value) == "table" and type(target[key]) == "table" then
			M.merge_tables(target[key], value)
		else
			target[key] = value
		end
	end
	return target
end

-- Create a configuration table with defaults
function M.create_config(defaults, user_config)
	return M.merge_tables(vim.deepcopy(defaults), user_config or {})
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Keymap Utilities
-- ══════════════════════════════════════════════════════════════════════════════

-- Create a keymap with consistent options
function M.keymap(mode, lhs, rhs, opts)
	local options = {
		noremap = true,
		silent = true,
	}
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Create buffer-local keymap
function M.buf_keymap(bufnr, mode, lhs, rhs, opts)
	local options = {
		noremap = true,
		silent = true,
		buffer = bufnr,
	}
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- UI & Display Utilities
-- ══════════════════════════════════════════════════════════════════════════════

-- Show notification with consistent styling
function M.notify(message, level, title)
	local notify_opts = {
		title = title or "Ahxar Config",
		timeout = 3000,
	}
	vim.notify(message, level or vim.log.levels.INFO, notify_opts)
end

-- Toggle a boolean option
function M.toggle_option(option)
	vim.o[option] = not vim.o[option]
	M.notify(option .. " " .. (vim.o[option] and "enabled" or "disabled"))
	return vim.o[option]
end

-- Get highlight group colors
function M.get_hl_color(group, attr)
	local hl = vim.api.nvim_get_hl(0, { name = group })
	return hl[attr]
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Buffer & Window Utilities
-- ══════════════════════════════════════════════════════════════════════════════

-- Get all open buffers
function M.get_all_buffers()
	local buffers = {}
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
			table.insert(buffers, buf)
		end
	end
	return buffers
end

-- Get current buffer file type
function M.get_current_filetype()
	return vim.bo.filetype
end

-- Check if current buffer is modified
function M.is_buffer_modified(bufnr)
	bufnr = bufnr or 0
	return vim.bo[bufnr].modified
end

-- ══════════════════════════════════════════════════════════════════════════════
-- LSP Utilities
-- ══════════════════════════════════════════════════════════════════════════════

-- Get LSP clients for current buffer
function M.get_lsp_clients(bufnr)
	bufnr = bufnr or 0
	return vim.lsp.get_clients({ bufnr = bufnr })
end

-- Check if LSP client supports a method
function M.lsp_supports_method(client, method, bufnr)
	if vim.fn.has("nvim-0.11") == 1 then
		return client:supports_method(method, bufnr)
	else
		return client.supports_method(method, { bufnr = bufnr })
	end
end

-- Get active LSP client names
function M.get_active_lsp_names(bufnr)
	local clients = M.get_lsp_clients(bufnr)
	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end
	return names
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Performance Utilities
-- ══════════════════════════════════════════════════════════════════════════════

-- Debounce function calls
function M.debounce(fn, timeout)
	local timer = vim.loop.new_timer()
	return function(...)
		local args = { ... }
		timer:start(timeout, 0, function()
			timer:stop()
			vim.schedule(function()
				fn(unpack(args))
			end)
		end)
	end
end

-- Throttle function calls
function M.throttle(fn, timeout)
	local last_call = 0
	return function(...)
		local now = vim.loop.now()
		if now - last_call > timeout then
			last_call = now
			return fn(...)
		end
	end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- System Integration
-- ══════════════════════════════════════════════════════════════════════════════

-- Execute shell command and return result
function M.execute_command(cmd, cwd)
	local prev_cwd = nil
	if cwd then
		prev_cwd = vim.fn.getcwd()
		vim.cmd("cd " .. cwd)
	end
	
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	
	if prev_cwd then
		vim.cmd("cd " .. prev_cwd)
	end
	
	return result:gsub("\n$", "") -- Remove trailing newline
end

-- Get operating system
function M.get_os()
	local os_name = vim.loop.os_uname().sysname:lower()
	if os_name:match("darwin") then
		return "macos"
	elseif os_name:match("linux") then
		return "linux"
	elseif os_name:match("windows") then
		return "windows"
	else
		return "unknown"
	end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Development & Debugging
-- ══════════════════════════════════════════════════════════════════════════════

-- Pretty print table contents (for debugging)
function M.dump_table(tbl, indent)
	indent = indent or 0
	local spacing = string.rep("  ", indent)
	
	if type(tbl) ~= "table" then
		print(spacing .. tostring(tbl))
		return
	end
	
	for key, value in pairs(tbl) do
		if type(value) == "table" then
			print(spacing .. tostring(key) .. ":")
			M.dump_table(value, indent + 1)
		else
			print(spacing .. tostring(key) .. ": " .. tostring(value))
		end
	end
end

-- Benchmark function execution
function M.benchmark(fn, iterations)
	iterations = iterations or 1
	local start_time = vim.loop.hrtime()
	
	for _ = 1, iterations do
		fn()
	end
	
	local end_time = vim.loop.hrtime()
	local duration = (end_time - start_time) / 1000000 -- Convert to milliseconds
	
	return duration / iterations
end

-- ══════════════════════════════════════════════════════════════════════════════
-- String Utilities
-- ══════════════════════════════════════════════════════════════════════════════

-- Split string by delimiter
function M.split_string(str, delimiter)
	local result = {}
	local pattern = "[^" .. delimiter .. "]+"
	
	for match in str:gmatch(pattern) do
		table.insert(result, match)
	end
	
	return result
end

-- Trim whitespace from string
function M.trim_string(str)
	return str:gsub("^%s*(.-)%s*$", "%1")
end

-- Check if string starts with prefix
function M.starts_with(str, prefix)
	return str:sub(1, #prefix) == prefix
end

-- Check if string ends with suffix  
function M.ends_with(str, suffix)
	return str:sub(-#suffix) == suffix
end

return M