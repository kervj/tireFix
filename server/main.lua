ESX = exports["es_extended"]:getSharedObject()


ESX.RegisterUsableItem('tire', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('tireFix', source)
end)

RegisterNetEvent('tire:removeItem')
AddEventHandler('tire:removeItem', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('tire', 1)
end)
