fx_version 'cerulean'
game "gta5"
lua54 'yes'
author "Krs Store"
version '1.0.0'
description 'Krs VehicleShop'

shared_scripts {
    "@ox_lib/init.lua",
    '@qbx_core/modules/lib.lua',
    "shared/**/*.lua"
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/state.lua',      
    'client/vehicle.lua',
    'client/camera.lua',
    'client/showroom.lua',
    'client/testdrive.lua',
    'client/nui.lua',
    'client/sell.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server/version.lua",
    "server/main.lua",
}

ui_page "web/build/index.html"

files {
    "web/build/index.html",
    "web/build/**/*",
    'locales/*.json'
}

dependencies {
    'ox_lib',
    'qbx_core',
    'ox_inventory'
}