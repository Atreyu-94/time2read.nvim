local M = {}

local filetypes = {}
local wpm = 150

local wordcount = vim.fn.wordcount().words
local visual_wordcount = vim.fn.wordcount().visual_words

local function minutes2read()
	local result = wordcount / wpm
	return result
end

local function minutes2time(total_minutes)
	local days = math.floor(total_minutes / 1440)
	local hours = math.floor((total_minutes - (days * 1440)) / 60)
	local minutes = math.floor(total_minutes - (days * 1440) - (hours * 60))

	--[[	if days == 0 then
		days = "00"
	elseif hours == 0 then
		hours = "00"
	elseif minutes == 0 then
		minutes = "00"
	end]]
	--

	return days, hours, minutes
end

local function filetype_check()
	return vim.tbl.contains(filetypes, vim.bo.filetype) == true or false
end

function M.setup(options)
	options = options or {}
	filetypes = options.filetypes or { "markdown" }
	wpm = options.wpm or 150
end

function M.time2read_insert()
	if filetype_check() == true then
		vim.api.nvim_create_autocmd("BufWritePost", {
			callback = minutes2time(minutes2read()),
		})

		return minutes2time(minutes2read).days
			.. ":"
			.. minutes2time(minutes2read).hours
			.. ":"
			.. minutes2time(minutes2read).minutes
	else
		return nil
	end
end

return M
