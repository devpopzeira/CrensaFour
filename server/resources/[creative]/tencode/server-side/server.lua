-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("tencode",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local codes = {
	[10] = {
		tag = "10",
		text = "Confronto em andamento",
		blip = 44
	},
	[13] = {
		tag = "13",
		text = "Oficial ferido",
		blip = 51
	},
	[20] = {
		tag = "20",
		text = "Localização",
		blip = 45
	},
	[32] = {
		tag = "32",
		text = "Homem armado",
		blip = 28
	},
	[38] = {
		tag = "38",
		text = "Parando veículo suspeito",
		blip = 74
	},
	[50] = {
		tag = "50",
		text = "Acidente de trânsito",
		blip = 43
	},
	[78] = {
		tag = "78",
		text = "Reforço solicitado",
		blip = 65
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDCODE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.sendCode(code)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local ped = GetPlayerPed(source)
		local coords = GetEntityCoords(ped)
		local identity = vRP.userIdentity(user_id)

		local policeResult = vRP.numPermission("Police")
		for k,v in pairs(policeResult) do
			async(function()
				if code ~= "4" then
					vRPC.playSound(v,"Event_Start_Text","GTAO_FM_Events_Soundset")
				end

				TriggerClientEvent("NotifyPush",v,{ code = codes[parseInt(code)]["tag"], title = codes[parseInt(code)]["text"], x = coords["x"], y = coords["y"], z = coords["z"], name = identity["name"].." "..identity["name2"], time = "Recebido às "..os.date("%H:%M"), blipColor = codes[parseInt(code)]["blip"] })
			end)
		end
	end
end