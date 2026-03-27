-- Love 2D config 
require "love2d.config".setup({
	path_to_love_bin = "/Applications/love.app/Contents/MacOS/love",
	debug_window_opts = {
		split = "right"
	}
})

-- Love
vim.keymap.set('n', "<leader>vv", "<cmd>LoveRun<cr>")
vim.keymap.set('n', "<leader>vs", "<cmd>LoveStop<cr>")

function LoveCreateProject()
	local project_name = vim.fn.input("Enter project name: ")
	if project_name == "" then
		print("Project creation cancelled.")
		return
	end

	local project_path = vim.fn.input("Enter project path (default: current directory): ")
	if project_path == "" then
		project_path = vim.fn.getcwd()
	end

	local full_path = project_path .. "/" .. project_name

	if vim.fn.isdirectory(full_path) == 1 then
		print("Directory already exists: " .. full_path)
		return
	end

	vim.fn.mkdir(full_path, "p")

	local main_lua_content = [[
		function love.load()
			print("Hello, Love2D!")
		end
	]]
	local file = io.open(full_path .. "/main.lua", "w")
	if file then
		file:write(main_lua_content)
		file:close()
		print("Created Love2D project at: " .. full_path)
	else
		print("Error creating main.lua in: " .. full_path)
	end
end

-- Make command available
vim.api.nvim_create_user_command('LoveCreateProject', LoveCreateProject, {})

-- Create a template for love2d projects
vim.keymap.set('n', '<leader>cl', ':LoveCreateProject<CR>')

return {}
