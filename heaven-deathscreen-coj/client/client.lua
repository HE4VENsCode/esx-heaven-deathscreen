RegisterNetEvent('coj-deathscreen:client:onPlayerDeath')
AddEventHandler('coj-deathscreen:client:onPlayerDeath', function(isDead)
    if isDead then
        local killername = nil
        TriggerEvent('coj-deathscreen:client:setDeathStatus', true)
        SendNUIMessage({type = "show", status = true})
        SetNuiFocus(true, true)

        local PedKiller = GetPedSourceOfDeath(PlayerPedId())
        local killerid = NetworkGetPlayerIndexFromPed(PedKiller)

        if IsEntityAVehicle(PedKiller) and IsEntityAPed(GetVehiclePedIsIn(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
            killerid = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
        end

        if (killerid == -1) then
            killername = Config.Translation.Suicide
        elseif (killerid == nil) then
            killername = Config.Translation.Unknown
        elseif (killerid ~= -1) then

            if Config.UseRPName then
                TriggerServerEvent('coj-deathscreen:server:getRPName', GetPlayerServerId(killerid))
            else
                killername = GetPlayerName(killerid)
            end
        end

        SendNUIMessage({type = 'setUPValues', killer = killername, timer = Config.Timer})
    end
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)

    SendNUIMessage({type = "show", status = false})
    SetNuiFocus(false, false)
    TriggerEvent('coj-deathscreen:client:remove_revive')

end)


RegisterNetEvent('coj-deathscreen:client:getRPName')
AddEventHandler('coj-deathscreen:client:getRPName', function(name)
    SendNUIMessage({type = 'setUPValues', killer = name, timer = Config.Timer})
end)

RegisterNetEvent('coj-deathscreen:client:hide_ui')
AddEventHandler('coj-deathscreen:client:hide_ui', function()
    SendNUIMessage({type = "show", status = false})
    SetNuiFocus(false, false)
end)

RegisterNuiCallback("accept_to_die", function(data)
    SendNUIMessage({type = "show", status = false})
    SetNuiFocus(false, false)
    TriggerEvent('coj-deathscreen:client:remove_revive')
    if Config.Framework == 'esx' then
        Core.TriggerServerCallback("coj-deathscreen:server:removeMoney")
        Core.ShowNotification((Config.Translation.MoneyRemoved):format(Config.PriceForDead))
    elseif Config.Framework == 'qbcore' then
        Core.Functions.TriggerCallback("coj-deathscreen:server:removeMoney")
        Core.Functions.Notify((Config.Translation.MoneyRemoved):format(Config.PriceForDead), 'primary', 5000)
    end
end)

RegisterNuiCallback("call_emergency", function(data)
    SendDistressSignal()
end)

RegisterNuiCallback("time_expired", function(data)
    SetNuiFocus(false, false)
    TriggerEvent('coj-deathscreen:client:remove_revive')
end)
