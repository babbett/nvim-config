-- Vim Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.termguicolors = true
vim.opt.incsearch = true -- crtl-g ctrl-t to go to next, previous when incsearching. or something
vim.opt.ignorecase = true
vim.opt.foldmethod = "expr" -- zA (unfold all), zM (fold all), zj/zk (next/prev fold)
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""

vim.g.mapleader = ' '

-- Basic keymap stuff
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>s', ':e #<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>S', ':sf #<CR>')
vim.keymap.set('n', '<leader>t', ':below terminal<CR>i')

-- Add plugins here
vim.pack.add({
	{ src = "https://github.com/vague-1k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	--{ src = "https://github.com/neovim/nvim-lspconfig" }
	-- moved everything locally, can config the lsp in the ./lsp folder
})

require "mini.pick".setup()
require "oil".setup({
	view_options = { show_hidden = true }
})
require "mason".setup()
require "nvim-treesitter.configs".setup({
	ensure_installed = { "lua", "typescript", "javascript", "css", "html", "python", "cpp" },
	highlight = { enable = true }
})

-- Genuinely don't know how this works... seems to work though. from some blog
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

-- Config Plugins
vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")


vim.keymap.set('n', '<leader>ee', ":Oil<CR>")
vim.keymap.set('n', '<leader>ec', ":Oil ~/.config/nvim<CR>")


-- LSP configs
-- had to install using `brew install lua-language-server`
-- no folding-range
vim.lsp.enable({ "lua_ls", "pylsp" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

-- Colors!!
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")


-- This is all noob shit
--
--
-- Notes on some mappings so I don't forget --
-- Hover (vim.lsp.buf.hover()): shift-K, shift-K-K to go into the menu
-- Native LSP hover: Ctrl-W-D (window diagnostic)
--
-- Notes on Vim, i guess --
-- Buffers, Windows, and Tabs --
-- Buffer: text file in memory. :ls to view them
-- Window: viewport on the buffer. :vsp creates a vertical split, two viewports
-- on one buffer. :b *name of buffer* to show a buffer in a window
-- Tabs: collection of windows. Basically a layout, not actually a tab
