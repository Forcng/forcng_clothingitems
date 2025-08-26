local Applied = {}

RegisterNetEvent('forcng:applyItem', function(gear)
    local ped = PlayerPedId()
    local category = gear.category
    local isAccessory = gear.isAccessory

    local slotId = isAccessory and Config.Props[category] or Config.Components[category]
    if slotId == nil then
        print("Slot Not Found - Invalid Cateogry", category)
        return
    end

    local function playAnim()
        if gear.dict and gear.clip and gear.duration then
            RequestAnimDict(gear.dict)
            local tries = 0
            while not HasAnimDictLoaded(gear.dict) and tries < 50 do
                Wait(50); tries += 1
            end
            if HasAnimDictLoaded(gear.dict) then
                TaskPlayAnim(ped, gear.dict, gear.clip, 3.0, 3.0, gear.duration, 49, 0, false, false, false)
                Wait(gear.duration)
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
            SetPedPropIndex(ped, slotId, gear.model, gear.variant or 0, true)
            current.newDrawable, current.newTexture = gear.model, gear.variant or 0
            return
        else
            playAnim()
            local prevDrawable = curDrawable
            local prevTexture  = curTexture
            SetPedPropIndex(ped, slotId, gear.model, gear.variant or 0, true)
            Applied[category] = {
                isAccessory = true,
                slotId = slotId,
                prevDrawable = prevDrawable,
                prevTexture  = prevTexture,
                newDrawable  = gear.model,
                newTexture   = gear.variant or 0
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
            SetPedComponentVariation(ped, slotId, gear.model, gear.variant or 0, 2)
            current.newDrawable, current.newTexture = gear.model, gear.variant or 0
            return
        else
            playAnim()
            local prevDrawable = curDrawable
            local prevTexture  = curTexture
            SetPedComponentVariation(ped, slotId, gear.model, gear.variant or 0, 2)
            Applied[category] = {
                isAccessory = false,
                slotId = slotId,
                prevDrawable = prevDrawable,
                prevTexture  = prevTexture,
                newDrawable  = gear.model,
                newTexture   = gear.variant or 0
            }
            return
        end
    end
end)
