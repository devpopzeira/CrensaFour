-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("engine",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehFuels = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentFuel(price)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.paymentFull(user_id,price) then
			return true
		else
			TriggerClientEvent("Notify",source,"vermelho","Dólares insuficientes.",5000)
			return false
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.vehicleFuel(vehicle)
	if vehFuels[vehicle] == nil then
		vehFuels[vehicle] = 50
	end

	return vehFuels[vehicle]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:tryFuel")
AddEventHandler("engine:tryFuel",function(vehicle,fuel,playerAround)
	vehFuels[vehicle] = fuel

	if playerAround then
		for _,v in ipairs(playerAround) do
			async(function()
				TriggerClientEvent("engine:syncFuel",v,vehicle,fuel)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTENGINES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:insertEngines")
AddEventHandler("engine:insertEngines",function(vehicle,vehFuel,vehBrake)
	vehFuels[vehicle] = vehFuel
end)