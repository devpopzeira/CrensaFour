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
Tunnel.bindInterface("chest",cRP)
vSERVER = Tunnel.getInterface("chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local chestOpen = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local chestCoords = {
	{ "State",360.43,-1600.48,25.83,"1" },
	{ "Lspd",486.46,-994.94,31.07,"1" },
	{ "Sheriff",1836.96,3685.16,34.80,"1" },
	{ "Sheriff",-445.38,6019.65,37.38,"1" },
	{ "Ranger",386.72,800.09,187.47,"1" },
	{ "Corrections",1844.31,2573.84,46.26,"1" },
	{ "Paramedic",306.17,-601.98,43.25,"1" },
	{ "Paramedic",-258.00,6332.62,32.72,"1" },
	{ "Mechanic",124.03,-3007.52,7.02,"1" },
	{ "Mechanic",550.83,-194.0,54.49,"1" },
	{ "Ballas",95.63,-1984.42,20.35,"3" },
	{ "Vagos",371.43,-2047.06,21.95,"3" },
	{ "Vanilla",93.73,-1290.75,28.72,"1" },
	{ "Triads",-816.57,-695.90,31.87,"1" },
	{ "Arcade",-1648.71,-1073.21,13.83,"1" },
	{ "Desserts",-590.63,-1058.59,22.64,"1" },
	{ "Aztecas",513.03,-1803.79,28.40,"3" },
	{ "Families",-153.34,-1628.55,33.52,"3" },
	{ "EastSide",1162.06,-1634.68,36.85,"1" },
	{ "Bloods",233.09,-1751.65,28.91,"3" },
	{ "TheLost",2527.20,4109.24,39.14,"1" },
	{ "Vinhedo",-1870.64,2059.23,135.44,"1" },
	{ "Playboy",-1524.90,148.86,60.74,"1" },
	{ "Salieris",413.24,-1498.08,33.72,"1" },
	{ "PizzaThis",796.54,-749.05,31.26,"1" },
	{ "BurgerShot",-1191.58,-902.94,13.99,"1" },
	{ "PopsDiner",1597.65,6453.04,25.31,"1" },
	{ "Crips",-1079.82,-1679.64,4.57,"1" },
	{ "Streets",70.44,-1391.86,29.37,"3" },
	{ "trayShot",-1195.20,-893.13,14.41,"2",true },
	{ "trayDesserts",-584.01,-1059.30,22.41,"2",true },
	{ "trayPops",1586.68,6457.04,26.21,"2",true },
	{ "trayPizza",811.10,-752.78,26.74,"2",true }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTINFOS
-----------------------------------------------------------------------------------------------------------------------------------------
local chestInfos = {
	["1"] = {
		{
			event = "chest:openSystem",
			label = "Abrir",
			tunnel = "shop"
		},{
			event = "chest:upgradeSystem",
			label = "Aumentar",
			tunnel = "shop"
		}
	},
	["2"] = {
		{
			event = "chest:openSystem",
			label = "Bandeja",
			tunnel = "shop"
		}
	},
	["3"] = {
		{
			event = "chest:openSystem",
			label = "Abrir",
			tunnel = "shop"
		},{
			event = "chest:upgradeSystem",
			label = "Aumentar",
			tunnel = "shop"
		},{
			event = "crafting:Toys",
			label = "Criação",
			tunnel = "shop"
		}
	},
	["4"] = {
		{
			event = "chest:openSystem",
			label = "Abrir",
			tunnel = "shop"
		},{
			event = "chest:upgradeSystem",
			label = "Aumentar",
			tunnel = "shop"
		},{
			event = "crafting:Streets",
			label = "Criação",
			tunnel = "shop"
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	for k,v in pairs(chestCoords) do
		exports["target"]:AddCircleZone("Chest:"..k,vector3(v[2],v[3],v[4]),0.5,{
			name = "Chest:"..k,
			heading = 3374176,
			useZ = true
		},{
			shop = k,
			distance = 1.5,
			options = chestInfos[v[5]]
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:openSystem",function(shopId)
	if vSERVER.checkIntPermissions(chestCoords[shopId][1]) and MumbleIsConnected() then
		SetNuiFocus(true,true)
		chestOpen = chestCoords[shopId][1]
		SendNUIMessage({ action = "showMenu" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPGRADESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:upgradeSystem",function(shopId)
	if MumbleIsConnected() then
		vSERVER.upgradeSystem(chestCoords[shopId][1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function()
	SendNUIMessage({ action = "hideMenu" })
	SetNuiFocus(false,false)
	chestOpen = ""
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("takeItem",function(data)
	if MumbleIsConnected() then
		vSERVER.takeItem(data["item"],data["slot"],data["amount"],data["target"],chestOpen)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("storeItem",function(data)
	if MumbleIsConnected() then
		vSERVER.storeItem(data["item"],data["slot"],data["amount"],data["target"],chestOpen)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateChest",function(data)
	if MumbleIsConnected() then
		vSERVER.updateChest(data["slot"],data["target"],data["amount"],chestOpen)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestChest",function(data,cb)
	local myInventory,myChest,invPeso,invMaxpeso,chestPeso,chestMaxpeso = vSERVER.openChest(chestOpen)
	if myInventory then
		cb({ myInventory = myInventory, myChest = myChest, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Update")
AddEventHandler("chest:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:UPDATEWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:UpdateWeight")
AddEventHandler("chest:UpdateWeight",function(invPeso,invMaxpeso,chestPeso,chestMaxpeso)
	SendNUIMessage({ action = "updateWeight", invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
end)