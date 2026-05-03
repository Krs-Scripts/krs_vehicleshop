local Showroom = require 'client.showroom'
local cfg = require 'shared.config'
local State = require 'client.state'

local function createShopBlip(data)
    local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipSprite(blip, data.blipSprite or 361)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, data.blipColor or 6)
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(data.label or 'Showroom')
    EndTextCommandSetBlipName(blip)

    return blip
end

for shopType, data in pairs(cfg.shops) do
    createShopBlip(data)

    lib.zones.sphere({
        coords = data.coords,
        radius = 3.0,
        onEnter = function()
            lib.showTextUI(locale('open_shop'), {
                icon = 'E',
                style = {
                    backgroundColor = '#202020',
                    color = 'white'
                }
            })
        end,
        onExit = function()
            lib.hideTextUI()
        end,
        inside = function()
            if IsControlJustReleased(0, 38) then
                State.currentShopType = shopType
                Showroom.openShowRoom(true)
            end
        end
    })

  
    if data.sell then
        lib.zones.sphere({
            coords = data.sell.coords,
            radius = data.sell.radius or 3.0,

            onEnter = function()
                 lib.showTextUI(locale('sell_vehicle'), {
                    icon = 'E',
                    style = {
                        backgroundColor = '#202020',
                        color = 'white'
                    }
                })
            end,
            onExit = function()
                lib.hideTextUI()
            end,
            inside = function()
                if IsControlJustReleased(0, 38) then
                    OpenSellMenu(shopType)
                end
            end
        })
    end
end