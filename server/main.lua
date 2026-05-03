local cfg = require 'shared.config'

---@param model string
---@return table|nil
local function getVehicleData(model)
    if not model then
        lib.print.error('[KRS] getVehicleData: model is nil')
        return nil
    end

    for i = 1, #cfg.vehicles do
        local v = cfg.vehicles[i]

        if v.model and v.model:lower() == model:lower() then
            return v
        end
    end

    return nil
end

---@param spawns vector4[]
---@return vector4
local function getClearSpawn(spawns)
    for i = 1, #spawns do
        local spawn = spawns[i]
        if #lib.getNearbyVehicles(spawn.xyz, 2.5) == 0 then
            return spawn
        end
    end
    return spawns[1]
end

---@param src number
---@param method string
---@param amount number
local function removeMoney(src, method, amount)
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return false end

    method = method:lower()

    if method == 'bank' then
        if (player.PlayerData.money.bank or 0) >= amount then
            return player.Functions.RemoveMoney('bank', amount, 'vehicleshop')
        end
    elseif method == 'cash' then
        local count = exports.ox_inventory:Search(src, 'count', 'money')
        if count >= amount then
            exports.ox_inventory:RemoveItem(src, 'money', amount)
            return true
        end
    end

    return false
end

---@param netId number
---@return number|nil
local function waitForEntity(netId)
    local entity = 0
    local timeout = 0

    while timeout < 50 do
        entity = NetworkGetEntityFromNetworkId(netId)
        if entity ~= 0 and DoesEntityExist(entity) then
            return entity
        end
        Wait(100)
        timeout += 1
    end

    return nil
end

---@param src number
---@param vehicleId number
---@param coords vector4
---@return number|nil
local function SpawnVehicle(src, vehicleId, coords)
    local vehicleData = exports.qbx_vehicles:GetPlayerVehicle(vehicleId)

    if not vehicleData then
        lib.print.error('[KRS] vehicleData nil', vehicleId)
        return nil
    end

    local model = vehicleData.model or vehicleData.vehicle or vehicleData.modelName

    if not model then
        lib.print.error('[KRS] model nil', json.encode(vehicleData))
        return nil
    end

    local netId, vehicle = qbx.spawnVehicle({
        model = model,
        spawnSource = coords,
        warp = GetPlayerPed(src)
    })

    if not netId or netId == 0 or not vehicle or vehicle == 0 then
        lib.print.error('[KRS] spawn failed')
        return nil
    end

    Entity(vehicle).state:set('vehicleid', vehicleId, true)

    exports.qbx_vehiclekeys:GiveKeys(src, vehicle)

    return netId
end

RegisterNetEvent('krs_vehicleshop:server:buyVehicle', function(data)
    local src = source

    if type(data) ~= 'table' or not data.model then
        lib.print.error('[KRS] invalid data')
        return
    end

    local player = exports.qbx_core:GetPlayer(src)
    if not player then
        lib.print.error('[KRS] player nil')
        return
    end

    local vehicleData = getVehicleData(data.model)
    if not vehicleData then
        lib.print.error('[KRS] config vehicle missing:', data.model)
        return
    end

    local shop = cfg.shops[vehicleData.shopType]
    if not shop then
        lib.print.error('[KRS] shop missing:', vehicleData.shopType)
        return
    end

    local coords = getClearSpawn(shop.spawns)
    local price = vehicleData.price

    if not removeMoney(src, data.method, price) then
        exports.qbx_core:Notify(src, locale('insufficient_money'), 'error')
        return
    end

    local plate = lib.string.random('AAA###'):upper():gsub("%s+", "")

    local props = {
        plate = plate
    }

    if data.color then
        props.customPrimaryColour = { data.color.r, data.color.g, data.color.b }
        props.customSecondaryColour = { data.color.r, data.color.g, data.color.b }
    end

    local vehicleId = exports.qbx_vehicles:CreatePlayerVehicle({
        model = data.model,
        citizenid = player.PlayerData.citizenid,
        props = props
    })

    if not vehicleId then
        lib.print.error('[KRS] create vehicle failed')
        return
    end

    local netId = SpawnVehicle(src, vehicleId, coords)
    if not netId then return end

    local entity = waitForEntity(netId)
    if not entity then
        lib.print.error('[KRS] entity sync fail')
        return
    end

    if data.color then
        TriggerClientEvent('krs_vehicleshop:client:applyColor', src, netId, data.color)
    end

    lib.print.info('[KRS] purchased:', plate)

    exports.qbx_core:Notify(src, locale('vehicle_purchased'), 'success')
end)

RegisterNetEvent('krs_vehicleshop:testdriveKeys', function(netId, give)
    local src = source

    if type(netId) ~= 'number' then return end

    local entity = waitForEntity(netId)
    if not entity then return end

    if give then
        exports.qbx_vehiclekeys:GiveKeys(src, entity)
        Entity(entity).state:set('keys', { [src] = true }, true)
    else
        exports.qbx_vehiclekeys:RemoveKeys(src, entity)
        Entity(entity).state:set('keys', nil, true)
    end
end)

---@param data table
RegisterNetEvent('krs_vehicleshop:server:sellVehicle', function(data)
    local src = source

    if type(data) ~= 'table' then return end

    local netId = data.netId
    local shopType = data.shopType

    local shop = cfg.shops[shopType]
    if not shop then return end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end

    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end

    local plate = GetVehicleNumberPlateText(entity)
    if not plate or plate == '' then
        lib.print.error('[KRS] plate missing')
        return
    end

    local vehicleData = MySQL.single.await(
        'SELECT * FROM player_vehicles WHERE plate = ?',
        { plate }
    )

    if not vehicleData then
        lib.print.error('[KRS] vehicle not found:', plate)
        return
    end

    if vehicleData.citizenid ~= player.PlayerData.citizenid then
        exports.qbx_core:Notify(src, locale('not_owner'), 'error')
        lib.print.error('[SELL EXPLOIT]')
        return
    end

    local model = vehicleData.model or vehicleData.vehicle or vehicleData.modelName
    if not model then
        lib.print.error('[KRS] model missing', json.encode(vehicleData))
        return
    end

    local configVehicle = getVehicleData(model)
    if not configVehicle then
        lib.print.error('[KRS] config missing for model:', model)
        return
    end

    local percentage = shop.sellPercentage or 0.5
    local price = math.floor(configVehicle.price * percentage)

    player.Functions.AddMoney('bank', price, 'vehicle-sold')

    DeleteEntity(entity)

    MySQL.update.await(
        'DELETE FROM player_vehicles WHERE id = ?',
        { vehicleData.id }
    )

    exports.qbx_core:Notify(src, locale('vehicle_sold', price), 'success')
end)