local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local objects = {
	ship = {},
	batteries = {},
}

local batteries = {}

RegisterNetEvent("fireworks:setupObjects", function(list)
	local count = 0
	for k, v in ipairs(list.ship) do
		if LoadModel(v.model) then
			local object = CreateObjectNoOffset(v.model, v.x, v.y, v.z, false, true, false)
			SetEntityHeading(object, v.h)
			FreezeEntityPosition(object, true)
			objects.ship[k] = object
			count = count + 1
		end
	end
	print("^3" .. count .. " ^2ship parts created!")

	count = 0
	batteries = list.batteries
	for k, v in ipairs(list.batteries) do
		if LoadModel(v.model) then
			local object = CreateObjectNoOffset(v.model, v.x, v.y, v.z - 1.0, false, true, false)
			SetEntityHeading(object, v.h)
			FreezeEntityPosition(object, true)
			objects.batteries[k] = object
			count = count + 1
		end
	end
	print("^3" .. count .. " ^2firework batteries created!")
end)


local particleList = {
	"scr_indep_firework_trailburst",
	"scr_indep_firework_fountain",
}

RegisterNetEvent("fireworks:sync", function(current)
	local selectedParticle = particleList[math.random(#particleList)]
	for k, enabled in ipairs(current) do
		if parseInt(enabled) == 0 then
			selectedParticle = particleList[1]
			break
		end
	end

	for k, enabled in ipairs(current) do
		local battery = batteries[k]
		if battery and parseInt(enabled) == 1 then
			local particleDict = "scr_indep_fireworks"
			if LoadPtfxAsset(particleDict) then
				UseParticleFxAssetNextCall(particleDict)
				StartParticleFxNonLoopedAtCoord(selectedParticle,battery.x,battery.y,battery.z,0.0,0.0,0.0,2.5,false,false,false,false)
			end
		end
	end
end)

function LoadModel(modelName)
	local model = GetHashKey(modelName)
	if not IsModelValid(model) or not IsModelInCdimage(model) then
		print("Modelo inválido!", modelName)
		return
	end

	while not HasModelLoaded(model) do
		-- print("Loading...")
		RequestModel(model)
		Wait(10)
	end
	return true
end