LUKA = {}

local LUKAAdmins = {
    'steam:11000013ec68de8', 
    '', 
    '',
    '',
    '',
    '',
    '',
}

ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- FUNKCIJE LUKA 

LUKA.jel_admin = function()
    local LUKA_identifier = GetPlayerIdentifiers(src)
    LUKA_identifier = LUKA_identifier[1]
    for i, v in pairs(LUKAAdmins) do 
        if v == LUKA_identifier then 
            return true 
        end
    end 
    return false
end

RegisterServerEvent('LUKA-admin:obavestenje')
AddEventHandler('LUKA-admin:obavestenje', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'STAFF', '~b~Informacija', 'Za 5 minuta ide restart servera', 'CHAR_ANDREAS', 8)
    end
end)


RegisterServerEvent('LUKA-admin:jeadmin')
AddEventHandler('LUKA-admin:jeadmin', function()
    local LUKAidentifier = GetPlayerIdentifiers(source)
    LUKAidentifier = LUKAidentifier[1]
    for a, v in pairs(LUKAAdmins) do 
        if v == LUKAidentifier then 
            TriggerClientEvent('LUKA-admin:proveriadmina', source, true)
            return true 
        end
    end 
    return false 
end)
