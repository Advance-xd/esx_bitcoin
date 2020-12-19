ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local reward = 0.0001
local gps = 1.1

Citizen.CreateThread(function()
    while true do
        MySQL.Async.fetchAll('SELECT * FROM bitcoin', {}, function(result)
            for i=1, #result do
                local grap = result[i].graphics * gps
                MySQL.Async.execute('UPDATE `bitcoin` SET bitcoins = @bitcoinchange',
                {
                    ['@bitcoinchange'] = grap * reward + result[i].bitcoins,
                })
                
            end
        
        end)
        
        Citizen.Wait(1000)
    end
end)

RegisterServerEvent("esx_bitcoin:addmoney")
AddEventHandler("esx_bitcoin:addmoney", function(amount)
    
    local xPlayer = ESX.GetPlayerFromId(source)  
    local cid = xPlayer["characterId"]

    xPlayer.addAccountMoney('bank', amount * Config.Diff)
    TriggerClientEvent('esx:showNotification', source, 'Du sålde ' .. amount .. ' bitcoin för ' .. amount * Config.Diff .. ' kr')
    MySQL.Async.execute('UPDATE `bitcoin` SET bitcoins = 0 WHERE identifier = @cid',
        {
            ['@cid'] = cid,
        }   
    )
end)

RegisterServerEvent("esx_bitcoin:buy")
AddEventHandler("esx_bitcoin:buy", function()
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getAccount('bank').money
    local graffe = xPlayer.getInventoryItem(Config.ItemName).count

    if money >= Config.price then
        if graffe >= 1 then
            xPlayer.removeAccountMoney('bank', Config.price)
            xPlayer.removeInventoryItem(1, graffe)
            TriggerClientEvent('esx:showNotification', source, 'Du köpte en bitcoin farm')
            TriggerClientEvent('esx_bitcoin:closemenu', source)
            CreateFarm(source)

        else
            TriggerClientEvent('esx:showNotification', source, 'Du saknar ett grafikkort')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'Du har inte råd')
    end


end)

RegisterServerEvent("esx_bitcoin:add")
AddEventHandler("esx_bitcoin:add", function()
    player = source
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local graffe = xPlayer.getInventoryItem(Config.ItemName).count
    local cid = xPlayer["characterId"]
    
    if graffe >= 1 then
          
        MySQL.Async.fetchAll('SELECT graphics FROM bitcoin WHERE identifier = @cid', {["@cid"] = cid}, function(result)
        
            
            if result[1].graphics >= 20 then
                TriggerClientEvent('esx:showNotification', player, 'Du får inte plats med flera grafikkort')   
            else
                xPlayer.removeInventoryItem(Config.ItemName, 1)
                TriggerClientEvent('esx:showNotification', player, "Du satt in 1 grafikkort")  
                
                
                MySQL.Async.execute('UPDATE `bitcoin` SET graphics = @graffe WHERE identifier = @cid',
                {
                    ['@cid'] = cid,
                    ['@graffe'] = 1 + result[1].graphics
                })
                
                 
            end
        end)
            
        
        
    else
        TriggerClientEvent('esx:showNotification', player, "Du saknar grafikkort")
    end



end)

ESX.RegisterServerCallback('esx_bitcoin:fetchbitcoin', function(source, cb)
    
    local player = ESX.GetPlayerFromId(source)
    local cid = player["characterId"]

    MySQL.Async.fetchAll('SELECT bitcoins FROM bitcoin WHERE identifier = @cid', {["@cid"] = cid}, function(result)   
        if result[1].bitcoins ~= nil then
            cb(result[1].bitcoins)
            
        else
            print('no bitcoin found')
        end
    end)
    
end)

ESX.RegisterServerCallback('esx_bitcoin:fetchgraphics', function(source, cb)
    
    local player = ESX.GetPlayerFromId(source)
    local cid = player["characterId"]

    MySQL.Async.fetchAll('SELECT graphics FROM bitcoin WHERE identifier = @cid', {["@cid"] = cid}, function(result)
        if result[1].graphics ~= nil then
            cb(result[1].graphics)
            
        else
            print('no graffe found')
        end
    end)
    
end)

function CreateFarm(src)
    local player = ESX.GetPlayerFromId(src)
    local cid = player["characterId"]

    MySQL.Async.execute('INSERT INTO bitcoin (identifier, bitcoins, graphics) VALUES (@identifier, @bitcoins, @graphics)', 
        {
            ["@identifier"] = cid,
            ["@bitcoins"] = 0,
            ["@graphics"] = 1
        }
    )
    
end