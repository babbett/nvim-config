vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.termguicolors = true
vim.opt.incsearch = true    -- n N to go to next, previous when incsearching. or something
vim.opt.ignorecase = true
vim.opt.foldmethod = "expr" -- zA (unfold all), zM (fold all), zj/zk (next/prev fold)
vim.opt.foldlevelstart = 99 -- when opening buffer, nothing is folded
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.scrolloff = 7


-- Link the OS and Vim clipboard together, scheduled after startup (decrease load time)
-- Not sure if i want this, but turning it on for now?
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.g.mapleader = ' '


-- Basic keymap stuff
---- save/quit
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set({ 'n', 'x' }, '<leader>q', ':quit<CR>')
---- yanking
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>s', ':e #<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>S', ':sf #<CR>')
----- terminal
vim.keymap.set('n', '<leader>t', ':below terminal<CR>i')

vim.keymap.set('i', 'jk', '<esc>')

vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- vim.keymap.set('n', '<C-J>', '<C-w>+')
-- vim.keymap.set('n', '<C-K>', '<C-w>-')
-- vim.keymap.set('n', '<C-H>', '<C-w>>')
-- vim.keymap.set('n', '<C-L>', '<C-w><')

---- splits
-- vim.keymap.set('n', '<leader>p', ':vsplit<CR>')
---- rename (should just use 'grn' instead
-- vim.keymap.set('n', '<leader>r', function()
-- 	local newname = vim.fn.input("Enter new name:")
-- 	vim.lsp.buf.rename(newname)
-- end
-- )

-- can use gd to get definition, what can i do to get usage?
-- vim.keymap.set('n', '<leader>gu', function()
--
-- end)

-- function Refactor()
-- 	local new_name = vim.fn.input("Enter new name:")
-- 	vim.lsp.buf.rename(new_name)
-- end

-- Add plugins here
vim.pack.add({
	{ src = "https://github.com/vague-1k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/S1M0N38/love2d.nvim" },
	{ src = "https://github.com/adelarsq/image_preview.nvim" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/karb94/neoscroll.nvim" },
	{ src = "https://github.com/benomahony/oil-git.nvim" },
	-- { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	--{ src = "https://github.com/neovim/nvim-lspconfig" }
	-- moved everything locally, can config the lsp in the ./lsp folder
})
-- trying out smooth scrolling
require "neoscroll".setup({
		duration_multiplier = .5
})

require "toggleterm".setup()
local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

function _lazygit_toggle()
	lazygit:toggle()
end

vim.keymap.set("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

require "love2d.config".setup({
	path_to_love_bin = "/Applications/love.app/Contents/MacOS/love",
	debug_window_opts = {
		split = "below"
	}
})

-- Necessary Plugins
require "mini.pick".setup()
local image_preview = require "image_preview"
image_preview.setup()

local oil = require "oil"
oil.setup({
	columns = { "icon" }
})

require("oil-git").setup()

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
---- Pick
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('v', '<leader>f', '"fyaa:Pick files<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
vim.keymap.set('n', '<leader>F', ':Pick grep<CR>')
---- Oil
vim.keymap.set('n', '<leader>ee', ":Oil<CR>")
vim.keymap.set('n', '<leader>ec', ":Oil ~/.config/nvim<CR>")
vim.keymap.set('n', '<leader>ef', oil.toggle_float)
vim.keymap.set('n', '<leader>eh', oil.toggle_hidden)
vim.keymap.set('n', '<leader>v', oil.toggle_hidden)
---- Love
vim.keymap.set('n', "<leader>vv", "<cmd>LoveRun<cr>")
vim.keymap.set('n', "<leader>vs", "<cmd>LoveStop<cr>")
---- image preview (not supported in iterm2)
vim.keymap.set('n', "<leader>i", image_preview.PreviewImageOil)


-- LSP configs
-- had to install using `brew install lua-language-server`
-- no folding-range
vim.lsp.enable({ "lua_ls", "pylsp" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

-- Colors!!
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")



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
--
-- Commenting:
-- g is a weird command that puts vim into a mode i do not currently understand. does some useful stuff tho
-- gc{motion} comments out whatever is described by the motion
-- gcc comments out a single line (kinda?)
-- gx goes to the link/executes a program
