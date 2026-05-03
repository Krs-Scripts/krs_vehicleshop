local cfg = require 'shared.config'

---@param model number
---@return table|nil
local function getVehicleData(model)
    if not model then return nil end

    for i = 1, #cfg.vehicles do
        local v = cfg.vehicles[i]

        if v.model and joaat(v.model) == model then
            return v
        end
    end

    return nil
end

---@param vehicle number
---@param plate string
---@param shopType string
---@param price number
function ConfirmSell(vehicle, plate, shopType, price)
    local alert = lib.alertDialog({
        header = locale('confirm_sell_header'),
        content = ('%s\n\n $%s'):format(
            locale('confirm_sell_content', plate),
            price or 0
        ),
        centered = true,
        cancel = true
    })

    if alert ~= 'confirm' then return end

    if not DoesEntityExist(vehicle) then
        exports.qbx_core:Notify(locale('vehicle_not_found'), 'error')
        return
    end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)

    TriggerServerEvent('krs_vehicleshop:server:sellVehicle', {
        netId = netId,
        shopType = shopType
    })
end

---@param shopType string
function OpenSellMenu(shopType)
    local ped = cache.ped
    local coords = GetEntityCoords(ped)

    local nearby = lib.getNearbyVehicles(coords, 10.0)

    if not nearby or #nearby == 0 then
        exports.qbx_core:Notify(locale('no_vehicles'), 'error')
        return
    end

    local shop = cfg.shops[shopType]
    if not shop then return end

    local percentage = shop.sellPercentage or 0.5
    local options = {}

    for i = 1, #nearby do
        local veh = nearby[i].vehicle

        if DoesEntityExist(veh) then
            local plate = GetVehicleNumberPlateText(veh)
            local model = GetEntityModel(veh)

            local vehicleData = getVehicleData(model)

            local price = 0
            local labelPrice = 'N/A'

            if vehicleData then
                price = math.floor(vehicleData.price * percentage)
                labelPrice = ('$%s'):format(price)
            end

            options[#options + 1] = {
                title = ('[%s] - %s'):format(plate, labelPrice),
                description = locale('sell_vehicle'),
                icon = 'car',
                onSelect = function()
                    ConfirmSell(veh, plate, shopType, price)
                end
            }
        end
    end

    if #options == 0 then
        exports.qbx_core:Notify(locale('no_valid_vehicles'), 'error')
        return
    end

    lib.registerContext({
        id = 'sell_vehicle_menu',
        title = locale('sell_vehicle'),
        options = options
    })

    lib.showContext('sell_vehicle_menu')
end