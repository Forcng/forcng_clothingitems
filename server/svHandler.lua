ESX = exports["es_extended"]:getSharedObject()

for _, gear in pairs(Config.WearableItems) do
    ESX.RegisterUsableItem(gear.uniqueItem, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            TriggerClientEvent('forcng:applyItem', source, WearableItems)
        end
    end)

    print("usable item:", WearableItems.uniqueItem)
end

