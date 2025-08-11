local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local PLACE_ID = 109983668079237 -- PlaceId alvo
local API_URL = "http://127.0.0.1:8765"

local LocalPlayer = Players.LocalPlayer
local autoJoinEnabled = true -- já inicia ativo
local lastJobId = nil

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5,
            Icon = ("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png"):format(LocalPlayer.UserId)
        })
    end)
end

local function safeGet(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        return result
    else
        return nil
    end
end

local function tryTeleport(jobId)
    if not jobId or #jobId < 10 then
        return
    end
    if jobId == lastJobId then
        return
    end
    lastJobId = jobId

    notify("Auto Join", "Entrando no servidor: "..jobId)
    local success, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(PLACE_ID, jobId, LocalPlayer)
    end)
    if not success then
        warn("[AutoJoin] Falha ao teleportar: "..tostring(err))
        notify("Erro", "Falha ao teleportar. Tentando novamente...")
    end
end

notify("Auto Join", "Ativado automaticamente. Aguardando JobId...")

task.spawn(function()
    while true do
        if autoJoinEnabled then
            local status = safeGet(API_URL.."/check_update")
            if status == "1" then
                local jobId = safeGet(API_URL.."/get_clipboard")
                tryTeleport(jobId)
            end
        end
        task.wait(1)
    end
end)
