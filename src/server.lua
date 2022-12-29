local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())

local times = {
	start = "29/12 14:25",
	finish = "29/12 14:30",
}


Citizen.CreateThread(function()
	GlobalState.fireworks = false

	Wait(3000)
	while true do
		local time = os.date("%d/%m %H:%M")
		if time == times.start then
			if not GlobalState.fireworks then
				startFireworks()
			end
		end
		Wait(2000)
	end
end)

-- Fireworks Show
local objectList = {
	ship = {
		{ x = -1983.21, y = -1406.4, z = 5.0, h = 141.03 + 180, model = "des_shipsink_01" },
		{ x = -1983.21, y = -1406.4, z = 5.0, h = 141.03 + 180, model = "des_shipsink_02" },
		{ x = -1983.21, y = -1406.4, z = 5.0, h = 141.03 + 180, model = "des_shipsink_03" },
		{ x = -1983.21, y = -1406.4, z = 5.0, h = 141.03 + 180, model = "des_shipsink_04" },
		{ x = -1983.21, y = -1406.4, z = 5.0, h = 141.03 + 180, model = "des_shipsink_05" },
	},
	batteries = {
		--[[ 01 ]] { x = -1951.99, y = -1408.93, z = 20.49, h = 0.0, model = "ind_prop_firework_03" }, -- Container 1
		--[[ 02 ]] { x = -1953.52, y = -1407.57, z = 20.49, h = 0.0, model = "ind_prop_firework_03" }, -- Container 1
		--[[ 03 ]] { x = -1955.22, y = -1406.10, z = 20.49, h = 0.0, model = "ind_prop_firework_03" }, -- Container 1
		--[[ 04 ]] { x = -1957.09, y = -1404.58, z = 20.49, h = 0.0, model = "ind_prop_firework_03" }, -- Container 1
		--[[ 05 ]] { x = -1964.70, y = -1398.36, z = 20.64, h = 0.0, model = "ind_prop_firework_03" }, -- Container 2
		--[[ 06 ]] { x = -1967.15, y = -1395.94, z = 20.64, h = 0.0, model = "ind_prop_firework_03" }, -- Container 2
		--[[ 07 ]] { x = -1970.01, y = -1393.58, z = 20.64, h = 0.0, model = "ind_prop_firework_03" }, -- Container 2
		--[[ 08 ]] { x = -1976.87, y = -1388.28, z = 20.70, h = 0.0, model = "ind_prop_firework_03" }, -- Container 3
		--[[ 09 ]] { x = -1978.85, y = -1386.96, z = 20.70, h = 0.0, model = "ind_prop_firework_03" }, -- Container 3
		--[[ 10 ]] { x = -1980.87, y = -1385.30, z = 20.70, h = 0.0, model = "ind_prop_firework_03" }, -- Container 3
		--[[ 11 ]] { x = -1983.62, y = -1383.03, z = 20.70, h = 0.0, model = "ind_prop_firework_03" }, -- Container 3
		--[[ 12 ]] { x = -1999.51, y = -1370.18, z = 20.60, h = 0.0, model = "ind_prop_firework_03" }, -- Container 4
		--[[ 13 ]] { x = -2001.77, y = -1368.35, z = 20.60, h = 0.0, model = "ind_prop_firework_03" }, -- Container 4
		--[[ 14 ]] { x = -2004.05, y = -1366.60, z = 20.60, h = 0.0, model = "ind_prop_firework_03" }, -- Container 4
		--[[ 14 ]] { x = -2005.49, y = -1365.46, z = 20.60, h = 0.0, model = "ind_prop_firework_03" }, -- Container 4
		--[[ 15 ]] { x = -2007.23, y = -1363.85, z = 20.03, h = 0.0, model = "ind_prop_firework_03" }, -- Container 4
	}
}

function startFireworks()
	while GlobalState.Hours ~= 0 do
		local hours = GlobalState.Hours
		local minutes = GlobalState.Minutes
		if minutes < 30 then
			GlobalState.Minutes = 30
		else
			GlobalState.Minutes = 0
			if hours + 1 < 24 then
				GlobalState.Hours = hours + 1
			else
				GlobalState.Hours = 0
			end
		end
		Wait(1000)
	end

	GlobalState.Hours = 0
	GlobalState.Minutes = 0

	GlobalState.fireworks = true
	TriggerClientEvent("Notify",-1,"sucesso","Evento iniciado!")

	TriggerClientEvent("fireworks:setupObjects", -1, objectList)

	Wait(5000)
	local currentPos = 1
	while os.date("%d/%m %H:%M") ~= times.finish do
		local hasOneEnabled = false
		local currentFireworks = {}
		for k, v in ipairs(patterns) do
			local chars = {}
			for char in v:gmatch("%d") do
				table.insert(chars, char)
			end

			if #chars < currentPos then
				currentPos = 0
				print("Fireworks pattern re-started!")
				goto skip
			end

			local char = chars[currentPos]
			if parseInt(char) == 1 then
				hasOneEnabled = true
			end
			currentFireworks[k] = char
		end

		if not hasOneEnabled then
			goto skip
		end

		TriggerClientEvent("fireworks:sync", -1, currentFireworks)
		::skip::
		currentPos = currentPos + 1
		Wait(500)
	end

	GlobalState.fireworks = false
	TriggerClientEvent("Notify",-1,"aviso","Evento finalizado!")
end

AddEventHandler("Connect", function(user_id, source)
	if GlobalState.fireworks then
		TriggerClientEvent("fireworks:setupObjects", source, objectList)
	end
end)
