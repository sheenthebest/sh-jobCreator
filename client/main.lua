local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {} --QBCore.Functions.GetPlayerData()
local PlayerJob = {}
local CurrentBlips = {}
local JobData = {}
local onDuty = nil
local looping = false

--------------
-- FUNCTIONS
--------------

local function Init(job)
    local table = Config.Jobs[job]
    if not table then return end
    
    if table.enableBlips then
        JobData["blips"] = table.blips
        CreateBlips(JobData["blips"])
    end
    if table.duty.enable then JobData["duty"] = table.duty end
    if table.stash.enable then JobData["stashes"] = table.stash end
    if table.trash.enable then JobData["trashes"] = table.trash end
    if table.equipment.enable then JobData["equipment"] = table.equipment end
    if table.garage.enable then JobData["garages"] = table.garage end
    if table.zones and next(table.zones) then JobData["zones"] = table.zones end

    LoadLoop(true)
end

local function GiveKeys(veh)
    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
end

local function hasJob()
    local jobExist = Config.Jobs[PlayerJob.name]
    if jobExist then return true end
    return false
end

local function CreateBlips(data)
    for k, v in pairs(data) do
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(blip, v.sprite)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, v.scale)
        SetBlipColour(blip, v.colour)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(blip)
        CurrentBlips[#CurrentBlips + 1] = blip
    end
end

local function Duty()
    onDuty = not onDuty
    TriggerServerEvent("QBCore:ToggleDuty")
end

local function SetWeaponSeries(dataItems)
    for k, _ in pairs(dataItems) do
        if k < 6 then
            JobData['equipment'].items[k].info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
        end
    end
end

local function OpenGarage(vehicles, coords, plate)
    local vehicleMenu = {}
    for veh, v in pairs(vehicles) do
        vehicleMenu[#vehicleMenu+1] = {
            header = v.label,
            txt = "",
            params = {
                event = "jobCreator:cl:SpawnVehicle",
                args = {
                    vehicle = veh,
                    coords = coords,
                    extras = v.extras,
                    livery = v.livery,
                    plate = plate,

                }
            }
        }
    end

    vehicleMenu[#vehicleMenu+1] = {
        header = 'Close Menu',
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }
    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

--------------
-- LOOP
--------------

local function LoadLoop(bool)
    if looping == bool then return end -- spam protection
    looping = bool

    CreateThread(function()
        while looping do
            local idle = 2200

            if JobData and next(JobData) then
                local ped = PlayerPedId()
                local pcoords = GetEntityCoords(ped)

                if JobData['zones'] and next(JobData['zones']) then
                    for k, v in pairs(JobData['zones']) do 
                        local dist = #(pcoords - v.coords)
                        if dist < 10.0 then
                            idle = 1
                            DrawText3D(v.coords.x, v.coords.y, v.coords.z, v.label)
                            if dist < v.distance then
                                if IsControlJustPressed(0, 38) then
                                    if v.eventType == 'server' then
                                        TriggerServerEvent(v.event, {
                                            location = k,
                                            coords = v.coords,
                                            params = v.params
                                        })
                                    else
                                        TriggerEvent(v.event, {
                                            location = k,
                                            coords = v.coords,
                                            params = v.params
                                        })
                                    end
                                    Wait(1500)
                                end
                            end
                        end
                    end
                end

                if JobData['duty'] and next(JobData['duty']) then
                    local ped = PlayerPedId()
                    local pcoords = GetEntityCoords(ped)
                    for k, v in pairs(JobData['duty'].locations) do
                        local dist = #(pcoords - v)
                        if dist < 10.0 then
                            idle = 1
                            DrawText3D(v.x, v.y, v.z, JobData['duty'].label)
                            if dist < 1.5 then
                                if IsControlJustPressed(0, 38) then
                                    Duty()
                                end
                            end 
                        end
                    end
                end

                if JobData['stashes'] and next(JobData['stashes']) then
                    local ped = PlayerPedId()
                    local pcoords = GetEntityCoords(ped)
                    for k, v in pairs(JobData['stashes'].locations) do
                        local dist = #(pcoords - v)
                        if dist < 10.0 then
                            idle = 1
                            DrawText3D(v.x, v.y, v.z, JobData['stashes'].label)
                            if dist < 1.5 then
                                if IsControlJustPressed(0, 38) then
                                    TriggerServerEvent("inventory:server:OpenInventory", "stash", "jobStash_".. PlayerJob.name, {
                                        maxweight = 4000000,
                                        slots = 300,
                                    })
                                    TriggerEvent("inventory:client:SetCurrentStash", "jobStash_".. PlayerJob.name)
                                    Wait(1500)
                                end
                            end 
                        end
                    end
                end

                if JobData['trashes'] and next(JobData['trashes']) then
                    local ped = PlayerPedId()
                    local pcoords = GetEntityCoords(ped)
                    for k, v in pairs(JobData['trashes'].locations) do
                        local dist = #(pcoords - v)
                        if dist < 10.0 then
                            idle = 1
                            DrawText3D(v.x, v.y, v.z, JobData['trashes'].label)
                            if dist < 1.5 then
                                if IsControlJustPressed(0, 38) then
                                    TriggerServerEvent("inventory:server:OpenInventory", "stash", "jobTrash_".. PlayerJob.name, {
                                        maxweight = 4000000,
                                        slots = 300,
                                    })
                                    TriggerEvent("inventory:client:SetCurrentStash", "jobTrash_".. PlayerJob.name)
                                    Wait(1500)
                                end
                            end 
                        end
                    end
                end
                
                if JobData['equipment'] and next(JobData['equipment']) then
                    local ped = PlayerPedId()
                    local pcoords = GetEntityCoords(ped)
                    for k, v in pairs(JobData['equipment'].locations) do
                        local dist = #(pcoords - v)
                        if dist < 10.0 then
                            idle = 1
                            DrawText3D(v.x, v.y, v.z, JobData['equipment'].label)
                            if dist < 1.5 then
                                if IsControlJustPressed(0, 38) then
                                    local authorizedItems = {
                                        label = JobData['equipment'].labelMenu,
                                        slots = JobData['equipment'].slots,
                                        items = {}
                                    }
                                    local index = 1
                                    for _, armoryItem in pairs(JobData['equipment'].items) do
                                        for i=1, #armoryItem.authorizedJobGrades do
                                            if armoryItem.authorizedJobGrades[i] == PlayerJob.grade.level then
                                                authorizedItems.items[index] = armoryItem
                                                authorizedItems.items[index].slot = index
                                                index = index + 1
                                            end
                                        end
                                    end
                                    SetWeaponSeries(JobData['equipment'].items)
                                    TriggerServerEvent("inventory:server:OpenInventory", "shop", PlayerJob.name, authorizedItems)
                                    Wait(1500)
                                end
                            end 
                        end
                    end
                end

                if JobData['garages'] and next(JobData['garages']) then
                    local ped = PlayerPedId()
                    local pcoords = GetEntityCoords(ped)
                    for k, v in pairs(JobData['garages'].locations) do
                        local dist = #(pcoords - vec3(v.x, v.y, v.z))
                        if dist < 10.0 then
                            idle = 1
                            if IsPedInAnyVehicle(ped) then
                                DrawText3D(v.x, v.y, v.z, JobData['garages'].store_label)
                                if IsControlJustPressed(0, 38) then
                                    DeleteVehicle(GetVehiclePedIsIn(ped, false))
                                    Wait(1500)
                                end
                            else 
                                DrawText3D(v.x, v.y, v.z, JobData['garages'].label)
                                if dist < 1.5 then
                                    if IsControlJustPressed(0, 38) then
                                        OpenGarage(JobData['garages'].vehicles, v, JobData['garages'].jobPlate)
                                        Wait(1500)
                                    end
                                end 
                            end
                        end
                    end
                end
            end
            Wait(idle)
        end
    end)
end

--------------
-- EVENTS
--------------

RegisterNetEvent("jobCreator:cl:SpawnVehicle", function(data)
    if hasJob() then
        QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
            local veh = NetToVeh(netId)
            if data.plate then SetVehicleNumberPlateText(veh, data.plate..tostring(math.random(1000, 9999))) end
            SetEntityHeading(veh, data.coords.w)
            exports[Config.FuelExport]:SetFuel(veh, 100.0)
            if data.extras then QBCore.Shared.SetDefaultVehicleExtras(veh, data.extras) end
            if data.livery then SetVehicleLivery(veh, data.livery) end
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            GiveKeys(veh)
            SetVehicleEngineOn(veh, true, true)
        end, data.vehicle, data.coords, true)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    onDuty = PlayerJob.onduty
    Init(PlayerJob.name)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty

    LoadLoop(false)
    if next(CurrentBlips) then
        for k, v in pairs(CurrentBlips) do
            RemoveBlip(v)
        end
    end
    JobData = {}
    Wait(500)
    Init(PlayerJob.name)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    PlayerJob = {}
    JobData = {}
    LoadLoop(false)

    if next(CurrentBlips) then
        for k, v in pairs(CurrentBlips) do
            RemoveBlip(v)
        end
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        PlayerData = QBCore.Functions.GetPlayerData()
        PlayerJob = PlayerData.job
        onDuty = PlayerJob.onduty
        Init(PlayerJob.name)
    end
end)

