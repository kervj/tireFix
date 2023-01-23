ESX = exports["es_extended"]:getSharedObject()

--- repair kit
RegisterNetEvent('tireFix')
AddEventHandler('tireFix', function()
	local playerPed = PlayerPedId()
	local vehicle = GetClosestVehicleToPlayer()
	local closestTire = GetClosestVehicleTire(vehicle)

		TriggerEvent("tire_anim")
		Citizen.Wait(50)
		TriggerServerEvent("tire:removeItem")
		Citizen.Wait(6000)
		SetVehicleTyreFixed(vehicle, closestTire.tireIndex)
		Citizen.Wait(50)
		ClearPedTasksImmediately(playerPed)
		SetEntityAsNoLongerNeeded(vehicle)
		ESX.ShowNotification('Tire repaired')
end)


RegisterNetEvent("esx_basicneeds:wytrychd")
AddEventHandler("esx_basicneeds:wytrychd",function()
  TriggerEvent('MF_LockPicking:StartMinigame') -- mf lockpiking needed
end)

--- tire animation
RegisterNetEvent("tire_anim")
AddEventHandler("tire_anim", function(options)

	local ad = "amb@world_human_gardener_plant@female@idle_a"
	local anim = "idle_a_female"
	local player = PlayerPedId()


	if (DoesEntityExist(player) and not IsEntityDead(player)) then
		loadAnimDict(ad)
		if ( IsEntityPlayingAnim(player, ad, anim, 1)) then 
			TaskPlayAnim(player, ad, "exit", 1.0, 1.0, 8.0, 48, 0, 0, 0, 0)
			ClearPedSecondaryTask(player)
		else
			SetCurrentPedWeapon(player, -1569615261,true)
			TaskPlayAnim(player, ad, anim, 1.0, 1.0, 8.0, 48, 0, 0, 0, 0)
		end       
	end
end)


function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function GetClosestVehicleToPlayer()
	local player = PlayerId()
	local playerPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(playerPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.0)
	local radius = 2.0
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, radius, 10, GetPlayerPed(-1), 5)
	local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
	return vehicle
end

function GetClosestVehicleTire(vehicle)
	local tireBones = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}
	local tireIndex = {
		["wheel_lf"] = 0,
		["wheel_rf"] = 1,
		["wheel_lm1"] = 2,
		["wheel_rm1"] = 3,
		["wheel_lm2"] = 45,
		["wheel_rm2"] = 47,
		["wheel_lm3"] = 46,
		["wheel_rm3"] = 48,
		["wheel_lr"] = 4,
		["wheel_rr"] = 5,
	}
	local player = PlayerId()
	local playerPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(playerPed, false)
	local minDistance = 1.5
	local closestTire = nil
	
	for a = 1, #tireBones do
		local bonePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tireBones[a]))
		local distance = #(plyPos - bonePos)

		if closestTire == nil then
			if distance <= minDistance then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		else
			if distance < closestTire.boneDist then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		end
	end

	return closestTire
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end


