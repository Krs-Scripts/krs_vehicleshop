local State = require 'client.state'

local camSettings = {
    {radius = 6.5, height = 1.5, fov = 45.0}, 
    {radius = 4.5, height = 0.5, fov = 35.0}, 
    {radius = 5.5, height = 2.5, fov = 50.0}, 
    {radius = 4.0, height = 1.2, fov = 30.0}, 
}

local function manageCamera()
    if State.currentCam then return end 

    State.currentCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(State.currentCam, true)
    RenderScriptCams(true, false, 0, true, false)

    CreateThread(function()
        while State.isShowroomOpen do

            if not State.vehiclePreview or not DoesEntityExist(State.vehiclePreview) then
                Wait(500)
            else
                local now = GetGameTimer()
                
                if now - State.lastCamChange > 7000 then
                    State.lastCamChange = now
                    State.currentCamSetting += 1
                    if State.currentCamSetting > #camSettings then State.currentCamSetting = 1 end
                    SetCamFov(State.currentCam, camSettings[State.currentCamSetting].fov)
                end

                local setting = camSettings[State.currentCamSetting]
                State.camAngle += 0.002
                
                local vehicleCoords = GetEntityCoords(State.vehiclePreview)

                local x = vehicleCoords.x + (math.cos(State.camAngle) * setting.radius)
                local y = vehicleCoords.y + (math.sin(State.camAngle) * setting.radius)
    
                SetCamCoord(State.currentCam, x, y, vehicleCoords.z + setting.height)
                PointCamAtEntity(State.currentCam, State.vehiclePreview, 0.0, 0.0, 0.0, true)

                Wait(3) 
            end
        end
    end)
end

local function stopCamera()
    RenderScriptCams(false, false, 0, true, false)

    if State.currentCam then
        DestroyCam(State.currentCam, false)
        State.currentCam = nil
    end

    State.camAngle = 0.0
    State.currentCamSetting = 1
end

return {
    manageCamera = manageCamera,
    stopCamera = stopCamera
}