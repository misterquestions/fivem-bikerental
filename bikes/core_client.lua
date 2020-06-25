AddEventHandler("onClientResourceStart",
  function()
    while true do
      TriggerEvent("onClientFrameUpdate")
      Citizen.Wait(0)
    end
  end
)