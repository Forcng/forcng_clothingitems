ESX = exports["es_extended"]:getSharedObject()

for _, gear in pairs(Config.Gear) do
    ESX.RegisterUsableItem(gear.uniqueItem, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            TriggerClientEvent('forcng:applyItem', source, gear)
        end
    end)

    print("usable item:", gear.uniqueItem)
end
