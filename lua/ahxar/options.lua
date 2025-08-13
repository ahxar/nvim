-- ══════════════════════════════════════════════════════════════════════════════
-- Leader Keys - Must be set before plugins load
-- ══════════════════════════════════════════════════════════════════════════════
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ══════════════════════════════════════════════════════════════════════════════
-- Display & UI Settings
-- ══════════════════════════════════════════════════════════════════════════════
vim.o.number = true
vim.o.relativenumber = true
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.scrolloff = 8
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd("let g:netrw_banner = 0")

-- ══════════════════════════════════════════════════════════════════════════════
-- Mouse & Input
-- ══════════════════════════════════════════════════════════════════════════════
vim.o.mouse = "a"

-- ══════════════════════════════════════════════════════════════════════════════
-- Indentation & Formatting
-- ══════════════════════════════════════════════════════════════════════════════
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.breakindent = true
vim.o.wrap = false
vim.opt.backspace = { "start", "eol", "indent" }

-- ══════════════════════════════════════════════════════════════════════════════
-- Search Settings
-- ══════════════════════════════════════════════════════════════════════════════
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.inccommand = "split"

-- ══════════════════════════════════════════════════════════════════════════════
-- Window & Split Management
-- ══════════════════════════════════════════════════════════════════════════════
vim.o.splitright = true
vim.o.splitbelow = true


-- ══════════════════════════════════════════════════════════════════════════════
-- File & Backup Settings
-- ══════════════════════════════════════════════════════════════════════════════
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true
vim.g.editorconfig = true

