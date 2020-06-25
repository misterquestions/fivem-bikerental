local canOpenMenu = false
local rentalMarkers = {
	CreateMarker("bikerenta", -1342.278, -1299.347, 3.836463, 1.5),
}

WarMenu.CreateMenu("rentMenu", "Alquilar una bicicleta")
WarMenu.SetSubTitle("rentMenu", "Configurar")
WarMenu.CreateSubMenu("closeMenu", "rentMenu", "¿Estás seguro?")

-- Rental model
local models = { "Bmx", "Cruiser", "Fixter", "Scorcher", "TriBike", "TriBike2", "TriBike3" }
local modelCurrentIndex = 1

local function updateModelSelection(currentIndex)
	modelCurrentIndex = currentIndex
end

-- Rental duration
local durations = { "10 Segundos", "1 minuto", "5 minutos", "10 minutos", "25 minutos" }
local numberDurations = { 0.16666666666666666666666666666667, 1, 5, 10, 25 }
local durationCurrentIndex = 1

local function updateDurationSelection(currentIndex)
	durationCurrentIndex = currentIndex
end

local function DestroyMyBike()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	if DoesEntityExist(vehicle) then
		DeleteEntity(vehicle)
	end
end

-- Actual dispatch of the vehicle
local function dispatchBike()
	-- Use vehicle name
	local vehicleName = models[modelCurrentIndex]

	-- load the model
	RequestModel(vehicleName)

	-- wait for the model to load
	while not HasModelLoaded(vehicleName) do
		Citizen.Wait(500)
	end

	-- get the player's position
	local playerPed = PlayerPedId()
	local playerPosition = GetEntityCoords(playerPed)

	-- create the vehicle
	local vehicle = CreateVehicle(vehicleName, playerPosition.x, playerPosition.y, playerPosition.z, GetEntityHeading(playerPed), true, false)

	-- set the player ped into the vehicle's driver seat
	SetPedIntoVehicle(playerPed, vehicle, -1)

	-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
	SetEntityAsNoLongerNeeded(vehicle)

	-- release the model
	SetModelAsNoLongerNeeded(vehicleName)

	-- Delete the vehicle in the selected time
	local finalDuration = 1000 * 60 * numberDurations[durationCurrentIndex]
	Citizen.SetTimeout(finalDuration, DestroyMyBike)
end

AddEventHandler("onClientMarkerEnter",
	function(marker)
		if table.find(rentalMarkers, marker) then
			if not canOpenMenu then
				canOpenMenu = true
			end
		end
	end
)

AddEventHandler("onClientMarkerLeave",
	function(marker)
		if table.find(rentalMarkers, marker) then
			if canOpenMenu then
				canOpenMenu = false
			end
		end
	end
)

AddEventHandler("onClientFrameUpdate",
	function()
		if not canOpenMenu and WarMenu.IsAnyMenuOpened() then
			WarMenu.CloseMenu()
		elseif WarMenu.IsMenuOpened("rentMenu") then
			WarMenu.ComboBox("Modeo", models, modelCurrentIndex, 1, updateModelSelection)
			WarMenu.ComboBox("Tiempo", durations, durationCurrentIndex, 1, updateDurationSelection)
			if WarMenu.Button("Alquilar") then
				dispatchBike()
				WarMenu.CloseMenu()
			end
			WarMenu.MenuButton("Salir", "closeMenu")
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened("closeMenu") then
			if WarMenu.Button("Si") then
				WarMenu.CloseMenu()
			end
			WarMenu.MenuButton("No", "rentMenu")
			WarMenu.Display()
		elseif IsControlJustPressed(0, 34) and not WarMenu.IsAnyMenuOpened() and canOpenMenu then -- M by default
			WarMenu.OpenMenu("rentMenu")
		end
	end
)