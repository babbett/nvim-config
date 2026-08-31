-- Pop the current window's buffer out into a floating window, toggle back to
-- collapse it. Only one popout at a time: triggering from a different window
-- closes the existing popout and opens a new one for the current window.
local popout = nil

local function toggle_popout()
	if popout and not vim.api.nvim_win_is_valid(popout.float_win) then
		popout = nil
	end

	local win = vim.api.nvim_get_current_win()

	if popout then
		local was_float = win == popout.float_win
		local source = popout.source_win
		vim.api.nvim_win_close(popout.float_win, false)
		popout = nil
		if was_float then
			if vim.api.nvim_win_is_valid(source) then
				vim.api.nvim_set_current_win(source)
			end
			return
		end
		-- current window wasn't the float; fall through to open a new popout for it
	end

	local buf = vim.api.nvim_win_get_buf(win)
	local ui = vim.api.nvim_list_uis()[1]
	local width = math.floor(ui.width * 0.9)
	local height = math.floor(ui.height * 0.9)
	local float_win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((ui.height - height) / 2),
		col = math.floor((ui.width - width) / 2),
		border = "rounded",
	})
	popout = { float_win = float_win, source_win = win }
end

vim.keymap.set('n', '<leader>z', toggle_popout, { desc = "Toggle buffer popout float" })

return {}
