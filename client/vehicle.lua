local cfg = require 'shared.config'
local State = require 'client.state'

Vehicle = {}

---@return number?
function Vehicle.getPreview()
    return State.vehiclePreview
end

---@return table
function Vehicle.getColor()
    return State.selectedColor
end

---@param color {r:number,g:number,b:number}
function Vehicle.setColor(color)
    State.selectedColor = color
end

function Vehicle.deletePreview()
    if State.vehiclePreview and DoesEntityExist(State.vehiclePreview) then
        DeleteEntity(State.vehiclePreview)
        State.vehiclePreview = nil
    end
end

---@param vehicle number
---@param color {r:number,g:number,b:number}
function Vehicle.applyColor(vehicle, color)
    SetVehicleCustomPrimaryColour(vehicle, color.r, color.g, color.b)
    SetVehicleCustomSecondaryColour(vehicle, color.r, color.g, color.b)
    SetVehicleDirtLevel(vehicle, 0.0)
end

---@param model string|number
---@param coords vec4 
---@return number?
function Vehicle.spawnPreview(model, coords)
    local modelHash = lib.requestModel(model)
    if not modelHash then return end

    Vehicle.deletePreview()

    local p = coords or cfg.shops[State.currentShopType].preview

    State.vehiclePreview = CreateVehicle(modelHash, p.x, p.y, p.z, p.w, false, false)

    FreezeEntityPosition(State.vehiclePreview, true)
    SetVehicleEngineOn(State.vehiclePreview, true, true, false)

    Vehicle.applyColor(State.vehiclePreview, State.selectedColor)

    return State.vehiclePreview
end

return Vehicle