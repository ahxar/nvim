-- ══════════════════════════════════════════════════════════════════════════════
-- Snacks.nvim - Collection of Useful Neovim Utilities
-- Dashboard, notifications, terminal, and various UI improvements
-- ══════════════════════════════════════════════════════════════════════════════

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		-- NOTE: Options
		opts = {
			styles = {
				input = {
					keys = {
						n_esc = { "<C-c>", { "cmp_close", "cancel" }, mode = "n", expr = true },
						i_esc = { "<C-c>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
					},
				},
			},
			input = {
				enabled = true,
			},
			dashboard = {
				enabled = true,
				sections = {
					{ section = "header" },
					{ section = "keys" },
					{ section = "startup" },
					{
						section = "terminal",
						cmd = "ascii-image-converter ~/Documents/terminal-bg/pngegg.png -C -c",
						random = 15,
						pane = 2,
						indent = 15,
						height = 20,
					},
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				},
			},
			picker = {},
			explorer = {},
			lazygit = {
				enabled = true,
				-- Configuration for lazygit integration
				config = {
					-- Use a floating window
					win = {
						style = "float",
						border = "rounded",
						title = " Lazygit ",
						title_pos = "center",
						width = 0.9,
						height = 0.9,
					},
					-- Theme configuration to match Neovim
					theme = {
						-- Use the same colorscheme as Neovim
						activeBorderColor = { fg = "blue", bold = true },
						inactiveBorderColor = { fg = "gray" },
						optionsTextColor = { fg = "blue" },
						selectedLineBgColor = { bg = "gray" },
						cherryPickedCommitBgColor = { bg = "cyan" },
						cherryPickedCommitFgColor = { fg = "blue" },
						unstagedChangesColor = { fg = "red" },
						defaultFgColor = { fg = "white" },
					},
				},
			},
		},
		keys = {
			-- ══════════════════════════════════════════════════════════════════════════════
			-- Core Actions (Most Frequently Used)
			-- ══════════════════════════════════════════════════════════════════════════════
			{
				"<leader><space>",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart Find Files",
			},
			{
				"<leader>,",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>e",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},
			{
				"<leader>/",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>n",
				function()
					Snacks.picker.notifications()
				end,
				desc = "Notifications",
			},

			-- ══════════════════════════════════════════════════════════════════════════════
			-- Find Operations (<leader>f) - Alphabetical & Mnemonic
			-- ══════════════════════════════════════════════════════════════════════════════
			{
				"<leader>fc",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config Files",
			},
			{
				"<leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.git_files()
				end,
				desc = "Find Git Files",
			},
			{
				"<leader>fh",
				function()
					Snacks.picker.recent()
				end,
				desc = "Find Recent (History)",
			},
			{
				"<leader>fp",
				function()
					Snacks.picker.projects()
				end,
				desc = "Find Projects",
			},

			-- ══════════════════════════════════════════════════════════════════════════════
			-- Git Operations (<leader>g)
			-- ══════════════════════════════════════════════════════════════════════════════
			{
				"<leader>gb",
				function()
					Snacks.picker.git_branches()
				end,
				desc = "Git Branches",
			},
			{
				"<leader>gd",
				function()
					Snacks.picker.git_diff()
				end,
				desc = "Git Diff (Hunks)",
			},
			{
				"<leader>gf",
				function()
					Snacks.picker.git_log_file()
				end,
				desc = "Git Log File",
			},
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log",
			},
			{
				"<leader>gL",
				function()
					Snacks.picker.git_log_line()
				end,
				desc = "Git Log Line",
			},
			{
				"<leader>gs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git Status",
			},
			{
				"<leader>gS",
				function()
					Snacks.picker.git_stash()
				end,
				desc = "Git Stash",
			},

			-- ══════════════════════════════════════════════════════════════════════════════
			-- Lazygit Integration (<leader>g) - Terminal Git Interface
			-- ══════════════════════════════════════════════════════════════════════════════
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit (Root)",
			},
			{
				"<leader>gG",
				function()
					Snacks.lazygit({ cwd = vim.fn.expand("%:p:h") })
				end,
				desc = "Lazygit (Current File Dir)",
			},
			{
				"<leader>gc",
				function()
					Snacks.lazygit.log()
				end,
				desc = "Lazygit Commits",
			},
			{
				"<leader>gC",
				function()
					Snacks.lazygit.log_file()
				end,
				desc = "Lazygit Current File History",
			},

			-- ══════════════════════════════════════════════════════════════════════════════
			-- Search & Browse Operations (<leader>s) - Specialized Search
			-- ══════════════════════════════════════════════════════════════════════════════
			{
				'<leader>s"',
				function()
					Snacks.picker.registers()
				end,
				desc = "Registers",
			},
			{
				"<leader>s/",
				function()
					Snacks.picker.search_history()
				end,
				desc = "Search History",
			},
			{
				"<leader>sa",
				function()
					Snacks.picker.autocmds()
				end,
				desc = "Autocmds",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sB",
				function()
					Snacks.picker.grep_buffers()
				end,
				desc = "Grep Open Buffers",
			},
			{
				"<leader>sC",
				function()
					Snacks.picker.commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>sd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>sD",
				function()
					Snacks.picker.diagnostics_buffer()
				end,
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>sh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help Pages",
			},
			{
				"<leader>sH",
				function()
					Snacks.picker.highlights()
				end,
				desc = "Highlights",
			},
			{
				"<leader>si",
				function()
					Snacks.picker.icons()
				end,
				desc = "Icons",
			},
			{
				"<leader>sj",
				function()
					Snacks.picker.jumps()
				end,
				desc = "Jumps",
			},
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>sl",
				function()
					Snacks.picker.loclist()
				end,
				desc = "Location List",
			},
			{
				"<leader>sm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>sM",
				function()
					Snacks.picker.man()
				end,
				desc = "Man Pages",
			},
			{
				"<leader>sp",
				function()
					Snacks.picker.lazy()
				end,
				desc = "Search for Plugin Spec",
			},
			{
				"<leader>sq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>sR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},
			{
				"<leader>su",
				function()
					Snacks.picker.undo()
				end,
				desc = "Undo History",
			},
			{
				"<leader>sw",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},

			-- ══════════════════════════════════════════════════════════════════════════════
			-- LSP Operations
			-- ══════════════════════════════════════════════════════════════════════════════
			-- Navigation (g prefix - standard vim patterns)
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Goto Definition",
			},
			{
				"gD",
				function()
					Snacks.picker.lsp_declarations()
				end,
				desc = "Goto Declaration",
			},
			{
				"gI",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
			{
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				desc = "References",
				nowait = true,
			},
			{
				"gy",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			},
			-- Symbol Search (<leader>s prefix)
			{
				"<leader>ss",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "LSP Document Symbols",
			},
			{
				"<leader>sS",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "LSP Workspace Symbols",
			},

			-- ══════════════════════════════════════════════════════════════════════════════
			-- UI Operations (<leader>u)
			-- ══════════════════════════════════════════════════════════════════════════════
			{
				"<leader>uC",
				function()
					Snacks.picker.colorschemes()
				end,
				desc = "Colorschemes",
			},
		},
	},
}
