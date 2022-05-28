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
Tunnel.bindInterface("blipsystem",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local userList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local tempList = {}
		for k,v in pairs(userList) do
			local ped = GetPlayerPed(k)
			if DoesEntityExist(ped) then
				tempList[k] = { GetEntityCoords(ped),v[1],v[2],v[3] }
			end
		end

		for k,v in pairs(userList) do
			async(function()
				if v[1] ~= "Prisioneiro" and v[1] ~= "Corredor" then
					TriggerClientEvent("blipsystem:Blips",k,tempList)
				end
			end)
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:SERVICEENTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("blipsystem:serviceEnter")
AddEventHandler("blipsystem:serviceEnter",function(source,service,color)
	if userList[source] == nil then
		userList[source] = { service,color }
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:SERVICEEXIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("blipsystem:serviceExit")
AddEventHandler("blipsystem:serviceExit",function(source)
	TriggerClientEvent("blipsystem:Clear",source)
	serviceExit(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	serviceExit(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:SERVICEEXIT
-----------------------------------------------------------------------------------------------------------------------------------------
function serviceExit(source)
	if userList[source] then
		userList[source] = nil

		for k,v in pairs(userList) do
			async(function()
				TriggerClientEvent("blipsystem:Remove",k,source)
			end)
		end
	end
end