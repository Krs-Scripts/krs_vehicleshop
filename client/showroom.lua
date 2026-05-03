local State = require 'client.state'
local Vehicle = require 'client.vehicle'
local Camera = require 'client.camera'
local cfg = require 'shared.config'

---@description Safe player teleport
---@param coords vector3
---@param heading number
function teleportPlayer(coords, heading)
    local ped = cache.ped

    DoScreenFadeOut(400)
    Wait(400)

    FreezeEntityPosition(ped, true)

    RequestCollisionAtCoord(coords.x, coords.y, coords.z)

    local found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)

    SetEntityCoords(ped, coords.x, coords.y, groundZ or coords.z, false, false, false, false)

    if heading then
        SetEntityHeading(ped, heading)
    end

    while not HasCollisionLoadedAroundEntity(ped) do Wait(0) end

    Wait(100)

    FreezeEntityPosition(ped, false)

    DoScreenFadeIn(400)
end

---@description Cleans the showroom completely
local function cleanupShowroom()
    Vehicle.deletePreview() 

    RenderScriptCams(false, false, 0, true, false)

    if State.currentCam then
        DestroyCam(State.currentCam, false)
        State.currentCam = nil
    end

    State.camAngle = 0.0
    State.currentCamSetting = 1
    State.isShowroomOpen = false
end

---@param state boolean
---@description Open or close the showroom
local function openShowRoom(state)
    State.isShowroomOpen = state

    if state and not State.entryCoords then
        State.entryCoords = GetEntityCoords(cache.ped)
        State.entryHeading = GetEntityHeading(cache.ped)
    end

    SetNuiFocus(state, state)

    if state then
        DisplayRadar(false)
    else
        local isInVehicle = cache.vehicle and cache.vehicle ~= 0 and not IsThisModelABicycle(cache.vehicle)
        DisplayRadar(isInVehicle)
    end

    SendNUIMessage({
        action = 'setShowroomVisible',
        data = state
    })

    if not state then
        cleanupShowroom()

        if State.entryCoords then
            teleportPlayer(State.entryCoords, State.entryHeading)
            State.entryCoords = nil
            State.entryHeading = nil
        end

        return
    end

    DoScreenFadeOut(400)
    Wait(400)

    local firstModel = nil

    for _, v in ipairs(cfg.vehicles) do
        if v.shopType == State.currentShopType then
            firstModel = v.model
            break
        end
    end

    if not firstModel then firstModel = cfg.vehicles[1].model end

    lib.requestModel(firstModel)

    Vehicle.deletePreview()

    local shopData = cfg.shops[State.currentShopType]
    local p = shopData.preview

    State.vehiclePreview = CreateVehicle(firstModel, p.x, p.y, p.z, p.w, false, false)

    FreezeEntityPosition(State.vehiclePreview, true)
    SetVehicleEngineOn(State.vehiclePreview, true, true, false)

    Vehicle.applyColor(State.vehiclePreview, State.selectedColor)

    Camera.manageCamera()

    Wait(400)
    DoScreenFadeIn(400)
end

return {
    openShowRoom = openShowRoom,
    cleanupShowroom = cleanupShowroom
}