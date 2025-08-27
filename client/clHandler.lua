local Applied = {}

RegisterNetEvent('forcng:applyItem', function(WearableItems)
    local ped = PlayerPedId()
    local category = WearableItems.category
    local isAccessory = WearableItems.isAccessory

    local slotId = isAccessory and Config.Props[category] or Config.Components[category]
    if slotId == nil then
        print("Slot Not Found - Invalid Cateogry", category)
        return
    end

    local function playAnim()
        if WearableItems.dict and WearableItems.clip and WearableItems.duration then
            RequestAnimDict(WearableItems.dict)
            local tries = 0
            while not HasAnimDictLoaded(WearableItems.dict) and tries < 50 do
                Wait(50); tries += 1
            end
            if HasAnimDictLoaded(WearableItems.dict) then
                TaskPlayAnim(ped, WearableItems.dict, WearableItems.clip, 3.0, 3.0, WearableItems.duration, 49, 0, false, false, false)
                Wait(WearableItems.duration)
                ClearPedTasks(ped)
            end
        end
    end

    local current = Applied[category]

    if isAccessory then
        local curDrawable = GetPedPropIndex(ped, slotId)
        local curTexture  = GetPedPropTextureIndex(ped, slotId)

        if current then
            if curDrawable == current.newDrawable and curTexture == current.newTexture then
                playAnim()
                if current.prevDrawable and current.prevDrawable ~= -1 then
                    SetPedPropIndex(ped, slotId, current.prevDrawable, current.prevTexture or 0, true)
                else
                    ClearPedProp(ped, slotId)
                end
                Applied[category] = nil
                return
            end
            playAnim()
            SetPedPropIndex(ped, slotId, WearableItems.model, WearableItems.variant or 0, true)
            current.newDrawable, current.newTexture = WearableItems.model, WearableItems.variant or 0
            return
        else
            playAnim()
            local prevDrawable = curDrawable
            local prevTexture  = curTexture
            SetPedPropIndex(ped, slotId, WearableItems.model, WearableItems.variant or 0, true)
            Applied[category] = {
                isAccessory = true,
                slotId = slotId,
                prevDrawable = prevDrawable,
                prevTexture  = prevTexture,
                newDrawable  = WearableItems.model,
                newTexture   = WearableItems.variant or 0
            }
            return
        end

    else
        local curDrawable = GetPedDrawableVariation(ped, slotId)
        local curTexture  = GetPedTextureVariation(ped, slotId)

        if current then
            if curDrawable == current.newDrawable and curTexture == current.newTexture then
                playAnim()
                local pd = current.prevDrawable or 0
                local pt = current.prevTexture  or 0
                SetPedComponentVariation(ped, slotId, pd, pt, 2)
                Applied[category] = nil
                return
            end
            playAnim()
            SetPedComponentVariation(ped, slotId, WearableItems.model, WearableItems.variant or 0, 2)
            current.newDrawable, current.newTexture = WearableItems.model, WearableItems.variant or 0
            return
        else
            playAnim()
            local prevDrawable = curDrawable
            local prevTexture  = curTexture
            SetPedComponentVariation(ped, slotId, WearableItems.model, WearableItems.variant or 0, 2)
            Applied[category] = {
                isAccessory = false,
                slotId = slotId,
                prevDrawable = prevDrawable,
                prevTexture  = prevTexture,
                newDrawable  = WearableItems.model,
                newTexture   = WearableItems.variant or 0
            }
            return
        end
    end
end)

