patterns = {}

Citizen.CreateThread(function()
	local counter = 1
	local content
	while true do
		content = LoadResourceFile("heyy_fireworks", "src/patterns/" .. counter .. ".txt")
		if not content then 
			print((counter - 1) .. " patterns loaded!")
			break 
		end

		local splitted = split(content, "([^\n]+)")
		for k, v in ipairs(splitted) do
			patterns[k] = (patterns[k] or "") .. v
		end

		counter = counter + 1
		Wait(0)
	end
end)

function split(content, char)
	local splitted = {}
	for word in content:gmatch(char) do 
		table.insert(splitted, word)
	end
	return splitted
end
