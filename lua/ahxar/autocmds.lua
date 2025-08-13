-- ══════════════════════════════════════════════════════════════════════════════
-- Autocommands Configuration
-- Automated behaviors and event-driven functionality
-- ══════════════════════════════════════════════════════════════════════════════

-- ══════════════════════════════════════════════════════════════════════════════
-- Visual Feedback & User Experience
-- ══════════════════════════════════════════════════════════════════════════════

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("ahxar-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 200 })
	end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- File Management & Buffer Behavior
-- ══════════════════════════════════════════════════════════════════════════════

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Remove trailing whitespace on save",
	group = vim.api.nvim_create_augroup("ahxar-trim-whitespace", { clear = true }),
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- Automatically create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Create missing directories when saving",
	group = vim.api.nvim_create_augroup("ahxar-auto-mkdir", { clear = true }),
	callback = function(event)
		local file = vim.loop.fs_realpath(event.match) or event.match
		local dir = vim.fn.fnamemodify(file, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- Window & Layout Management
-- ══════════════════════════════════════════════════════════════════════════════

-- Automatically resize splits when vim is resized
vim.api.nvim_create_autocmd("VimResized", {
	desc = "Automatically resize splits when Neovim window is resized",
	group = vim.api.nvim_create_augroup("ahxar-auto-resize", { clear = true }),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Go to last known cursor position when opening a file",
	group = vim.api.nvim_create_augroup("ahxar-last-position", { clear = true }),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line_count = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- Terminal & External Command Integration
-- ══════════════════════════════════════════════════════════════════════════════

-- Remove line numbers and other UI elements in terminal
vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Disable line numbers in terminal buffers",
	group = vim.api.nvim_create_augroup("ahxar-terminal-no-number", { clear = true }),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- File Type Specific Behaviors
-- ══════════════════════════════════════════════════════════════════════════════

-- Set specific options for different file types
vim.api.nvim_create_autocmd("FileType", {
	desc = "Set file type specific options",
	group = vim.api.nvim_create_augroup("ahxar-filetype-options", { clear = true }),
	pattern = { "gitcommit", "markdown", "text" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.textwidth = 80
	end,
})

-- Use 2 spaces for certain file types
vim.api.nvim_create_autocmd("FileType", {
	desc = "Use 2 spaces for indentation in specific file types",
	group = vim.api.nvim_create_augroup("ahxar-indent-2", { clear = true }),
	pattern = {
		"lua",
		"javascript",
		"typescript",
		"json",
		"yaml",
		"html",
		"css",
		"vue",
		"svelte",
		"jsx",
		"tsx",
		"xml",
	},
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
	end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- Development & Productivity
-- ══════════════════════════════════════════════════════════════════════════════

-- Check for external file changes more frequently
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	desc = "Check for external file changes",
	group = vim.api.nvim_create_augroup("ahxar-checktime", { clear = true }),
	callback = function()
		if vim.api.nvim_get_mode().mode ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

-- Close certain buffer types with q
vim.api.nvim_create_autocmd("FileType", {
	desc = "Close certain buffer types with 'q'",
	group = vim.api.nvim_create_augroup("ahxar-close-with-q", { clear = true }),
	pattern = {
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"checkhealth",
		"fugitive",
		"Jaq",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- Performance & Memory Management
-- ══════════════════════════════════════════════════════════════════════════════

-- Clean up unused buffers periodically (safer implementation)
vim.api.nvim_create_autocmd("BufHidden", {
	desc = "Clean up hidden buffers with no name",
	group = vim.api.nvim_create_augroup("ahxar-cleanup-buffers", { clear = true }),
	callback = function(event)
		-- Only delete if buffer is valid and meets strict criteria
		if
			vim.api.nvim_buf_is_valid(event.buf)
			and vim.api.nvim_buf_get_name(event.buf) == ""
			and vim.bo[event.buf].buftype == ""
			and not vim.bo[event.buf].modified
			and not vim.bo[event.buf].buflisted
			and vim.fn.bufwinnr(event.buf) == -1
		then
			-- Use pcall to safely delete buffer
			pcall(vim.api.nvim_buf_delete, event.buf, { force = false })
		end
	end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- Plugin Integration Helpers
-- ══════════════════════════════════════════════════════════════════════════════

-- Helper function for plugin-specific autocommands
local function create_plugin_autocmd(event, pattern, callback, desc)
	vim.api.nvim_create_autocmd(event, {
		desc = desc or "Plugin-specific autocmd",
		group = vim.api.nvim_create_augroup("ahxar-plugin-" .. tostring(math.random(1000, 9999)), { clear = true }),
		pattern = pattern,
		callback = callback,
	})
end

-- Export helper function for plugins to use
_G.ahxar_create_plugin_autocmd = create_plugin_autocmd
