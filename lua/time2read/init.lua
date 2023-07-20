local M = {}

local filetypes = { "markdown" }
local wpm = 150
local preferred_time = 0

function M.setup(options)
	options = options or {}
	filetypes = options.filetypes or { "markdown" }
	wpm = options.wpm or 150
	preferred_time = options.preferred_time or 0

	vim.api.nvim_create_autocmd({ "InsertCharPre" }, {
		-- pattern = { "*.md" },
		callback = M.time2read_insert,
		-- group = "time2reader",
	})
end

local function minutes2read()
	local wordcount = vim.fn.wordcount().words
	local result = wordcount / wpm
	return result
end

local function minutes2time(total_minutes)
	local days = math.floor(total_minutes / 1440)
	local hours = math.floor((total_minutes % 1440) / 60)
	local minutes = math.floor((total_minutes % 1440) % 60)
	local seconds = math.floor((total_minutes * 60) % 60)

	return days, hours, minutes, seconds
end

function M.time2read_insert()
	local filetype_check = vim.tbl_contains(filetypes, vim.bo.filetype)
	local _, hours, minutes, seconds = minutes2time(minutes2read())

	if filetype_check == false then
		return nil
	elseif filetype_check == true and preferred_time == 0 then
		return string.format("%02d:%02d′%02d″", hours, minutes, seconds)
	elseif filetype_check == true and preferred_time ~= 0 then
		local percent = math.floor(minutes2read() * 100 / preferred_time)
		local time = string.format("%02d′%02d″", minutes, seconds)
		local result = tostring(percent) .. "%% " .. time

		return result
	end
end

return M
