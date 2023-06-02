RegisterNetEvent('coj-deathscreen:server:getRPName')
AddEventHandler('coj-deathscreen:server:getRPName', function(killerid)
    local Player = GetPlayer(killerid)
    if Player == nil then return end
    TriggerClientEvent('coj-deathscreen:client:getRPName', source, GetPlayerRPName(killerid))
end)
