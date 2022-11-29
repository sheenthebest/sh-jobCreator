--[[ 
    
Config.Jobs['police'] = { -- job 'police' -- this is example so locations are totally random
    enableBlips = true, -- or false to disable 
    blips = {
        [1] = {
            label = 'Police Station',
            coords = vector3(354.19, -951.09, 29.42),
            sprite = 1,
            colour = 1,
            scale = 0.8
        }
    },
    duty = {
        enable = true, -- or false to disable 
        label = 'Press [E] duty - on/off',
        locations = {
            vector3(410.79, -1009.77, 29.38),
            vector3(410.23, -1014.75, 29.35)
        }
    },
    stash = {
        enable = true, -- or false to disable 
        label = 'Press [E] to open stash',
        locations = {
            vector3(417.02, -1012.94, 29.23),
            vector3(417.61, -1006.53, 29.24)
        },
        slots = 10,
        weight = 20000,
    },
    trash = {
        enable = true, -- or false to disable 
        label = 'Press [E] to open trash',
        locations = {
            vector3(417.03, -1002.43, 29.27),
            vector3(410.97, -1001.91, 29.33)
        }
    },
    equipment = {
        enable = true, -- or false to disable 
        label = 'Press [E] to open equipment',
        locations = {
            vector3(417.33, -995.2, 29.31),
            vector3(410.87, -995.1, 29.27)
        },

        labelMenu = 'Equipment', -- Inventory header
        slots = 30, -- Inventory Slots
        items = {
            [1] = { 
                name = 'weapon_pistol',
                price = 0,
                amount = 1,
                info = {
                    serie = '', -- leave empty
                    attachments = {
                        {component = 'COMPONENT_AT_PI_FLSH', label = 'Flashlight'},
                    }
                },
                type = 'weapon',
                slot = 1,
                authorizedJobGrades = {0, 1, 2, 3, 4}
            },
            [2] = {
                name = 'heavyarmor',
                price = 0,
                amount = 50,
                info = {},
                type = 'item',
                slot = 2,
                authorizedJobGrades = {0, 1, 2, 3, 4}
            }
        }
    },
    garage = {
        enable = true, -- or false to disable 
        label = 'Press [E] to open garage',
        store_label = 'Press [E] to store vehicle',
        locations = {
            vector4(410.4, -988.0, 29.27, 0.0),
            vector4(416.73, -988.06, 29.4, 0.0)
        },
        jobPlate = 'LSPD', -- only 4diggits tag or false
        vehicles = {
            ['police'] = {
                label = 'police',
                extras = {
                    ['1'] = true, -- on/off
                    ['2'] = true,
                    ['3'] = true,
                    ['4'] = true,
                    ['5'] = true,
                    ['6'] = true,
                    ['7'] = true,
                    ['8'] = true,
                    ['9'] = true,
                    ['10'] = true,
                    ['11'] = true,
                    ['12'] = true,
                    ['13'] = true,
                },
                livery = 1,
            }
        },
    },
    zones = {
        ['name_tag_1'] = {
            coords = vector3(419.16, -988.48, 29.3),
            distance = 1.5, -- interact distance
    
            eventType = 'client', -- or 'server'
            event = 'jobCreator:cl:Test',
            label = 'Press E to do something',
            params = {test = 'test'}
        }
    }, -- if you don't need to use any zones, just make it like this  -   zones = {}
} 

]]

-----------------
-- ZONE EVENTS
-----------------

--[[ 
RegisterNetEvent('jobCreator:cl:Test', function(data)
    print('result - ', json.encode(data))
end)
 ]]