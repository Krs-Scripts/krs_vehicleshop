lib.locale()

local cfg = {}

cfg.testDriveTime = 60000

cfg.paletteSwatches = {
    "#0496ff", -- Blue
    "#39ff14", -- Neon Green
    "#ff007f", -- Pink
    "#9d00ff", -- Purple
    "#d0ff00", -- Yellow
    "#ff1e00", -- Red
    "#0050ff", -- Deep Blue
    "#ff6e00", -- Orange
    "#f0f0ff", -- Whiteish
    "#64646e", -- Grey
    "#0f0f0f"  -- Black
}


cfg.instructor = { 
    model = `cs_siemonyetarian`
}

cfg.shops = {
    ['car'] = {
        coords = vec3(-57.1781, -1096.2910, 26.4224),
        preview = vec4(-42.8151, -1098.8698, 26.4224, 57.3641),
        testDrive = vec4(-50.8154, -1116.4513, 26.4345, 5.3229),
        spawns = {
            vec4(-62.3970, -1105.5636, 26.3412, 66.3168)
        },
        sell = {
            coords = vec3(-49.6195, -1076.6696, 26.8635),
            radius = 3.0
        },
        sellPercentage = 0.6,
        blipSprite = 523,
        blipColor = 0,
        label = "Car Dealer Showroom",
        useInstructor = true
    },

    ['boat'] = {
        coords = vec3(-795.9545, -1492.9948, 1.5952),
        preview = vec4(-813.4109, -1478.8121, -0.4746, 109.3086),
        testDrive = vec4(-795.7076, -1501.7313, -0.4747, 107.6712),
        spawns = {
            vec4(-802.5, -1510.6, -0.47, 110.0)
        },
        sell = {
            coords = vec3(-800.0, -1500.0, 0.0),
            radius = 4.0
        },
        sellPercentage = 0.5,
        blipSprite = 410,
        blipColor = 0,
        label = "Nautical Showroom",
        useInstructor = true
    },

    ['air'] = {
        coords = vec3(-978.8, -2997.5, 13.9),
        preview = vec4(-963.3, -2986.9, 13.9, 60.0),
        testDrive = vec4(-978.7322, -3155.3057, 13.9444, 56.9899),
        spawns = {
            vec4(-977.0, -2985.0, 13.9, 60.0)
        },
        sell = {
            coords = vec3(-980.0, -2990.0, 13.9),
            radius = 5.0
        },
        sellPercentage = 0.4,
        blipSprite = 64,
        blipColor = 0,
        label = "Aeronautical Showroom",
        useInstructor = false
    }
}

cfg.vehicles = {
    -- COMPACTS
    { name = "Asbo", model = "asbo", price = 15000, category = "compacts", shopType = 'car' },
    { name = "Blista", model = "blista", price = 18000, category = "compacts", shopType = 'car' },
    { name = "Kanjo", model = "kanjo", price = 22000, category = "compacts", shopType = 'car' },
    { name = "Brioso", model = "brioso", price = 28000, category = "compacts", shopType = 'car' },
    { name = "Brioso 300", model = "brioso2", price = 18000, category = "compacts", shopType = 'car' },
    { name = "Club", model = "club", price = 25000, category = "compacts", shopType = 'car' },
    { name = "Dilettante", model = "dilettante", price = 22000, category = "compacts", shopType = 'car' },
    { name = "Issi", model = "issi2", price = 19000, category = "compacts", shopType = 'car' },
    { name = "Prairie", model = "prairie", price = 15000, category = "compacts", shopType = 'car' },
    { name = "Panto", model = "panto", price = 8000, category = "compacts", shopType = 'car' },

    -- SEDANS
    { name = "Asea", model = "asea", price = 8000, category = "sedans", shopType = 'car' },
    { name = "Asterope", model = "asterope", price = 12000, category = "sedans", shopType = 'car' },
    { name = "Cognoscenti", model = "cognoscenti", price = 38000, category = "sedans", shopType = 'car' },
    { name = "Emperor", model = "emperor", price = 9000, category = "sedans", shopType = 'car' },
    { name = "Fugitive", model = "fugitive", price = 18000, category = "sedans", shopType = 'car' },
    { name = "Glendale", model = "glendale", price = 15000, category = "sedans", shopType = 'car' },
    { name = "Ingot", model = "ingot", price = 11000, category = "sedans", shopType = 'car' },
    { name = "Premier", model = "premier", price = 13000, category = "sedans", shopType = 'car' },
    { name = "Regina", model = "regina", price = 9500, category = "sedans", shopType = 'car' },
    { name = "Stanier", model = "stanier", price = 12500, category = "sedans", shopType = 'car' },

    -- MUSCLE
    { name = "Blade", model = "blade", price = 28000, category = "muscle", shopType = 'car' },
    { name = "Buccaneer", model = "buccaneer", price = 22000, category = "muscle", shopType = 'car' },
    { name = "Dominator", model = "dominator", price = 35000, category = "muscle", shopType = 'car' },
    { name = "Dukes", model = "dukes", price = 34000, category = "muscle", shopType = 'car' },
    { name = "Ellie", model = "ellie", price = 40000, category = "muscle", shopType = 'car' },
    { name = "Faction", model = "faction", price = 23000, category = "muscle", shopType = 'car' },
    { name = "Gauntlet", model = "gauntlet", price = 36000, category = "muscle", shopType = 'car' },
    { name = "Impaler", model = "impaler", price = 33000, category = "muscle", shopType = 'car' },
    { name = "Phoenix", model = "phoenix", price = 31000, category = "muscle", shopType = 'car' },
    { name = "Slamvan", model = "slamvan", price = 22000, category = "muscle", shopType = 'car' },

    -- MOTORCYCLES
    { name = "Akuma", model = "akuma", price = 20000, category = "motorcycles", shopType = 'car' },
    { name = "Avarus", model = "avarus", price = 22000, category = "motorcycles", shopType = 'car' },
    { name = "Bagger", model = "bagger", price = 18000, category = "motorcycles", shopType = 'car' },
    { name = "Bati 801", model = "bati", price = 25000, category = "motorcycles", shopType = 'car' },
    { name = "BF400", model = "bf400", price = 32000, category = "motorcycles", shopType = 'car' },
    { name = "Cliffhanger", model = "cliffhanger", price = 35000, category = "motorcycles", shopType = 'car' },
    { name = "Daemon", model = "daemon", price = 17000, category = "motorcycles", shopType = 'car' },
    { name = "Defiler", model = "defiler", price = 36000, category = "motorcycles", shopType = 'car' },
    { name = "Double-T", model = "double", price = 20000, category = "motorcycles", shopType = 'car' },
    { name = "Faggio", model = "faggio2", price = 9500, category = "motorcycles", shopType = 'car' },

    -- VANS
    { name = "Burrito", model = "gburrito2", price = 49000, category = "vans", shopType = 'car' },
    { name = "Gang Burrito", model = "gburrito", price = 55000, category = "vans", shopType = 'car' },
    { name = "Youga", model = "youga", price = 25000, category = "vans", shopType = 'car' },
    { name = "Youga Classic", model = "youga2", price = 20000, category = "vans", shopType = 'car' },
    { name = "Moonbeam", model = "moonbeam", price = 38000, category = "vans", shopType = 'car' },
    { name = "Moonbeam Rider", model = "moonbeam2", price = 45000, category = "vans", shopType = 'car' },
    { name = "Paradise", model = "paradise", price = 19500, category = "vans", shopType = 'car' },
    { name = "Rumpo", model = "rumpo", price = 20000, category = "vans", shopType = 'car' },
    { name = "Surfer", model = "surfer", price = 9000, category = "vans", shopType = 'car' },
    { name = "Camper", model = "camper", price = 52000, category = "vans", shopType = 'car' },

    -- SPORTS
    { name = "9F", model = "ninef", price = 70000, category = "sports", shopType = 'car' },
    { name = "Alpha", model = "alpha", price = 55000, category = "sports", shopType = 'car' },
    { name = "Banshee", model = "banshee", price = 65000, category = "sports", shopType = 'car' },
    { name = "Buffalo", model = "buffalo", price = 30000, category = "sports", shopType = 'car' },
    { name = "Carbonizzare", model = "carbonizzare", price = 72000, category = "sports", shopType = 'car' },
    { name = "Comet", model = "comet2", price = 70000, category = "sports", shopType = 'car' },
    { name = "Elegy RH8", model = "elegy2", price = 50000, category = "sports", shopType = 'car' },
    { name = "Comet Turbo", model = "comet6", price = 35000, category = "sports", shopType = 'car' },
    { name = "Jester", model = "jester", price = 65000, category = "sports", shopType = 'car' },
    { name = "Kuruma", model = "kuruma", price = 45000, category = "sports", shopType = 'car' },

    -- SUPER
    { name = "Adder", model = "adder", price = 200000, category = "super", shopType = 'car' },
    { name = "Autarch", model = "autarch", price = 230000, category = "super", shopType = 'car' },
    { name = "Bullet", model = "bullet", price = 90000, category = "super", shopType = 'car' },
    { name = "Cheetah", model = "cheetah", price = 180000, category = "super", shopType = 'car' },
    { name = "Cyclone", model = "cyclone", price = 190000, category = "super", shopType = 'car' },
    { name = "Entity XF", model = "entityxf", price = 170000, category = "super", shopType = 'car' },
    { name = "FMJ", model = "fmj", price = 200000, category = "super", shopType = 'car' },
    { name = "Infernus", model = "infernus", price = 100000, category = "super", shopType = 'car' },
    { name = "Itali GTB", model = "italigtb", price = 160000, category = "super", shopType = 'car' },
    { name = "T20", model = "t20", price = 220000, category = "super", shopType = 'car' },

    -- BOATS
    { name = "Suntrap", model = "suntrap", price = 25000, category = "boats", shopType = 'boat' },
    { name = "Tropic", model = "tropic", price = 35000, category = "boats", shopType = 'boat' },
    { name = "Marquis", model = "marquis", price = 80000, category = "boats", shopType = 'boat' },
    { name = "Dinghy", model = "dinghy", price = 80000, category = "boats", shopType = 'boat' },
    { name = "Seashark3", model = "seashark3", price = 50000, category = "boats", shopType = 'boat' },

    -- PLANES / HELICOPTERS
    { name = "Shamal", model = "shamal", price = 1500000, category = "planes", shopType = 'air' },
    { name = "Mammatus", model = "mammatus", price = 470000, category = "planes", shopType = 'air' },
    { name = "Volatus", model = "volatus", price = 450000, category = "helicopters", shopType = 'air' },
    { name = "Conada", model = "conada", price = 350000, category = "helicopters", shopType = 'air' },
    { name = "Vestra", model = "vestra", price = 350000, category = "helicopters", shopType = 'air' },
}

return cfg
