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
opts.signcolumn = "yes"
opts.winborder = "rounded"
opts.termguicolors = true
opts.incsearch = true    -- n N to go to next, previous when incsearching. or something
opts.ignorecase = true
opts.foldmethod = "expr" -- zA (unfold all), zM (fold all), zj/zk (next/prev fold)
opts.foldlevelstart = 99 -- when opening buffer, nothing is folded
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opts.foldtext = ""
opts.scrolloff = 7


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
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/davidmh/mdx.nvim.git" },
	-- web dev lsps
	--   use 'neovim/nvim-lspconfig'
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },
	{ src = "https://github.com/hrsh7th/nvim-cmp.git" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp.git" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help.git" },
	{ src = "https://github.com/hrsh7th/cmp-buffer.git" },
	{ src = "https://github.com/hrsh7th/cmp-path.git" },
  -- Prettier
	{ src = "https://github.com/prettier/vim-prettier.git" },
  -- use {
  --   'prettier/vim-prettier',
  --   run = 'yarn install --frozen-lockfile --production',
  --   ft = {'javascript', 'typescript', 'css', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'}
  -- }
})

-- Config copilot plugin
-- require "copilot".setup({
-- 	suggestion = {
-- 		enabled = true,
-- 		auto_trigger = true
-- 	},
-- 	panel = {
-- 		enabled = true,
-- 		auto_refresh = true,
-- 		layout = {
-- 			position = "right", -- | top | left | right | bottom |
-- 			ratio = 0.4
-- 		},
-- 	},
-- })

-- local function _copilot_toggle()
-- 	if vim.g.copilot_enabled == nil then
-- 		vim.g.copilot_enabled = true
-- 	end
--
-- 	if vim.g.copilot_enabled then
-- 		print("Copilot disabled")
-- 	else
-- 		print("Copilot enabled")
-- 	end
--
-- 	-- this just tracks the state, toggle_auto_trigger actually does the
-- 	-- disable/enable
-- 	vim.g.copilot_enabled = not vim.g.copilot_enabled
--
-- 	require("copilot.suggestion").toggle_auto_trigger()
-- end
--
-- keymap.set("n", "<leader>c", _copilot_toggle, { noremap = true, silent = true })
-- keymap.set("n", "<leader>cp", ":Copilot panel toggle<CR>")

-- Config marks plubing
require "marks".setup({
	default_mappings = true,
	cyclic = true
})


-- Config neoscroll
require "neoscroll".setup({
	duration_multiplier = .5
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
keymap.set('n', '<leader>h', ':Pick help<nCR>')
-- would like to figure out a way to pick from the man pages
keymap.set('n', '<leader>F', ':Pick grep<CR>')
-- Love2D config
require "love2d.config".setup({
	path_to_love_bin = "/Applications/love.app/Contents/MacOS/love",
	debug_window_opts = {
		split = "right"
	}
})

vim.keymap.set('n', "<leader>vv", "<cmd>LoveRun<cr>")
vim.keymap.set('n', "<leader>vs", "<cmd>LoveStop<cr>")
require "plugins/love"


-- Mini icons (for oil)
require "mini.icons".setup()

-- Oil config
local oil = require "oil"
oil.setup({
	columns = { "size", "icon" }
})

require("oil-git").setup()
keymap.set('n', '<leader>ee', ":Oil<CR>")
keymap.set('n', '<leader>ec', ":Oil ~/.config/nvim<CR>")
keymap.set('n', '<leader>ef', oil.toggle_float)
keymap.set('n', '<leader>eh', oil.toggle_hidden)
keymap.set('n', '<leader>v', oil.toggle_hidden)
keymap.set('n', "<leader>i", image_preview.PreviewImageOil)

-- Mason and Treesitter config
require "mason".setup()
require "nvim-treesitter.configs".setup({
	ensure_installed = { "astro", "lua", "typescript", "javascript", "css", "html", "python", "cpp" },
	highlight = { enable = true }
})

-- Auto Commands
-- LSP-based autocompletion when LSP attaches
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client == nil then
			print("LSP client not found")
			return
		end
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

cmd("set completeopt+=noselect")

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
vim.lsp.enable({ "lua_ls", "pylsp" })

keymap.set('n', '<leader>lf', vim.lsp.buf.format)
