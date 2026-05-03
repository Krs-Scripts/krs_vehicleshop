local Vehicle = require 'client.vehicle'
local TestDrive = require 'client.testdrive'
local Showroom = require 'client.showroom'
local Camera = require 'client.camera'
local cfg = require 'shared.config'
local State = require 'client.state'

local function hexToRgb(hex)
    if not hex then return 0, 0, 0 end
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

RegisterNUICallback("getShowroomData", function(_, cb)
    local normalizedVehicles = {}

    local currentType = State.currentShopType

    for _, v in ipairs(cfg.vehicles) do
        if v.shopType == currentType then
            local modelName = tostring(v.model):lower()
            local image = v.image or ("https://docs.fivem.net/vehicles/%s.webp"):format(modelName)

            table.insert(normalizedVehicles, {
                model = v.model,
                name = v.name,
                price = v.price,
                image = image,
                category = string.lower((v.category or ""):gsub("%s+", ""))
            })
        end
    end

    local locales = {}
    local keys = { 
        "vehicle", "vehicle_color", "performance", "top_speed", "acceleration", 
        "braking", "handling", "storage", "test_drive", "purchase", 
        "search_placeholder", "purchase_title", "irreversible_action", "cash", "bank" 
    }
    
    for _, key in ipairs(keys) do locales[key] = locale(key) end

    cb({
        vehicles = normalizedVehicles,
        swatches = cfg.paletteSwatches,
        locales = locales
    })
end)

RegisterNUICallback("showroom:preview", function(data, cb)
    local shopData = cfg.shops[State.currentShopType]
    local veh = Vehicle.spawnPreview(data.model, shopData.preview)
    if not veh then cb(false) return end
    local mass = GetVehicleHandlingFloat(veh, "CHandlingData", "fMass")
    SendNUIMessage({
        action = "updateVehicleStats",
        data = {
            speed = GetVehicleEstimatedMaxSpeed(veh) * 3.6,
            acceleration = GetVehicleAcceleration(veh) * 100,
            braking = GetVehicleMaxBraking(veh),
            handling = GetVehicleMaxTraction(veh),
            storage = math.floor(mass / 10)
        }
    })
    Camera.manageCamera()
    cb(true)
end)


RegisterNUICallback("setPreviewColor", function(data, cb)
    local r, g, b = hexToRgb(data.color)
    local veh = Vehicle.getPreview()
    if veh then
        SetVehicleCustomPrimaryColour(veh, r, g, b)
        SetVehicleCustomSecondaryColour(veh, r, g, b)
        State.selectedColor = {r = r, g = g, b = b} 
    end
    cb(true)
end)

RegisterNUICallback("showroom:testDrive", function(data, cb)
    if not data or not data.model then cb(false) return end
    Showroom.openShowRoom(false) 
    local r, g, b = hexToRgb(data.color)
    TestDrive.start({ model = data.model }, {r = r, g = g, b = b})
    cb(true)
end)

RegisterNUICallback("showroom:purchase", function(data, cb)
    if not data or not data.model then cb(false) return end
    Showroom.openShowRoom(false)
    local r, g, b = hexToRgb(data.color)
    print("DEBUG NUI Method:", data.method) 
    TriggerServerEvent('krs_vehicleshop:server:buyVehicle', {
        model = data.model,
        price = data.price,
        method = tostring(data.method):lower(),
        color = { r = r, g = g, b = b } 
    })
    cb(true)
end)

RegisterNUICallback('hide-ui', function(_, cb)
    Showroom.openShowRoom(false)
    cb({})
end)

RegisterNetEvent('krs_vehicleshop:client:applyColor', function(netId, color)
    local vehicle = NetToVeh(netId)
    if not DoesEntityExist(vehicle) then return end

    SetVehicleCustomPrimaryColour(vehicle, color.r, color.g, color.b)
    SetVehicleCustomSecondaryColour(vehicle, color.r, color.g, color.b)
end)