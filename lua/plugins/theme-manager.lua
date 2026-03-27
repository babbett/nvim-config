-- Theme Manager Plugin Configuration
-- require "theme-manager".setup({
-- 		themes = {
-- 				"gruvbox",
-- 				"nord",
-- 				"tokyonight",
-- 				"catppuccin",
-- 		},
-- 		default_theme = "tokyonight",
-- 		switch_keymap = "<leader>tt",
-- 		auto_switch = true,
-- })

--- Theme Manager Plugin Configuration
--- A simple theme manager to switch between installed themes
--- @class theme-manager
--- @field available_themes string[] List of available themes
--- @field current_theme string Current active theme
--- @field switch_keymap string Keymap to switch themes
local theme_manager = {
	available_themes = { "vague", "lytmode" },
	current_theme = "lytmode",
	switch_keymap = "<leader>tt",
}

local cmd = vim.cmd

vim.pack.add({
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/github-main-user/lytmode.nvim" },
})

-- Colors!!
require "lytmode".setup({
	italic_comments = true,
})

cmd("colorscheme lytmode")
-- vim.cmd("colorscheme vague")

-- Some modifitcations to the theme
cmd(":hi statusline guibg=NONE guifg=#cc8222")
-- set the background of the ui black
cmd(":hi Normal guibg=clear")
cmd(":hi SignColumn guibg=black")
cmd(":hi LineNr guibg=black guifg=#444444")
-- set the number column numbers to a dark gray
cmd(":hi CursorLineNr guibg=#000000 guifg=#000000")
-- set the color of the current line number to black on black to hide it


-- make the line number of the current line stand out
cmd(":hi Folded guibg=black guifg=#ffffff")
print("Theme manager loaded")

return {}
