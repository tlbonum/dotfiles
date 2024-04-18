vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.bo.softtabstop = 2
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.wo.relativenumber = true

-- vim.opt.shortmess = "o"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.completeopt = "menuone,noselect"
vim.opt.termguicolors = true
vim.opt.scrolloff = 4
vim.opt.laststatus = 2
vim.opt.cmdheight = 0
vim.opt.mouse = "a"
vim.opt.breakindent = true
vim.opt.smartcase = true
vim.opt.ignorecase = true -- case-insensitive searching unless \c or capital in search
vim.opt.undofile = true -- save undo history
vim.opt.clipboard = "unnamedplus" -- sync clipboard between os and neovim.
vim.opt.guifont = "berkeley mono:h12.5" -- applies to neovide or the like

vim.opt.inccommand = "split" -- substitution preview
vim.opt.linespace = 2
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = {
	tab = "→ ",
	lead = "·",
	trail = "·",
	nbsp = "␣",
}

-- Disable automatic comment continuation for line comments
-- vim.o.comments = "s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-,fb:•"
-- vim.o.comments = "-://"

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local wr_group = vim.api.nvim_create_augroup("WinResize", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
	group = wr_group,
	pattern = "*",
	command = "wincmd =",
	desc = "Automatically resize windows when the host window size changes.",
})

function SpellToggle()
	if vim.opt.spell:get() then
		vim.opt_local.spell = false
		vim.opt_local.spelllang = "en"
	else
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "en_us", "de" }
	end
end

-- local DIAG_SIGNS = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
local DIAG_SIGNS = { Error = " ", Warn = " ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(DIAG_SIGNS) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

function _G.diag_statusline()
	local out = ""
	local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	if errors > 0 then
		out = out .. "%#Error#" .. errors .. " " .. DIAG_SIGNS.Error
	end
	local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	if warnings > 0 then
		out = out .. "%#WarningMsg#" .. warnings .. " " .. DIAG_SIGNS.Warn
	end
	local infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	if infos > 0 then
		out = out .. "%#InfoMsg#" .. infos .. " " .. DIAG_SIGNS.Info
	end
	local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	if hints > 0 then
		out = out .. "%#DiagnosticSignHint#" .. hints .. " " .. DIAG_SIGNS.Hint
	end
	return out
end

-- vim.opt.statusline = "%<%f %h%m%r%=%-14.(%l,%c%V%) %P %y"
-- local fileencoding = " %{&fileencoding?&fileencoding:&encoding}"
-- local fileformat = " [%{&fileformat}]"
-- local percentage = " %p%%"
local base_color = "%#StatusLine#"
local modified_color = "%#TodoFgWARN#"
local file_name = "%f"
local modified = "%m"
local readOnly = "%r"
local help = "%h"
local align_right = "%="
local linecol = "%-3l:%-2c"
local filetype = "%y"
local diag_statusline = "%{%v:lua.diag_statusline()%}"

--stylua: ignore
vim.opt.statusline = string.format(
	"%s%s%s%s%s %s %s%s %s%s %s",
	modified_color, modified,
	base_color, readOnly, help, file_name,
	align_right,
	diag_statusline,
	base_color, linecol, filetype
)

-- Automatically show diagnostic on mouseover
-- vim.api.nvim_create_autocmd({ "CursorHold" }, {
--   callback = function()
--     vim.diagnostic.open_float()
--   end
-- })

local diag_config = {
	virtual_text = { prefix = "●" },
	-- These are defaults
	-- virtual_text = true,
	-- float = false,
	-- underline = false
}

vim.diagnostic.config(diag_config)

vim.keymap.set("n", "<leader>xo", function()
	local opt = vim.diagnostic.config()
	if opt == nil or opt.virtual_text == false then
		opt = diag_config
	else
		opt.virtual_text = false
	end
	vim.diagnostic.config(opt)
end, { desc = "toggle diagnostic virtual text" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "prev diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "diagnostic m[e]ssage" })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set("n", "<Char-0xAA>", "<cmd>write<cr>", { desc = "save file" })
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Don't immediately jump to the next occurrence during searches
vim.api.nvim_set_keymap("n", "*", ":keepjumps normal! mi*`i<CR>", { noremap = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set({ "n", "v", "i" }, "<A-z>", ":set nowrap!<CR>", { desc = "toggle line wrap" })

vim.keymap.set("n", "<M-T>", "<CMD>vs<bar>:b#<CR>", { desc = "reopen last split" })

-- Create splits
vim.keymap.set({ "n", "v", "i" }, "<A-v>", "<cmd>vs<cr>", { desc = "vertical split" })
vim.keymap.set({ "n", "v", "i" }, "<A-s>", "<cmd>sp<cr>", { desc = "horizontal split" })

vim.keymap.set("n", "<A-q>", "<cmd>q<cr>", { desc = "close buffer" })

-- Cycle between buffers
-- vim.keymap.set("n", "<TAB>", ":bn<CR>")
-- vim.keymap.set("n", "<S-TAB>", ":bp<CR>")
-- vim.keymap.set("n", "<leader>bd", ":bd<CR>") -- from Doom Emacs

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv", { desc = "center on search" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "center on search" })

vim.keymap.set("n", "<A-w>", "<C-w>", { desc = "manage windows" })

vim.keymap.set({ "n", "v" }, "J", "5j")
vim.keymap.set({ "n", "v" }, "K", "5k")

-- vim.keymap.set({ 'n', 'v' }, '<C-E>', "5<C-e>")
-- vim.keymap.set({ 'n', 'v' }, '<C-Y>', "5<C-y>")

vim.keymap.set({ "n", "v" }, "G", "Gzz")

vim.keymap.set({ "n", "v" }, "<A-j>", "5jzz")
vim.keymap.set({ "n", "v" }, "<A-k>", "5kzz")

vim.keymap.set({ "n", "v" }, "<C-j>", "jzz")
vim.keymap.set({ "n", "v" }, "<C-k>", "kzz")

-- Keep selection when moving
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Keep selection when indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "zh", "zH", { desc = "move screen left" })
vim.keymap.set("n", "zl", "zL", { desc = "move screen right" })

-- Prevent x and c from filling up register
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "c", '"_c')

vim.keymap.set("n", "zu", "zMzO", {
	desc = "fold all except cursor",
	silent = true,
	noremap = true,
})

-- Prevent empty-line dd from filling up register
vim.keymap.set("n", "dd", function()
	if vim.fn.getline(".") == "" then
		return '"_dd'
	end
	return "dd"
end, { expr = true })

-- Copy file info

vim.keymap.set("n", "<leader>fy", [[:lua vim.fn.setreg('+', vim.fn.expand('%'))<CR>]], {
	noremap = true,
	silent = true,
	desc = "Copy current filepath relative",
})

vim.keymap.set("n", "<leader>fY", [[:lua vim.fn.setreg('+', vim.fn.expand('%:p'))<CR>]], {
	noremap = true,
	silent = true,
	desc = "Copy current filepath full",
})

vim.keymap.set("n", "<leader>fn", [[:lua vim.fn.setreg('+', vim.fn.expand('%:t'))<CR>]], {
	noremap = true,
	silent = true,
	desc = "Copy current file name",
})

-- json
vim.keymap.set("", "<leader>cje", ":'<,'>!jq '. | tostring'<CR>", { noremap = true, silent = true, desc = "[j]son [e]ncode selection" })
vim.keymap.set("", "<leader>cjE", ":%!jq '. | tostring'<CR>", { noremap = true, silent = true, desc = "[j]son [e]ncode buffer" })
vim.keymap.set("", "<leader>cjd", ":'<,'>!jq '. | fromjson'<CR>", { noremap = true, silent = true, desc = "[j]son [d]ecode selection" })
vim.keymap.set("", "<leader>cjD", ":%!jq '. | fromjson'<CR>", { noremap = true, silent = true, desc = "[j]son [d]ecode buffer" })

-- url
vim.keymap.set("", "<leader>cue", ":'<,'>!jq -sRr @uri<CR>", { noremap = true, silent = true, desc = "[u]rl [e]ncode selection" })
vim.keymap.set("", "<leader>cuE", ":%!jq -sRr @uri<CR>", { noremap = true, silent = true, desc = "[u]rl [e]ncode buffer" })
-- vim.keymap.set("", "<leader>cud", ":'<,'>!perl -MHTML::Entities -pe 'decode_entities($_)'<CR>", { noremap = true, silent = true, desc = "[u]rl [d]ecode selection" })
-- vim.keymap.set("", "<leader>cuD", ":%!perl -MHTML::Entities -pe 'decode_entities($_)'<CR>", { noremap = true, silent = true, desc = "[u]rl [d]ecode buffer" })

-- base64
vim.keymap.set("", "<leader>cbe", ":'<,'>!base64<CR>", { noremap = true, silent = true, desc = "[b]ase64 [e]ncode selection" })
vim.keymap.set("", "<leader>cbE", ":%!base64<CR>", { noremap = true, silent = true, desc = "[b]ase64 [e]ncode buffer" })
vim.keymap.set("", "<leader>cbd", ":'<,'>!base64 --decode<CR>", { noremap = true, silent = true, desc = "[b]ase64 [d]ecode selection" })
vim.keymap.set("", "<leader>cbD", ":%!base64 --decode<CR>", { noremap = true, silent = true, desc = "[b]ase64 [d]ecode buffer" })

-- the line beneath this is called `modeline`. see `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "exit terminal mode" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "clear highlight" })

-- Shift line upwards
-- vim.keymap.set("n", "J", "mzJ`z")

-- Navigate splits
-- vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<CR>")
-- vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<CR>")
-- vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<CR>")
-- vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<CR>")

-- Resize splits
-- vim.keymap.set("n", "<C-Up>", ":resize -2<CR>")
-- vim.keymap.set("n", "<C-Down>", ":resize +2<CR>")
-- vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
-- vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")
-- vim.keymap.set("t", "<C-Up>", "<cmd>resize -2<CR>")
-- vim.keymap.set("t", "<C-Down>", "<cmd>resize +2<CR>")
-- vim.keymap.set("t", "<C-Left>", "<cmd>vertical resize -2<CR>")
-- vim.keymap.set("t", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- Move lines
-- vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "move line down" })
-- vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "move line up" })
-- vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "move line down" })
-- vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "move line up" })
-- vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "move line down" })
-- vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "move line up" })

vim.g["test#pane"] = ""
vim.g["test#prev_cmd"] = ""

local function pane(cmd, dir)
	dir = dir or "right"
	vim.system({ "wezterm", "cli", "get-pane-direction", dir }, { text = true }, function(p1)
		if p1.code ~= 0 then
			print("err: " .. p1.stderr)
		else
			vim.g["test#pane"] = p1.stdout:gsub("%s+", "")
			if cmd ~= "clear" then
				vim.g["test#prev_cmd"] = cmd
			end
		end

		if vim.g["test#pane"] == "" then
			vim.system({
				"wezterm",
				"cli",
				"split-pane",
				"--horizontal",
				"--cells=80",
				"--",
				"/opt/homebrew/bin/fish",
				"-C",
				cmd,
			}, { text = true }, function(p2)
				if p2.code ~= 0 then
					print("err: " .. p2.stderr)
				end
			end)
		else
			os.execute('echo "' .. cmd .. '" | wezterm cli send-text --no-paste --pane-id=' .. vim.g["test#pane"])
		end
	end)
end

vim.keymap.set("n", "<leader>tc", function()
	pane("gotestsum --format=standard-verbose -- " .. vim.fn.expand("%") .. " -run " .. vim.fn.expand("<cword>"))
end, { desc = "[t]est [c]ursor" })

vim.keymap.set("n", "<leader>tC", function()
	pane("gotestsum --format=standard-verbose --watch -- " .. vim.fn.expand("%") .. " -run " .. vim.fn.expand("<cword>"))
end, { desc = "[t]est [C]ursor watch" })

vim.keymap.set("n", "<leader>tf", function()
	pane("gotestsum --format=standard-verbose -- " .. vim.fn.expand("%"))
end, { desc = "[t]est [f]ile" })

-- vim.keymap.set("n", "<leader>tF", function()
-- 	pane("gotestsum --format=standard-verbose --watch -- " .. vim.fn.expand("%"))
-- end, { desc = "[t]est [f]ile watch" })

vim.keymap.set("n", "<leader>td", function()
	pane("gotestsum --format=standard-verbose -- " .. vim.fn.expand("%:h"))
end, { desc = "[t]est [d]irectory" })

vim.keymap.set("n", "<leader>tD", function()
	pane("gotestsum --format=standard-verbose --watch -- " .. vim.fn.expand("%:h"))
end, { desc = "[t]est [d]irectory watch" })

vim.keymap.set("n", "<leader>tq", function()
	if vim.g["test#pane"] == "" then
		return
	end
	os.execute("wezterm cli kill-pane --pane-id=" .. vim.g["test#pane"])
	vim.g["test#pane"] = ""
end, { desc = "[t]est [q]uit" })

vim.keymap.set("n", "<leader>tx", function()
	pane("clear")
end, { desc = "[t]est clear" })

vim.keymap.set("n", "<leader>tr", function()
	local cmd = vim.g["test#prev_cmd"]
	if cmd ~= "" then
		pane(cmd)
	end
end, { desc = "[t]est [r]e-run" })

local function border(hl_name)
	return {
		{ "╭", hl_name },
		{ "─", hl_name },
		{ "╮", hl_name },
		{ "│", hl_name },
		{ "╯", hl_name },
		{ "─", hl_name },
		{ "╰", hl_name },
		{ "│", hl_name },
	}
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	"tpope/vim-unimpaired",

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"j-hui/fidget.nvim",
				opts = {
					notification = {
						window = {
							winblend = 0,
						},
					},
				},
			},
			"folke/neodev.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(mode, keys, func, desc)
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
					end

					local builtin = require("telescope.builtin")
					-- map("n", "<leader>gd", builtin.lsp_definitions, "[g]oto [d]efinition")
					-- map("n", "<leader>gt", builtin.lsp_type_definitions, "[g]oto [t]ype")
					-- map("n", "<leader>gs", builtin.lsp_document_symbols, "document [s]ymbols")
					-- map("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")
					-- map("n", "<leader>gr", builtin.lsp_references, "[g]oto [r]eferences")
					-- map("n", "<leader>gi", builtin.lsp_implementations, "[g]oto [i]mplementation")

					map("n", "gD", builtin.lsp_definitions, "[g]oto [d]efinition")
					map("n", "gT", builtin.lsp_type_definitions, "[g]oto [t]ype")
					-- map("n", "wS", builtin.lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")
					map("n", "gs", builtin.lsp_document_symbols, "document [s]ymbols")
					map("n", "gr", builtin.lsp_references, "[g]oto [r]eferences")

					-- FIX: possibly conflict mapping?
					map("n", "gi", builtin.lsp_implementations, "[g]oto [i]mplementation")

					-- map({ "n", "i" }, "<Char-0xAB>", "<CMD>Lspsaga hover_doc<CR>", "hover help")
					map({ "n", "i" }, "<Char-0xAB>", vim.lsp.buf.hover, "hover help")
					map({ "n", "i" }, "<Char-0xAC>", vim.lsp.buf.signature_help, "signature help")

					-- map("n", "gD", "<CMD>Glance definitions<CR>", "[g]lance [D]efinition")
					-- map("n", "gT", "<CMD>Glance type_definitions<CR>", "[g]lance [T]ype")
					-- map("n", "gR", "<CMD>Glance references<CR>", "[g]lance [R]ereferences")
					-- map("n", "gI", "<CMD>Glance implementations<CR>", "[g]lance [I]mplementations")

					map("n", "gd", ":Lspsaga peek_definition<CR>", "[g]oto [d]efinition")
					-- map("n", "gd", vim.lsp.buf.definition, "[g]oto [d]efinition")
					map("n", "gt", ":Lspsaga peek_type_definition<CR>", "[g]oto [t]ype definition")
					-- map("n", "gt", vim.lsp.buf.type_definition, "[g]oto [t]ype")
					-- map("n", "gr", vim.lsp.buf.references, "[g]oto [r]eference")
					-- map("n", "gi", vim.lsp.buf.implementation, "[g]oto [i]mplementation")
					map("n", "gl", vim.lsp.buf.declaration, "[g]oto dec[l]aration")

					map("n", "<leader>cr", vim.lsp.buf.rename, "[r]ename")
					map("n", "<leader>ca", vim.lsp.buf.code_action, "[a]ction")

					map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[w]orkspace [a]dd folder")
					map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[w]orkspace [r]emove folder")
					map("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, "[w]orkspace [l]ist folders")

					vim.api.nvim_buf_create_user_command(event.buf, "Format", vim.lsp.buf.format, { desc = "format buffer" })

					-- local client = vim.lsp.get_client_by_id(event.data.client_id)
					-- if client and client.server_capabilities.documentHighlightProvider then
					--   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
					--     buffer = event.buf,
					--     callback = vim.lsp.buf.document_highlight,
					--   })
					--
					--   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
					--     buffer = event.buf,
					--     callback = vim.lsp.buf.clear_references,
					--   })
					-- end

					-- client.server_capabilities.documentFormattingProvider = false
					-- client.server_capabilities.documentRangeFormattingProvider = false
					-- if vim.lsp.inlay_hint then
					--   vim.lsp.inlay_hint.enable(buffer, true)
					-- end

					map("n", "<leader>co", vim.lsp.codelens.run, "codelens run")
					map("n", "<leader>cl", function()
						vim.lsp.codelens.refresh({ bufnr = event.buf })
					end, "codelens refresh")
					map("n", "<leader>cL", function()
						vim.lsp.codelens.clear(event.data.client_id, event.buf)
					end, "codelens clear")
				end,
			})

			if vim.lsp.inlay_hint then
				vim.keymap.set("n", "<leader>ch", function()
					local hints = vim.lsp.inlay_hint
					hints.enable(0, not hints.is_enabled())
				end, { desc = "[h]ints (inlay)" })
			end

			local servers = {
				clangd = {},
				pyright = {},
				rust_analyzer = {},
				gopls = {
					settings = {
						gopls = {
							expandWorkspaceToModule = true,
							completeUnimported = true,
							usePlaceholders = true,
							experimentalPostfixCompletions = true,
							staticcheck = true,
							analyses = {
								unreachable = true,
								unusedparams = true,
								shadow = true,
							},
							codelenses = {
								gc_details = true,
								generate = true,
								regenerate_cgo = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralType = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				},
				tsserver = {
					settings = {
						typescript = {
							inlayHints = {
								includeInlayEnumMemberValueHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = true, -- false
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = true, -- false
							},
						},
						javascript = {
							inlayHints = {
								includeInlayEnumMemberValueHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = true,
							},
						},
					},
				},
				eslint = {},
				html = { filetypes = { "html", "twig", "hbs" } },
				yamlls = {},
				terraformls = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							completion = { callSnippet = "Replace" },
							telemetry = { enable = false },
							hint = { enable = true },
							workspace = {
								checkThirdParty = false,
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
						},
					},
				},
			}

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			local floatBorder = border("FloatBorder")
			local lspconfig = require("lspconfig")
			local ensure_installed = vim.list_extend(vim.tbl_keys(servers), { "stylua" })

			local handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
					border = floatBorder,
				}),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
					border = floatBorder,
				}),
			}

			require("mason").setup({ ui = { border = "single" } })
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local config = servers[server_name]
						if not config then
							return
						end

						-- FIX: the following breaks LSP stuff like usePlaceholders:
						-- if config.capabilities then
						-- 	config.capabilities = vim.tbl_deep_extend("force", config.capabilities, capabilities)
						-- end
						-- if config.handlers then
						-- 	config.handlers = vim.tbl_deep_extend("force", config.handlers, handlers)
						-- end

						config.capabilities = capabilities
						config.handlers = handlers

						lspconfig[server_name].setup(config)
					end,
				},
			})

			-- require("neodev").setup({
			-- 	library = {
			-- 		plugins = { "neotest" },
			-- 		types = true,
			-- 	},
			-- })

			-- To instead override globally
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			---@diagnostic disable-next-line: duplicate-set-field
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or floatBorder
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end
		end,
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		-- stylua: ignore
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			vim.keymap.set("n", "<M-a>", function() harpoon:list():append() end)
			vim.keymap.set("n", "<M-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

			vim.keymap.set("n", "<M-1>", function() harpoon:list():select(1) end)
			vim.keymap.set("n", "<M-2>", function() harpoon:list():select(2) end)
			vim.keymap.set("n", "<M-3>", function() harpoon:list():select(3) end)
			vim.keymap.set("n", "<M-4>", function() harpoon:list():select(4) end)
			vim.keymap.set("n", "<M-5>", function() harpoon:list():select(5) end)
			vim.keymap.set("n", "<M-6>", function() harpoon:list():select(6) end)

			vim.keymap.set("n", "<M-p>", function() harpoon:list():prev() end)
			vim.keymap.set("n", "<M-n>", function() harpoon:list():next() end)

			harpoon:extend({
				UI_CREATE = function(cx)
					vim.keymap.set("n", "<C-v>", function()
						harpoon.ui:select_menu_item({ vsplit = true })
					end, { buffer = cx.bufnr })

					vim.keymap.set("n", "<C-x>", function()
						harpoon.ui:select_menu_item({ split = true })
					end, { buffer = cx.bufnr })

					vim.keymap.set("n", "<C-t>", function()
						harpoon.ui:select_menu_item({ tabedit = true })
					end, { buffer = cx.bufnr })
				end,
			})
		end,
	},

	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
		-- stylua: ignore
		init = function()
			vim.g.codeium_disable_bindings = 1
			vim.g.codeium_manual = true

			vim.keymap.set("n", "<leader>cc", "<CMD>Codeium Toggle<CR>", { desc = "[c]odium toggle" })
			vim.keymap.set("i", "<M-i>", function() return vim.fn["codeium#Complete"]() end, { expr = true, desc = "codeium trigger" })
			vim.keymap.set("i", "<M-y>", function() return vim.fn["codeium#Accept"]() end, { expr = true, desc = "codeium accept" })
			vim.keymap.set("i", "<M-n>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, desc = "codeium next" })
			vim.keymap.set("i", "<M-p>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, desc = "codeium prev" })
			vim.keymap.set("i", "<M-c>", function() return vim.fn["codeium#Clear"]() end, { expr = true, desc = "codeium clear" })

			-- source: https://github.com/Exafunction/codeium.vim/issues/27
			local expr_opts = {
				noremap = true,
				silent = true,
				expr = true,
				-- With expr = true, replace_keycodes is set to true. See https://github.com/orgs/community/discussions/29817
				-- We need to set it to false to avoid extraneous characters when accepting a suggestion.
				replace_keycodes = false,
			}

			local function getCodeiumCompletions()
				local status, completion = pcall(function()
					return vim.api.nvim_eval("b:_codeium_completions.items[b:_codeium_completions.index].completionParts[0].text")
				end)
				if status then
					return completion
				else
					return ""
				end
			end

			local function accept_one_line()
				local text = getCodeiumCompletions()
				return vim.fn.split(text, [[[\n]\zs]])[1] .. "\n"
			end

			local function accept_one_word()
				local text = getCodeiumCompletions()
				return vim.fn.split(text, [[\(\w\+\|\W\+\)\zs]])[1]
			end

			vim.keymap.set("i", "<M-d>", accept_one_line, expr_opts)
			vim.keymap.set("i", "<M-f>", accept_one_word, expr_opts)

			-- Line completion
			-- vim.keymap.set('i', '<M-d>', function()
			--   local fullCompletion = vim.api.nvim_eval(
			--     "b:_codeium_completions.items[b:_codeium_completions.index].completionParts[0].text"
			--   )
			--   local cursor = vim.api.nvim_win_get_cursor(0)
			--   local line = vim.api.nvim_get_current_line()
			--   local completion = string.gsub(fullCompletion, '\n.*$', '')
			--   if (completion ~= '') then
			--     vim.defer_fn(function()
			--       local nline = line:sub(0, cursor[2]) .. completion .. line:sub(cursor[2] + 1)
			--       vim.api.nvim_set_current_line(nline)
			--       vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #completion })
			--       print('pre enter ' .. vim.inspect(cursor))
			--       vim.api.nvim_feedkeys('\n', 'i', true)
			--     end, 0)
			--   end
			-- end, { expr = true })
			--
			-- -- Word completion
			-- vim.keymap.set('i', '<M-f>', function()
			--   local fullCompletion = vim.api.nvim_eval(
			--     "b:_codeium_completions.items[b:_codeium_completions.index].completionParts[0].text"
			--   )
			--   local cursor = vim.api.nvim_win_get_cursor(0)
			--   local line = vim.api.nvim_get_current_line()
			--   local completion = string.match(fullCompletion, '[ ,;.]*[^ ,;.]+')
			--   vim.defer_fn(function()
			--     if (string.match(completion, '^\t')) then
			--       vim.api.nvim_buf_set_lines(0, cursor[1], cursor[1], true, { completion })
			--       vim.api.nvim_win_set_cursor(0, { cursor[1] + 1, #completion })
			--     else
			--       local nline = line:sub(0, cursor[2]) .. completion .. line:sub(cursor[2] + 1)
			--       vim.api.nvim_set_current_line(nline)
			--       vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #completion })
			--     end
			--   end, 0)
			-- end, { expr = true })
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		---@diagnostic disable-next-line: assign-type-mismatch
		version = false,
		event = "VimEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets
					-- This step is not supported in many windows environments
					-- Remove the below condition to re-enable on windows
					if vim.fn.has("win32") == 1 then
						return
					end
					return "make install_jsregexp"
				end)(),
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"rafamadriz/friendly-snippets",
			-- "chrisgrieser/cmp_yanky",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			luasnip.config.setup()

			local ELLIPSIS_CHAR = "…"
			local MAX_LABEL_WIDTH = 20
			local MIN_LABEL_WIDTH = 20

			cmp.setup({
				performance = {
					max_view_entries = 15,
				},
				experimental = {
					ghost_text = true,
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert,noselect" },
				window = {
					completion = {
						border = border("CmpBorder"),
						-- scrollbar = false
					},
					documentation = {
						border = border("CmpDocBorder"),
						-- scrollbar = false
					},
				},
				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(_, vim_item)
						local label = vim_item.abbr
						if label == nil then
							return vim_item
						end

						local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
						if truncated_label ~= label then
							vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
						elseif string.len(label) < MIN_LABEL_WIDTH then
							local padding = string.rep(" ", MIN_LABEL_WIDTH - string.len(label))
							vim_item.abbr = label .. padding
						end

						return vim_item
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<Char-0xAF>"] = cmp.mapping.complete(), -- CMD-Enter
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),

					["<M-n>"] = cmp.mapping.select_next_item(),
					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<M-p>"] = cmp.mapping.select_prev_item(),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),

					-- ["<Tab>"] = cmp.mapping(function(fallback)
					-- 	if cmp.visible() then
					-- 		cmp.select_next_item()
					-- 	elseif luasnip.expand_or_locally_jumpable() then
					-- 		luasnip.expand_or_jump()
					-- 	else
					-- 		fallback()
					-- 	end
					-- end, { "i", "s" }),
					-- ["<S-Tab>"] = cmp.mapping(function(fallback)
					-- 	if cmp.visible() then
					-- 		cmp.select_prev_item()
					-- 	elseif luasnip.locally_jumpable(-1) then
					-- 		luasnip.jump(-1)
					-- 	else
					-- 		fallback()
					-- 	end
					-- end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					-- { name = "luasnip", keyword_length = 2 },
					{ name = "luasnip" },
					{ name = "path" },
					-- { name = "cmp_yanky" },
				},
			})
		end,
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
			local wk = require("which-key")

			wk.register({
				["gc"] = "line comment",
				["gb"] = "block comment",
				["g>"] = "comment region",
				["g>c"] = "add line comment",
				["g>b"] = "add block comment",
				["g<lt>"] = "uncomment region",
				["g<lt>c"] = "remove line comment",
				["g<lt>b"] = "remove block comment",
			}, { mode = "n" })

			wk.register({
				["g>"] = "comment region",
				["g<lt>"] = "uncomment region",
			}, { mode = "x" })
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VimEnter",
		config = function()
			local wk = require("which-key")

			wk.setup({
				window = {
					border = "single",
				},
				layout = {
					height = { max = 50 },
					spacing = 1,
				},
			})

			wk.register({
				["<leader>c"] = { name = "[c]ode", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[d]ebugger", _ = "which_key_ignore" },
				["<leader>g"] = { name = "[g]oto", _ = "which_key_ignore" },
				["<leader>h"] = { name = "[h]unk/git", _ = "which_key_ignore" },
				["<leader>s"] = { name = "[s]earch", _ = "which_key_ignore" },
				["<leader>f"] = { name = "[f]ile", _ = "which_key_ignore" },
				["<leader>t"] = { name = "[t]est", _ = "which_key_ignore" },
				["<leader>w"] = { name = "[w]orkspace", _ = "which_key_ignore" },
				["<leader>x"] = { name = "trouble", _ = "which_key_ignore" },
				["<leader>cj"] = { name = "json", _ = "which_key_ignore" },
				["<leader>cu"] = { name = "url", _ = "which_key_ignore" },
				["<leader>cb"] = { name = "base64", _ = "which_key_ignore" },
				["<M-w>"] = { name = "manage [w]indows", _ = "which_key_ignore" },
			})

			wk.register({
				["<leader>"] = { name = "visual <leader>" },
				["<leader>h"] = { "[h]unk/git" },
				["<leader>cj"] = { name = "json", _ = "which_key_ignore" },
				["<leader>cu"] = { name = "url", _ = "which_key_ignore" },
				["<leader>cb"] = { name = "base64", _ = "which_key_ignore" },
			}, { mode = "v" })
		end,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				term_colors = true,
				transparent_background = true,
				integrations = {
					lsp_saga = true,
					gitsigns = true,
					treesitter = true,
					markdown = true,
					fidget = true,
					mason = true,
					-- neotest = true,
					telescope = {
						enabled = true,
						style = "nvchad",
					},
					indent_blankline = {
						enabled = false,
						scope_color = "surface1", -- text
					},
					illuminate = true,
					dropbar = {
						enabled = true,
						color_mode = true,
					},
					lsp_trouble = true,
					-- which_key = true
				},
				color_overrides = {
					mocha = {
						rosewater = "#ebc0b8", -- "#f5e0dc",
						flamingo = "#e9aaaa", -- "#f2cdcd",
						pink = "#ef9cd8", -- "#f5c2e7",
						mauve = "#b580f4", -- "#cba6f7",
						red = "#ef688e", -- "#f38ba8",
						maroon = "#e47f8f", -- "#eba0ac",
						peach = "#f89c62", -- "#fab387",
						yellow = "#f6d488", -- "#f9e2af",
						green = "#8ada83", -- "#a6e3a1",
						teal = "#77dac9", -- "#94e2d5",
						sky = "#69d3e6", -- "#89dceb",
						sapphire = "#55bbe8", -- "#74c7ec",
						blue = "#649cf8", -- "#89b4fa",
						lavender = "#8999fd", -- "#b4befe",

						text = "#cdd6f4",
						subtext1 = "#bac2de",
						subtext0 = "#a6adc8",
						overlay2 = "#9399b2",
						overlay1 = "#7f849c",
						overlay0 = "#6c7086",
						surface2 = "#585b70",
						surface1 = "#45475a",
						surface0 = "#313244",
						base = "#000000", -- "#1e1e2e",
						mantle = "#181825",
						crust = "#11111b",
					},
				},
				custom_highlights = function(colors)
					local bc = { bg = colors.base, fg = colors.surface0 }
					local searchColor = colors.rosewater

					return {
						CmpBorder = bc,
						CmpDocBorder = bc,
						SagaBorder = bc,
						FloatBorder = bc,
						NormalBorder = bc,
						TelescopeBorder = bc,
						TelescopePromptBorder = bc,
						CursorLine = { bg = "#0c0c12" },
						StatusLine = { fg = "#585b70" }, -- colors.surface0

						PmenuThumb = { bg = "#1e1e2e" },
						PmenuSel = { bg = colors.mantle, fg = colors.text },
						CodeiumSuggestion = { fg = colors.surface0 },
						LineNr = { fg = colors.surface0 },
						CursorLineNr = { fg = colors.rosewater },
						Whitespace = { fg = colors.surface0 },
						IlluminatedWordText = { bg = "#161622" },
						IlluminatedWordRead = { bg = "#161622" },
						IlluminatedWordWrite = { bg = "#161622" },

						UfoFoldedEllipsis = { bg = colors.rosewater },
						Folded = { bg = colors.crust },

						IncSearch = { bg = searchColor },
						Search = { fg = searchColor, bg = "none" },
						CurSearch = { bg = searchColor },
						NoiceVirtualText = { fg = searchColor },

						VM_Mono = { fg = colors.crust, bg = searchColor },
						VM_Extend = { fg = colors.crust, bg = searchColor },
						VM_Cursor = { fg = colors.crust, bg = searchColor },
						VM_Insert = { fg = colors.crust, bg = searchColor },

						-- GlancePreviewNormal = { fg = "none" },
						-- GlanceListnormal = { fg = "none" },
						-- GlanceListFilename = { fg = "none" },
						-- GlanceListFilepath = { fg = "none" },

						-- FlashMatch = { fg = "red" },
						-- FlashCurrent = { fg = "red" },
						-- FlashBackdrop = { fg = "red" },
						-- FlashLabel = { fg = "red" },
					}
				end,
			})
			vim.cmd("colorscheme catppuccin")
		end,
	},

	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup()
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = buffer
					vim.keymap.set(mode, l, r, opts)
				end

				-- navigation
				map({ "n", "v" }, "]h", function()
					if vim.wo.diff then
						return "]h"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "jump to next hunk" })

				map({ "n", "v" }, "[h", function()
					if vim.wo.diff then
						return "[h"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "jump to previous hunk" })

				local vOptions = { vim.fn.line("."), vim.fn.line("v") }

				-- visual mode
				map("v", "<leader>hs", function()
					gs.stage_hunk(vOptions)
				end, { desc = "[s]tage git hunk" })
				map("v", "<leader>hr", function()
					gs.reset_hunk(vOptions)
				end, { desc = "[r]eset git hunk" })

				-- normal mode
				map("n", "<leader>hs", gs.stage_hunk, { desc = "[s]tage hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "[r]eset hunk" })
				map("n", "<leader>hS", gs.stage_buffer, { desc = "[S]tage buffer" })
				map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "[u]ndo stage hunk" })
				map("n", "<leader>hR", gs.reset_buffer, { desc = "[R]eset buffer" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "[p]review hunk" })
				map("n", "<leader>hb", function()
					gs.blame_line({ full = false })
				end, { desc = "[b]lame line" })
				map("n", "<leader>hB", gs.toggle_current_line_blame, { desc = "[B]lame line toggle" })
				map("n", "<leader>hd", gs.diffthis, { desc = "[d]iff index" })
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, { desc = "[D]iff last commit" })

				-- toggles
				map("n", "<leader>hx", gs.toggle_deleted, { desc = "show deleted" })

				-- text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
			end,
		},
	},

	{
		"windwp/nvim-autopairs",
		dependencies = { "hrsh7th/nvim-cmp" },
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")

			npairs.setup({
				check_ts = true,
				ts_config = {
					lua = { "string" }, -- it will not add a pair on that treesitter node
					javascript = { "template_string" },
					java = false, -- don't check treesitter on java
				},
			})

			local ts_conds = require("nvim-autopairs.ts-conds")

			-- press % => %% only while inside a comment or string
			npairs.add_rules({
				Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
				Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
			})
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			-- 'nvim-telescope/telescope-ui-select.nvim',
			-- "nvim-telescope/telescope-frecency.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					dynamic_preview_title = true,
					file_ignore_patterns = {
						".git/",
						"node_modules/",
						"package-lock.json",
						"yarn.lock",
						".DS_Store",
					},
					layout_strategy = "vertical",
					layout_config = {
						vertical = {
							height = 0.9,
							preview_height = 0.67,
							-- width = function(_, cols)
							--   return math.min(math.floor(cols * 0.87), 120)
							-- end
						},
						center = {
							height = 0.2,
							preview_height = 0.8,
							width = function(_, cols)
								return math.min(math.floor(cols * 0.87), 120)
							end,
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
				extensions = {
					file_browser = {
						theme = "ivy",
						initial_mode = "normal",
						-- hijack_netrw = true
						-- theme = "dropdown"
					},
					-- ['ui-select'] = {
					--   require('telescope.themes').get_dropdown()
					-- }
				},
			})

			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "file_browser")

			-- Function to find the git root directory based on the current buffer's path
			local function find_git_root()
				-- Use the current buffer's path as the starting point for the git search
				local current_file = vim.api.nvim_buf_get_name(0)
				local current_dir
				local cwd = vim.fn.getcwd()
				-- If the buffer is not associated with a file, return nil
				if current_file == "" then
					current_dir = cwd
				else
					-- Extract the directory from the current file's path
					current_dir = vim.fn.fnamemodify(current_file, ":h")
				end

				-- Find the Git root directory from the current file's path
				local root = vim.fn.systemlist("git -C " .. vim.fn.escape(" ", current_dir) .. " rev-parse --show-toplevel")[1]
				if vim.v.shell_error ~= 0 then
					print("Not a git repository. Searching on current working directory")
					return cwd
				end
				return root
			end

			local builtin = require("telescope.builtin")

			-- Custom live_grep function to search in git root
			local function live_grep_git_root()
				local git_root = find_git_root()
				if git_root then
					builtin.live_grep({ search_dirs = { git_root } })
				end
			end

			vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

			vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] find recently opened files" })
			-- vim.keymap.set("n", "<leader><leader>", "<Cmd>Telescope frecency workspace=CWD<CR>",
			--   { desc = "[<space>] find via frecency" })
			vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[<space>] find existing buffers" })
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false }))
			end, { desc = "[/] fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>sn", ":Telescope notify<CR>", { desc = "[s]each [n]otifications" })
			vim.keymap.set("n", "<leader>st", ":TodoTelescope<CR>", { desc = "[s]each [t]odos" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[s]earch [s]elect telescope" })
			vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "search [g]it [f]iles" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[s]earch [f]iles" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[s]earch [h]elp" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[s]earch current [w]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[s]earch [g]rep" })
			vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<CR>", { desc = "[s]earch [G]rep git" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[s]earch [d]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[s]earch [r]esume" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[s]earch [k]eymaps" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[s]earch recent files ("." for repeat)' })
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
			end, { desc = "[s]earch [/] in open files" })

			vim.keymap.set("n", "<space>ff", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", {
				noremap = true,
				desc = "browse [f]iles current path",
			})
			vim.keymap.set("n", "<space>fF", ":Telescope file_browser<CR>", {
				noremap = true,
				desc = "browse [F]iles root path",
			})

			-- TODO: escape special characters
			vim.keymap.set("v", "<C-f>", "y<ESC>:Telescope live_grep default_text=<c-r>0<CR>", {
				noremap = true,
				silent = true,
				desc = "[f]ind selection",
			})

			vim.keymap.set("n", "<leader>sc", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[s]earch neovim [c]onfig" })

			-- vim.keymap.set('n', '<c-d>', function()
			--   require('telescope.actions').delete_buffer()
			-- end)
		end,
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- stylua: ignore
		config = function()
			local tb = require("trouble")
			vim.keymap.set("n", "<leader>xx", tb.toggle, { desc = "toggle" })
			vim.keymap.set("n", "<leader>xw", function() tb.toggle("workspace_diagnostics") end, { desc = "diagnostics [w]orkspace" })
			vim.keymap.set("n", "<leader>xd", function() tb.toggle("document_diagnostics") end, { desc = "diagnostics [d]ocument" })
			vim.keymap.set("n", "<leader>xq", function() tb.toggle("quickfix") end, { desc = "[q]uickfix" })
			vim.keymap.set("n", "<leader>xl", function() tb.toggle("loclist") end, { desc = "[l]oclist" })
			vim.keymap.set("n", "<leader>xr", function() tb.toggle("lsp_references") end, { desc = "lsp [r]eferences" })
			-- vim.keymap.set("n", "[d", function() tb.next({ skip_groups = true, jump = true }) end, { desc = "next" })
			-- vim.keymap.set("n", "]d", function() tb.previous({ skip_groups = true, jump = true }) end, { desc = "prev" })
		end,
	},

	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local ufo = require("ufo")
			vim.o.foldcolumn = "0" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", ufo.openAllFolds)
			vim.keymap.set("n", "zM", ufo.closeAllFolds)

			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" 󰁂 %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			ufo.setup({
				fold_virt_text_handler = handler,
			})
		end,
	},

	{
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup({
				select = {
					telescope = require("telescope.themes").get_cursor(),
				},
			})
		end,
	},

	{
		"rrethy/vim-illuminate",
		lazy = true,
		enabled = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "cursormoved", "insertleave" },
		config = function()
			local i = require("illuminate")
			i.configure({
				filetypes_denylist = {
					"neo-tree",
					"telescope",
					"nvim-tree",
				},
			})
			-- vim.keymap.set('n', '<a-n>', i.goto_next_reference, { desc = "move to next reference" })
			-- vim.keymap.set('n', '<a-N>', i.goto_prev_reference, { desc = "move to previous reference" })
		end,
	},

	{
		"petertriho/nvim-scrollbar",
		config = function()
			---@diagnostic disable-next-line: undefined-field
			require("scrollbar").setup({
				excluded_filetypes = { "neo-tree" },
				marks = {
					Error = { text = { "" } },
					Warn = { text = { "" } },
					Info = { text = { "󰌶" } },
					Hint = { text = { "" } },
					Cursor = { priority = 9 },
				},
			})
			-- require("scrollbar.handlers.gitsigns").setup()
			-- require("scrollbar.handlers.search").setup()
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim", -- image support in preview window: see `# preview mode`
			{
				"s1n7ax/nvim-window-picker",
				version = "2.*",
				config = function()
					require("window-picker").setup({
						filter_rules = {
							include_current_win = false,
							autoselect_one = true,
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify" },
								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
					})
				end,
			},
		},
		init = function()
			vim.keymap.set("", "<leader>ft", "<CMD>Neotree filesystem toggle<CR>", { desc = "Tree [t]oggle" })
			vim.keymap.set("", "<leader>fb", "<CMD>Neotree buffers toggle<CR>", { desc = "Tree [b]uffers" })
			vim.keymap.set("", "<leader>fg", "<CMD>Neotree git_status toggle<CR>", { desc = "Tree [g]it" })
			vim.keymap.set("", "<leader>fs", "<CMD>Neotree document_symbols toggle<CR>", { desc = "Tree [s]ymbols" })
			vim.keymap.set("", "<leader>fc", "<CMD>Neotree close<CR>", { desc = "Tree [c]lose" })
		end,
		config = function()
			require("neo-tree").setup({
				filesystem = {
					hijack_netrw_behavior = "disabled",
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
					},
					follow_current_file = {
						enabled = true,
					},
				},
			})
		end,
	},

	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "[u]ndotree" })
		end,
	},

	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		config = function()
			local n = require("neogen")
			n.setup({ snippet_engine = "luasnip" })
			vim.keymap.set("n", "<leader>cd", n.generate, { desc = "[d]ocs generator" })
		end,
	},

	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lspsaga").setup({
				lightbulb = { enable = false },
				symbol_in_winbar = { enable = false },
				ui = {
					kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
				},
				-- definition = {
				--   width = 0.45,
				--   height = 0.35
				-- }
			})
		end,
	},

	{
		"junegunn/limelight.vim",
		config = function()
			vim.cmd("let g:limelight_conceal_guifg = '#686a76'")
			vim.keymap.set({ "n", "v" }, "<leader>l", "<CMD>Limelight!!<CR>", { desc = "[l]imelight" })
		end,
	},

	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		config = function()
			local sp = require("smart-splits")
			sp.setup({ ignored_filetypes = { "NvimTree", "neo-tree" } })
			-- Moving between splits
			vim.keymap.set("n", "<A-H>", sp.move_cursor_left)
			vim.keymap.set("n", "<A-J>", sp.move_cursor_down)
			vim.keymap.set("n", "<A-K>", sp.move_cursor_up)
			vim.keymap.set("n", "<A-L>", sp.move_cursor_right)
			-- Resize
			vim.keymap.set("n", "<C-S-h>", sp.resize_left)
			vim.keymap.set("n", "<C-S-j>", sp.resize_down)
			vim.keymap.set("n", "<C-S-k>", sp.resize_up)
			vim.keymap.set("n", "<C-S-l>", sp.resize_right)
			-- Swapping buffers between windows
			vim.keymap.set("n", "<C-A-S-h>", sp.swap_buf_left)
			vim.keymap.set("n", "<C-A-S-j>", sp.swap_buf_down)
			vim.keymap.set("n", "<C-A-S-k>", sp.swap_buf_up)
			vim.keymap.set("n", "<C-A-S-l>", sp.swap_buf_right)
		end,
	},

	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"leoluz/nvim-dap-go",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				automatic_installation = true,
				automatic_setup = true,
				handlers = {},
				ensure_installed = { "delve" },
			})

			---@diagnostic disable-next-line: missing-fields
			dapui.setup({
				icons = {
					expanded = "▾",
					collapsed = "▸",
					current_frame = "*",
				},
				---@diagnostic disable-next-line: missing-fields
				controls = {
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
						disconnect = "⏏",
					},
				},
			})

			vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "[t]oggle" })

			vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "[s]tart/continue" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "step [i]nto" })
			vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "step [o]ver" })
			vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "step o[u]t" })
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[B]reakpoint toggle" })
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "[B]reakpoint condition" })

			-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
			vim.keymap.set("n", "<leader>dr", dapui.toggle, { desc = "[r]esults" })

			vim.keymap.set("n", "<leader>dm", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { desc = "breakpoint [m]essage" })

			vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "open [r]epl" })
			-- vim.keymap.set("n", "<leader>dl", dap.repl.run_last, { desc = "re-test [l]ast" })

			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			-- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
			-- dap.listeners.before.event_exited['dapui_config'] = dapui.close

			require("dap-go").setup()
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				user_default_options = {
					mode = "virtualtext",
					tailwind = true,
					hsl_fn = true,
					rgb_fn = true,
					names = false,
				},
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		-- event = { "BufWritePre" },
		-- cmd = { "ConformInfo" },
		config = function()
			local conform = require("conform")
			local ignore_filetypes = { "sql", "java", "javascript", "typescript", "tsx", "typescriptreact" }
			-- local slow_format_filetypes = {}

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					go = { "goimports", "gofumpt" },
					json = { "deno_fmt" },
					-- javascript = { { "prettierd", "prettier" } },
					-- ["*"] = { "codespell" }, totalY = totally
				},
				formatters = {
					shfmt = {
						prepend_args = { "-i", "2" },
					},
				},

				format_on_save = function(buffer)
					if vim.g.disable_autoformat or vim.b[buffer].disable_autoformat then
						return
					end

					if vim.tbl_contains(ignore_filetypes, vim.bo[buffer].filetype) then
						return
					end

					-- if slow_format_filetypes[vim.bo[buffer].filetype] then
					--   return
					-- end

					-- local function on_format(err)
					--   if err and err:match("timeout$") then
					--     slow_format_filetypes[vim.bo[buffer].filetype] = true
					--   end
					-- end

					-- Disable autoformat for files in a certain path
					local bufname = vim.api.nvim_buf_get_name(buffer)
					if bufname:match("/node_modules/") then
						return
					end

					return {
						timeout_ms = 500,
						lsp_fallback = true,
					} -- , on_format
				end,

				-- format_after_save = function(buffer)
				--   if not slow_format_filetypes[vim.bo[buffer].filetype] then
				--     return
				--   end
				--   return { lsp_fallback = true }
				-- end
			})

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, { desc = "disable autoformat-on-save", bang = true })

			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, { desc = "re-enable autoformat-on-save" })

			vim.keymap.set("n", "<leader>cm", function()
				conform.format({ async = false, lsp_fallback = true })
			end, { desc = "for[m]at buffer" })

			vim.keymap.set("n", "<leader>cM", function()
				if vim.b.disable_autoformat or vim.g.disable_autoformat then
					vim.cmd("FormatEnable")
				else
					vim.cmd("FormatDisable")
				end
			end, { desc = "for[M]at on save" })

			-- vim.keymap.set("n", "<leader>fn", ":%s/\\n/\r/g<CR>", { desc = "Replace \n with \r" })
		end,
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "cpp", "go", "lua", "python", "rust", "tsx", "json", "javascript", "typescript", "vimdoc", "vim", "bash", "regex", "jsdoc", "graphql", "dockerfile", "yaml", "html" },
				auto_install = true,
				sync_install = false,
				ignore_install = {},
				modules = {},
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						scope_incremental = "<C-space>",
						node_incremental = "v",
						node_decremental = "V",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
							["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },

							-- ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
							["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

							["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
							["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

							["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
							["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

							["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
							["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

							["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
							["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

							["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
							["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

							-- ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
							-- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

							["ac"] = { query = "@comment.inner", desc = "Select comment inner" },
							["ic"] = { query = "@comment.outer", desc = "Select comment outer" },

							["ri"] = { query = "@return.inner", desc = "Select return inner" },
							["ra"] = { query = "@return.outer", desc = "Select return outer" },

							["ba"] = { query = "@block.inner", desc = "Select block inner" },
							["bi"] = { query = "@block.outer", desc = "Select block outer" },

							-- works for javascript/typescript files (custom captures I created in after/queries/ecma/textobjects.scm)
							["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
							["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
							["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
							["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner", -- swap parameters/argument with next
							["<leader>m"] = "@function.outer", -- swap function with next
							["<leader>p"] = "@property.outer", -- swap object property with next
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner", -- swap parameters/argument with prev
							["<leader>M"] = "@function.outer", -- swap function with previous
							["<leader>P"] = "@property.outer", -- swap object property with prev
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist

						goto_next_start = {
							["]a"] = { query = "@parameter.outer", desc = "Next parameter/argument start" },
							-- ["]a"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

							["]f"] = { query = "@call.outer", desc = "Next function call start" },
							["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
							-- ["]c"] = { query = "@class.outer", desc = "Next class start" },
							["]c"] = { query = "@comment.outer", desc = "Next comment start" },
							["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
							["]l"] = { query = "@loop.outer", desc = "Next loop start" },

							-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
							-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
							["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
							["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
						},
						goto_next_end = {
							["]A"] = { query = "@parameter.outer", desc = "Next parameter/argument end" },
							["]F"] = { query = "@call.outer", desc = "Next function call end" },
							["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
							-- ["]C"] = { query = "@class.outer", desc = "Next class end" },
							["]C"] = { query = "@comment.outer", desc = "Next comment end" },
							["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
							["]L"] = { query = "@loop.outer", desc = "Next loop end" },
						},
						goto_previous_start = {
							["[a"] = { query = "@parameter.outer", desc = "Prev parameter/argument start" },
							["[f"] = { query = "@call.outer", desc = "Prev function call start" },
							["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
							-- ["[c"] = { query = "@class.outer", desc = "Prev class start" },
							["[c"] = { query = "@comment.outer", desc = "Prev comment start" },
							["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
							["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
						},
						goto_previous_end = {
							["[A"] = { query = "@parameter.outer", desc = "Prev parameter/argument end" },
							["[F"] = { query = "@call.outer", desc = "Prev function call end" },
							["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
							-- ["[C"] = { query = "@class.outer", desc = "Prev class end" },
							["[C"] = { query = "@comment.outer", desc = "Prev comment end" },
							["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
							["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
						},
					},
				},
			})

			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			-- Repeat movement with ; and ,
			-- ensure ; goes forward and , goes backward regardless of the last direction
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			-- vim way: ; goes to the direction you were moving.
			-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
		end,
	},

	{
		"Wansmer/treesj",
		event = "VimEnter",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			local tj = require("treesj")
			tj.setup({
				use_default_keymaps = false,
				max_join_length = 99999,
				check_syntax_error = false,
			})
			vim.keymap.set("n", "gS", tj.toggle, { desc = "[s]plit/join" })
			vim.keymap.set("n", "gX", tj.split, { desc = "split" })
			vim.keymap.set("n", "gX", tj.join, { desc = "join" })
		end,
	},

	{
		"echasnovski/mini.nvim",
		config = function()
			-- require("mini.operators").setup()
			require("mini.bracketed").setup()
			require("mini.align").setup()
			require("mini.hipatterns").setup()
			-- require("mini.sessions").setup({
			-- 	autoread = true,
			-- 	autowrite = true,
			-- 	directory = "~/.nvim_sessions",
			-- 	file = "sessions.vim",
			-- })
			require("mini.move").setup({
				mappings = {
					-- Move selection in Visual mode
					left = "<C-A-h>",
					right = "<C-A-l>",
					down = "<C-A-j>",
					up = "<C-A-k>",
					-- Move current line in Normal mode
					line_left = "<C-A-h>",
					line_right = "<C-A-l>",
					line_down = "<C-A-j>",
					line_up = "<C-A-k>",
				},
				options = {
					-- Automatically reindent selection during linewise vertical move
					reindent_linewise = true,
				},
			})
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local tc = require("todo-comments")

			tc.setup({
				keywords = {
					FIX = { icon = " ", color = "error", alt = { "fix", "FIXME", "BUG", "FIXIT", "ISSUE" } },
					TODO = { icon = " ", color = "info", alt = { "todo" } },
					HACK = { icon = " ", color = "warning", alt = { "hack" } },
					WARN = { icon = " ", color = "warning", alt = { "warn", "WARNING", "XXX" } },
					PERF = { icon = " ", alt = { "perf", "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					NOTE = { icon = " ", color = "hint", alt = { "note", "INFO" } },
					TEST = { icon = "⏲ ", color = "test", alt = { "test", "TESTING", "PASSED", "FAILED" } },
				},
				highlight = {
					keyword = "wide_fg",
				},
			})

			vim.keymap.set("n", "]t", tc.jump_next, { desc = "next todo comment" })
			vim.keymap.set("n", "[t", tc.jump_prev, { desc = "previous todo comment" })
			vim.keymap.set("n", "<leader>xt", "<CMD>TodoQuickFix<CR>", { desc = "[t]odos" })
		end,
	},

	{
		"wellle/targets.vim",
	},

	{
		"mg979/vim-visual-multi",
	},

	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			--     Old text                    Command         New text
			-- ---------------------------------------------------------------------
			--     surr*ound_words             ysiw)           (surround_words)
			--     *make strings               ys$"            "make strings"

			--     surr*ound_words             siw)           (surround_words)
			--     *make strings               s$"            "make strings"
			--     [delete ar*ound me!]        ds]             delete around me!
			--     remove <b>HTML t*ags</b>    dst             remove HTML tags
			--     'change quot*es'            cs'"            "change quotes"
			--     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
			--     delete(functi*on calls)     dsf             function calls
			require("nvim-surround").setup({
				keymaps = {
					insert = "<C-g>s",
					insert_line = "<C-g>S",
					normal = "s",
					normal_cur = "ss",
					normal_line = "S",
					normal_cur_line = "SS",
					-- normal = "ys",
					-- normal_cur = "yss",
					-- normal_line = "yS",
					-- normal_cur_line = "ySS",
					visual = "S",
					visual_line = "gS",
					delete = "ds",
					change = "cs",
					change_line = "cS",
				},
			})
		end,
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		-- stylua: ignore
		config = function()
			local f = require("flash")
			f.setup({
				incremental = false,
				modes = {
					search = {
						enabled = false
					}
				}
			})
			-- vim.keymap.set({ "n", "x", "o" }, "s", function() f.jump() end, { desc = "Flash" })
			vim.keymap.set({ "n", "x", "o" }, "<A>-f", function() f.jump() end, { desc = "Flash" })
			-- vim.keymap.set({ "n", "x", "o" }, "S", function() f.treesitter() end, { desc = "Flash Treesitter" })
			vim.keymap.set("o", "r", function() f.remote() end, { desc = "Remote Flash" })
			vim.keymap.set({ "o", "x" }, "R", function() f.treesitter_search() end, { desc = "Treesitter Search" })
			vim.keymap.set({ "c" }, "<c-s>", function() f.toggle() end, { desc = "Toggle Flash Search" })
		end,
	},

	-- {
	-- 	"gbprod/yanky.nvim",
	-- 	dependencies = { "kkharji/sqlite.lua" },
	-- 	event = "BufEnter",
	-- 	config = function()
	-- 		local ts = require("telescope")
	-- 		local yy = require("yanky")
	-- 		yy.setup()
	--
	-- 		vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank text" })
	-- 		vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put yanked text after cursor" })
	-- 		vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put yanked text before cursor" })
	-- 		vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put yanked text after selection" })
	-- 		vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put yanked text before selection" })
	--
	-- 		vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)", { desc = "Select previous entry through yank history" })
	-- 		vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)", { desc = "Select next entry through yank history" })
	-- 		vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put indented before cursor (linewise)" })
	-- 		vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put indented after cursor (linewise)" })
	-- 		vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put indented before cursor (linewise)" })
	-- 		vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", { desc = "Put and indent right" })
	-- 		vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", { desc = "Put and indent left" })
	-- 		vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", { desc = "Put before and indent right" })
	-- 		vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", { desc = "Put before and indent left" })
	-- 		vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)", { desc = "Put after applying a filter" })
	-- 		vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)", { desc = "Put before applying a filter" })
	--
	-- 		vim.keymap.set("n", "<leader>sp", function()
	-- 			ts.extensions.yank_history.yank_history()
	-- 		end, { desc = "[s]earch [p]aste" })
	-- 	end,
	-- },

	-- {
	-- 	"rmagatti/auto-session",
	-- 	config = function()
	-- 		---@diagnostic disable-next-line: missing-fields
	-- 		require("auto-session").setup({
	-- 			log_level = "warn",
	-- 			auto_session_suppress_dirs = { "~/", "/" },
	-- 		})
	-- 	end,
	-- },

	-- https://github.com/tpope/vim-dadbod/pull/162
	-- {
	-- 	"kristijanhusak/vim-dadbod-ui",
	-- 	dependencies = {
	-- 		{
	-- 			"tpope/vim-dadbod",
	-- 			lazy = true,
	-- 		},
	-- 		{
	-- 			"kristijanhusak/vim-dadbod-completion",
	-- 			ft = { "sql", "mysql", "plsql" },
	-- 			lazy = true,
	-- 		},
	-- 	},
	-- 	cmd = {
	-- 		"DBUI",
	-- 		"DBUIToggle",
	-- 		"DBUIAddConnection",
	-- 		"DBUIFindBuffer",
	-- 	},
	-- 	init = function()
	-- 		vim.g.db_ui_use_nerd_fonts = 1
	-- 	end,
	-- },
	-- {
	-- 	"rcarriga/nvim-notify",
	-- 	config = function()
	-- 		require("notify").setup({
	-- 			render = "compact",
	-- 			stages = "static",
	-- 		})
	-- 	end,
	-- },

	-- {
	-- 	"folke/noice.nvim",
	-- 	event = "VeryLazy",
	-- 	-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
	-- 	dependencies = { "MunifTanjim/nui.nvim" },
	-- 	config = function()
	-- 		require("noice").setup({
	-- 			cmdline = { view = "cmdline" },
	-- 			notify = { enabled = false },
	-- 			lsp = {
	-- 				progress = { enabled = false },
	-- 				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
	-- 				override = {
	-- 					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
	-- 					["vim.lsp.util.stylize_markdown"] = true,
	-- 					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
	-- 				},
	-- 				hover = { enabled = false },
	-- 				signature = { enabled = false },
	-- 				messages = { view_search = false },
	-- 				-- documentation = {
	-- 				-- 	opts = {
	-- 				-- 		win_options = {
	-- 				-- 			concealcursor = "n",
	-- 				-- 			conceallevel = 3,
	-- 				-- 			winhighlight = {
	-- 				-- 				Normal = "Normal",
	-- 				-- 				FloatBorder = "Todo",
	-- 				-- 			},
	-- 				-- 		},
	-- 				-- 	},
	-- 				-- },
	-- 			},
	-- 			views = {
	-- 				split = { enter = true },
	-- 				mini = {
	-- 					timeout = 5000,
	-- 					win_options = {
	-- 						winblend = 100,
	-- 					},
	-- 					-- focusable = false,
	-- 					-- border = {
	-- 					-- 	style = "none",
	-- 					-- },
	-- 				},
	-- 			},
	-- 			presets = {
	-- 				bottom_search = true, -- use a classic bottom cmdline for search
	-- 				-- command_palette = true, -- position the cmdline and popupmenu together
	-- 				long_message_to_split = true, -- long messages will be sent to a split
	-- 				inc_rename = false, -- enables an input dialog for inc-rename.nvim
	-- 				-- lsp_doc_border = true, -- add a border to hover docs and signature help
	-- 			},
	-- 			routes = {
	-- 				{ filter = { find = "E162" }, view = "mini" },
	-- 				{ filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
	-- 				{ filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
	-- 				{ filter = { event = "msg_show", find = "search hit TOP" }, skip = true },
	-- 				{ filter = { event = "emsg", find = "E23" }, skip = true },
	-- 				{ filter = { event = "emsg", find = "E20" }, skip = true },
	-- 				{ filter = { find = "No signature help" }, skip = true },
	-- 				{ filter = { find = "E37" }, skip = true },
	-- 			},
	-- 		})
	-- 	end,
	-- },

	-- {
	-- 	"dnlhc/glance.nvim",
	-- 	config = function()
	-- 		require("glance").setup({
	-- 			theme = {
	-- 				enable = false,
	-- 				mode = "darken",
	-- 			},
	-- 			border = {
	-- 				enable = true,
	-- 				top_char = "―",
	-- 				bottom_char = "―",
	-- 			},
	-- 		})
	-- 	end,
	-- },

	-- {
	-- 	"nvim-neotest/neotest",
	-- 	event = "VeryLazy",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"antoinemadec/FixCursorHold.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"nvim-neotest/nvim-nio",
	-- 		"nvim-neotest/neotest-go",
	-- 		"nvim-neotest/neotest-jest",
	-- 	},
	-- 	-- stylua: ignore
	-- 	config = function()
	-- 		vim.diagnostic.config({
	-- 			virtual_text = {
	-- 				format = function(diag)
	-- 					return diag.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
	-- 				end,
	-- 			},
	-- 		}, vim.api.nvim_create_namespace("neotest"))
	--
	-- 		local nt = require("neotest")
	--
	-- 		nt.setup({
	-- 			status = { virtual_text = true },
	-- 			output = { open_on_run = true },
	-- 			adapters = {
	-- 				require("neotest-go"),
	-- 				-- require("neotest-jest")({
	-- 				-- 	jestCommand = "npm test --",
	-- 				-- 	jestConfigFile = "custom.jest.config.ts",
	-- 				-- 	env = { CI = true },
	-- 				-- 	cwd = function(path)
	-- 				-- 		return vim.fn.getcwd()
	-- 				-- 	end,
	-- 				-- }),
	-- 			},
	-- 			-- quickfix = {
	-- 			-- 	open = function()
	-- 			-- 		if require("lazyvim.util").has("trouble.nvim") then
	-- 			-- 			vim.cmd("Trouble quickfix")
	-- 			-- 		else
	-- 			-- 			vim.cmd("copen")
	-- 			-- 		end
	-- 			-- 	end,
	-- 			-- },
	-- 		})
	--
	-- 		vim.keymap.set("n", "<leader>tT", function() nt.run.run(vim.loop.cwd()) end, { desc = "[T]est all files" })
	-- 		vim.keymap.set("n", "<leader>tt", function() nt.run.run(vim.fn.expand("%")) end, { desc = "[t]est current file" })
	-- 		vim.keymap.set("n", "<leader>tf", nt.run.run, { desc = "test current [f]unction" })
	-- 		vim.keymap.set("n", "<leader>tr", nt.run.run, { desc = "[r]un nearest" })
	-- 		vim.keymap.set("n", "<leader>ts", nt.run.stop, { desc = "[s]top test" })
	-- 		vim.keymap.set("n", "<leader>ts", nt.summary.toggle, { desc = "su[m]mary" })
	-- 		vim.keymap.set("n", "<leader>tO", nt.output_panel.toggle, { desc = "[O]utput panel" })
	-- 		vim.keymap.set("n", "<leader>to", function() nt.output.open({ enter = true, auto_close = true }) end, { desc = "[o]utput" })
	-- 	end,
	-- },

	-- {
	-- 	"smoka7/multicursors.nvim",
	-- 	event = "VeryLazy",
	-- 	dependencies = {
	-- 		"smoka7/hydra.nvim",
	-- 	},
	-- 	opts = {},
	-- 	cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
	-- 	keys = {
	-- 		{
	-- 			mode = { "v", "n" },
	-- 			"<Leader>m",
	-- 			"<cmd>MCstart<cr>",
	-- 			desc = "Create a selection for selected text or word under the cursor",
	-- 		},
	-- 	},
	-- },

	-- {
	-- 	"willothy/wezterm.nvim",
	-- 	config = function()
	-- 		local w = require("wezterm")
	-- 		w.setup()
	--
	-- 		vim.keymap.set("n", "<leader>tt", function()
	-- 			w.split_pane.horizontal({
	-- 				-- {cwd}        (string|nil)
	-- 				-- {pane}       (number|nil)    The pane to split (default current)
	-- 				-- {top}        (boolean|nil)   (default false)
	-- 				-- {left}       (boolean|nil)   (default false)
	-- 				-- {bottom}     (boolean|nil)   (default false)
	-- 				-- {right}      (boolean|nil)   (default false)
	-- 				-- {move_pane}  (number|nil)    Move a pane instead of spawning a command in it (default nil/disabled)
	-- 				-- {percent}    (number|nil)    The percentage of the pane to split (default nil)
	-- 				-- {program}    (string[]|nil)  The program to spawn in the new pane (default nil/Wezterm default)
	-- 				-- {top_level}  (boolean|nil)   Split the window instead of the pane (default false)-
	-- 			})
	-- 			local paneId = w.get_current_pane()
	-- 			w.exec("ls")
	-- 		end)
	--
	-- 		-- local s = ':TermExec direction=vertical size=80 name=test cmd="'
	-- 		-- local c = "gotestsum --format=standard-verbose "
	-- 		-- local e = '"<CR>'
	-- 		--
	-- 		-- vim.keymap.set("n", "<leader>tt", s .. c .. "-- ./% -run <cword>" .. e, { desc = "function" })
	-- 		-- vim.keymap.set("n", "<leader>tT", s .. c .. "--watch -- ./%:h -run <cword>" .. e, { desc = "function watch" })
	-- 		-- vim.keymap.set("n", "<leader>tf", s .. c .. "-- ./%" .. e, { desc = "file" })
	-- 		-- vim.keymap.set("n", "<leader>tF", s .. c .. "--watch -- ./%:h" .. e, { desc = "file watch" })
	-- 		-- -- gotestsum --format=standard-verbose --watch -- ./apps/matching-api/src/search/
	-- 		-- vim.keymap.set("n", "<leader>tq", ":ToggleTerm<CR>", { desc = "toggle" })
	-- 	end,
	-- },

	-- {
	-- 	"akinsho/toggleterm.nvim",
	-- 	version = "*",
	-- 	config = function()
	-- 		local tt = require("toggleterm")
	-- 		tt.setup({
	-- 			-- shade_terminals = false
	-- 			winbar = {
	-- 				enabled = false,
	-- 			},
	-- 		})
	--
	-- 		function _G.set_terminal_keymaps()
	-- 			local opts = { buffer = 0 }
	-- 			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	-- 			vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	-- 			vim.keymap.set("t", "<A-H>", [[<Cmd>wincmd h<CR>]], opts)
	-- 			vim.keymap.set("t", "<A-J>", [[<Cmd>wincmd j<CR>]], opts)
	-- 			vim.keymap.set("t", "<A-K>", [[<Cmd>wincmd k<CR>]], opts)
	-- 			vim.keymap.set("t", "<A-L>", [[<Cmd>wincmd l<CR>]], opts)
	-- 			vim.keymap.set("t", "<A-W>", [[<C-\><C-n><C-w>]], opts)
	-- 		end
	--
	-- 		-- if you only want these mappings for toggle term use term://*toggleterm#* instead
	-- 		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
	--
	-- 		local s = ':TermExec direction=vertical size=80 name=test cmd="'
	-- 		local c = "gotestsum --format=standard-verbose "
	-- 		local e = '"<CR>'
	--
	-- 		-- TODO: find a way to cancel the watch command..
	--
	-- 		vim.keymap.set("n", "<leader>tt", s .. c .. "-- ./% -run <cword>" .. e, { desc = "function" })
	-- 		vim.keymap.set("n", "<leader>tT", s .. c .. "--watch -- ./%:h -run <cword>" .. e, { desc = "function watch" })
	-- 		vim.keymap.set("n", "<leader>tf", s .. c .. "-- ./%" .. e, { desc = "file" })
	-- 		vim.keymap.set("n", "<leader>tF", s .. c .. "--watch -- ./%:h" .. e, { desc = "file watch" })
	-- 		-- gotestsum --format=standard-verbose --watch -- ./apps/matching-api/src/search/
	-- 		vim.keymap.set("n", "<leader>tq", ":ToggleTerm<CR>", { desc = "toggle" })
	--
	-- 		-- vim.keymap.set("n", "<leader>tT", function() nt.run.run(vim.loop.cwd()) end, { desc = "[T]est all files" })
	-- 		-- vim.keymap.set("n", "<leader>tt", function() nt.run.run(vim.fn.expand("%")) end, { desc = "[t]est current file" })
	-- 		-- vim.keymap.set("n", "<leader>tf", nt.run.run, { desc = "test current [f]unction" })
	-- 		-- vim.keymap.set("n", "<leader>tr", nt.run.run, { desc = "[r]un nearest" })
	-- 		-- vim.keymap.set("n", "<leader>ts", nt.run.stop, { desc = "[s]top test" })
	-- 		-- vim.keymap.set("n", "<leader>ts", nt.summary.toggle, { desc = "su[m]mary" })
	-- 		-- vim.keymap.set("n", "<leader>tO", nt.output_panel.toggle, { desc = "[O]utput panel" })
	-- 		-- vim.keymap.set("n", "<leader>to", function() nt.output.open({ enter = true, auto_close = true }) end, { desc = "[o]utput" })
	-- 	end,
	-- },

	-- {
	-- 	"kevinhwang91/nvim-bqf",
	-- 	dependencies = {
	-- 		"junegunn/fzf",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	ft = "qf",
	-- 	lazy = true,
	-- 	opts = { preview = { winblend = 0 } },
	-- },

	-- {
	-- 	"gbprod/yanky.nvim",
	-- 	config = function()
	-- 		require("yanky").setup()
	-- 	end
	-- },

	-- {
	--   "chentoast/marks.nvim",
	--   config = function()
	--     require('marks').setup({
	--       -- whether to map keybinds or not. default true
	--       default_mappings = true,
	--       -- which builtin marks to show. default {}
	--       builtin_marks = { ".", "<", ">", "^" },
	--       -- whether movements cycle back to the beginning/end of buffer. default true
	--       cyclic = true,
	--       -- whether the shada file is updated after modifying uppercase marks. default false
	--       force_write_shada = false,
	--       -- how often (in ms) to redraw signs/recompute mark positions.
	--       -- higher values will have better performance but may cause visual lag,
	--       -- while lower values may cause performance penalties. default 150.
	--       refresh_interval = 250,
	--       -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
	--       -- marks, and bookmarks.
	--       -- can be either a table with all/none of the keys, or a single number, in which case
	--       -- the priority applies to all marks.
	--       -- default 10.
	--       sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	--       -- disables mark tracking for specific filetypes. default {}
	--       excluded_filetypes = {},
	--       -- disables mark tracking for specific buftypes. default {}
	--       excluded_buftypes = {},
	--       -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
	--       -- sign/virttext. Bookmarks can be used to group together positions and quickly move
	--       -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
	--       -- default virt_text is "".
	--       -- bookmark_0 = {
	--       --   sign = "⚑",
	--       --   virt_text = "hello world",
	--       --   -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
	--       --   -- defaults to false.
	--       --   annotate = false,
	--       -- },
	--       mappings = {}
	--     })
	--   end
	-- },

	-- {
	--   "pmizio/typescript-tools.nvim",
	--   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	--   opts = {}
	-- }

	-- {
	--   'akinsho/bufferline.nvim',
	--   dependencies = {
	--     'nvim-tree/nvim-web-devicons'
	--   },
	--   opts = {},
	-- },

	-- {
	--   'bekaboo/dropbar.nvim',
	--   -- optional, but required for fuzzy finder support
	--   dependencies = {
	--     'nvim-telescope/telescope-fzf-native.nvim'
	--   },
	--   config = function()
	--     require('dropbar').setup()
	--     vim.ui.select = require('dropbar.utils.menu').select
	--   end
	-- },

	-- {
	--   "wfxr/minimap.vim",
	--   build = "cargo install --locked code-minimap",
	--   lazy = false,
	--   cmd = {
	--     "minimap",
	--     "minimapclose",
	--     "minimaptoggle",
	--     "minimaprefresh",
	--     "minimapupdatehighlight"
	--   },
	--   init = function()
	--     vim.cmd("let g:minimap_width = 3")
	--     vim.cmd("let g:minimap_auto_start = 1")
	--     vim.cmd("let g:minimap_auto_start_win_enter = 1")
	--     -- vim.cmd("let g:minimap_highlight_search = 1")
	--     -- vim.cmd("let g:minimap_background_processing = 1")
	--     -- vim.cmd("let g:minimap_git_colors = 1")
	--   end
	-- },

	-- {
	--   'nvim-lualine/lualine.nvim',
	--   dependencies = {
	--     'nvim-tree/nvim-web-devicons'
	--   },
	--   opts = {
	--     options = {
	--       globalstatus = true,
	--       theme = 'auto',
	--       -- theme = 'catppuccin',
	--       icons_enabled = false,
	--       component_separators = '|',
	--       section_separators = {
	--         left = '',
	--         right = ''
	--       }
	--     }
	--   }
	-- }
}, {
	ui = {
		border = "single",
	},
})
