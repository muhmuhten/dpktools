for line in io.lines() do
	line = line:gsub("^%s*#", "0#"):gsub("#.*", "")
	if line:byte() == 122 then
		io.write(line:sub(line:match("\t()")):gsub("\\n", "\n"):gsub("\\r", "\r"):gsub("\\\\", "\\"), "\0")
	else
		local width, rest = line:match("(%d+)(.*)")
		for num in rest:gmatch("%S+") do
			io.write(string.pack("<i"..width, tonumber(num)))
		end
	end
end
