local uv = vim.uv or vim.loop
local current_flavor

local function detect_flavor()
	local is_dark_mode = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null"):find("Dark") ~= nil
	return is_dark_mode and "mocha" or "latte", is_dark_mode
end

local function apply_theme(force)
	local flavor, is_dark_mode = detect_flavor()
	if not force and current_flavor == flavor then
		return
	end

	current_flavor = flavor
	vim.opt.background = is_dark_mode and "dark" or "light"
	require("catppuccin").setup({
		flavour = flavor,
	})
	vim.cmd.colorscheme("catppuccin")
end

apply_theme(true)

vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		apply_theme(false)
	end,
})

local timer = uv.new_timer()
if timer then
	timer:start(0, 5000, vim.schedule_wrap(function()
		if vim.v.exiting ~= 0 then
			return
		end
		apply_theme(false)
	end))

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			timer:stop()
			timer:close()
		end,
	})
end
