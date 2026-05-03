local State = require 'client.state'
local cfg = require 'shared.config'
local Vehicle = require 'client.vehicle'

TestDrive = {}

---@param veh number
---@return number? instructor
local function createInstructor(veh)
    
    local instructorModel = cfg.instructor.model

    if not lib.requestModel(instructorModel, 5000) then return end

    local instructor = CreatePedInsideVehicle(veh, 4, instructorModel, 0, true, false)

    if not DoesEntityExist(instructor) then return end

    SetEntityAsMissionEntity(instructor, true, true)
    SetBlockingOfNonTemporaryEvents(instructor, true)
    SetEntityInvincible(instructor, true)
    SetPedCanBeDraggedOut(instructor, false)
    SetPedConfigFlag(instructor, 17, true)

    SetModelAsNoLongerNeeded(instructorModel)

    return instructor
end

---@param vehicle table
---@param overrideColor table?
function TestDrive.start(vehicle, overrideColor)
    if not vehicle or not vehicle.model then return end

    local entryCoords = GetEntityCoords(cache.ped)
    local entryHeading = GetEntityHeading(cache.ped)

    local location = cfg.shops[State.currentShopType].testDrive
    local model = type(vehicle.model) == "string" and joaat(vehicle.model) or vehicle.model

    if not lib.requestModel(model, 5000) then
        exports.qbx_core:Notify(locale('invalid_model'):format(vehicle.model), 'error')
        return
    end

    DoScreenFadeOut(400)
    Wait(400)

    local veh = CreateVehicle(model, location.x, location.y, location.z, location.w, true, false)
    
    SetEntityAsMissionEntity(veh, true, true)
    local netId = VehToNet(veh)
    SetNetworkIdExistsOnAllMachines(netId, true)
    SetNetworkIdCanMigrate(netId, false) 

    TriggerServerEvent('krs_vehicleshop:testdriveKeys', VehToNet(veh), vehicle.model, true)

    if GetResourceState('ox_fuel') == 'started' then
        Entity(veh).state.fuel = 100.0
    else
        SetVehicleFuelLevel(veh, 100.0)
    end

    if overrideColor then
        SetVehicleCustomPrimaryColour(veh, overrideColor.r, overrideColor.g, overrideColor.b)
        SetVehicleCustomSecondaryColour(veh, overrideColor.r, overrideColor.g, overrideColor.b)
    end

    SetVehicleNumberPlateText(veh, "TEST KRS")
    SetVehicleDoorsLocked(veh, 1) 
    SetPedIntoVehicle(cache.ped, veh, -1)
    SetVehicleEngineOn(veh, true, true, false)

    local currentShop = cfg.shops[State.currentShopType]
    local instructor = nil
    if currentShop.useInstructor then
        instructor = createInstructor(veh)
    end

    local start = GetGameTimer()
    local maxTime = cfg.testDriveTime or 60000
    local destroyed = false

    SendNUIMessage({ action = "testDrive:start", data = { duration = maxTime } })
    SetNuiFocus(false, false)
    DisplayRadar(true)
    SendNUIMessage({ action = "setShowroomVisible", data = false })

    DoScreenFadeIn(400)

    while GetGameTimer() - start < maxTime do
        Wait(0) 

        local remaining = math.ceil((maxTime - (GetGameTimer() - start)) / 1000)
        SendNUIMessage({ action = "testDrive:update", data = remaining })

        DisableControlAction(0, 75, true) 
        
        if not GetIsVehicleEngineRunning(veh) then
            SetVehicleEngineOn(veh, true, true, false)
        end

        if IsEntityDead(veh) or GetEntityHealth(veh) <= 0 then
            destroyed = true
            break
        end
    end

    SendNUIMessage({ action = "testDrive:end" })

    if entryCoords then
        teleportPlayer(entryCoords, entryHeading)
    end

    TriggerServerEvent('krs_vehicleshop:testdriveKeys', VehToNet(veh), vehicle.model, false)

    if instructor and DoesEntityExist(instructor) then DeleteEntity(instructor) end
    if DoesEntityExist(veh) then DeleteEntity(veh) end

    SetPedCanBeDraggedOut(cache.ped, true)
    SetModelAsNoLongerNeeded(model)
end

return TestDrive