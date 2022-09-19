
local unpack = string.unpack
local data = io.read "*a"
local pos = 0
local function cont (fmt)
	if type(fmt) == "number" then
		fmt = "<i" .. fmt
	end

	local data, newpos = unpack(fmt, data, pos+1)
	pos = newpos-1
	return data, pos
end

local type_count = cont(4)
io.write("4\t", type_count)

local offsets = {}
for j=0,type_count do
	local offset = cont(4)
	offsets[j+1] = offset
	io.write("\t", offset)
end
io.write "\n"

local start_pos = pos

for j=1,type_count do
	if pos-start_pos ~= offsets[j] then
		assert(false, "desync from " .. offsets[j] .. " to " .. (pos-start_pos))
	end

	local entry_count = cont(4)
	local entry_size = cont(4)
	io.write("4\t", entry_count, "\t", entry_size, "\n")

	for k=1,entry_count do
		local word_size = 1
		if arg[j] and entry_size % tonumber(arg[j]) == 0 then
			word_size = tonumber(arg[j])
		elseif entry_size % 4 == 0 then
			word_size = 4
		end

		io.write(word_size)
		for n=word_size,entry_size,word_size do
			io.write("\t", (cont(word_size)))
		end
		io.write "\n"
	end
end

if pos-start_pos ~= offsets[#offsets] then
	assert(false, "desync from strings " .. offsets[#offsets] .. " to " .. (pos-start_pos))
end

while pos < #data do
	io.write("z@", pos-start_pos - offsets[#offsets], "\t", cont "z":gsub("\\([\\rn])", "\\\\"):gsub("\r", "\\r"):gsub("\n", "\\n"), "\n")
end
