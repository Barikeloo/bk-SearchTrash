ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local props = {}
local propsUsabled = {}

CreateThread(function()

    while true do

        Wait(5000)

        local allProps = ESX.Game.GetObjects()

        for i=1, #allProps do
            for k, v in pairs(Config.Prop) do
                if GetEntityModel(allProps[i]) == v then
                    table.insert(props, allProps[i])
                end
            end
        end

    end

end)

Citizen.CreateThread(function()
    while true do
        local wait = 1000

        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)

        for i=1, #props do
            local propPos = GetEntityCoords(props[i])
            local dist = #(pos - propPos)

            if dist < 7.5 and not IsPedInAnyVehicle(PlayerPedId()) and not propsUsabled[props[i]] then
                wait = 0
                
                if dist < 1.8 then
                    ESX.ShowHelpNotification(Config.Text)
                    if IsControlJustReleased(0, 38) then
                        local random = math.random(Config.MinReward, Config.MaxReward)
                        local item = Config.Items[math.random(#Config.Items)]
                        FreezeEntityPosition(playerPed, true)
                        ExecuteCommand('e medic')
                        Citizen.Wait(5000)
                        ClearPedTasksImmediately(playerPed)
                        propsUsabled[props[i]] = true
                        CreateThread(function()
                            local prop = props[i]
                            Wait(Config.RenovationPropTime)
                            propsUsabled[prop] = false
                        end)
                        FreezeEntityPosition(playerPed, false)
                        TriggerServerEvent('bk-search:dropItem', item, random)
                    end
                end
            end
        end

        Wait(wait)
    end
end)