-- ══════════════════════════════════════════════════════════════════════════════
-- Color Scheme Configuration
-- VSCode-inspired theme with transparency support
-- ══════════════════════════════════════════════════════════════════════════════

-- Helper function to enable transparency
local function enable_transparency()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
end

return {
	{
		"Mofiqul/vscode.nvim",
		name = "vscode",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("vscode")
			vim.cmd("hi Directory guibg=NONE")
			vim.cmd("hi SignColumn guibg=NONE")
			enable_transparency()
		end,
	},
}
