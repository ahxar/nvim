return {
	{
		"captbaritone/better-indent-support-for-php-with-html",
		ft = { "php", "html" },
	},
	{
		"ojroques/vim-oscyank",
		event = "TextYankPost",
	},
	{
		"kkoomen/vim-doge",
		build = ":call doge#install()",
		cmd = { "DogeGenerate", "DogeCreateDocStandard" },
		ft = { "python", "php", "javascript", "typescript", "lua" },
	},
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gdiff", "Gwrite", "Gread", "Gstatus", "Gblame", "Glog" },
	},
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
		},
	},
	{
		"nvim-lua/plenary.nvim",
		keys = {
			{ "<Esc>", "<cmd>nohlsearch<cr>", mode = "n", desc = "Clear search highlights" },
		},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		ft = { "css", "scss", "html", "javascript", "typescript", "vue", "svelte" },
		config = function()
			require("nvim-highlight-colors").setup({
				render = "background",
				enable_named_colors = true,
				enable_tailwind = true,
			})
		end,
	},
}
