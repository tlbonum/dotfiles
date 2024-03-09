vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.bo.softtabstop = 2
vim.wo.number = true
vim.wo.signcolumn = "yes"
vim.wo.relativenumber = true

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
vim.opt.guifont = "berkeley mono:h14" -- applies to neovide or the like
vim.opt.statusline = "%<%f %h%m%r%=%-14.(%l,%c%V%) %P %y"
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

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
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

-- local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
local signs = { Error = " ", Warn = " ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Automatically show diagnostic on mouseover
-- vim.api.nvim_create_autocmd({ "CursorHold" }, {
--   callback = function()
--     vim.diagnostic.open_float()
--   end
-- })

vim.diagnostic.config({
	-- These are defaults
	-- virtual_text = true,
	-- float = false,
	-- underline = false
	virtual_text = {
		prefix = "●",
	},
})

-- local wr_group = vim.api.nvim_create_augroup('WinResize', { clear = true })
-- vim.api.nvim_create_autocmd('VimResized', {
--   group = wr_group,
--   pattern = '*',
--   command = 'wincmd =',
--   desc = 'Automatically resize windows when the host window size changes.'
-- })

vim.keymap.set("n", "<Char-0xAA>", "<cmd>write<cr>", { desc = "save file" })

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Don't immediately jump to the next occurrence during searches
vim.api.nvim_set_keymap("n", "*", ":keepjumps normal! mi*`i<CR>", { noremap = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "prev diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "diagnostic m[e]ssage" })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set({ "n", "v", "i" }, "<A-z>", ":set nowrap!<CR>", { desc = "toggle line wrap" })

vim.keymap.set("n", "<M-T>", "<CMD>vs<bar>:b#<CR>", { desc = "reopen last split" })

-- Create splits
vim.keymap.set({ "n", "v", "i" }, "<A-v>", "<cmd>vs<cr>", { desc = "vertical split" })
vim.keymap.set({ "n", "v", "i" }, "<A-s>", "<cmd>sp<cr>", { desc = "horizontal split" })

vim.keymap.set("n", "<A-q>", "<cmd>q<cr>", { desc = "close buffer" })

-- Cycle between buffers
vim.keymap.set("n", "<TAB>", ":bn<CR>")
vim.keymap.set("n", "<S-TAB>", ":bp<CR>")
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
					map("n", "<leader>gd", builtin.lsp_definitions, "[g]oto [d]efinition")
					map("n", "<leader>gt", builtin.lsp_type_definitions, "[g]oto [t]ype")
					map("n", "<leader>gs", builtin.lsp_document_symbols, "document [s]ymbols")
					map("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")
					map("n", "<leader>gr", builtin.lsp_references, "[g]oto [r]eferences")
					map("n", "<leader>gi", builtin.lsp_implementations, "[g]oto [i]mplementation")

					map({ "n", "i" }, "<Char-0xAB>", "<CMD>Lspsaga hover_doc<CR>", "hover help")
					map({ "n", "i" }, "<Char-0xAC>", vim.lsp.buf.signature_help, "signature help")

					map("n", "gD", "<CMD>Glance definitions<CR>", "[g]lance [D]efinition")
					map("n", "gT", "<CMD>Glance type_definitions<CR>", "[g]lance [T]ype")
					map("n", "gR", "<CMD>Glance references<CR>", "[g]lance [R]ereferences")
					map("n", "gI", "<CMD>Glance implementations<CR>", "[g]lance [I]mplementations")

					map("n", "gd", "<CMD>Lspsaga peek_definition<CR>", "[g]oto [d]efinition")
					-- map('n', 'gd', vim.lsp.buf.definition, "[g]oto [d]efinition")
					map("n", "gt", "<CMD>Lspsaga peek_type_definition<CR>", "[g]oto [t]ype definition")
					-- map('n', 'gt', vim.lsp.buf.type_definition, "[g]oto [t]ype")
					map("n", "gr", vim.lsp.buf.references, "[g]oto [r]eference")
					map("n", "gi", vim.lsp.buf.implementation, "[g]oto [i]mplementation")
					map("n", "gl", vim.lsp.buf.declaration, "[g]oto dec[l]aration")

					map("n", "<leader>cr", vim.lsp.buf.rename, "[r]ename")
					map("n", "<leader>ca", vim.lsp.buf.code_action, "[a]ction")
					-- { context = { only = { 'quickfix', 'refactor', 'source' } } }

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

						if config.capabilities then
							config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities)
						end

						if config.handlers then
							config.handlers = vim.tbl_deep_extend("force", handlers, config.handlers)
						end

						lspconfig[server_name].setup(config)
					end,
				},
			})

			require("neodev").setup({
				library = {
					plugins = { "neotest" },
					types = true,
				},
			})

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
		"Exafunction/codeium.vim",
		event = "BufEnter",
		init = function()
			vim.g.codeium_disable_bindings = 1
			vim.g.codeium_manual = true
			vim.keymap.set("n", "<leader>cc", "<CMD>Codium Toggle<CR>", { desc = "[c]odium toggle" })

			vim.keymap.set("i", "<M-i>", function()
				return vim.fn["codeium#Complete"]()
			end, { expr = true, desc = "codeium trigger" })
			vim.keymap.set("i", "<M-y>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, desc = "codeium accept" })
			vim.keymap.set("i", "<M-n>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true, desc = "codeium next" })
			vim.keymap.set("i", "<M-p>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true, desc = "codeium prev" })
			vim.keymap.set("i", "<M-c>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true, desc = "codeium clear" })

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
		event = "InsertEnter",
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
			-- 'hrsh7th/cmp-nvim-lsp-signature-help',
			"hrsh7th/cmp-path",
			"rafamadriz/friendly-snippets",
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
				completion = { completeopt = "menu,menuone,noinsert" },
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
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<Char-0xAF>"] = cmp.mapping.complete(), -- CMD-Enter
					["<CR>"] = cmp.mapping.confirm({
						-- behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					-- { name = "nvim_lsp_signature_help" },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "path" },
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
				["g>"] = "Comment region",
				["g>c"] = "Add line comment",
				["g>b"] = "Add block comment",
				["g<lt>"] = "Uncomment region",
				["g<lt>c"] = "Remove line comment",
				["g<lt>b"] = "Remove block comment",
			}, { mode = "n" })

			wk.register({
				["g>"] = "Comment region",
				["g<lt>"] = "Uncomment region",
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
				["<M-w>"] = { name = "manage [w]indows", _ = "which_key_ignore" },
			})

			wk.register({
				["<leader>"] = { name = "visual <leader>" },
				["<leader>h"] = { "[h]unk/git" },
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
					neotest = true,
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
					return {
						CmpBorder = bc,
						CmpDocBorder = bc,
						SagaBorder = bc,
						FloatBorder = bc,
						NormalBorder = bc,
						TelescopeBorder = bc,
						TelescopePromptBorder = bc,
						CursorLine = { bg = "#0a0a0e" },
						GlancePreviewNormal = { fg = "none" },
						GlanceListnormal = { fg = "none" },
						GlanceListFilename = { fg = "none" },
						GlanceListFilepath = { fg = "none" },
						PmenuThumb = { bg = "#1e1e2e" },
						PmenuSel = { bg = colors.mantle, fg = colors.text },
						CodeiumSuggestion = { fg = colors.surface0 },
						LineNr = { fg = colors.surface0 },
						Whitespace = { fg = colors.surface0 },
						IlluminatedWordText = { bg = "#1e1e2e" },
						IlluminatedWordRead = { bg = "#1e1e2e" },
						IlluminatedWordWrite = { bg = "#1e1e2e" },
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
				map({ "n", "v" }, "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "jump to next hunk" })

				map({ "n", "v" }, "[c", function()
					if vim.wo.diff then
						return "[c"
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
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{
				"tpope/vim-dadbod",
				lazy = true,
			},
			{
				"kristijanhusak/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" },
				lazy = true,
			},
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
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
			--     [delete ar*ound me!]        ds]             delete around me!
			--     remove <b>HTML t*ags</b>    dst             remove HTML tags
			--     'change quot*es'            cs'"            "change quotes"
			--     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
			--     delete(functi*on calls)     dsf             function calls
			require("nvim-surround").setup()
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
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					previewer = false,
				}))
			end, { desc = "[/] fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[s]earch [s]elect telescope" })
			vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "search [g]it [f]iles" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[s]earch [f]iles" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[s]earch [h]elp" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[s]earch current [w]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[s]earch [g]rep" })
			vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<cr>", { desc = "[s]earch [G]rep git" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[s]earch [d]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[s]earch [r]esume" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[s]earch [k]eymaps" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[s]earch recent files ("." for repeat)' })
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
			end, { desc = "[s]earch [/] in open files" })

			vim.api.nvim_set_keymap("n", "<space>ff", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true, desc = "Browse [f]iles current path" })
			vim.api.nvim_set_keymap("n", "<space>fF", ":Telescope file_browser<CR>", { noremap = true, desc = "Browse [F]iles root path" })

			-- TODO: escape special characters
			vim.api.nvim_set_keymap("v", "<C-f>", "y<ESC>:Telescope live_grep default_text=<c-r>0<CR>", {
				noremap = true,
				silent = true,
				desc = "[f]ind selection",
			})

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[s]earch [n]eovim config" })

			-- vim.keymap.set('n', '<c-d>', function()
			--   require('telescope.actions').delete_buffer()
			-- end)
		end,
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local trouble = require("trouble")
			vim.keymap.set("n", "<leader>xx", function()
				trouble.toggle()
			end, { desc = "Trouble Toggle" })
			vim.keymap.set("n", "<leader>xw", function()
				trouble.toggle("workspace_diagnostics")
			end, { desc = "Trouble Workspace Diagnostics" })
			vim.keymap.set("n", "<leader>xd", function()
				trouble.toggle("document_diagnostics")
			end, { desc = "Trouble Document Diagnostics" })
			vim.keymap.set("n", "<leader>xq", function()
				trouble.toggle("quickfix")
			end, { desc = "Trouble Quickfix" })
			vim.keymap.set("n", "<leader>xl", function()
				trouble.toggle("loclist")
			end, { desc = "Trouble Loclist" })
			vim.keymap.set("n", "gR", function()
				trouble.toggle("lsp_references")
			end, { desc = "Trouble LSP References" })
			-- vim.keymap.set("n", "[d", function() trouble.next({ skip_groups = true, jump = true }) end, { desc = "Go Next" })
			-- vim.keymap.set("n", "]d", function() trouble.previous({ skip_groups = true, jump = true }) end, { desc = "Go Prev" })
		end,
	},

	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

			require("ufo").setup( --[[ {
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end
      } ]])
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
			"muniftanjim/nui.nvim",
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
		config = function()
			require("neogen").setup({
				snippet_engine = "luasnip",
			})
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
		"dnlhc/glance.nvim",
		config = function()
			require("glance").setup({
				theme = {
					enable = false,
					mode = "darken",
				},
				border = {
					enable = true,
					top_char = "―",
					bottom_char = "―",
				},
			})
		end,
	},

	{
		"kevinhwang91/nvim-bqf",
		dependencies = {
			"junegunn/fzf",
			"nvim-treesitter/nvim-treesitter",
		},
		ft = "qf",
		lazy = true,
		opts = { preview = { winblend = 0 } },
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
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"leoluz/nvim-dap-go",
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
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-jest",
		},
		config = function()
			vim.diagnostic.config({
				virtual_text = {
					format = function(diag)
						return diag.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					end,
				},
			}, vim.api.nvim_create_namespace("neotest"))

			local nt = require("neotest")

			nt.setup({
				status = { virtual_text = true },
				output = { open_on_run = true },
				adapters = {
					require("neotest-go"),
					require("neotest-jest")({
						jestCommand = "npm test --",
						jestConfigFile = "custom.jest.config.ts",
						env = { CI = true },
						cwd = function(path)
							return vim.fn.getcwd()
						end,
					}),
				},
				quickfix = {
					open = function()
						if require("lazyvim.util").has("trouble.nvim") then
							vim.cmd("Trouble quickfix")
						else
							vim.cmd("copen")
						end
					end,
				},
			})

			vim.keymap.set("n", "<leader>tT", function()
				nt.run.run(vim.loop.cwd())
			end, { desc = "[T]est all files" })
			vim.keymap.set("n", "<leader>tt", function()
				nt.run.run(vim.fn.expand("%"))
			end, { desc = "[t]est current file" })
			vim.keymap.set("n", "<leader>tr", function()
				nt.run.run()
			end, { desc = "[r]un nearest" })
			vim.keymap.set("n", "<leader>tS", function()
				nt.run.stop()
			end, { desc = "[S]top test" })
			vim.keymap.set("n", "<leader>ts", function()
				nt.summary.toggle()
			end, { desc = "[s]ummary" })
			vim.keymap.set("n", "<leader>tO", function()
				nt.output_panel.toggle()
			end, { desc = "[O]utput panel" })
			vim.keymap.set("n", "<leader>to", function()
				nt.output.open({ enter = true, auto_close = true })
			end, { desc = "[o]utput" })
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
		-- event = { "BufWritePre" },
		-- cmd = { "ConformInfo" },
		config = function()
			local conform = require("conform")
			local ignore_filetypes = { "sql", "java", "javascript", "typescript", "tsx" }
			-- local slow_format_filetypes = {}

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					-- javascript = { { "prettierd", "prettier" } },
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
		"rmagatti/auto-session",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "/" },
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "cpp", "go", "lua", "python", "rust", "tsx", "javascript", "typescript", "vimdoc", "vim", "bash" },
				auto_install = true,
				sync_install = false,
				ignore_install = {},
				modules = {},
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						-- init_selection = 'v',
						scope_incremental = "<c-s>",
						node_incremental = "v",
						node_decremental = "V",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
						goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
						goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
						goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
					},
					swap = {
						enable = true,
						swap_next = { ["<leader>a"] = "@parameter.inner" },
						swap_previous = { ["<leader>A"] = "@parameter.inner" },
					},
				},
			})
		end,
	},

	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.splitjoin").setup()
			require("mini.hipatterns").setup()
			require("mini.align").setup()
			require("mini.sessions").setup({ autoread = true })
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
					["@fix"] = { icon = " ", color = "error", alt = { "FIX", "FIXME", "BUG", "FIXIT", "ISSUE" } },
					["@todo"] = { icon = " ", color = "info", alt = { "TODO" } },
					["@hack"] = { icon = " ", color = "warning", alt = { "HACK" } },
					["@warn"] = { icon = " ", color = "warning", alt = { "WARN", "WARNING", "XXX" } },
					["@perf"] = { icon = " ", alt = { "PERF", "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					["@note"] = { icon = " ", color = "hint", alt = { "NOTE", "INFO" } },
					["@test"] = { icon = "⏲ ", color = "test", alt = { "TEST", "TESTING", "PASSED", "FAILED" } },
				},
			})

			vim.keymap.set("n", "]t", tc.jump_next, { desc = "next todo comment" })
			vim.keymap.set("n", "[t", tc.jump_prev, { desc = "previous todo comment" })
		end,
	},

	-- {
	--   "phaazon/hop.nvim",
	--   lazy = true,
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
