ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(0)
	end
end)


local bitcoins = 0
local graphics = 0

local farm = false 

Citizen.CreateThread(function()
	Citizen.Wait(10)
	while true do
		local sleep = 500



		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.coords.x, Config.coords.y, Config.coords.z, true)

		if distance < 5.0 then
			sleep = 5
			ESX.DrawMarker("Bitcoin Farm", 27, Config.coords.x, Config.coords.y, Config.coords.z, 255, 255, 255, 1.2, 1.2)
			
			if distance < 1.5 then
				if IsControlJustPressed(0, 38) then
					
					if farm == nil then
						
					else
						if farm then
							OpenMenu()
						else
							OpenBuyMenu()
						end
					end

				end
			end
		end

		Citizen.Wait(sleep)
	end

end)

function OpenMenu()
	
	
	
	local elements = {
		{label = "Bitcoins: " .. bitcoins, value = 'bitcoins'},
		{label = "Grafikkort: " .. graphics, value = 'cards'},
		
		
	  }
	
	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bitcoin_menu',
		{
		  title    = 'Bitcoin Farm',
		  align = "center",
		  elements = elements
		},
	  function(data, menu)
		local selected = data.current.value
	
		if selected == 'bitcoins' then
			menu.close()
			OpenBitcoinMenu()
		  
		end
		if selected == 'cards' then
			menu.close()
			OpenCardsMenu()
		  
		end
		
		
	  end, function(data, menu)
		menu.close()
	  end)
	
	
end

function OpenBitcoinMenu()

	  local elements = {
		{label = "Bitcoin pris: " .. Config.Diff, value = 'price'},
		{label = "Sälj", value = 'sell'}
		
	  }
	
	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bitcoin_selling',
		{
		  title    = 'Bitcoin Farm',
		  align = "center",
		  elements = elements
		},
	  function(data, menu)
		local selected = data.current.value
	
		if selected == 'sell' then
			
			if bitcoins > 0 then
				
				TriggerServerEvent('esx_bitcoin:addmoney', bitcoins)
				bitcoins = 0
				menu.close()
			else
				TriggerEvent('esx:showNotification', 'Du har inga bitcoin')
			end


		
		
		end
		
		
	  end, function(data, menu)
		menu.close()
	  end)
	
end

function OpenCardsMenu()
	local elements = {
		{label = "Lägg till ett grafikkort", value = 'add'},
		
		
	  }
	
	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bitcoin_cards',
		{
		  title    = 'Bitcoin Farm',
		  align = "center",
		  elements = elements
		},
	  function(data, menu)
		local selected = data.current.value
	
		if selected == 'add' then
			menu.close()
			TriggerServerEvent('esx_bitcoin:add')
		  
		end
		
		
		
	  end, function(data, menu)
		menu.close()
	  end)
end

function OpenBuyMenu()
	
	
	local elements = {
		{label = "Köp en bitcoin farm (" .. Config.price .. " kr)", value = 'buy'},
		
		
	  }
	
	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bitcoin_buy',
		{
		  title    = 'Bitcoin Farm',
		  align = "center",
		  elements = elements
		},
	  function(data, menu)
		local selected = data.current.value
	
		if selected == 'buy' then
			menu.close()
			TriggerServerEvent('esx_bitcoin:buy')
			farm = true


		
		
		end
		
		
	  end, function(data, menu)
		menu.close()
	  end)
end

------------------------------------------------------- UI ----------------------------------------------------

inMenu = false

RegisterCommand('bitcoin', function(source, args, rawCommand)
	if inMenu then
		closeUI()
		inMenu = false
	else
		ESX.TriggerServerCallback('esx_bitcoin:fetchbitcoin', function(bitcoinss)
			sendbitcoins = bitcoinss			
		end)
		ESX.TriggerServerCallback('esx_bitcoin:fetchgraphics', function(graphicss)
			sendgraphics = graphicss
		end)
		openUI()
	end
end)

RegisterNUICallback('close', function(data, cb) 
	if (inMenu) then
		closeUI()
	end

end)

RegisterNUICallback("sold", function(data, cb)
	TriggerServerEvent('esx_bitcoin:addmoney', data.bc)
end)

RegisterNUICallback("error", function(data, cb)
	TriggerEvent('esx:showNotification', 'Du har inte så många bitcoins')
end)

RegisterNUICallback("all", function()
	SendNUIMessage({type = "all", graphics = sendgraphics})
end)

RegisterNUICallback("sell", function()
	if bitcoins > 0 then
				
		TriggerServerEvent('esx_bitcoin:addmoney', bitcoins)
		bitcoins = 0
	else
		TriggerEvent('esx:showNotification', 'Du har inga bitcoin')
	end
end)

function openUI()
	inMenu = true
	SetNuiFocus(true, true)

	if sendgraphics == nil or sendgraphics == nil then
		SendNUIMessage({type = "open"})
		Citizen.Wait(500)
		update()
	else
		SendNUIMessage({type = "open", bitcoins = sendbitcoins, graphics = sendgraphics})
	end
end

function closeUI() 
	inMenu = false
	SetNuiFocus(false, false)
    SendNUIMessage({type = "close"})
end

RegisterCommand('load', function(source, args, rawCommand)
    hasfarm()
	update()
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	hasfarm()
	update()
end)


function hasfarm()
	ESX.TriggerServerCallback('esx_bitcoin:fetchgraphics', function(graphicss)
		sendgraphics = graphicss
	end)
	Citizen.Wait(1000)
	if sendgraphics == nil then
		farm = false
	else
		farm = true
	end
	
end

function update()
	
	ESX.TriggerServerCallback('esx_bitcoin:fetchbitcoin', function(bitcoinss)
		sendbitcoins = bitcoinss			
	end)
	ESX.TriggerServerCallback('esx_bitcoin:fetchgraphics', function(graphicss)
		sendgraphics = graphicss
	end)
	local diff = Config.Diff
	SendNUIMessage({type = "update", bitcoins = sendbitcoins, graphics = sendgraphics, price = diff})
	bitcoins = sendbitcoins
	graphics = sendgraphics 
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		while farm do
			update()
			Citizen.Wait(1000)
		end
	end
end)