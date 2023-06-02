playerJob = nil

if Config.Framework == 'esx' then
    Core = exports['es_extended']:getSharedObject()

    

    RegisterNetEvent("esx:setJob")
    AddEventHandler("esx:setJob", function(job) 
        playerJob = job 
    end)

    AddEventHandler('esx:onPlayerDeath', function(data)
        TriggerEvent('coj-deathscreen:client:onPlayerDeath', true)
    end)

    RegisterNetEvent('coj-deathscreen:client:remove_revive')
    AddEventHandler('coj-deathscreen:client:remove_revive', function ()
        local ped = PlayerPedId()
        SetEntityCoordsNoOffset(ped, Config.RespawnCoords.coords.x, Config.RespawnCoords.coords.y, Config.RespawnCoords.coords.z, false, false, false)
        NetworkResurrectLocalPlayer(Config.RespawnCoords.coords.x, Config.RespawnCoords.coords.y, Config.RespawnCoords.coords.z, Config.RespawnCoords.heading, true, false)
        SetPlayerInvincible(ped, false)
        ClearPedBloodDamage(ped)
      
        TriggerEvent('esx_basicneeds:resetStatus')
        TriggerServerEvent('esx:onPlayerSpawn')
        TriggerEvent('esx:onPlayerSpawn')
        TriggerEvent('playerSpawned')
        TriggerEvent('coj-deathscreen:client:setDeathStatus', false)
    end)

    RegisterNetEvent('coj-deathscreen:client:setDeathStatus')
    AddEventHandler('coj-deathscreen:client:remove_revive', function (bool)
        TriggerServerEvent('esx_ambulancejob:setDeathStatus', bool)
    end)

    SendDistressSignal = function()
        
    end

elseif Config.Framework == 'qbcore' then
    Core = exports['qb-core']:GetCoreObject()

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        playerJob = Core.Functions.GetPlayerData().job
    end)
    
    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
        playerJob = JobInfo
    end)
    
    RegisterNetEvent('coj-deathscreen:client:remove_revive')
    AddEventHandler('coj-deathscreen:client:remove_revive', function ()
        local ped = PlayerPedId()
    
        TriggerServerEvent('hospital:server:RespawnAtHospital')
        TriggerEvent('coj-deathscreen:client:setDeathStatus', false)
    end)

    RegisterNetEvent('coj-deathscreen:client:setDeathStatus')
    AddEventHandler('coj-deathscreen:client:remove_revive', function (bool)
        TriggerServerEvent("hospital:server:SetDeathStatus", bool)
        TriggerServerEvent("hospital:server:SetLaststandStatus", bool)
    end)

    SendDistressSignal = function()
        TriggerServerEvent('hospital:server:ambulanceAlert', 'Critical Medical Condition')
    end
end
