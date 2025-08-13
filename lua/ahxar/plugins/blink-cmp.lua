-- ══════════════════════════════════════════════════════════════════════════════
-- Blink.cmp - Modern Autocompletion Engine
-- Fast, feature-rich autocompletion with LSP, snippets, and AI integration
-- ══════════════════════════════════════════════════════════════════════════════

return {
	{
		"saghen/blink.cmp",
		event = { "VimEnter" },
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {},
				opts = {},
			},
			"folke/lazydev.nvim",
			"fang2hou/blink-copilot",
		},
		config = function()
			local utils = require("ahxar.utils")

			-- Safely setup blink.cmp with error handling
			local blink = utils.safe_require("blink.cmp")
			if not blink then
				vim.notify("Failed to load blink.cmp", vim.log.levels.ERROR)
				return
			end

			blink.setup({
				keymap = {
					preset = "super-tab",
					["<C-j>"] = { "select_next", "fallback" },
					["<C-k>"] = { "select_prev", "fallback" },
				},

				cmdline = {
					enabled = true,
					completion = { menu = { auto_show = true } },
				},

				appearance = {
					nerd_font_variant = "mono",
				},

				completion = {
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 500,
					},
					list = {
						selection = {
							preselect = true,
							auto_insert = true,
						},
					},
					ghost_text = { enabled = true },
				},

				sources = {
					default = { "lsp", "copilot", "path", "snippets", "lazydev" },
					providers = {
						copilot = {
							module = "blink-copilot",
							score_offset = 10,
							async = true,
						},
						lazydev = {
							module = "lazydev.integrations.blink",
							score_offset = 100,
						},
					},
				},

				snippets = {
					preset = "luasnip",
				},

				fuzzy = {
					implementation = "lua",
				},

				-- Shows a signature help window while you type arguments for a function
				signature = {
					enabled = true,
					-- trigger = { show_on_insert_on_trigger_character = true },
					-- window = { border = "single" },
				},
			})
		end,
	},
}
