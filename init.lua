local opts = vim.opt
local keymap = vim.keymap
local cmd = vim.cmd
local pack = vim.pack

opts.number = true
opts.relativenumber = true
opts.wrap = false
opts.tabstop = 2
opts.shiftwidth = 2
opts.swapfile = false
opts.undofile = true -- save undo history to `undodir`
opts.signcolumn = "yes"
opts.winborder = "rounded"
opts.termguicolors = true
opts.incsearch = true    -- n N to go to next, previous when incsearching. or something
opts.smartcase = true    -- case insensitive searches if no caps in query, case sensitive if caps included
opts.foldmethod = "expr" -- zA (unfold all), zM (fold all), zj/zk (next/prev fold)
opts.foldlevelstart = 99 -- when opening buffer, nothing is folded
opts.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opts.foldtext = ""
opts.scrolloff = 7
opts.updatetime = 750 -- recommended time [here](https://www.reddit.com/r/vim/comments/3ql651/what_do_you_set_your_updatetime_to/)



-- Link the OS and Vim clipboard together, scheduled after startup (decrease load time)
-- Not sure if i want this, but turning it on for now?
vim.schedule(function()
	opts.clipboard = "unnamedplus"
end)

vim.g.mapleader = ' '


-- Basic keymap stuff
---- save/quit
keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
keymap.set('n', '<leader>w', ':write<CR>')
keymap.set({ 'n', 'x' }, '<leader>q', ':quit<CR>')
---- yanking
keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')
keymap.set({ 'n', 'v', 'x' }, '<leader>s', ':e #<CR>')
keymap.set({ 'n', 'v', 'x' }, '<leader>S', ':sf #<CR>')

keymap.set('n', '<C-j>', '<C-w>j')
keymap.set('n', '<C-k>', '<C-w>k')
keymap.set('n', '<C-h>', '<C-w>h')
keymap.set('n', '<C-l>', '<C-w>l')

-- splits
-- vim.keymap.set('n', '<leader>p', ':vsplit<CR>')

-- Add plugins here
pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/S1M0N38/love2d.nvim" },
	{ src = "https://github.com/adelarsq/image_preview.nvim" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/karb94/neoscroll.nvim" },
	{ src = "https://github.com/benomahony/oil-git.nvim" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	-- web dev lsps
	--   use 'neovim/nvim-lspconfig'
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },
	{ src = "https://github.com/hrsh7th/nvim-cmp.git" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp.git" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help.git" },
	{ src = "https://github.com/hrsh7th/cmp-buffer.git" },
	{ src = "https://github.com/hrsh7th/cmp-path.git" },
	{ src = "https://github.com/windwp/nvim-ts-autotag.git" },
	{ src = "https://github.com/windwp/nvim-autopairs.git" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim.git" },
	{ src = "https://github.com/folke/which-key.nvim.git" },
	{ src = "https://github.com/nvim-mini/mini.extra" },
	-- claude
	{ src = "https://github.com/greggh/claude-code.nvim.git" },
})


-- Config marks plubing
require "marks".setup({
	default_mappings = true,
	cyclic = true
})


-- Config neoscroll
require "neoscroll".setup({
	duration_multiplier = .5
})

-- Config which-key (labels the leader-key groups below so they show up in
-- the popup instead of just a flat list of raw mappings)
require "which-key".setup()
require "which-key".add({
	{ "<leader>e", group = "Explore (Oil)" },
	{ "<leader>f", group = "Find" },
	{ "<leader>c", group = "Git hunk" },
	{ "<leader>l", group = "LSP" },
})
-- classic, modern, helix

-- Config gitsigns (in-buffer git gutter signs, hunk staging/preview)
require "gitsigns".setup({
	on_attach = function(bufnr)
		local function map(mode, lhs, rhs, desc)
			keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end
		local gs = require "gitsigns"

		map('n', ']h', gs.next_hunk, "Next hunk")
		map('n', '[h', gs.prev_hunk, "Prev hunk")
		map('n', '<leader>cs', gs.stage_hunk, "Stage hunk")
		map('n', '<leader>cr', gs.reset_hunk, "Reset hunk")
		map('n', '<leader>cp', gs.preview_hunk, "Preview hunk")
		map('n', '<leader>cb', gs.toggle_current_line_blame, "Toggle line blame")
	end,
})

-- Config lazygit
require "toggleterm".setup()
local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

local function _lazygit_toggle()
	lazygit:toggle()
end

keymap.set("n", "<leader>g", _lazygit_toggle, { noremap = true, silent = true })

-- Config terminal
local floatterm = Terminal:new({ direction = "float" })

local function _float_term_toggle()
	floatterm:toggle()
end

keymap.set("n", "<leader>t", _float_term_toggle, { noremap = true, silent = true })
keymap.set('n', '<leader>T', ':below terminal<CR>i')

-- Mini Pick config
require "mini.pick".setup()
local image_preview = require "image_preview"
image_preview.setup()

keymap.set('n', '<leader>f', ':Pick files<CR>')
keymap.set('v', '<leader>f', '"fyaa:Pick files<CR>')
keymap.set('n', '<leader>h', ':Pick help<CR>')
-- would like to figure out a way to pick from the man pages
keymap.set('n', '<leader>F', ':Pick grep<CR>')

-- Mini Extra: extra mini.pick pickers (diagnostics, LSP symbols, oldfiles)
require "mini.extra".setup()
local mini_extra = require "mini.extra"
keymap.set('n', '<leader>fd', mini_extra.pickers.diagnostic, { desc = "Diagnostics" })
keymap.set('n', '<leader>fo', mini_extra.pickers.oldfiles, { desc = "Recent files" })
keymap.set('n', '<leader>fs', function() mini_extra.pickers.lsp({ scope = 'document_symbol' }) end,
	{ desc = "Document symbols" })

-- Grep a string project-wide without the interactive prompt (e.g. to jump
-- from `document.getElementById("manual-url")` in a .js file to the matching
-- id="manual-url" in an .html file).
local function grep_pattern(pattern)
	if pattern == '' then return end
	-- Escape regex metacharacters so the search is a literal match, since
	-- mini.pick passes the pattern straight through to ripgrep as a regex.
	local escaped = pattern:gsub('[%^%$%.%*%+%?%(%)%[%]%{%}%|\\]', '\\%0')
	require("mini.pick").builtin.grep({ pattern = escaped })
end

-- Normal mode: grep the quoted string under the cursor (covers
-- `getElementById("manual-url")`), falling back to the word under the cursor.
keymap.set('n', '<leader>fw', function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local from = 1
	while true do
		local s, e, str = line:find('["\']([^"\']-)["\']', from)
		if not s then break end
		if col >= s and col <= e then
			grep_pattern(str)
			return
		end
		from = e + 1
	end
	grep_pattern(vim.fn.expand('<cword>'))
end, { desc = "Grep string/word under cursor" })

-- Visual mode: grep the selected text.
keymap.set('x', '<leader>fw', function()
	vim.cmd('normal! "zy')
	grep_pattern(vim.fn.getreg('z'))
end, { desc = "Grep visual selection" })
-- Love2D config
require "plugins/love"

-- Buffer popout (floating window toggle)
require "plugins/popout"


-- Mini icons (for oil)
require "mini.icons".setup()

-- Oil config
local oil = require "oil"
oil.setup({
	columns = { "size", "icon" }
})

require("oil-git").setup()
keymap.set('n', '<leader>ee', ":Oil<CR>", { desc = "Open oil to the current directory" })
keymap.set('n', '<leader>ec', ":Oil ~/.config/nvim<CR>", { desc = "Open Oil to the nvim config" })
keymap.set('n', '<leader>ef', oil.toggle_float, { desc = "Open Oil to a floating window" })
keymap.set('n', '<leader>eh', oil.toggle_hidden, { desc = "Hide/show the hidden files in the directory" })
keymap.set('n', "<leader>i", image_preview.PreviewImageOil, { desc = "Open an image preview of the file under the cursor" })

-- Mason and Treesitter config
require "mason".setup()
require "nvim-treesitter.configs".setup({
	ensure_installed = { "astro", "lua", "typescript", "javascript", "css", "html", "python", "cpp", "c_sharp", "gdscript" },
	highlight = { enable = true }
})

-- Auto-close and auto-rename html/jsx/etc tags based on treesitter
require "nvim-ts-autotag".setup()

-- claude config
require "claude-code".setup()

-- nvim-cmp config
local cmp = require "cmp"
cmp.setup({
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "path" },
	}, {
		{ name = "buffer" },
	}),
})

cmd("set completeopt=menu,menuone,noselect")

-- Autopairs (bracket/quote auto-close), wired to auto-add the closing pair
-- of a function call when a completion is confirmed (e.g. confirming
-- `foo` inserts `foo()` with the cursor between the parens).
require "nvim-autopairs".setup()
cmp.event:on('confirm_done', require "nvim-autopairs.completion.cmp".on_confirm_done())

-- Markdown-specific settings
vim.api.nvim_create_autocmd('BufWinEnter', {
	pattern = { '*.md' },
	callback = function()
		vim.opt.wrap = true
		-- vim.opt.colorcolumn = '80'
		-- vim.opt.textwidth = 80
	end,
})

vim.api.nvim_create_autocmd('BufWinLeave', {
	pattern = { '*.md' },
	callback = function()
		vim.opt.wrap = false
		-- vim.opt.colorcolumn = '120'
		-- vim.opt.textwidth = 120
	end,
})

-- Themes and appearance
require "plugins/theme-manager"

-- LSP configs
-- had to install using `brew install lua-language-server`
-- no folding-range
vim.lsp.config('*', {
	capabilities = require "cmp_nvim_lsp".default_capabilities(),
})

vim.lsp.inlay_hint.enable(true)

-- eslint (JS/TS linter, separate from ts_ls which only type-checks). Only
-- attaches in projects with an eslint config file. Requires the
-- `vscode-eslint-language-server` binary on $PATH:
--   npm i -g vscode-langservers-extracted
-- or `:MasonInstall eslint-lsp`.
-- Its auto-fixable rules are applied on save from the format-on-save
-- autocmd below (before formatting runs), so eslint fixes and formatting
-- can't race or apply out of order.

-- TODO (deferred, noted 2026-08-31): add nvim-dap + nvim-dap-ui + netcoredbg
-- for step-through C# debugging. Skipping for now.

-- TODO: switch C# from omnisharp to roslyn_ls once it's worth the extra setup
-- omnisharp scans its own process cwd for projects/solutions rather than taking
-- a root argument, but Neovim doesn't set the LSP process's cwd to root_dir by
-- default. Wrapping cmd as a function lets us pass the already-resolved
-- config.root_dir through as the spawned process's cwd. (Explicit vim.lsp.config()
-- calls always beat lsp/*.lua files on the runtimepath, so this is done here
-- rather than in lsp/omnisharp.lua, to avoid losing a merge race against
-- nvim-lspconfig's own bundled omnisharp.lua.)
vim.lsp.config('omnisharp', {
	cmd = function(dispatchers, config)
		local cmd = {
			vim.fn.executable('OmniSharp') == 1 and 'OmniSharp' or 'omnisharp',
			'-z',
			'--hostPID', tostring(vim.fn.getpid()),
			'DotNet:enablePackageRestore=false',
			'--encoding', 'utf-8',
			'--languageserver',
		}
		return vim.lsp.rpc.start(cmd, dispatchers, { cwd = config.root_dir })
	end,
})

vim.lsp.enable({ "lua_ls", "pylsp", "ts_ls", "html", "cssls", "eslint", "omnisharp", "gdscript", "markdown", "marksman" })

-- Notify when a normal file buffer has no LSP client attached (e.g. no server
-- configured for the filetype, or the configured one failed to start).
-- Deferred to give the client time to spawn and attach before checking.
vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('LspAttachCheck', { clear = true }),
	callback = function(args)
		local bufnr, ft = args.buf, args.match
		if ft == '' then return end
		vim.defer_fn(function()
			if not vim.api.nvim_buf_is_valid(bufnr) then return end
			if vim.bo[bufnr].buftype ~= '' then return end
			if #vim.lsp.get_clients({ bufnr = bufnr }) == 0 then
				vim.notify('No LSP found for ' .. ft, vim.log.levels.WARN)
			end
		end, 1000)
	end,
})

keymap.set('n', '<leader>lf', vim.lsp.buf.format)

-- Format on save (LSP-backed: html, cssls, ts_ls all support textDocument/formatting).
-- For js/ts, apply eslint's auto-fixable rules first, synchronously, so they
-- land before (and don't race with) the formatter.
vim.api.nvim_create_autocmd('BufWritePre', {
	group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true }),
	pattern = { '*.html', '*.css', '*.js', '*.jsx', '*.ts', '*.tsx' },
	callback = function(args)
		local eslint = vim.lsp.get_clients({ bufnr = args.buf, name = 'eslint' })[1]
		if eslint then
			eslint:request_sync('workspace/executeCommand', {
				command = 'eslint.applyAllFixes',
				arguments = {
					{ uri = vim.uri_from_bufnr(args.buf), version = vim.lsp.util.buf_versions[args.buf] },
				},
			}, 2000, args.buf)
		end
		vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 2000 })
	end,
})
