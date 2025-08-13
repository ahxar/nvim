-- ══════════════════════════════════════════════════════════════════════════════
-- Keybindings Configuration
-- Custom keymaps and shortcuts for improved workflow
-- ══════════════════════════════════════════════════════════════════════════════

-- ══════════════════════════════════════════════════════════════════════════════
-- General Navigation & Movement
-- ══════════════════════════════════════════════════════════════════════════════

-- Window navigation - seamless movement between splits
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Clear search highlights on Escape
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- ══════════════════════════════════════════════════════════════════════════════
-- Text Editing & Manipulation
-- ══════════════════════════════════════════════════════════════════════════════

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better paste behavior - don't overwrite clipboard with deleted text
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without overwriting clipboard" })

-- ══════════════════════════════════════════════════════════════════════════════
-- File & Buffer Management
-- ══════════════════════════════════════════════════════════════════════════════

-- Quick save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all files" })

-- Quick quit
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit current buffer" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all buffers" })

-- Force quit without save
vim.keymap.set("n", "<leader><leader>q", "<cmd>q!<cr>", { desc = "Force quit without saving" })

-- ══════════════════════════════════════════════════════════════════════════════
-- Search & Replace
-- ══════════════════════════════════════════════════════════════════════════════

-- Better search - center cursor and open folds
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Replace word under cursor
vim.keymap.set(
	"n",
	"<leader>rw",
	":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
	{ desc = "Replace word under cursor" }
)

-- ══════════════════════════════════════════════════════════════════════════════
-- Development & Utilities
-- ══════════════════════════════════════════════════════════════════════════════

-- Reload configuration for development
vim.keymap.set("n", "<leader><leader>r", function()
	require("ahxar").reload()
end, { desc = "Reload Neovim configuration" })

-- Toggle relative line numbers
vim.keymap.set("n", "<leader>tn", function()
	vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle relative line numbers" })

-- Toggle word wrap
vim.keymap.set("n", "<leader>tw", function()
	vim.o.wrap = not vim.o.wrap
end, { desc = "Toggle word wrap" })

-- ══════════════════════════════════════════════════════════════════════════════
-- System Integration
-- ══════════════════════════════════════════════════════════════════════════════

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })

-- Paste from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>P", '"+p', { desc = "Paste from system clipboard" })

-- Delete to void register (don't overwrite clipboard)
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void register" })

-- ══════════════════════════════════════════════════════════════════════════════
-- Quick Access Commands
-- ══════════════════════════════════════════════════════════════════════════════

-- Open configuration file
vim.keymap.set("n", "<leader>ce", "<cmd>e $MYVIMRC<cr>", { desc = "Edit configuration" })

-- Source configuration file
vim.keymap.set("n", "<leader>cs", "<cmd>source $MYVIMRC<cr>", { desc = "Source configuration" })

-- Open lazy plugin manager
vim.keymap.set("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Open Lazy plugin manager" })

-- Open Mason LSP installer
vim.keymap.set("n", "<leader>pm", "<cmd>Mason<cr>", { desc = "Open Mason LSP installer" })

-- Health check
vim.keymap.set("n", "<leader>ch", "<cmd>checkhealth<cr>", { desc = "Run health check" })

-- Custom health check for this configuration
vim.keymap.set("n", "<leader>ca", function()
	require("ahxar").health()
end, { desc = "Check Ahxar config health" })

-- ══════════════════════════════════════════════════════════════════════════════
-- Terminal Integration
-- ══════════════════════════════════════════════════════════════════════════════

-- Better terminal navigation
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Move to left window from terminal" })
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Move to bottom window from terminal" })
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Move to top window from terminal" })
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Move to right window from terminal" })

-- Open terminal in various ways
vim.keymap.set("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Open terminal in current buffer" })
vim.keymap.set("n", "<leader>ts", "<cmd>split | terminal<cr>", { desc = "Open terminal in horizontal split" })
vim.keymap.set("n", "<leader>tv", "<cmd>vsplit | terminal<cr>", { desc = "Open terminal in vertical split" })

-- ══════════════════════════════════════════════════════════════════════════════
-- Text Objects & Selection
-- ══════════════════════════════════════════════════════════════════════════════

-- Select all content
vim.keymap.set("n", "<leader>a", "ggVG", { desc = "Select all content" })

-- Better line beginning/end
vim.keymap.set({ "n", "v" }, "H", "^", { desc = "Go to first non-blank character" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "Go to end of line" })

-- Join lines while keeping cursor position
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (keep cursor position)" })

-- ══════════════════════════════════════════════════════════════════════════════
-- Plugin-specific keymaps are defined in their respective plugin configuration files
-- This file focuses on core Neovim functionality and general workflow improvements
-- ══════════════════════════════════════════════════════════════════════════════
