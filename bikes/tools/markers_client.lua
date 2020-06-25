local createdMarkers = {}

function CreateMarker(id, x, y, z, size)
  local data = {
    x = x,
    y = y,
    z = z,
    size = size,
    inside = false,
  }
  
  createdMarkers[id] = data
  return id
end


AddEventHandler("onClientFrameUpdate",
  function()
    local localPlayer = PlayerPedId()
    local playerCoords = GetEntityCoords(localPlayer)

    for id, data in pairs(createdMarkers) do
      DrawMarker(
        1,								-- Type
        data.x,				    -- posX
        data.y,				    -- posY
        data.z,				    -- posZ
        0.0,							-- dirX
        0.0,							-- dirY
        0.0,							-- dirZ
        0.0,							-- rotX
        0.0,							-- rotY
        0.0,							-- rotZ
        data.size,				-- scaleX
        data.size,				-- scaleY
        0.5,							-- scaleZ
        0,								-- red
        0,								-- green
        255,							-- blue
        100,							-- alpha
        false,						-- bobUpAndDown
        false,						-- faceCamera
        2 								-- doesnt matter
      )
      
      if Vdist(playerCoords.x, playerCoords.y, playerCoords.z, data.x, data.y, data.z) <= data.size then
        if not data.inside then
          data.inside = true
          TriggerEvent("onClientMarkerEnter", id)
        end
      else
        if data.inside then
          data.inside = false
          TriggerEvent("onClientMarkerLeave", id)
        end
      end
    end
  end
)