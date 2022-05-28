-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local showBlips = {}
local timeBlips = {}
local numberBlips = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("enterNotifys",function(source,args,rawCommand)
	if not exports["player"]:blockCommands() and not exports["player"]:handCuff() and MumbleIsConnected() then
		SendNUIMessage({ action = "showAll" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("enterNotifys","Consultar as notificações.","keyboard","F2")
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFYPUSH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("NotifyPush")
AddEventHandler("NotifyPush",function(data)
	data["street"] = GetStreetNameFromHashKey(GetStreetNameAtCoord(data["x"],data["y"],data["z"]))

	SendNUIMessage({ action = "notify", data = data })

	numberBlips = numberBlips + 1

	timeBlips[numberBlips] = 60
	showBlips[numberBlips] = AddBlipForCoord(data["x"],data["y"],data["z"])

	SetBlipSprite(showBlips[numberBlips],270)
	SetBlipDisplay(showBlips[numberBlips],4)
	SetBlipAsShortRange(showBlips[numberBlips],true)
	SetBlipColour(showBlips[numberBlips],data["blipColor"])
	SetBlipScale(showBlips[numberBlips],0.9)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(data["title"])
	EndTextCommandSetBlipName(showBlips[numberBlips])

	if parseInt(data["code"]) == 13 then
		TriggerEvent("sounds:source","deathcop",0.7)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(timeBlips) do
			if timeBlips[k] > 0 then
				timeBlips[k] = timeBlips[k] - 1

				if timeBlips[k] <= 0 then
					RemoveBlip(showBlips[k])
					showBlips[k] = nil
					timeBlips[k] = nil
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOCUSON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("focusOn",function()
	SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOCUSOFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("focusOff",function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("setWay",function(data)
	SetNewWaypoint(data["x"] + 0.0001,data["y"] + 0.0001)
	SendNUIMessage({ action = "hideAll" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("phoneCall",function(data)
	exports["smartphone"]:callPlayer(data["phone"])
	SendNUIMessage({ action = "hideAll" })
end)