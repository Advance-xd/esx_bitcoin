ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(0)
	end
end)






local graphics = 0
local bitcoins = 0

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
					ESX.TriggerServerCallback('esx_bitcoin:fetchbitcoin', function(bitcoinss)
						bitcoins = bitcoinss			
					end)
					ESX.TriggerServerCallback('esx_bitcoin:fetchgraphics', function(graphicss)
						graphics = graphicss
						if graphics == 0 then
							OpenBuyMenu()
						else
							OpenMenu()
						end
					end)
					

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
			TriggerServerEvent('esx_bitcoin:buy')
			


		
		
		end
		
		
	  end, function(data, menu)
		menu.close()
	  end)
end


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

function update()
	
	ESX.TriggerServerCallback('esx_bitcoin:fetchbitcoin', function(bitcoinss)
		sendbitcoins = bitcoinss			
	end)
	--ESX.TriggerServerCallback('esx_bitcoin:fetchgraphics', function(graphicss)
	--	sendgraphics = graphicss
	--end)
	SendNUIMessage({type = "update", bitcoins = sendbitcoins, graphics = sendgraphics})	
end

function closeUI() 
	inMenu = false
	SetNuiFocus(false, false)
    SendNUIMessage({type = "close"})
end

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		
		print('update')
		update()
		
		Citizen.Wait(1000)
	end

end)