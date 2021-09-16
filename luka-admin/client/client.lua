ESX = nil

LUKA_noclip = false
LUKA_nevidljiv = false
LUKA_noclipSpeed = 2.01
LUKA = {}
Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(100)
    end
end)

-- Varijable

local jel_admin

Citizen.CreateThread(function()
	LUKA.proveriadmina()
    while true do 
        Wait(150)
    end
end)

LUKA.proveriadmina = function()
    jel_admin = nil
    TriggerServerEvent('LUKA-admin:jeadmin')
    while (jel_admin == nil) do
        Citizen.Wait(100)
    end
end

RegisterNetEvent('LUKA-admin:proveriadmina')
AddEventHandler('LUKA-admin:proveriadmina', function(state)
    jel_admin = state 
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(10)
        if IsControlJustReleased(0, 56) and jel_admin then 
			LUKAMeni()
		elseif IsControlJustReleased(0, 56) and not jel_admin then 
			ESX.ShowNotification('Nemas permisije za ovo!')
        end 
        if LUKA_noclip then
            local ped = PlayerPedId()
            local x,y,z = getPosition()
            local dx,dy,dz = getCamDirection()
            local speed = LUKA_noclipSpeed
        
  
            SetEntityVelocity(ped, 0.05,  0.05,  0.05)
  
            if IsControlPressed(0, 32) then
                x = x + speed * dx
                y = y + speed * dy
                z = z + speed * dz
            end
  
            if IsControlPressed(0, 269) then
                x = x - speed * dx
                y = y - speed * dy
                z = z - speed * dz
            end
  
            SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
        end
	end
end)


function LUKAMeni()
    local elements = {}

    local elements = {
		{label = "Noclip | ⭐", value = "noclip"},
		{label = "Nevidljivost | 🕶️", value = "nevidljiv"},
		{label = "Izleci | 💉", value = "ozivi"},
		{label = "Izbrisi vozilo | 🚗", value = "clearVehicle"},
		{label = "Popravi vozilo | 🧰", value = "popravi"},
		{label = "Najavi restart | 📜", value = "obavesti"},
		{label = "Izadji | ❌", value = "zatvori"}
    }


    ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'LUKA_meni',
		{
			title  = "Balkan Wonder Staff",
			elements = elements
		},
		function(data, menu)
			if data.current.value == "noclip" then
				TriggerEvent('LUKA-admin:noklipovan')
			elseif data.current.value == "clearVehicle" then
				TriggerEvent('esx:deleteVehicle')
				TriggerEvent('esx:showNotification', "Vozilo ~r~izbrisano~w~.")
			elseif data.current.value == "ozivi" then
				TriggerEvent('LUKA-admin:oziviIgraca')
			elseif data.current.value == "popravi" then
				TriggerEvent( 'LUKA-admin:popravivozilo')
			elseif data.current.value == "nevidljiv" then
				TriggerEvent('LUKA-admin:nevidljivost')
			elseif data.current.value == "obavesti" then
				TriggerServerEvent('LUKA-admin:obavestenje')
			elseif data.current.value == "zatvori" then
				ESX.UI.Menu.CloseAll()
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end

RegisterNetEvent('LUKA-admin:noklipovan')
AddEventHandler('LUKA-admin:noklipovan',function()
	LUKA_noclip = not LUKA_noclip
    local ped = PlayerPedId()

    if LUKA_noclip then
    	SetEntityInvincible(ped, true)
    	SetEntityVisible(ped, false, false)
    else
    	SetEntityInvincible(ped, false)
    	SetEntityVisible(ped, true, false)
    end

    if LUKA_noclip == true then 
        ESX.ShowNotification('Noclip je ~g~aktiviran')
    else
        ESX.ShowNotification('Noclip je ~r~deaktiviran.')
    end
end)

RegisterNetEvent('LUKA-admin:nevidljivost')
AddEventHandler('LUKA-admin:nevidljivost', function()
	LUKA_nevidljiv = not LUKA_nevidljiv
    local ped = PlayerPedId()
    SetEntityVisible(ped, not LUKA_nevidljiv, false)
    if LUKA_nevidljiv == true then 
        ESX.ShowNotification('Nevidljivost je ~g~aktivirana.')
    else
        ESX.ShowNotification('Nevidljivost je ~r~deaktivirana.')
    end
end)

RegisterNetEvent('LUKA-admin:popravivozilo')
AddEventHandler('LUKA-admin:popravivozilo', function()
    local ply = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(ply)
    if IsPedInAnyVehicle(ply) then 
        SetVehicleFixed(plyVeh)
        SetVehicleDeformationFixed(plyVeh)
        SetVehicleUndriveable(plyVeh, false)
        SetVehicleEngineOn(plyVeh, true, true)
        ESX.ShowNotification('~g~Popravili ste vozilo!')
    else
        ESX.ShowNotification('~r~Morate biti blizu vozila!')
    end
end)

RegisterNetEvent('LUKA-admin:teleport')


RegisterNetEvent('LUKA-admin:oziviIgraca')
AddEventHandler('LUKA-admin:oziviIgraca', function()
    if jel_admin then 
        local LUKA_ped = PlayerPedId()
        SetEntityHealth(LUKA_ped, 200)
        ESX.ShowNotification('~y~Izlecili ste.')
        ClearPedBloodDamage(LUKA_ped)
        ResetPedVisibleDamage(LUKA_ped)
        ClearPedLastWeaponDamage(LUKA_ped)
    else
        ESX.ShowNotification('~r~Niste staff.')
    end
end)

--[[
	FUNKCIJE
]]

getPosition = function()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
  	return x,y,z
end

getCamDirection = function()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(PlayerPedId())
	local pitch = GetGameplayCamRelativePitch()
  
	local x = -math.sin(heading*math.pi/180.0)
	local y = math.cos(heading*math.pi/180.0)
	local z = math.sin(pitch*math.pi/180.0)
  
	local len = math.sqrt(x*x+y*y+z*z)
	if len ~= 0 then
	  x = x/len
	  y = y/len
	  z = z/len
	end
  
	return x,y,z
end

teleportByCar = function()
	local player = PlayerPedId()
	local blip = GetFirstBlipInfoId(8)
	local coche =  GetVehiclePedIsIn(PlayerPedId(),false)
		local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())
		SetEntityCoords(coche,coord.x,coord.y,coord.z+5)
		TriggerEvent('esx:showNotification', "Uspesno ste se ~g~teleportovali.")
		SetPedIntoVehicle(PlayerPedId(), coche, - 1)
		DrawNotification(false, true)
end

teleportToPoint = function()
    local player = PlayerPedId()
	local blip = GetFirstBlipInfoId(8)
	local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())
	SetEntityCoords(player,coord.x,coord.y,coord.z)
	TriggerEvent('esx:showNotification', "Uspesno ste se ~g~teleportovali.")
	DrawNotification(false, true)
end