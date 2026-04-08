repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Setting = {
    ["Team"] = "Pirates",
    ["Chat"] = {},
    ["Skip Race V4"] = true,
    ["Melee"] = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["C"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["V"] = {["Enable"] = false, ["HoldTime"] = 0.1},
        ["Delay"] = 1.5
    },
    ["Sword"] = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["Delay"] = 1
    },
    ["Gun"] = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["Delay"] = 1,
        ["GunMode"] = false
    },
    ["Fruit"] = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["X"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["C"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["V"] = {["Enable"] = false, ["HoldTime"] = 0.1},
        ["F"] = {["Enable"] = true, ["HoldTime"] = 0.1},
        ["Delay"] = 1
    },
    ["Hunt"] = {
        ["Min"] = 0,
        ["Max"] = 30000000,
        ["MaxDistance"] = 30000
    },
    ["Skip"] = {
        ["Fruit"] = false,
        ["FruitList"] = {"Buddha", "Leopard", "T-Rex"},
        ["SafeZone"] = true,
        ["NoHaki"] = true,
        ["NoPvP"] = true
    },
    ["SafeHealth"] = {
        ["Health"] = 4700,
        ["Mask"] = false,
        ["MaskType"] = "Mask",
        ["RaceV4"] = false
    },
    ["Another"] = {
        ["V3"] = true,
        ["V4"] = true,
        ["AutoObservation"] = true,
        ["CustomHealth"] = true,
        ["Health"] = 4700,
        ["AutoStoreFruit"] = true,
        ["AutoRandomFruitOnJoin"] = true,
        ["AutoRandomBoneOnJoin"] = true,
        ["WhiteScreen"] = false,
        ["FPSBoots"] = false,
        ["AutoServerHop"] = true,
        ["HopWhenNoBounty"] = true,
        ["BountyLock"] = false,
        ["BountyLockAt"] = 30000000,
        ["ServerHopAfterTime"] = false,
        ["ServerHopTime"] = 900,
        ["CheckCombatBeforeHop"] = true,
        ["MaxPlayersInServer"] = 8
    },
    ["Webhook"] = {
        ["Enabled"] = true,
        ["Url"] = "https://ptb.discord.com/api/webhooks/1485273103410921603/AF5cCr5CoU1MeLbj9eexIhaEfuc13Rgdfs3R1w0--_PdyaxdPyhwAIitrzqqpZ02Iatb"
    }
}

local CFG = getgenv().Setting
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF_Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local LocalPlayer = game:GetService("Players").LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local player = game.Players.LocalPlayer
local VirtualUser  = game:GetService("VirtualUser")

local _currentChar = player.Character
CommF_Remote:InvokeServer("SetTeam", CFG["Team"])

local charLoaded = false
local _conn
_conn = player.CharacterAdded:Connect(function()
    charLoaded = true
    _conn:Disconnect()
end)
local _t = 0
repeat task.wait(0.1); _t = _t + 0.1 until charLoaded or _t >= 5
if _conn then pcall(function() _conn:Disconnect() end) end

local character = player.Character or player.CharacterAdded:Wait()
repeat task.wait(0.1) until character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid")
print("Character loaded after team switch")
loadstring(game:HttpGet("https://raw.githubusercontent.com/letrungkien2k10/LoL/refs/heads/main/test.lua"))()
repeat task.wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")
getgenv().weapon = nil
getgenv().targ = nil
getgenv().lasttarrget = nil
getgenv().checked = {}
getgenv().pl = game.Players:GetPlayers()
getgenv().killed = nil
getgenv().ServerBlacklist = getgenv().ServerBlacklist or {}

local WEBHOOKS = {
    FullMoon          = "https://ptb.discord.com/api/webhooks/1489972659373473935/5SYjVIIUGTeSxeqU6i8GwmUcsdByVJFGEala98-xYqgOszr2wEZZ9tU3Ypz9jAy2j9re",
    NearFullMoon      = "https://ptb.discord.com/api/webhooks/1489972504176099548/Ax0SiWkikITemgrt21lIYbAfvVEp98n0DOxbiqSibPvsZiApiiAscrWT9ZTL5oXaxjjF",
    Boss              = "https://ptb.discord.com/api/webhooks/1489972397867012146/KgWF45FYWCl_Ymij8tSvbVgWO-3z1Sppd53BbXRUUiNgXYB_paP-0CBFMO4IbTC4WWuW",
    Haki              = "https://ptb.discord.com/api/webhooks/1489973503254855814/A617qsd9cKAvZQ6NU5X3ARo5g0DUNw74ZKot2Stp_EsJH5ESPh3jkEP_uXQxZoLAfToe",
    Sword             = "https://ptb.discord.com/api/webhooks/1489973638613696706/j6-LxX8XqxDhOAbzjUk8b-1kov1e6yJ6EATqIdC3VgFxVYqMQn4vp03e93wZ9-Km9vwj",
    Fruit             = "https://ptb.discord.com/api/webhooks/1489973826115600434/lzjBgkBJf_v1eN8WQffPCuiB21HUAj9Dhl78_PKgO209xobvZ3Y0Jhevn6PmMEza4Tfi",
    KitsuneIsland     = "https://ptb.discord.com/api/webhooks/1489973949025489027/XfVkV0NOmFUyWJKPTn73QX78K6uJpwLmN70Fg3x6jzDfX8HZdOSUUuvv43mIfy9RMf4N",
    PrehistoricIsland = "https://ptb.discord.com/api/webhooks/1489974105422823565/0vww7YWpr0MBKyRc9HeCmS3wIPATqA5HbD_pmCHw5T6z4FtOW0yWk2iNc1oewmuA0wrt",
    MirageIsland      = "https://ptb.discord.com/api/webhooks/1489974271991218176/IUd9ZrDhXJvO2VNZkvejqBQQGJuTNf5gTIZ_kWo4w7ViLf6FUALJemTs95Ot7LO_IhCp",
    Berry             = "https://ptb.discord.com/api/webhooks/1489974383437942927/Gcvhc8pBcYRcKR4rRck1uKrm0Hlmbgu0tDT_1VqdWMDjka06m1HpnqEAULOUUq6fTQpE",
    Elites            = "https://ptb.discord.com/api/webhooks/1489974517903392808/p6IyMsPgpytvc0D9nq_cFgbS0X_88K0po8brbQSeLH57KK4blW1DAqytFZf0eIAjCcrG",
    CastleRaid        = "https://ptb.discord.com/api/webhooks/1489974864025485322/gREVMfyINYpvqNxovgxLc-jrZ9IRWTj6LJJPG3PcbQUrfRsiK07ZgnWWswdodqXYArHj",
}

local SHARED_IMAGE = nil
local THUMBNAIL_IMAGE = "https://media.discordapp.net/attachments/1257952994800963647/1490411126628810993/your_name.gif?ex=69d3f507&is=69d2a387&hm=d6ed012f12fbc3164250a9a364a8f3b3a992239c15621b0cf9d2bcd8ee8d75ed&="
local WEBHOOK_ICONS = {
    boss = {title = "💀", name = "Boss Alert"},
    moon = {title = "🌙", name = "Moon Alert"},
    berry = {title = "🫐", name = "Berry Alert"},
    elites = {title = "⚔️", name = "Elite Alert"},
    castleraid = {title = "🏰", name = "Castle Raid"},
    sword = {title = "🗡️", name = "Legendary Sword"},
    fruit = {title = "🍎", name = "Fruit Spawn"},
    fruitdrop = {title = "🍎", name = "Fruit Drop"},
    haki = {title = "⚡", name = "Haki Alert"},
    island = {title = "🏝️", name = "Island Alert"},
}
local worldMap = {}
local World1, World2, World3 = false, false, false
local distbyp, island

local WebhookEnabled = true
local WebhookCooldowns = {}
local WEBHOOK_CD = 10

local function CanNotify(key)
    local now = os.clock()
    if not WebhookCooldowns[key] or (now - WebhookCooldowns[key]) >= WEBHOOK_CD then
        WebhookCooldowns[key] = now
        return true
    end
    return false
end

local function GetWebhookKey(eventType, dataKey)
    if eventType == "moon" then
        return dataKey == "fullmoon" and "FullMoon" or "NearFullMoon"
    elseif eventType == "boss"   then return "Boss"
    elseif eventType == "haki"   then return "Haki"
    elseif eventType == "sword"  then return "Sword"
    elseif eventType == "fruit"  then return "Fruit"
    elseif eventType == "island" then
        if dataKey == "kitsune"      then return "KitsuneIsland"
        elseif dataKey == "prehistoric" or dataKey == "volcano" then return "PrehistoricIsland"
        else return "MirageIsland" end
    elseif eventType == "berry"     then return "Berry"
    elseif eventType == "elites"    then return "Elites"
    elseif eventType == "castleraid" then return "CastleRaid"
    end
    return nil
end

local function GetIslandDistanceFromTiki(dataKey)
    local ws = game:GetService("Workspace")
    local tikiPos = nil
    local function getPosition(obj)
        if not obj then return nil end
        if typeof(obj) == "CFrame" then
            return obj.Position
        end
        if typeof(obj) == "Vector3" then
            return obj
        end
        if obj:IsA("BasePart") then
            return obj.Position
        end
        if obj:IsA("Model") then
            if obj.PrimaryPart then
                return obj.PrimaryPart.Position
            end
            local pivot = obj:GetPivot()
            return pivot.Position
        end
        return nil
    end

    if island and island["Tiki Outpost"] then
        tikiPos = getPosition(island["Tiki Outpost"])
    elseif ws.Map then
        local tikiPart = ws.Map:FindFirstChild("Tiki Outpost") or ws.Map:FindFirstChild("TikiOutpost")
        tikiPos = getPosition(tikiPart)
    end

    if not tikiPos then
        return nil
    end

    local targetPos = nil
    if dataKey == "kitsune" then
        local kitsune = ws.Map and (ws.Map:FindFirstChild("KitsuneIsland") or ws.Map:FindFirstChild("Kitsune Island"))
        targetPos = getPosition(kitsune)
    elseif dataKey == "mirage" then
        local loc = ws:FindFirstChild("_WorldOrigin") and ws._WorldOrigin:FindFirstChild("Locations")
        if loc then
            local mirage = loc:FindFirstChild("Mirage Island")
            targetPos = getPosition(mirage)
        end
    elseif dataKey == "prehistoric" or dataKey == "volcano" then
        local loc = ws:FindFirstChild("_WorldOrigin") and ws._WorldOrigin:FindFirstChild("Locations")
        if loc then
            local prehistoric = loc:FindFirstChild("Prehistoric Island")
            targetPos = getPosition(prehistoric)
        end
        if not targetPos and ws.Map then
            local prehistoricModel = ws.Map:FindFirstChild("PrehistoricIsland")
            targetPos = getPosition(prehistoricModel)
        end
    end

    if targetPos then
        return math.floor((targetPos - tikiPos).Magnitude)
    end
    return nil
end

local function SendNotify(eventType, data)
    if not WebhookEnabled then return end
    local wKey = GetWebhookKey(eventType, data.key or "")
    if not wKey then return end
    local url = WEBHOOKS[wKey]
    if not url or url == "WEBHOOK_URL_HERE" or url == "" then return end
    if not CanNotify(wKey .. "_" .. (data.key or "")) then return end

    local Http        = game:GetService("HttpService")
    local Players     = game:GetService("Players")
    local playerCount = #Players:GetPlayers()
    local maxPlayers  = 12
    local jobId       = tostring(game.JobId)
    local placeId = tostring(game.PlaceId)
    local timeOfDay   = tostring(game:GetService("Lighting").TimeOfDay or "00:00:00")
    local worldNum    = World1 and 1 or World2 and 2 or World3 and 3 or "?"
    local iconMeta    = WEBHOOK_ICONS[eventType] or {title = "📢", name = "Notify"}
    local titleIcon   = data.titleIcon or iconMeta.title
    local authorName  = data.authorName or iconMeta.name

    local fields = {}
    local color  = data.color or 0x00ffff

    if eventType == "boss" then
        fields = {
            {name = "💀 Boss Name :", value = "```" .. (data.name or "?") .. "```", inline = true},
            {name = "👥 Players :",   value = "```" .. playerCount .. "/" .. maxPlayers .. "```", inline = true},
            {name = "🆔 Job-Id :",    value = "```" .. jobId .. "```", inline = false},
            {name = "🗺️ Place-Id :",  value = "```" .. placeId .. "```", inline = false},
            {name = "📜 Script :",    value = '```\ngame:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "' .. jobId .. '")\n```', inline = false},
        }
        color = data.color or 0x00ffff
    elseif eventType == "moon" then
        fields = {
            {name = "🕒 Become Around :", value = "```" .. (data.become or "1 Minute ( s )") .. "```", inline = true},
            {name = "👥 Players :", value = "```" .. playerCount .. "/" .. maxPlayers .. "```", inline = true},
            {name = "🌙 Moon Phase :", value = "```" .. (data.phase or "5/5") .. "```", inline = false},
            {name = "🆔 Job-Id :", value = "```" .. jobId .. "```", inline = false},
            {name = "🗺️ Place-Id :", value = "```" .. placeId .. "```", inline = false},
            {name = "📜 Script :", value = '```\ngame:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "' .. jobId .. '")\n```', inline = false},
        }
        color = data.color or 0x00ffff
    elseif eventType == "berry" then
        fields = {
            {name = "🫐 Berry Type :", value = "```" .. (data.name or "?") .. "```", inline = true},
            {name = "👥 Players :", value = "```" .. playerCount .. "/" .. maxPlayers .. "```", inline = true},
            {name = "🆔 Job-Id :", value = "```" .. jobId .. "```", inline = false},
            {name = "🗺️ Place-Id :", value = "```" .. placeId .. "```", inline = false},
            {name = "📜 Script :", value = '```\ngame:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "' .. jobId .. '")\n```', inline = false},
        }
        color = data.color or 0x00ffff
    elseif eventType == "elites" then
        fields = {
            {name = "⚔️ Elite Name :", value = "```" .. (data.name or "?") .. "```", inline = true},
            {name = "📍 Spawn Position :", value = "```" .. (data.position or "?") .. "```", inline = true},
            {name = "👥 Players :", value = "```" .. playerCount .. "/" .. maxPlayers .. "```", inline = true},
            {name = "🆔 Job-Id :", value = "```" .. jobId .. "```", inline = false},
            {name = "🗺️ Place-Id :", value = "```" .. placeId .. "```", inline = false},
            {name = "📜 Script :", value = '```\ngame:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "' .. jobId .. '")\n```', inline = false},
        }
        color = data.color or 0x00ffff
    elseif eventType == "castleraid" then
        fields = {
            {name = "🏰 Castle Raid :", value = "```" .. (data.name or "Castle Raid Active") .. "```", inline = true},
            {name = "👥 Players :", value = "```" .. playerCount .. "/" .. maxPlayers .. "```", inline = true},
            {name = "🆔 Job-Id :", value = "```" .. jobId .. "```", inline = false},
            {name = "🗺️ Place-Id :", value = "```" .. placeId .. "```", inline = false},
            {name = "📜 Script :", value = '```\ngame:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "' .. jobId .. '")\n```', inline = false},
        }
        color = data.color or 0x00ffff
    elseif eventType == "sword" then
        fields = {
            {name = "🗡️ Legendary Sword :", value = "```" .. (data.name or "?") .. "```", inline = true},
            {name = "🌍 World :", value = "```" .. tostring(worldNum) .. "```", inline = true},
            {name = "👥 Players :", value = "```" .. playerCount .. "/" .. maxPlayers .. "```", inline = true},
            {name = "🆔 Job-Id :", value = "```" .. jobId .. "```", inline = false},
            {name = "🗺️ Place-Id :", value = "```" .. placeId .. "```", inline = false},
            {name = "📜 Script :", value = '```\ngame:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "' .. jobId .. '")\n```', inline = false},
        }
        color = data.color or 0x9B59B6
    elseif eventType == "fruit" then
        fields = {
            {name = "🍎 Fruit :", value = "```" .. (data.name or "?") .. "```", inline = true},
            {name = "🌍 World :", value = "```" .. tostring(worldNum) .. "```", inline = true},
            {name = "👥 Players :", value = "```" .. playerCount .. "/" .. maxPlayers .. "```", inline = true},
            {name = "🆔 Job-Id :", value = "```" .. jobId .. "```", inline = false},
            {name = "🗺️ Place-Id :", value = "```" .. placeId .. "```", inline = false},
            {name = "📜 Script :", value = '```\ngame:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "' .. jobId .. '")\n```', inline = false},
        }
        color = data.color or 0x00ffff
    elseif eventType == "haki" then
        fields = {
            {name = "⚡ Haki :", value = "```" .. (data.name or "Buso Haki V3") .. "```", inline = true},
            {name = "🌍 World :", value = "```" .. tostring(worldNum) .. "```", inline = true},
            {name = "👥 Players :", value = "```" .. playerCount .. "/" .. maxPlayers .. "```", inline = true},
            {name = "🆔 Job-Id :", value = "```" .. jobId .. "```", inline = false},
            {name = "🗺️ Place-Id :", value = "```" .. placeId .. "```", inline = false},
            {name = "📜 Script :", value = '```\ngame:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "' .. jobId .. '")\n```', inline = false},
        }
        color = data.color or 0x8E44AD
    elseif eventType == "island" then
        fields = {
            {name = "🏝️ Island :", value = "```" .. (data.name or "Unknown") .. "```", inline = true},
            {name = "📏 Distance from Tiki :", value = "```" .. ((data.distance and tostring(data.distance) .. " m") or "N/A") .. "```", inline = true},
            {name = "🆔 Job-Id :", value = "```" .. jobId .. "```", inline = false},
            {name = "🗺️ Place-Id :", value = "```" .. placeId .. "```", inline = false},
            {name = "📜 Script :", value = '```\ngame:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "' .. jobId .. '")\n```', inline = false},
        }
        color = data.color or 0x00ffff
    elseif eventType == "fruitdrop" then
        fields = {
            {name = "🍎 Fruit :", value = "```" .. (data.name or "?") .. "```", inline = true},
            {name = "📍 Position :", value = "```" .. (data.position or "?") .. "```", inline = true},
            {name = "👥 Players :", value = "```" .. playerCount .. "/" .. maxPlayers .. "```", inline = true},
            {name = "🆔 Job-Id :", value = "```" .. jobId .. "```", inline = false},
            {name = "🗺️ Place-Id :", value = "```" .. placeId .. "```", inline = false},
            {name = "📜 Script :", value = '```\ngame:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "' .. jobId .. '")\n```', inline = false},
        }
        color = data.color or 0x00ffff
    end

    local embed = {
        title     = titleIcon .. " YOUR NAME NOTIFY BLOX FRUIT",
        color     = color,
        fields    = fields,
        author    = {
            name = authorName,
            icon_url = THUMBNAIL_IMAGE,
        },
        thumbnail = {
            url = THUMBNAIL_IMAGE,
        },
        footer    = {
            text     = "Made by Kien",
            icon_url = THUMBNAIL_IMAGE,
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }

    local payload = Http:JSONEncode({embeds = {embed}})

    task.spawn(function()
        pcall(function()
            local reqFunc = syn and syn.request or (typeof(request) == "function" and request) or (http and http.request) or nil
            if reqFunc then
                reqFunc({
                    Url     = url,
                    Method  = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body    = payload,
                })
            end
        end)
    end)
end

local Icons = {
    ["coins"]     = "rbxassetid://10709811110",
    ["clock"]     = "rbxassetid://10709805144",
    ["heart"]     = "rbxassetid://10723406885",
    ["shield"]    = "rbxassetid://10734951847",
    ["star"]      = "rbxassetid://10734966248",
    ["user"]      = "rbxassetid://10747373176",
    ["target"]    = "rbxassetid://10734977012",
    ["ruler"]     = "rbxassetid://10734941018",
    ["sword"]     = "rbxassetid://10734975486",
    ["swords"]    = "rbxassetid://10734975692",
    ["server"]    = "rbxassetid://10734949856",
    ["trophy"]    = "rbxassetid://10747363809",
    ["search"]    = "rbxassetid://10734943674",
    ["flame"]     = "rbxassetid://10723376114",
    ["cherry"]    = "rbxassetid://10709790875",
    ["crosshair"] = "rbxassetid://10709818534",
    ["activity"]  = "rbxassetid://10709752035",
}

local SkipPlayer
local HopServers

getgenv().hopserver = false
local hopserver = false
local function setHopServer(val)
    hopserver = val
    getgenv().hopserver = val
end

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp_ui = game.Players.LocalPlayer
local TweenService_UI = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YourNameHub_AutoBounty"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 20

local guiVisible = true

local DropShadowHolder = Instance.new("Frame")
DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadowHolder.BackgroundTransparency = 1
DropShadowHolder.Name = "DropShadowHolder"
DropShadowHolder.Parent = ScreenGui
DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadowHolder.Size = UDim2.new(0, 560, 0, 355)
DropShadowHolder.ZIndex = 1

local MainFrame = Instance.new("Frame")
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
MainFrame.BackgroundTransparency = 0
MainFrame.Name = "Main"
MainFrame.Parent = DropShadowHolder
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(50, 50, 60)
MainStroke.Thickness = 1.2
local MainGradient = Instance.new("UIGradient", MainFrame)
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 22)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(34, 34, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(62, 62, 68))
})
MainGradient.Rotation = 135

local Camera = game:GetService("Workspace").CurrentCamera

local BASE_W, BASE_H = 560, 355
local PILL_W, PILL_H = 280, 48
local ToggleContainer, _tcTitle, _tcSub, _tcAvatarLbl, _tcAvatar, _tcIconFrame, _tcIconLbl, _tcAvatarStroke
local AvatarCircle, AvatarLabel, HubTitle, HubSub, HDivider, StatusDot, StatusLbl
local InfoPanel, InfoTitle
local InfoBounty, InfoRace, InfoLevel, InfoHealth, InfoDivider, InfoMelee, InfoFPS, InfoKill
local BountyCard, TimeCard, CardBountyVal, CardTimeVal
local TargetInfoCard, TargetTitle, TargetNameIco, TargetName, TargetLevelIco, TargetLevel
local TargetHealthIco, TargetHealth, TargetDistanceIco, TargetDistance, TargetBtnDivider, SkipBtn, HopBtn
local BotDivider, ExecIcon, ExecStatusLbl, CreditLbl
local CX, CY, CW, CH, GAP = 168, 110, 183, 60, 8
local DEFAULT_UI_POSITION = UDim2.new(0.5, 0, 0.5, 0)
local lastUIPosition = DEFAULT_UI_POSITION

local function isMobile()
    local vp = Camera and Camera.ViewportSize or Vector2.new(800, 600)
    if UserInputService.TouchEnabled then
        return true
    end
    if vp.X <= 900 or vp.Y <= 600 then
        return true
    end
    return false
end

local function calcUISize()
    local vp = Camera.ViewportSize
    local sw, sh = vp.X, vp.Y

    local w, h, pillW, pillH

    if isMobile() then
        w     = math.clamp(sw * 0.92, 320, 500)
        h     = math.clamp(sh * 0.65, 248, 300)
        pillW = math.clamp(sw * 0.68, 200, 280)
        pillH = 44
    else
        local scaleX = math.min(sw / (BASE_W + 40), 1)
        local scaleY = math.min(sh / (BASE_H + 40), 1)
        local scale  = math.min(scaleX, scaleY)
        scale = math.max(scale, 0.55)

        w     = math.floor(BASE_W * scale)
        h     = math.floor(BASE_H * scale)
        pillW = math.floor(PILL_W * math.max(scale, 0.75))
        pillH = math.floor(PILL_H * math.max(scale, 0.85))
    end

    return math.floor(w), math.floor(h), math.floor(pillW), math.floor(pillH)
end

local function ApplyToggleLayout()
    if not ToggleContainer then
        return
    end

    local _, h, pillW, pillH = calcUISize()
    local mobile = isMobile()

    if mobile and guiVisible then
        local vp = Camera.ViewportSize
        local uiW, uiH = calcUISize()
        local top = math.floor((vp.Y - uiH) / 2)
        local left = math.floor((vp.X - uiW) / 2)

        ToggleContainer.AnchorPoint = Vector2.new(1, 0)
        ToggleContainer.Position = UDim2.new(0, left + uiW - 6, 0, math.max(top + 6, 6))
        ToggleContainer.Size = UDim2.new(0, 34, 0, 34)

        if _tcAvatar then _tcAvatar.Visible = false end
        if _tcTitle then _tcTitle.Visible = false end
        if _tcSub then _tcSub.Visible = false end
        if _tcIconFrame then
            _tcIconFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            _tcIconFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            _tcIconFrame.Size = UDim2.new(0, 20, 0, 20)
        end
        if _tcIconLbl then
            _tcIconLbl.TextSize = 8
        end
    else
        ToggleContainer.AnchorPoint = Vector2.new(0.5, 0)
        ToggleContainer.Position = UDim2.new(0.5, 0, 0, 6)
        ToggleContainer.Size = UDim2.new(0, pillW, 0, pillH)

        if _tcAvatar then
            _tcAvatar.Visible = true
            local tRatio = pillH / 48
            local avatarSize = math.floor(38 * tRatio)
            _tcAvatar.Position = UDim2.new(0, 6, 0.5, 0)
            _tcAvatar.Size = UDim2.new(0, avatarSize, 0, avatarSize)
        end
        if _tcTitle then
            _tcTitle.Visible = true
            _tcTitle.TextSize = math.max(math.floor(12 * (pillH / 48)), 8)
            _tcTitle.Position = UDim2.new(0, 52, 0, 6)
            _tcTitle.Size = UDim2.new(1, -86, 0, 20)
        end
        if _tcSub then
            _tcSub.Visible = true
            _tcSub.TextSize = math.max(math.floor(10 * (pillH / 48)), 7)
            _tcSub.Position = UDim2.new(0, 52, 0, 26)
            _tcSub.Size = UDim2.new(1, -86, 0, 14)
        end
        if _tcIconFrame then
            local iconSize = math.floor(28 * (pillH / 48))
            _tcIconFrame.AnchorPoint = Vector2.new(1, 0.5)
            _tcIconFrame.Position = UDim2.new(1, -8, 0.5, 0)
            _tcIconFrame.Size = UDim2.new(0, iconSize, 0, iconSize)
        end
        if _tcIconLbl then
            _tcIconLbl.TextSize = math.max(math.floor(12 * (pillH / 48)), 8)
        end
    end
end

local function ApplyResponsive()
    local w, h, pillW, pillH = calcUISize()
    local mobile = isMobile()
    DropShadowHolder.Size = UDim2.new(0, w, 0, h)
    DropShadowHolder.Position = lastUIPosition or DEFAULT_UI_POSITION

    local scale = w / BASE_W

    ApplyToggleLayout()

    local textScale = scale * 1.1

    if HubTitle then HubTitle.TextSize = mobile and 13 or math.max(math.floor(17 * textScale), 12) end
    if HubSub then HubSub.TextSize = mobile and 9 or math.max(math.floor(10 * textScale), 8) end
    if AvatarLabel then
        AvatarLabel.TextSize = mobile and 14 or math.max(math.floor(26 * textScale), 16)
    end

    if AvatarCircle then
        if mobile then
            AvatarCircle.Position = UDim2.new(0, 10, 0, 22)
            AvatarCircle.Size = UDim2.new(0, 28, 0, 28)
        else
            AvatarCircle.Position = UDim2.new(0, 16, 0, 50)
            AvatarCircle.Size = UDim2.new(0, 62, 0, 62)
        end
    end

    if HubTitle then
        if mobile then
            HubTitle.Position = UDim2.new(0, 44, 0, 10)
            HubTitle.Size = UDim2.new(1, -84, 0, 20)
        else
            HubTitle.Position = UDim2.new(0, 92, 0, 20)
            HubTitle.Size = UDim2.new(0, 340, 0, 26)
        end
    end

    if HubSub then
        if mobile then
            HubSub.Visible = true
            HubSub.Position = UDim2.new(0, 44, 0, 30)
            HubSub.Size = UDim2.new(1, -84, 0, 18)
        else
            HubSub.Visible = true
            HubSub.Position = UDim2.new(0, 92, 0, 48)
            HubSub.Size = UDim2.new(0.62, 0, 0, 30)
        end
    end

    if HDivider then
        HDivider.Position = mobile and UDim2.new(0, 0, 0, 66) or UDim2.new(0, 0, 0, 96)
    end

    if StatusDot then
        StatusDot.Position = mobile and UDim2.new(0, 44, 0, 54) or UDim2.new(0, 92, 0, 80)
        if mobile then StatusDot.Size = UDim2.new(0, 7, 0, 7) else StatusDot.Size = UDim2.new(0, 8, 0, 8) end
    end

    if StatusLbl then
        StatusLbl.Position = mobile and UDim2.new(0, 55, 0, 49) or UDim2.new(0, 106, 0, 78)
        if mobile then StatusLbl.Size = UDim2.new(0, 110, 0, 14) else StatusLbl.Size = UDim2.new(0, 120, 0, 16) end
    end

    if StatusLbl then StatusLbl.TextSize = mobile and 9 or math.max(math.floor(10 * textScale), 8) end

    if InfoTitle then InfoTitle.TextSize = mobile and 9 or math.max(math.floor(12 * textScale), 10) end
    if InfoPanel then
        if mobile then
            InfoPanel.Position = UDim2.new(0, 6, 0, 72)
            InfoPanel.Size = UDim2.new(0, 108, 0, 196)
        else
            InfoPanel.Position = UDim2.new(0, 10, 0, 110)
            InfoPanel.Size = UDim2.new(0, 148, 0, 198)
        end
    end
    if InfoTitle then
        if mobile then
            InfoTitle.Position = UDim2.new(0, 8, 0, 6)
            InfoTitle.Size = UDim2.new(1, -8, 0, 14)
        else
            InfoTitle.Position = UDim2.new(0, 10, 0, 7)
            InfoTitle.Size = UDim2.new(1, -10, 0, 16)
        end
    end
    if mobile then
        local infoRows = {
            {label = InfoBounty, y = 24},
            {label = InfoRace, y = 48},
            {label = InfoLevel, y = 72},
            {label = InfoHealth, y = 96},
            {label = InfoMelee, y = 122},
            {label = InfoFPS, y = 146},
            {label = InfoKill, y = 170},
        }
        for _, rowData in ipairs(infoRows) do
            local row = rowData.label
            if row and row.Parent then
                row.Parent.Position = UDim2.new(0, 8, 0, rowData.y)
                row.Parent.Size = UDim2.new(1, -8, 0, 20)
                row.Position = UDim2.new(0, 18, 0, 0)
                row.Size = UDim2.new(1, -18, 1, 0)
                row.TextSize = 9
                local icon = row.Parent:FindFirstChildOfClass("ImageLabel")
                if icon then
                    icon.Position = UDim2.new(0, 0, 0, 4)
                    icon.Size = UDim2.new(0, 14, 0, 14)
                end
            end
        end
        if InfoDivider then
            InfoDivider.Position = UDim2.new(0, 8, 0, 116)
            InfoDivider.Size = UDim2.new(1, -16, 0, 1)
        end
    else
        local infoRows = {
            {label = InfoBounty, y = 28},
            {label = InfoRace, y = 52},
            {label = InfoLevel, y = 76},
            {label = InfoHealth, y = 100},
            {label = InfoMelee, y = 128},
            {label = InfoFPS, y = 150},
            {label = InfoKill, y = 172},
        }
        for _, rowData in ipairs(infoRows) do
            local row = rowData.label
            if row and row.Parent then
                row.Parent.Position = UDim2.new(0, 10, 0, rowData.y)
                row.Parent.Size = UDim2.new(1, -10, 0, 20)
                row.Position = UDim2.new(0, 20, 0, 0)
                row.Size = UDim2.new(1, -20, 1, 0)
                row.TextSize = 11
                local icon = row.Parent:FindFirstChildOfClass("ImageLabel")
                if icon then
                    icon.Position = UDim2.new(0, 0, 0, 2)
                    icon.Size = UDim2.new(0, 16, 0, 16)
                end
            end
        end
        if InfoDivider then
            InfoDivider.Position = UDim2.new(0, 8, 0, 122)
            InfoDivider.Size = UDim2.new(1, -16, 0, 1)
        end
    end

    local cardScale = scale * 1.05
    if CardBountyVal then CardBountyVal.TextSize = mobile and 14 or math.max(math.floor(16 * cardScale), 12) end
    if CardTimeVal then CardTimeVal.TextSize = mobile and 14 or math.max(math.floor(16 * cardScale), 12) end

    if mobile and BountyCard and TimeCard then
        local infoW = 108
        local layoutGap = 5
        local rightX = infoW + 14
        local availableW = math.max(w - rightX - 8, 150)
        local cardW = math.floor((availableW - layoutGap) / 2)
        local cardH = 70
        local topY = 72

        BountyCard.Position = UDim2.new(0, rightX, 0, topY)
        BountyCard.Size = UDim2.new(0, cardW, 0, cardH)

        TimeCard.Position = UDim2.new(0, rightX + cardW + layoutGap, 0, topY)
        TimeCard.Size = UDim2.new(0, cardW, 0, cardH)
    elseif BountyCard and TimeCard then
        BountyCard.Position = UDim2.new(0, CX, 0, CY)
        BountyCard.Size = UDim2.new(0, CW, 0, CH)

        TimeCard.Position = UDim2.new(0, CX + CW + GAP, 0, CY)
        TimeCard.Size = UDim2.new(0, CW, 0, CH)
    end
    for _, card in ipairs({BountyCard, TimeCard}) do
        if card then
            local icon = card:FindFirstChild("CardIcon")
            local titleLabel = card:FindFirstChild("CardTitle")
            local valueLabel = card:FindFirstChild("CardValue")
            if mobile then
                if icon then
                    icon.Position = UDim2.new(0, 8, 0, 8)
                    icon.Size = UDim2.new(0, 12, 0, 12)
                end
                if titleLabel then
                    titleLabel.Position = UDim2.new(0, 24, 0, 8)
                    titleLabel.Size = UDim2.new(1, -28, 0, 12)
                    titleLabel.TextSize = 9
                    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                end
                if valueLabel then
                    valueLabel.Position = UDim2.new(0, 8, 0, 28)
                    valueLabel.Size = UDim2.new(1, -12, 0, 20)
                    valueLabel.TextSize = 12
                    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
                end
            else
                if icon then
                    icon.Position = UDim2.new(0, 10, 0, 8)
                    icon.Size = UDim2.new(0, 20, 0, 20)
                end
                if titleLabel then
                    titleLabel.Position = UDim2.new(0, 34, 0, 8)
                    titleLabel.Size = UDim2.new(1, -38, 0, 18)
                    titleLabel.TextSize = 11
                end
                if valueLabel then
                    valueLabel.Position = UDim2.new(0, 10, 0, 30)
                    valueLabel.Size = UDim2.new(1, -14, 0, 24)
                    valueLabel.TextSize = 16
                end
            end
        end
    end

    if TargetInfoCard then
        local newCardW = math.floor(CW * 2 + GAP)
        local newCardH = math.floor(132 * scale)

        if mobile then
            local infoW = 108
            local layoutGap = 5
            local rightX = infoW + 14
            local availableW = math.max(w - rightX - 8, 150)
            newCardW = availableW
            newCardH = 104
            local mobileCardTopY = 72
            local mobileCardH = 70
            TargetInfoCard.Position = UDim2.new(0, rightX, 0, mobileCardTopY + mobileCardH + 6)
        else
            TargetInfoCard.Position = UDim2.new(0, CX, 0, CY + CH + GAP)
        end

        TargetInfoCard.Size = UDim2.new(0, newCardW, 0, newCardH)
        local targetHeaderIcon = TargetInfoCard:FindFirstChild("TargetHeaderIcon")
        if targetHeaderIcon then
            if mobile then
                targetHeaderIcon.Position = UDim2.new(0, 6, 0, 8)
                targetHeaderIcon.Size = UDim2.new(0, 12, 0, 12)
            else
                targetHeaderIcon.Position = UDim2.new(0, 10, 0, 8)
                targetHeaderIcon.Size = UDim2.new(0, 20, 0, 20)
            end
        end
        if TargetTitle then
            if mobile then
                TargetTitle.Position = UDim2.new(0, 22, 0, 8)
                TargetTitle.Size = UDim2.new(1, -26, 0, 13)
            else
                TargetTitle.Position = UDim2.new(0, 34, 0, 8)
                TargetTitle.Size = UDim2.new(1, -38, 0, 18)
            end
        end

        if TargetTitle then TargetTitle.TextSize = mobile and 9 or math.max(math.floor(11 * textScale), 9) end

        local infoTextSize = mobile and 9 or math.max(math.floor(10 * textScale), 8)
        if TargetName then TargetName.TextSize = infoTextSize end
        if TargetLevel then TargetLevel.TextSize = infoTextSize end
        if TargetHealth then TargetHealth.TextSize = infoTextSize end
        if TargetDistance then TargetDistance.TextSize = infoTextSize end

        local rowSpacing = math.floor(20 * scale)
        if mobile then
            if TargetNameIco then TargetNameIco.Position = UDim2.new(0, 8, 0, 28); TargetNameIco.Size = UDim2.new(0, 10, 0, 10) end
            if TargetName then TargetName.Position = UDim2.new(0, 21, 0, 26); TargetName.Size = UDim2.new(0.5, -23, 0, 14) end
            if TargetLevelIco then TargetLevelIco.Position = UDim2.new(0.5, 2, 0, 28); TargetLevelIco.Size = UDim2.new(0, 10, 0, 10) end
            if TargetLevel then TargetLevel.Position = UDim2.new(0.5, 15, 0, 26); TargetLevel.Size = UDim2.new(0.5, -18, 0, 14) end
            if TargetHealthIco then TargetHealthIco.Position = UDim2.new(0, 8, 0, 48); TargetHealthIco.Size = UDim2.new(0, 10, 0, 10) end
            if TargetHealth then TargetHealth.Position = UDim2.new(0, 21, 0, 46); TargetHealth.Size = UDim2.new(0.5, -23, 0, 14) end
            if TargetDistanceIco then TargetDistanceIco.Position = UDim2.new(0.5, 2, 0, 48); TargetDistanceIco.Size = UDim2.new(0, 10, 0, 10) end
            if TargetDistance then TargetDistance.Position = UDim2.new(0.5, 15, 0, 46); TargetDistance.Size = UDim2.new(0.5, -18, 0, 14) end
        else
            if TargetNameIco then TargetNameIco.Size = UDim2.new(0, 13, 0, 13) end
            if TargetLevelIco then TargetLevelIco.Size = UDim2.new(0, 13, 0, 13) end
            if TargetHealthIco then TargetHealthIco.Size = UDim2.new(0, 13, 0, 13) end
            if TargetDistanceIco then TargetDistanceIco.Size = UDim2.new(0, 13, 0, 13) end
            if TargetName then TargetName.Size = UDim2.new(0.5, -28, 0, 18) end
            if TargetLevel then TargetLevel.Size = UDim2.new(0.5, -28, 0, 18) end
            if TargetHealth then TargetHealth.Size = UDim2.new(0.5, -28, 0, 18) end
            if TargetDistance then TargetDistance.Size = UDim2.new(0.5, -28, 0, 18) end
        end
        if TargetBtnDivider then
            local newBtnY = mobile and 66 or math.floor(76 * scale)
            TargetBtnDivider.Position = UDim2.new(0, 8, 0, newBtnY)
        end

        if SkipBtn then
            local newBtnY = mobile and 72 or math.floor(82 * scale)
            local newBtnH = mobile and 18 or math.max(math.floor(26 * scale), 20)
            SkipBtn.Position = UDim2.new(0, 8, 0, newBtnY)
            SkipBtn.Size = UDim2.new(0, (newCardW)/2-12, 0, newBtnH)
            SkipBtn.TextSize = mobile and 8 or math.max(math.floor(11 * textScale), 9)
        end

        if HopBtn then
            local newBtnY = mobile and 72 or math.floor(82 * scale)
            local newBtnH = mobile and 18 or math.max(math.floor(26 * scale), 20)
            HopBtn.Position = UDim2.new(0, (newCardW)/2+4, 0, newBtnY)
            HopBtn.Size = UDim2.new(0, (newCardW)/2-12, 0, newBtnH)
            HopBtn.TextSize = mobile and 8 or math.max(math.floor(11 * textScale), 9)
        end
    end

    if ExecStatusLbl then ExecStatusLbl.TextSize = mobile and 9 or math.max(math.floor(9 * textScale), 7) end
    if CreditLbl then CreditLbl.TextSize = mobile and 10 or math.max(math.floor(10 * textScale), 8) end

    if BotDivider then
        local bottomY = mobile and 204 or 314
        BotDivider.Visible = not mobile
        BotDivider.Position = UDim2.new(0, 0, 0, bottomY)
        if ExecIcon then
            ExecIcon.Visible = true
            ExecIcon.Position = mobile and UDim2.new(0, 122, 0, 257) or UDim2.new(0, 12, 0, bottomY + 4)
            ExecIcon.Size = mobile and UDim2.new(0, 10, 0, 10) or UDim2.new(0, 14, 0, 14)
        end
        if ExecStatusLbl then
            ExecStatusLbl.Visible = true
            ExecStatusLbl.Position = mobile and UDim2.new(0, 134, 0, 256) or UDim2.new(0, 34, 0, bottomY + 4)
            ExecStatusLbl.Size = mobile and UDim2.new(0, 70, 0, 12) or UDim2.new(0.56, 0, 0, 14)
        end
        if CreditLbl then
            CreditLbl.Position = mobile and UDim2.new(0, 0, 0, 256) or UDim2.new(0, 0, 0, bottomY + 4)
            CreditLbl.Size = mobile and UDim2.new(1, -10, 0, 12) or UDim2.new(1, -12, 0, 14)
        end
    end
end

ToggleContainer = Instance.new("Frame", ScreenGui)
ToggleContainer.Name = "ToggleUI"
ToggleContainer.AnchorPoint = Vector2.new(0.5, 0)
ToggleContainer.Position = UDim2.new(0.5, 0, 0, 6)
ToggleContainer.Size = UDim2.new(0, 280, 0, 48)
ToggleContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
ToggleContainer.BackgroundTransparency = 0.2
ToggleContainer.BorderSizePixel = 0
ToggleContainer.ZIndex = 200
ToggleContainer.ClipsDescendants = false
Instance.new("UICorner", ToggleContainer).CornerRadius = UDim.new(0, 10)
local _tcStroke = Instance.new("UIStroke", ToggleContainer)
_tcStroke.Color = Color3.fromRGB(55, 55, 65)
_tcStroke.Thickness = 1

_tcAvatar = Instance.new("Frame", ToggleContainer)
_tcAvatar.AnchorPoint = Vector2.new(0, 0.5)
_tcAvatar.Position = UDim2.new(0, 8, 0.5, 0)
_tcAvatar.Size = UDim2.new(0, 32, 0, 32)
_tcAvatar.BackgroundTransparency = 1
_tcAvatar.BorderSizePixel = 0
_tcAvatar.ZIndex = 201
_tcAvatarStroke = Instance.new("UIStroke", _tcAvatar)
_tcAvatarStroke.Enabled = false
_tcAvatarLbl = Instance.new("ImageLabel", _tcAvatar)
_tcAvatarLbl.Size = UDim2.new(1, 0, 1, 0)
_tcAvatarLbl.BackgroundTransparency = 1
_tcAvatarLbl.Image = "rbxassetid://79918815542456"
_tcAvatarLbl.ScaleType = Enum.ScaleType.Fit
_tcAvatarLbl.ZIndex = 202

_tcTitle = Instance.new("TextLabel", ToggleContainer)
_tcTitle.BackgroundTransparency = 1
_tcTitle.Position = UDim2.new(0, 48, 0, 6)
_tcTitle.Size = UDim2.new(1, -80, 0, 20)
_tcTitle.Text = "Your Name Hub Auto Bounty"
_tcTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
_tcTitle.Font = Enum.Font.GothamBold
_tcTitle.TextSize = 12
_tcTitle.TextXAlignment = Enum.TextXAlignment.Left
_tcTitle.ZIndex = 201

_tcSub = Instance.new("TextLabel", ToggleContainer)
_tcSub.BackgroundTransparency = 1
_tcSub.Position = UDim2.new(0, 48, 0, 26)
_tcSub.Size = UDim2.new(1, -80, 0, 14)
_tcSub.Text = "Click to hide UI | Running"
_tcSub.TextColor3 = Color3.fromRGB(120, 120, 140)
_tcSub.Font = Enum.Font.Gotham
_tcSub.TextSize = 10
_tcSub.TextXAlignment = Enum.TextXAlignment.Left
_tcSub.ZIndex = 201

_tcIconFrame = Instance.new("Frame", ToggleContainer)
_tcIconFrame.AnchorPoint = Vector2.new(1, 0.5)
_tcIconFrame.Position = UDim2.new(1, -8, 0.5, 0)
_tcIconFrame.Size = UDim2.new(0, 28, 0, 28)
_tcIconFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
_tcIconFrame.BorderSizePixel = 0
_tcIconFrame.ZIndex = 201
Instance.new("UICorner", _tcIconFrame).CornerRadius = UDim.new(0, 6)
_tcIconLbl = Instance.new("TextLabel", _tcIconFrame)
_tcIconLbl.Size = UDim2.new(1, 0, 1, 0)
_tcIconLbl.BackgroundTransparency = 1
_tcIconLbl.Text = "▼"
_tcIconLbl.TextColor3 = Color3.fromRGB(100, 200, 255)
_tcIconLbl.Font = Enum.Font.GothamBold
_tcIconLbl.TextSize = 12
_tcIconLbl.ZIndex = 202

local ToggleBtn = Instance.new("TextButton", ToggleContainer)
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = ""
ToggleBtn.ZIndex = 203

local _tweenOpen  = TweenInfo.new(0.35, Enum.EasingStyle.Back,  Enum.EasingDirection.Out)
local _tweenClose = TweenInfo.new(0.25, Enum.EasingStyle.Back,  Enum.EasingDirection.In)
local _animating = false

local function OpenUI()
    if _animating then return end
    _animating = true
    guiVisible = true
    if isMobile() then
        lastUIPosition = DEFAULT_UI_POSITION
    end
    DropShadowHolder.Visible = true
    DropShadowHolder.Position = lastUIPosition or DEFAULT_UI_POSITION
    local fullW, fullH = calcUISize()
    ApplyResponsive()
    DropShadowHolder.Size = UDim2.new(0, 1, 0, 1)
    local t = TweenService_UI:Create(DropShadowHolder, _tweenOpen, {
        Size = UDim2.new(0, fullW, 0, fullH)
    })
    t:Play()
    t.Completed:Connect(function()
        ApplyResponsive()
        ApplyToggleLayout()
        DropShadowHolder.Position = lastUIPosition or DEFAULT_UI_POSITION
        _animating = false
    end)
    _tcSub.Text = "Click to hide UI | Running"
    _tcSub.TextColor3 = Color3.fromRGB(120, 120, 140)
    _tcIconLbl.Text = "▼"
    _tcIconLbl.TextColor3 = Color3.fromRGB(100, 200, 255)
    _tcAvatarStroke.Color = Color3.fromRGB(0, 200, 120)
end

local function CloseUI()
    if _animating then return end
    _animating = true
    guiVisible = false
    local t = TweenService_UI:Create(DropShadowHolder, _tweenClose, {
        Size = UDim2.new(0, 1, 0, 1)
    })
    t:Play()
    t.Completed:Connect(function()
        if not guiVisible then
            DropShadowHolder.Visible = false
            local fullW, fullH = calcUISize()
            if isMobile() then
                lastUIPosition = DEFAULT_UI_POSITION
                DropShadowHolder.Position = DEFAULT_UI_POSITION
            end
            DropShadowHolder.Size = UDim2.new(0, fullW, 0, fullH)
            ApplyResponsive()
            ApplyToggleLayout()
        end
        _animating = false
    end)
    _tcSub.Text = "Click to show UI | Hidden"
    _tcSub.TextColor3 = Color3.fromRGB(160, 100, 100)
    _tcIconLbl.Text = "▲"
    _tcIconLbl.TextColor3 = Color3.fromRGB(200, 100, 100)
    _tcAvatarStroke.Color = Color3.fromRGB(160, 80, 80)
end

ToggleBtn.MouseButton1Click:Connect(function()
    if guiVisible then CloseUI() else OpenUI() end
end)

ToggleBtn.MouseEnter:Connect(function()
    TweenService_UI:Create(ToggleContainer, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(28, 28, 36),
        BackgroundTransparency = 0.1
    }):Play()
    TweenService_UI:Create(_tcStroke, TweenInfo.new(0.15), {
        Color = Color3.fromRGB(0, 180, 110)
    }):Play()
end)
ToggleBtn.MouseLeave:Connect(function()
    TweenService_UI:Create(ToggleContainer, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(20, 20, 26),
        BackgroundTransparency = 0.2
    }):Play()
    TweenService_UI:Create(_tcStroke, TweenInfo.new(0.15), {
        Color = Color3.fromRGB(55, 55, 65)
    }):Play()
end)

ApplyResponsive()
ApplyToggleLayout()
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local newW, newH = calcUISize()
    if guiVisible and not _animating then
        TweenService_UI:Create(DropShadowHolder,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint),
            {Size = UDim2.new(0, newW, 0, newH)}
        ):Play()
        DropShadowHolder.Position = lastUIPosition or DEFAULT_UI_POSITION
    end
    ApplyResponsive()
    ApplyToggleLayout()
end)

AvatarCircle = Instance.new("Frame", MainFrame)
AvatarCircle.AnchorPoint = Vector2.new(0, 0.5)
AvatarCircle.Position = UDim2.new(0, 16, 0, 54)
AvatarCircle.Size = UDim2.new(0, 62, 0, 62)
AvatarCircle.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
Instance.new("UICorner", AvatarCircle).CornerRadius = UDim.new(1, 0)
local AvatarStroke = Instance.new("UIStroke", AvatarCircle)
AvatarStroke.Color = Color3.fromRGB(200, 200, 200)
AvatarStroke.Thickness = 2

local HoloGradient = Instance.new("UIGradient", AvatarCircle)
HoloGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 32, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 65, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(32, 32, 40))
})
HoloGradient.Rotation = 45

AvatarLabel = Instance.new("TextLabel", AvatarCircle)
AvatarLabel.Size = UDim2.new(1, 0, 1, 0)
AvatarLabel.BackgroundTransparency = 1
AvatarLabel.Text = "YN"
AvatarLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
AvatarLabel.Font = Enum.Font.GothamBold
AvatarLabel.TextSize = 26

HubTitle = Instance.new("TextLabel", MainFrame)
HubTitle.AnchorPoint = Vector2.new(0, 0)
HubTitle.Position = UDim2.new(0, 92, 0, 20)
HubTitle.Size = UDim2.new(0, 340, 0, 26)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "Your Name Hub Auto Bounty"
HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextSize = 17
HubTitle.TextXAlignment = Enum.TextXAlignment.Left

HubSub = Instance.new("TextLabel", MainFrame)
HubSub.AnchorPoint = Vector2.new(0, 0)
HubSub.Position = UDim2.new(0, 92, 0, 48)
HubSub.Size = UDim2.new(0.62, 0, 0, 30)
HubSub.BackgroundTransparency = 1
HubSub.Text = "Your Name Hub - Auto Farm Bounty. Auto hunt bounty, skip bad targets, hop server when needed."
HubSub.TextColor3 = Color3.fromRGB(155, 155, 165)
HubSub.Font = Enum.Font.Gotham
HubSub.TextSize = 10
HubSub.TextXAlignment = Enum.TextXAlignment.Left
HubSub.TextYAlignment = Enum.TextYAlignment.Top
HubSub.TextWrapped = true

HDivider = Instance.new("Frame", MainFrame)
HDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
HDivider.BorderSizePixel = 0
HDivider.Position = UDim2.new(0, 0, 0, 96)
HDivider.Size = UDim2.new(1, 0, 0, 1)

StatusDot = Instance.new("Frame", MainFrame)
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(0, 92, 0, 80)
StatusDot.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
StatusDot.BorderSizePixel = 0
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

StatusLbl = Instance.new("TextLabel", MainFrame)
StatusLbl.Position = UDim2.new(0, 106, 0, 78)
StatusLbl.Size = UDim2.new(0, 120, 0, 16)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "RUNNING"
StatusLbl.TextColor3 = Color3.fromRGB(0, 220, 100)
StatusLbl.Font = Enum.Font.GothamBold
StatusLbl.TextSize = 10
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left

InfoPanel = Instance.new("Frame", MainFrame)
InfoPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
InfoPanel.BorderSizePixel = 0
InfoPanel.Position = UDim2.new(0, 10, 0, 110)
InfoPanel.Size = UDim2.new(0, 148, 0, 175)
Instance.new("UICorner", InfoPanel).CornerRadius = UDim.new(0, 8)

InfoTitle = Instance.new("TextLabel", InfoPanel)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Position = UDim2.new(0, 10, 0, 7)
InfoTitle.Size = UDim2.new(1, -10, 0, 16)
InfoTitle.Text = "Player Info"
InfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.TextSize = 12
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left

local function MakeInfoRow(parent, yOff, label, color, iconName)
    local frame = Instance.new("Frame", parent)
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0, 10, 0, yOff)
    frame.Size = UDim2.new(1, -10, 0, 20)

    if iconName and Icons[iconName] then
        local icon = Instance.new("ImageLabel", frame)
        icon.BackgroundTransparency = 1
        icon.Position = UDim2.new(0, 0, 0, 2)
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.Image = Icons[iconName]
        icon.ImageColor3 = color or Color3.fromRGB(0, 200, 255)
    end

    local row = Instance.new("TextLabel", frame)
    row.BackgroundTransparency = 1
    row.Position = UDim2.new(0, iconName and 20 or 0, 0, 0)
    row.Size = UDim2.new(1, iconName and -20 or 0, 1, 0)
    row.Text = label
    row.TextColor3 = color or Color3.fromRGB(0, 200, 255)
    row.Font = Enum.Font.GothamBold
    row.TextSize = 11
    row.TextXAlignment = Enum.TextXAlignment.Left
    row.TextYAlignment = Enum.TextYAlignment.Center
    return row
end

InfoBounty  = MakeInfoRow(InfoPanel, 28,  "Bounty: --",     Color3.fromRGB(50, 220, 100), "coins")
InfoRace    = MakeInfoRow(InfoPanel, 52,  "Race: --",       Color3.fromRGB(255, 220, 50), "user")
InfoLevel   = MakeInfoRow(InfoPanel, 76,  "Level: --",      Color3.fromRGB(255, 255, 255), "star")
InfoHealth  = MakeInfoRow(InfoPanel, 100, "Health: 100%",    Color3.fromRGB(255, 80, 80), "heart")

InfoDivider = Instance.new("Frame", InfoPanel)
InfoDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
InfoDivider.BorderSizePixel = 0
InfoDivider.Position = UDim2.new(0, 8, 0, 122)
InfoDivider.Size = UDim2.new(1, -16, 0, 1)

InfoMelee  = MakeInfoRow(InfoPanel, 128, "Ping: --",        Color3.fromRGB(80, 220, 160),  "activity")
InfoFPS    = MakeInfoRow(InfoPanel, 150, "FPS: --",         Color3.fromRGB(100, 200, 255),  "crosshair")
InfoKill   = MakeInfoRow(InfoPanel, 172, "Kills: 0",       Color3.fromRGB(255, 100, 80),   "swords")

InfoPanel.Size = UDim2.new(0, 148, 0, 198)



local function MakeCard(parent, x, y, w, h, accentColor, iconName, titleText, valueText)
    local card = Instance.new("Frame", parent)
    card.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    card.BorderSizePixel = 0
    card.Position = UDim2.new(0, x, 0, y)
    card.Size = UDim2.new(0, w, 0, h)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local iconLbl = Instance.new("ImageLabel", card)
    iconLbl.Name = "CardIcon"
    iconLbl.BackgroundTransparency = 1
    iconLbl.Position = UDim2.new(0, 10, 0, 8)
    iconLbl.Size = UDim2.new(0, 20, 0, 20)
    iconLbl.Image = Icons[iconName] or "rbxassetid://0"
    iconLbl.ImageColor3 = accentColor

    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.Name = "CardTitle"
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 34, 0, 8)
    titleLbl.Size = UDim2.new(1, -38, 0, 18)
    titleLbl.Text = titleText
    titleLbl.TextColor3 = accentColor
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local valueLbl = Instance.new("TextLabel", card)
    valueLbl.Name = "CardValue"
    valueLbl.BackgroundTransparency = 1
    valueLbl.Position = UDim2.new(0, 10, 0, 30)
    valueLbl.Size = UDim2.new(1, -14, 0, 24)
    valueLbl.Text = valueText
    valueLbl.TextColor3 = Color3.fromRGB(235, 235, 235)
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextSize = 16
    valueLbl.TextXAlignment = Enum.TextXAlignment.Left

    return card, valueLbl
end

CX = 168
CY = 110
CW = 183
CH = 60
GAP = 8

BountyCard, CardBountyVal = MakeCard(MainFrame, CX,        CY,           CW, CH, Color3.fromRGB(50, 210, 100), "coins", "Bounty Earned", "0")
TimeCard, CardTimeVal   = MakeCard(MainFrame, CX+CW+GAP, CY,           CW, CH, Color3.fromRGB(255, 195, 0),  "clock", "Time Elapsed",  "0H 0M 0S")

TargetInfoCard = Instance.new("Frame", MainFrame)
TargetInfoCard.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
TargetInfoCard.BorderSizePixel = 0
TargetInfoCard.Position = UDim2.new(0, CX, 0, CY+CH+GAP)
TargetInfoCard.Size = UDim2.new(0, CW*2+GAP, 0, 132)
Instance.new("UICorner", TargetInfoCard).CornerRadius = UDim.new(0, 8)

local TargetIcon = Instance.new("ImageLabel", TargetInfoCard)
TargetIcon.Name = "TargetHeaderIcon"
TargetIcon.BackgroundTransparency = 1
TargetIcon.Position = UDim2.new(0, 10, 0, 8)
TargetIcon.Size = UDim2.new(0, 20, 0, 20)
TargetIcon.Image = Icons["target"]
TargetIcon.ImageColor3 = Color3.fromRGB(80, 160, 255)

TargetTitle = Instance.new("TextLabel", TargetInfoCard)
TargetTitle.BackgroundTransparency = 1
TargetTitle.Position = UDim2.new(0, 34, 0, 8)
TargetTitle.Size = UDim2.new(1, -38, 0, 18)
TargetTitle.Text = "Target Info"
TargetTitle.TextColor3 = Color3.fromRGB(80, 160, 255)
TargetTitle.Font = Enum.Font.GothamBold
TargetTitle.TextSize = 11
TargetTitle.TextXAlignment = Enum.TextXAlignment.Left

TargetNameIco = Instance.new("ImageLabel", TargetInfoCard)
TargetNameIco.BackgroundTransparency = 1
TargetNameIco.Position = UDim2.new(0, 10, 0, 32)
TargetNameIco.Size = UDim2.new(0, 13, 0, 13)
TargetNameIco.Image = Icons["user"]
TargetNameIco.ImageColor3 = Color3.fromRGB(100, 200, 255)
TargetNameIco.Active = false
TargetName = Instance.new("TextLabel", TargetInfoCard)
TargetName.BackgroundTransparency = 1
TargetName.Position = UDim2.new(0, 26, 0, 30)
TargetName.Size = UDim2.new(0.5, -28, 0, 18)
TargetName.Text = "Name: --"
TargetName.TextColor3 = Color3.fromRGB(200, 220, 255)
TargetName.Font = Enum.Font.GothamBold
TargetName.TextSize = 10
TargetName.TextXAlignment = Enum.TextXAlignment.Left

TargetLevelIco = Instance.new("ImageLabel", TargetInfoCard)
TargetLevelIco.BackgroundTransparency = 1
TargetLevelIco.Position = UDim2.new(0.5, 2, 0, 32)
TargetLevelIco.Size = UDim2.new(0, 13, 0, 13)
TargetLevelIco.Image = Icons["star"]
TargetLevelIco.ImageColor3 = Color3.fromRGB(255, 210, 0)
TargetLevelIco.Active = false
TargetLevel = Instance.new("TextLabel", TargetInfoCard)
TargetLevel.BackgroundTransparency = 1
TargetLevel.Position = UDim2.new(0.5, 18, 0, 30)
TargetLevel.Size = UDim2.new(0.5, -28, 0, 18)
TargetLevel.Text = "Level: --"
TargetLevel.TextColor3 = Color3.fromRGB(255, 230, 120)
TargetLevel.Font = Enum.Font.GothamBold
TargetLevel.TextSize = 10
TargetLevel.TextXAlignment = Enum.TextXAlignment.Left

TargetHealthIco = Instance.new("ImageLabel", TargetInfoCard)
TargetHealthIco.BackgroundTransparency = 1
TargetHealthIco.Position = UDim2.new(0, 10, 0, 52)
TargetHealthIco.Size = UDim2.new(0, 13, 0, 13)
TargetHealthIco.Image = Icons["heart"]
TargetHealthIco.ImageColor3 = Color3.fromRGB(255, 80, 100)
TargetHealthIco.Active = false
TargetHealth = Instance.new("TextLabel", TargetInfoCard)
TargetHealth.BackgroundTransparency = 1
TargetHealth.Position = UDim2.new(0, 26, 0, 50)
TargetHealth.Size = UDim2.new(0.5, -28, 0, 18)
TargetHealth.Text = "Health: --"
TargetHealth.TextColor3 = Color3.fromRGB(255, 150, 160)
TargetHealth.Font = Enum.Font.GothamBold
TargetHealth.TextSize = 10
TargetHealth.TextXAlignment = Enum.TextXAlignment.Left

TargetDistanceIco = Instance.new("ImageLabel", TargetInfoCard)
TargetDistanceIco.BackgroundTransparency = 1
TargetDistanceIco.Position = UDim2.new(0.5, 2, 0, 52)
TargetDistanceIco.Size = UDim2.new(0, 13, 0, 13)
TargetDistanceIco.Image = Icons["ruler"]
TargetDistanceIco.ImageColor3 = Color3.fromRGB(120, 120, 135)
TargetDistanceIco.Active = false
TargetDistance = Instance.new("TextLabel", TargetInfoCard)
TargetDistance.BackgroundTransparency = 1
TargetDistance.Position = UDim2.new(0.5, 18, 0, 50)
TargetDistance.Size = UDim2.new(0.5, -28, 0, 18)
TargetDistance.Text = "Distance: --"
TargetDistance.TextColor3 = Color3.fromRGB(180, 180, 200)
TargetDistance.Font = Enum.Font.GothamBold
TargetDistance.TextSize = 10
TargetDistance.TextXAlignment = Enum.TextXAlignment.Left

BotDivider = Instance.new("Frame", MainFrame)
BotDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
BotDivider.BorderSizePixel = 0
BotDivider.Position = UDim2.new(0, 0, 0, 314)
BotDivider.Size = UDim2.new(1, 0, 0, 1)

ExecIcon = Instance.new("ImageLabel", MainFrame)
ExecIcon.BackgroundTransparency = 1
ExecIcon.Position = UDim2.new(0, 12, 0, 318)
ExecIcon.Size = UDim2.new(0, 14, 0, 14)
ExecIcon.Image = Icons["activity"]
ExecIcon.ImageColor3 = Color3.fromRGB(100, 180, 255)

ExecStatusLbl = Instance.new("TextLabel", MainFrame)
ExecStatusLbl.BackgroundTransparency = 1
ExecStatusLbl.Position = UDim2.new(0, 34, 0, 318)
ExecStatusLbl.Size = UDim2.new(0.56, 0, 0, 14)
ExecStatusLbl.Text = "Executor: Loading..."
ExecStatusLbl.TextColor3 = Color3.fromRGB(90, 90, 105)
ExecStatusLbl.Font = Enum.Font.Gotham
ExecStatusLbl.TextSize = 9
ExecStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

CreditLbl = Instance.new("TextLabel", MainFrame)
CreditLbl.BackgroundTransparency = 1
CreditLbl.Position = UDim2.new(0, 0, 0, 318)
CreditLbl.Size = UDim2.new(1, -12, 0, 14)
CreditLbl.Text = "Your Name Hub"
CreditLbl.TextColor3 = Color3.fromRGB(0, 255, 255)
CreditLbl.Font = Enum.Font.Gotham
CreditLbl.TextSize = 10
CreditLbl.TextXAlignment = Enum.TextXAlignment.Right

local CreditStroke = Instance.new("UIStroke", CreditLbl)
CreditStroke.Color = Color3.fromRGB(0, 200, 255)
CreditStroke.Thickness = 0.5

local HopNotifyFrame = Instance.new("Frame", ScreenGui)
HopNotifyFrame.Name = "HopNotify"
HopNotifyFrame.AnchorPoint = Vector2.new(1, 1)
HopNotifyFrame.Position = UDim2.new(1, 20, 1, -16)
HopNotifyFrame.Size = UDim2.new(0, 300, 0, 80)
HopNotifyFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
HopNotifyFrame.BorderSizePixel = 0
HopNotifyFrame.ZIndex = 50
HopNotifyFrame.Visible = false
Instance.new("UICorner", HopNotifyFrame).CornerRadius = UDim.new(0, 12)
local HopNotifyStroke = Instance.new("UIStroke", HopNotifyFrame)
HopNotifyStroke.Color = Color3.fromRGB(140, 60, 240)
HopNotifyStroke.Thickness = 1.8

local HopNotifyGrad = Instance.new("UIGradient", HopNotifyFrame)
HopNotifyGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 18, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 30)),
})
HopNotifyGrad.Rotation = 90

local HopNotifyIcon = Instance.new("ImageLabel", HopNotifyFrame)
HopNotifyIcon.BackgroundTransparency = 1
HopNotifyIcon.Position = UDim2.new(0, 14, 0.5, -14)
HopNotifyIcon.Size = UDim2.new(0, 28, 0, 28)
HopNotifyIcon.Image = "rbxassetid://10734953451"
HopNotifyIcon.ImageColor3 = Color3.fromRGB(160, 80, 255)
HopNotifyIcon.ZIndex = 51

local HopNotifyTitle = Instance.new("TextLabel", HopNotifyFrame)
HopNotifyTitle.BackgroundTransparency = 1
HopNotifyTitle.Position = UDim2.new(0, 52, 0, 10)
HopNotifyTitle.Size = UDim2.new(1, -100, 0, 22)
HopNotifyTitle.Text = "HOPPING SERVER"
HopNotifyTitle.TextColor3 = Color3.fromRGB(200, 140, 255)
HopNotifyTitle.Font = Enum.Font.GothamBold
HopNotifyTitle.TextSize = 13
HopNotifyTitle.TextXAlignment = Enum.TextXAlignment.Left
HopNotifyTitle.ZIndex = 51

local HopNotifySub = Instance.new("TextLabel", HopNotifyFrame)
HopNotifySub.BackgroundTransparency = 1
HopNotifySub.Position = UDim2.new(0, 52, 0, 32)
HopNotifySub.Size = UDim2.new(1, -60, 0, 16)
HopNotifySub.Text = "Finding better server..."
HopNotifySub.TextColor3 = Color3.fromRGB(160, 160, 180)
HopNotifySub.Font = Enum.Font.Gotham
HopNotifySub.TextSize = 10
HopNotifySub.TextXAlignment = Enum.TextXAlignment.Left
HopNotifySub.ZIndex = 51

local HopCountBadge = Instance.new("Frame", HopNotifyFrame)
HopCountBadge.BackgroundColor3 = Color3.fromRGB(140, 60, 240)
HopCountBadge.BorderSizePixel = 0
HopCountBadge.Position = UDim2.new(1, -52, 0.5, -16)
HopCountBadge.Size = UDim2.new(0, 38, 0, 32)
HopCountBadge.ZIndex = 51
Instance.new("UICorner", HopCountBadge).CornerRadius = UDim.new(0, 8)
local HopCountLbl = Instance.new("TextLabel", HopCountBadge)
HopCountLbl.BackgroundTransparency = 1
HopCountLbl.Size = UDim2.new(1, 0, 1, 0)
HopCountLbl.Text = "3"
HopCountLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
HopCountLbl.Font = Enum.Font.GothamBold
HopCountLbl.TextSize = 16
HopCountLbl.ZIndex = 52

local HopProgressBg = Instance.new("Frame", HopNotifyFrame)
HopProgressBg.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
HopProgressBg.BorderSizePixel = 0
HopProgressBg.Position = UDim2.new(0, 14, 1, -10)
HopProgressBg.Size = UDim2.new(1, -28, 0, 4)
HopProgressBg.ZIndex = 51
Instance.new("UICorner", HopProgressBg).CornerRadius = UDim.new(1, 0)
local HopProgressBar = Instance.new("Frame", HopProgressBg)
HopProgressBar.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
HopProgressBar.BorderSizePixel = 0
HopProgressBar.Position = UDim2.new(0, 0, 0, 0)
HopProgressBar.Size = UDim2.new(1, 0, 1, 0)
HopProgressBar.ZIndex = 52
Instance.new("UICorner", HopProgressBar).CornerRadius = UDim.new(1, 0)

local _hopNotifyThread = nil
local _hopNotifyToken = 0

local function ResolveHopNotifyTitle(reason, providedTitle)
    if providedTitle and providedTitle ~= "" then
        return providedTitle
    end

    local lowered = string.lower(tostring(reason or ""))
    if lowered:find("pvp") or lowered:find("combat") then
        return "WAITING FOR PVP"
    end
    if lowered:find("teleport failed") or lowered:find("retry") then
        return "RETRYING HOP"
    end
    if lowered:find("no target") or lowered:find("no valid") then
        return "NO TARGETS FOUND"
    end
    return "HOPPING SERVER"
end

local function HideHopNotify(immediate)
    _hopNotifyToken = _hopNotifyToken + 1
    if _hopNotifyThread then
        task.cancel(_hopNotifyThread)
        _hopNotifyThread = nil
    end

    HopCountBadge.BackgroundColor3 = Color3.fromRGB(140, 60, 240)
    HopProgressBar.Size = UDim2.new(1, 0, 1, 0)

    if immediate or not HopNotifyFrame.Visible then
        HopNotifyFrame.Visible = false
        HopNotifyFrame.Position = UDim2.new(1, 20, 1, -16)
        return
    end

    local token = _hopNotifyToken
    TweenService_UI:Create(HopNotifyFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 20, 1, -16)
    }):Play()

    _hopNotifyThread = task.spawn(function()
        task.wait(0.3)
        if token ~= _hopNotifyToken then
            return
        end
        HopNotifyFrame.Visible = false
        _hopNotifyThread = nil
    end)
end

local function ShowHopNotify(reason, countdown, options)
    options = options or {}
    reason = reason or "Finding better server..."
    countdown = tonumber(countdown)

    local token = _hopNotifyToken + 1
    _hopNotifyToken = token

    if _hopNotifyThread then
        task.cancel(_hopNotifyThread)
        _hopNotifyThread = nil
    end

    HopNotifyTitle.Text = ResolveHopNotifyTitle(reason, options.title)
    HopNotifySub.Text = reason
    HopCountBadge.BackgroundColor3 = Color3.fromRGB(140, 60, 240)
    HopProgressBar.Size = UDim2.new(1, 0, 1, 0)
    HopNotifyFrame.Visible = true
    HopNotifyFrame.Position = UDim2.new(1, 20, 1, -16)
    TweenService_UI:Create(HopNotifyFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -16, 1, -16)
    }):Play()

    if not countdown or countdown <= 0 or options.persist then
        HopCountLbl.Text = "..."
        return
    end

    HopCountLbl.Text = tostring(countdown)
    _hopNotifyThread = task.spawn(function()
        local total = math.max(countdown, 1)
        for i = countdown, 1, -1 do
            if token ~= _hopNotifyToken then
                return
            end

            HopCountLbl.Text = tostring(i)
            TweenService_UI:Create(HopProgressBar, TweenInfo.new(1, Enum.EasingStyle.Linear), {
                Size = UDim2.new((i - 1) / total, 0, 1, 0)
            }):Play()
            TweenService_UI:Create(HopCountBadge, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
                BackgroundColor3 = Color3.fromRGB(200, 100, 255)
            }):Play()
            task.wait(1)
        end

        if token ~= _hopNotifyToken then
            return
        end

        HopCountLbl.Text = "GO!"
        HopCountBadge.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        task.wait(0.5)
        if token ~= _hopNotifyToken then
            return
        end
        HideHopNotify()
    end)
end

local EmptyNotifyFrame = Instance.new("Frame", ScreenGui)
EmptyNotifyFrame.Name = "EmptyServerNotify"
EmptyNotifyFrame.AnchorPoint = Vector2.new(0.5, 1)
EmptyNotifyFrame.Position = UDim2.new(0.5, 0, 1.2, 0)
EmptyNotifyFrame.Size = UDim2.new(0, 320, 0, 72)
EmptyNotifyFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
EmptyNotifyFrame.BorderSizePixel = 0
EmptyNotifyFrame.ZIndex = 60
EmptyNotifyFrame.Visible = false
Instance.new("UICorner", EmptyNotifyFrame).CornerRadius = UDim.new(0, 12)
local _esStroke = Instance.new("UIStroke", EmptyNotifyFrame)
_esStroke.Color = Color3.fromRGB(255, 140, 0)
_esStroke.Thickness = 1.8

local _esGrad = Instance.new("UIGradient", EmptyNotifyFrame)
_esGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 25, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 24)),
})
_esGrad.Rotation = 90

local _esIcon = Instance.new("TextLabel", EmptyNotifyFrame)
_esIcon.BackgroundTransparency = 1
_esIcon.Position = UDim2.new(0, 12, 0.5, -16)
_esIcon.Size = UDim2.new(0, 32, 0, 32)
_esIcon.Text = "!"
_esIcon.TextScaled = true
_esIcon.ZIndex = 61

local _esTitle = Instance.new("TextLabel", EmptyNotifyFrame)
_esTitle.BackgroundTransparency = 1
_esTitle.Position = UDim2.new(0, 52, 0, 8)
_esTitle.Size = UDim2.new(1, -60, 0, 22)
_esTitle.Text = "SERVER EMPTY"
_esTitle.TextColor3 = Color3.fromRGB(255, 160, 30)
_esTitle.Font = Enum.Font.GothamBold
_esTitle.TextSize = 13
_esTitle.TextXAlignment = Enum.TextXAlignment.Left
_esTitle.ZIndex = 61

local _esSub = Instance.new("TextLabel", EmptyNotifyFrame)
_esSub.BackgroundTransparency = 1
_esSub.Position = UDim2.new(0, 52, 0, 32)
_esSub.Size = UDim2.new(1, -60, 0, 16)
_esSub.Text = "Switching server..."
_esSub.TextColor3 = Color3.fromRGB(200, 160, 100)
_esSub.Font = Enum.Font.Gotham
_esSub.TextSize = 10
_esSub.TextXAlignment = Enum.TextXAlignment.Left
_esSub.ZIndex = 61

local _esPingBg = Instance.new("Frame", EmptyNotifyFrame)
_esPingBg.BackgroundColor3 = Color3.fromRGB(40, 25, 10)
_esPingBg.BorderSizePixel = 0
_esPingBg.Position = UDim2.new(0, 12, 1, -8)
_esPingBg.Size = UDim2.new(1, -24, 0, 4)
_esPingBg.ZIndex = 61
Instance.new("UICorner", _esPingBg).CornerRadius = UDim.new(1, 0)
local _esBar = Instance.new("Frame", _esPingBg)
_esBar.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
_esBar.BorderSizePixel = 0
_esBar.Position = UDim2.new(0, 0, 0, 0)
_esBar.Size = UDim2.new(1, 0, 1, 0)
_esBar.ZIndex = 62
Instance.new("UICorner", _esBar).CornerRadius = UDim.new(1, 0)

local _emptyNotifyShowing = false
local function ShowEmptyServerNotify(reason, countdown)
    if _emptyNotifyShowing then return end
    _emptyNotifyShowing = true
    reason = reason or "Switching server..."
    countdown = countdown or 5
    _esSub.Text = reason
    _esBar.Size = UDim2.new(1, 0, 1, 0)
    EmptyNotifyFrame.Visible = true
    EmptyNotifyFrame.Position = UDim2.new(0.5, 0, 1.2, 0)
    TweenService_UI:Create(EmptyNotifyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.96, 0)
    }):Play()
    task.spawn(function()
        for i = countdown, 1, -1 do
            _esSub.Text = reason .. " (" .. i .. "s)"
            TweenService_UI:Create(_esBar, TweenInfo.new(1, Enum.EasingStyle.Linear), {
                Size = UDim2.new((i-1)/countdown, 0, 1, 0)
            }):Play()
            task.wait(1)
        end
        TweenService_UI:Create(EmptyNotifyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 1.2, 0)
        }):Play()
        task.wait(0.35)
        EmptyNotifyFrame.Visible = false
        _emptyNotifyShowing = false
    end)
end

local function MakeBtn(parent, x, y, w, text, bgColor)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = bgColor or Color3.fromRGB(30, 30, 40)
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0, x, 0, y)
    btn.Size = UDim2.new(0, w, 0, 28)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

TargetBtnDivider = Instance.new("Frame", TargetInfoCard)
TargetBtnDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TargetBtnDivider.BorderSizePixel = 0
TargetBtnDivider.Position = UDim2.new(0, 8, 0, 88)
TargetBtnDivider.Size = UDim2.new(1, -16, 0, 1)

SkipBtn = MakeBtn(TargetInfoCard, 8,      96, (CW*2+GAP)/2-12, "   SKIP PLAYER", Color3.fromRGB(20, 50, 70))
HopBtn  = MakeBtn(TargetInfoCard, (CW*2+GAP)/2+4, 96, (CW*2+GAP)/2-12, "   HOP SERVER",  Color3.fromRGB(40, 20, 65))

local SkipBtnIcon = Instance.new("ImageLabel", SkipBtn)
SkipBtnIcon.BackgroundTransparency = 1
SkipBtnIcon.Position = UDim2.new(0, 8, 0.5, -8)
SkipBtnIcon.Size = UDim2.new(0, 16, 0, 16)
SkipBtnIcon.Image = "rbxassetid://10734961809"
SkipBtnIcon.ImageColor3 = Color3.fromRGB(0, 200, 255)
SkipBtnIcon.ZIndex = SkipBtn.ZIndex + 1
SkipBtnIcon.Active = false

local HopBtnIcon = Instance.new("ImageLabel", HopBtn)
HopBtnIcon.BackgroundTransparency = 1
HopBtnIcon.Position = UDim2.new(0, 8, 0.5, -8)
HopBtnIcon.Size = UDim2.new(0, 16, 0, 16)
HopBtnIcon.Image = "rbxassetid://10734953451"
HopBtnIcon.ImageColor3 = Color3.fromRGB(180, 100, 255)
HopBtnIcon.ZIndex = HopBtn.ZIndex + 1
HopBtnIcon.Active = false

local function AddBtnStroke(btn, color)
    local s = Instance.new("UIStroke", btn)
    s.Color = color; s.Thickness = 1.2
end
AddBtnStroke(SkipBtn, Color3.fromRGB(0, 160, 255))
AddBtnStroke(HopBtn,  Color3.fromRGB(140, 60, 240))

ApplyResponsive()
ApplyToggleLayout()

local dragging, dragInput, dragStart, startPos
local function update(input)
    if isMobile() then return end
    local delta = input.Position - dragStart
    DropShadowHolder.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    lastUIPosition = DropShadowHolder.Position
end
MainFrame.InputBegan:Connect(function(input)
    if isMobile() then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = DropShadowHolder.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if isMobile() then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if isMobile() then return end
    if input == dragInput and dragging then update(input) end
end)

HopBtn.MouseButton1Click:Connect(function()
    if hopserver then
        return
    end
    HopBtn.Text = "   HOPPING..."
    setHopServer(true)
    stopbypass = true
    SafeHop()
    task.spawn(function()
        while hopserver do
            task.wait(0.2)
        end
        HopBtn.Text = "   HOP SERVER"
    end)
end)
local _skipBtnCooldown = false
SkipBtn.MouseButton1Click:Connect(function()
    if _skipBtnCooldown then return end
    _skipBtnCooldown = true
    SkipBtn.Text = "   SKIPPING..."
    if SkipPlayer then SkipPlayer() end
    task.delay(1, function()
        SkipBtn.Text = "   SKIP PLAYER"
        _skipBtnCooldown = false
    end)
end)

local uiStartTime = os.time()
local initialBounty = nil
local lastTrackedBounty = nil
local lastEarnedBounty = 0
local totalKills = 0

local BountyLbl = CardBountyVal
local TimeLbl   = CardTimeVal

task.spawn(function()
    task.wait(3)
    if lp_ui and lp_ui:FindFirstChild("leaderstats") and lp_ui.leaderstats:FindFirstChild("Bounty/Honor") then
        initialBounty = lp_ui.leaderstats["Bounty/Honor"].Value
        lastTrackedBounty = initialBounty
        lastEarnedBounty = 0
    end
    ExecStatusLbl.Text = "Executor: " .. ((identifyexecutor and identifyexecutor()) or "Unknown")
end)

task.spawn(function()
    local function bindBountyTracker()
        local leaderstats = lp_ui and lp_ui:FindFirstChild("leaderstats")
        local bountyStat = leaderstats and leaderstats:FindFirstChild("Bounty/Honor")
        if not bountyStat then
            return false
        end

        initialBounty = initialBounty or bountyStat.Value
        lastTrackedBounty = bountyStat.Value
        lastEarnedBounty = math.max(0, bountyStat.Value - initialBounty)

        bountyStat:GetPropertyChangedSignal("Value"):Connect(function()
            local newValue = bountyStat.Value
            local oldValue = lastTrackedBounty
            local earnedNow = initialBounty and math.max(0, newValue - initialBounty) or 0
            local earnedDelta = earnedNow - (lastEarnedBounty or 0)

            if oldValue ~= nil and newValue > oldValue and earnedDelta > 0 then
                getgenv()._killCount = (getgenv()._killCount or 0) + 1

                local targetName = "Unknown"
                pcall(function()
                    if getgenv().targ and getgenv().targ.Name then
                        targetName = getgenv().targ.Name
                    elseif getgenv().killed and getgenv().killed.Name then
                        targetName = getgenv().killed.Name
                    end
                end)

                print("Bounty earned increased: +" .. tostring(earnedDelta) .. " | Total Kills: " .. tostring(getgenv()._killCount))
                sendKillWebhook(targetName, earnedDelta, newValue)
            end

            lastTrackedBounty = newValue
            lastEarnedBounty = earnedNow
        end)

        return true
    end

    while not bindBountyTracker() do
        task.wait(1)
    end
end)

local function FormatNum(n)
    if n >= 1e9 then return string.format("%.1fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.1fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n/1e3)
    else return tostring(n) end
end

RunService.RenderStepped:Connect(function(dt)
    pcall(function()
        if lp_ui and lp_ui:FindFirstChild("leaderstats") and lp_ui.leaderstats:FindFirstChild("Bounty/Honor") and initialBounty then
            local earned = lp_ui.leaderstats["Bounty/Honor"].Value - initialBounty
            CardBountyVal.Text = FormatNum(math.max(0, earned))
        end
        local diff = os.time() - uiStartTime
        local h = math.floor(diff/3600)
        local m = math.floor((diff%3600)/60)
        local s = diff%60
        CardTimeVal.Text = string.format("%dH %dM %dS", h, m, s)
        if lp_ui and lp_ui.Character then
            local char = lp_ui.Character
            if lp_ui:FindFirstChild("leaderstats") and lp_ui.leaderstats:FindFirstChild("Bounty/Honor") then
                InfoBounty.Text = "Bounty: " .. FormatNum(lp_ui.leaderstats["Bounty/Honor"].Value)
            end
            if lp_ui:FindFirstChild("Data") and lp_ui.Data:FindFirstChild("Race") then
                InfoRace.Text = "Race: " .. tostring(lp_ui.Data.Race.Value)
            end
            if lp_ui:FindFirstChild("Data") and lp_ui.Data:FindFirstChild("Level") then
                InfoLevel.Text = "Level: " .. tostring(lp_ui.Data.Level.Value) .. " (Max)"
            end
            if char:FindFirstChild("Humanoid") then
                local hp = math.floor(char.Humanoid.Health / char.Humanoid.MaxHealth * 100)
                InfoHealth.Text = "Health: " .. hp .. "%"
                InfoHealth.TextColor3 = hp > 50 and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(255, 40, 40)
            end
            local pingInt = 0
            pcall(function()
                pingInt = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            InfoMelee.Text = "Ping: " .. tostring(pingInt) .. "ms"
            InfoMelee.TextColor3 = pingInt <= 80 and Color3.fromRGB(80, 220, 160) or pingInt <= 150 and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(255, 80, 80)
            local fps = dt > 0 and math.floor(1 / dt + 0.5) or 0
            InfoFPS.Text = "FPS: " .. tostring(fps)
            InfoFPS.TextColor3 = fps >= 50 and Color3.fromRGB(100, 200, 255) or fps >= 30 and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(255, 80, 80)
            local kc = getgenv()._killCount or 0
            InfoKill.Text = "Kills: " .. tostring(kc)
        end
        local targ = getgenv().targ
        if targ and targ.Character and targ.Character:FindFirstChild("HumanoidRootPart") then
            local targTeam = targ.Team and tostring(targ.Team) or "?"
            local targHP = ""
            local targLevel = "--"
            local targRace = "--"

            if targ.Character:FindFirstChild("Humanoid") then
                targHP = math.floor(targ.Character.Humanoid.Health) .. "hp"
            end

            if targ:FindFirstChild("Data") then
                if targ.Data:FindFirstChild("Level") then
                    targLevel = tostring(targ.Data.Level.Value)
                end
                if targ.Data:FindFirstChild("Race") then
                    targRace = tostring(targ.Data.Race.Value)
                end
            end

            TargetName.Text = "Name: " .. targ.Name
            TargetLevel.Text = "Level: " .. targLevel
            TargetHealth.Text = "Health: " .. targHP
            TargetDistance.Text = "Distance: --"

            local myRoot = lp_ui.Character and lp_ui.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local dist = math.floor((myRoot.Position - targ.Character.HumanoidRootPart.Position).Magnitude)
                TargetDistance.Text = "Distance: " .. dist .. " m"
                TargetDistance.TextColor3 = dist < 50 and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(180, 180, 200)
            end
        else
            TargetName.Text = "Name: --"
            TargetLevel.Text = "Level: --"
            TargetHealth.Text = "Health: --"
            TargetDistance.Text = "Distance: --"
            TargetDistance.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
        if hopserver then
            StatusDot.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
            StatusLbl.Text = "HOPPING"
            StatusLbl.TextColor3 = Color3.fromRGB(255, 140, 0)
        else
            StatusDot.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
            StatusLbl.Text = "RUNNING"
            StatusLbl.TextColor3 = Color3.fromRGB(0, 220, 100)
        end
    end)
end)

worldMap = {[2753915549] = "World1",[4442272183] = "World2",[7449423635] = "World3"}
World1, World2, World3 = false, false, false
if worldMap[game.PlaceId] then
    local world = worldMap[game.PlaceId]
    if world == "World1" then World1 = true
    elseif world == "World2" then World2 = true
    elseif world == "World3" then World3 = true
    end
end

task.spawn(function()
    task.wait(6)
    pcall(function()
        if getgenv().Setting.Another.AutoRandomFruitOnJoin then
            local result = ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            print("Auto Random Fruit on join: " .. tostring(result or "Requested"))
        end
    end)
    pcall(function()
        if World3 and getgenv().Setting.Another.AutoRandomBoneOnJoin then
            local result = ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
            print("Auto Random Bone on join: " .. tostring(result or "Requested"))
        end
    end)
end)

local function AutoStoreBackpackFruits()
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        local eatRemote = tool:FindFirstChild("EatRemote", true)
        if eatRemote then
            local originalName = eatRemote.Parent and eatRemote.Parent:GetAttribute("OriginalName")
            if originalName then
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", originalName, tool)
                    print("Auto stored fruit: " .. tostring(originalName))
                end)
            end
        end
    end
end

task.spawn(function()
    task.wait(8)
    while task.wait(2) do
        pcall(function()
            if getgenv().Setting.Another.AutoStoreFruit then
                AutoStoreBackpackFruits()
            end
        end)
    end
end)

if World3 then
    distbyp = 5000
    island = {
        ["Port Town"] = CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375),
        ["Hydra Island"] = CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531),
        ["Mansion"] = CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375),
        ["Castle On The Sea"] = CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375),
        ["Haunted Island"] = CFrame.new(-9547.5703125, 141.0137481689453, 5535.16162109375),
        ["Great Tree"] = CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625),
        ["Candy Island"] = CFrame.new(-1106.076416015625, 13.016114234924316, -14231.9990234375),
        ["Cake Island"] = CFrame.new(-1903.6856689453125, 36.70722579956055, -11857.265625),
        ["Loaf Island"] = CFrame.new(-889.8325805664062, 64.72842407226562, -10895.8876953125),
        ["Peanut Island"] = CFrame.new(-1943.59716796875, 37.012996673583984, -10288.01171875),
        ["Cocoa Island"] = CFrame.new(147.35205078125, 23.642955780029297, -12030.5498046875),
        ["Tiki Outpost"] = CFrame.new(-16234,9,416),
        ["Submerged Island"] = CFrame.new(10880.5, -2086.5, 10033.5)
    }
elseif World2 then
    distbyp = 3500
    island = {
        a = CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938),
        b = CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094),
        c = CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375),
        d = CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344),
        e = CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828),
        f = CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875),
        g = CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188),
        h = CFrame.new(923.40197753906, 125.05712890625, 32885.875),
        i = CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125),
    }
elseif World1 then
    distbyp = 1500
    island = {
        a = CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594),
        b = CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156),
        c = CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688),
        d = CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969),
        e = CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754),
        f = CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094),
        g = CFrame.new(-4607.82275, 872.54248, -1667.55688),
        h = CFrame.new(-7952.31006, 5545.52832, -320.704956),
        i = CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313),
        j = CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969),
        k = CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469),
        l = CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813),
        m = CFrame.new(61163.8515625, 11.6796875, 1819.7841796875),
        n = CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875),
        o = CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656),
        p = CFrame.new(-4813.0249, 903.708557, -1912.69055),
        q = CFrame.new(-4970.21875, 717.707275, -2622.35449),
    }
end

local p = game.Players
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local hb = rs.Heartbeat
local rends = rs.RenderStepped

function bypass(Pos)
    if not lp.Character:FindFirstChild("Head") or not lp.Character:FindFirstChild("HumanoidRootPart") or not lp.Character:FindFirstChild("Humanoid") then
        return
    end
    for _, is in pairs(island) do
        if is == Pos then
            if is == CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531) then
                if tween then pcall(function() tween:Cancel() end) end
                repeat task.wait()
                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                        lp.Character.HumanoidRootPart.CFrame = is
                    else break end
                until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is
                task.wait(0.1)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
            else
                if not stopbypass then
                    if tween then pcall(function() tween:Cancel() end) end
                    repeat task.wait()
                        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                            lp.Character.HumanoidRootPart.CFrame = is
                        else break end
                    until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is
                    pcall(function()
                        game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(15)
                        lp.Character:SetPrimaryPartCFrame(is)
                        wait(0.1)
                        if lp.Character and lp.Character:FindFirstChild("Head") then
                            lp.Character.Head:Destroy()
                        end
                        wait(0.5)
                        repeat task.wait()
                            if lp.Character and lp.Character:FindFirstChild("PrimaryPart") then
                                lp.Character.PrimaryPart.CFrame = is
                            else break end
                        until lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0
                        task.wait(0.5)
                    end)
                end
            end
        end
    end
end

function submergedIslandBypass(targetPos)
    pcall(function()
        if not lp.Character:FindFirstChild("Head") or not lp.Character:FindFirstChild("HumanoidRootPart") or not lp.Character:FindFirstChild("Humanoid") then
            return
        end

        local npcPos = CFrame.new(-16269.7041, 25.2288494, 1373.65955)
        local destPos = targetPos or CFrame.new(10880.5, -2086.5, 10033.5)

        local Distance = (destPos.Position - lp.Character.HumanoidRootPart.Position).Magnitude

        if Distance > distbyp then
            print("Flying to Submarine Worker NPC...")

            to(npcPos)
            repeat task.wait(0.1)
            until lp.Character and lp.Character.PrimaryPart and (lp.Character.PrimaryPart.Position - npcPos.Position).Magnitude < 20

            task.wait(0.5)
            print("Reached NPC, calling TravelToSubmergedIsland...")

            local success = pcall(function()
                local args = {"TravelToSubmergedIsland"}
                game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args))
            end)

            if success then
                task.wait(2.5)
                print("Entered Submerged Island, moving to safe zone...")

                to(destPos)
                repeat task.wait(0.1)
                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    else break end
                until lp.Character and lp.Character.PrimaryPart and (lp.Character.PrimaryPart.Position - destPos.Position).Magnitude < 15

                task.wait(0.5)
                print("Entered Submerged Island!")
            else
                print("Failed to call TravelToSubmergedIsland")
            end
        end
    end)
end

local SubmergedNPCInteracted = false
local function InteractSubmergedNPC()
    if SubmergedNPCInteracted then return end
    SubmergedNPCInteracted = true

    task.wait(0.5)

    pcall(function()
        for _, model in pairs(workspace:GetChildren()) do
            if model:IsA("Model") and (model.Name:match("Submarine") or model.Name:match("NPC")) then
                if model:FindFirstChild("ClickDetector") then
                    model.ClickDetector:FireServer()
                    print("Found NPC, fired ClickDetector")
                    return
                end
            end
        end
    end)

    pcall(function()
        local UserInputService = game:GetService("UserInputService")
        UserInputService:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.2)
        UserInputService:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        print("Sent E key to interact")
    end)

    task.wait(1)
    SubmergedNPCInteracted = false
end

function to(Pos)
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0 then
            local Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

            if not game.Players.LocalPlayer.Character.PrimaryPart:FindFirstChild("Hold") then
                local Hold = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.PrimaryPart)
                Hold.Name = "Hold"
                Hold.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                Hold.Velocity = Vector3.new(0, 0, 0)
            end

            if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            end

            local Speed
            if Distance <= 250 then
                if tween then tween:Cancel() end
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
            elseif Distance < 1000 then
                Speed = 375
            elseif Distance >= 1000 then
                Speed = 350
            end

            pcall(function()
                tween = game:GetService("TweenService"):Create(
                    game.Players.LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
                    {CFrame = Pos}
                )
                tween:Play()
            end)

            if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main") and
               game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("InCombat") and
               game.Players.LocalPlayer.PlayerGui.Main.InCombat.Visible then
                if not string.find(string.lower(game.Players.LocalPlayer.PlayerGui.Main.InCombat.Text), "risk") then
                    -- không trong combat risk, không làm gì thêm
                else
                    local dist = math.huge
                    local is = nil

                    for i, v in pairs(island) do
                        if (Pos.Position - v.Position).magnitude < dist then
                            is = v
                            dist = (Pos.Position - v.Position).magnitude
                        end
                    end

                    if is == nil then return end

                    if lp:DistanceFromCharacter(Pos.Position) > distbyp then
                        if (lp.Character.Head.Position - Pos.Position).magnitude > (is.Position - Pos.Position).magnitude then
                            if tween then
                                pcall(function() tween:Destroy() end)
                            end

                            if (is.X == 61163.8515625 and is.Y == 11.6796875 and is.Z == 1819.7841796875) or
                               is == CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375) or
                               is == CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375) or
                               is == CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531) then

                                if tween then
                                    pcall(function() tween:Cancel() end)
                                end

                                repeat task.wait()
                                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                                        lp.Character.HumanoidRootPart.CFrame = is
                                    else
                                        break
                                    end
                                until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is

                                task.wait(0.1)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                            end
                        end
                    end
                end
            end

            if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            end

            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                    Pos.Y,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
                )
            end
        end
    end)
end

function buso()
    if lp.Character and not lp.Character:FindFirstChild("HasBuso") then
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

function Ken()
    if lp:FindFirstChild("PlayerGui") and
       lp.PlayerGui:FindFirstChild("ScreenGui") and
       lp.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
        return true
    else
        game:service("VirtualUser"):CaptureController()
        game:service("VirtualUser"):SetKeyDown("0x65")
        game:service("VirtualUser"):SetKeyUp("0x65")
        return false
    end
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if getgenv().Setting.Another.AutoObservation then
                Ken()
            end
        end)
    end
end)

function down(use, wait)
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, use, false, lp.Character.HumanoidRootPart)
            task.wait((wait or 0.1))
            game:GetService("VirtualInputManager"):SendKeyEvent(false, use, false, lp.Character.HumanoidRootPart)
        end
    end)
end

function equip(tooltip)
    local character = lp.Character or lp.CharacterAdded:wait()
    for _, item in pairs(lp.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == tooltip then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and not humanoid:IsDescendantOf(item) then
                lp.Character.Humanoid:EquipTool(item)
                return true
            end
        end
    end
    return false
end

function EquipWeapon(Tool)
    pcall(function()
        if lp.Backpack:FindFirstChild(Tool) then
            lp.Backpack:FindFirstChild(Tool).Parent = lp.Character
        end
    end)
end

task.spawn(function()
    while game:GetService("RunService").Stepped:wait() do
        pcall(function()
            if lp.Character then
                for _, v in pairs(lp.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

local function ApplyLowCpuMode()
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain

    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0

    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 1

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    for _, obj in pairs(g:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("UnionOperation") or obj:IsA("CornerWedgePart") or obj:IsA("TrussPart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("MeshPart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
            pcall(function()
                obj.TextureID = ""
            end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            if obj:IsA("ParticleEmitter") then
                obj.Lifetime = NumberRange.new(0)
            end
            obj.Enabled = false
        elseif obj:IsA("Explosion") then
            obj.BlastPressure = 1
            obj.BlastRadius = 1
        elseif obj:IsA("Fire") or obj:IsA("SpotLight") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
    end

    for _, effect in pairs(l:GetChildren()) do
        if effect:IsA("BlurEffect")
            or effect:IsA("SunRaysEffect")
            or effect:IsA("ColorCorrectionEffect")
            or effect:IsA("BloomEffect")
            or effect:IsA("DepthOfFieldEffect") then
            effect.Enabled = false
        end
    end
end

if getgenv().Setting.Another.FPSBoots then
    ApplyLowCpuMode()
end
game:GetService("RunService"):Set3dRenderingEnabled(true)

function hasValue(array, targetString)
    if not array then return false end
    for _, value in ipairs(array) do
        if value == targetString then
            return true
        end
    end
    return false
end

local y = nil
pcall(function()
    if lp:FindFirstChild("PlayerScripts") then
        local success, result = pcall(function()
            return require(lp.PlayerScripts:FindFirstChild("CombatFramework"))
        end)
        if success and result then
            local getCombatFrameworkR = debug.getupvalues(result)[2]
            y = getCombatFrameworkR
        end
    end
end)

task.spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if y and typeof(y) == "table" then
            pcall(function()
                if y.activeController then
                    y.activeController.hitboxMagnitude = 60
                    y.activeController.active = false
                    y.activeController.timeToNextBlock = 0
                    y.activeController.focusStart = 1655503339.0980349
                    y.activeController.increment = 1
                    y.activeController.blocking = false
                    y.activeController.attacking = false
                    if y.activeController.humanoid then
                        y.activeController.humanoid.AutoRotate = true
                    end
                end
            end)
        end
    end)
end)

local radius = 25
local speedCircle = 30
local angle = 0
local yTween = 5
local function getNextPosition(center)
    angle = angle + speedCircle
    return center + Vector3.new(math.sin(math.rad(angle)) * radius, yTween, math.cos(math.rad(angle)) * radius)
end

local starthop = false
local stopbypass = false
local hopInProgress = false
local hopRetryQueued = false
local SafeHop

local function HasActivePvpTag()
    local ok, result = pcall(function()
        local mainGui = lp:FindFirstChild("PlayerGui") and lp.PlayerGui:FindFirstChild("Main")
        local bottomHud = mainGui and mainGui:FindFirstChild("BottomHUDList")
        local inCombatFrame = bottomHud and bottomHud:FindFirstChild("InCombat")
        if inCombatFrame and inCombatFrame.Visible then
            local txt = string.lower(tostring(inCombatFrame.Text or ""))
            return string.find(txt, "risk") ~= nil or string.find(txt, "combat") ~= nil
        end
        return false
    end)
    return ok and result == true
end

task.spawn(function()
    while task.wait() do
        if hopserver then
            stopbypass = true
            starthop = true
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if starthop and not hopInProgress then
            SafeHop()
        end
    end
end)

function CheckInComBat()
    return HasActivePvpTag()
end

local function IsInPvPCombat()
    return HasActivePvpTag()
end

SafeHop = function()
    if hopInProgress then
        return
    end
    setHopServer(true)
    stopbypass = true
    starthop = true
    task.spawn(function()
        hopInProgress = true
        if getgenv().Setting.Another.CheckCombatBeforeHop and IsInPvPCombat() then
            print("In PvP tag, waiting until it clears before hop...")
            if TargetTitle then
                TargetTitle.Text = "Target Info [PvP]"
            end
            ShowHopNotify("PvP tag is active. Waiting before hopping...", nil, {
                title = "WAITING FOR PVP",
                persist = true
            })
            while hopserver and IsInPvPCombat() do
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    to(lp.Character.HumanoidRootPart.CFrame * CFrame.new(0, math.random(500, 10000), 0))
                end
                task.wait(1)
            end
            if TargetTitle then
                TargetTitle.Text = "Target Info"
            end
            if not hopserver then
                hopInProgress = false
                HideHopNotify(true)
                return
            end
            print("PvP tag cleared, hopping now")
        else
            ShowHopNotify("Searching for a better server...", 10, {
                title = "HOPPING SERVER"
            })
            task.wait(10)
        end
        starthop = false
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            to(CFrame.new(0, 10000, 0))
        end
        HopServers()
        hopInProgress = false
    end)
end

HopServers = function(counts)
    DontHop = false
    pcall(function()
        local maxPlayers = counts or 10
        ticklon = tick()
        repeat
            task.wait()
        until tick() - ticklon >= 1
        local function DoHop()
            for page = 1, math.huge, 1 do
                if ChooseRegion == nil or ChooseRegion == "" then
                    ChooseRegion = "Singapore"
                else
                    game:GetService("Players").LocalPlayer.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox.Text = ChooseRegion
                end
                local servers = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(page)
                if not servers then break end
                for jobId, info in pairs(servers) do
                    if jobId ~= game.JobId and info.Count < maxPlayers then
                        if DontHop then return end
                        print("Hopping to server: " .. tostring(jobId) .. " (" .. tostring(info.Count) .. " players)")
                        getgenv().checked = {}
                        getgenv().targ = nil
                        stopbypass = false
                        starthop = false
                        ShowHopNotify("Joining server with " .. tostring(info.Count) .. " players...", nil, {
                            title = "JOINING SERVER",
                            persist = true
                        })
                        game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", jobId)
                        return true
                    end
                end
            end
            return false
        end
        if not getgenv().HopLoaded then
            local function checkPrompt(v)
                if v.Name == "ErrorPrompt" then
                    if v.Visible then
                        local errorTitle = v:FindFirstChild("TitleFrame") and v.TitleFrame:FindFirstChild("ErrorTitle")
                        if errorTitle and errorTitle.Text == "Teleport Failed" then
                            if not hopRetryQueued then
                                hopRetryQueued = true
                                DontHop = true
                                setHopServer(true)
                                ShowHopNotify("Teleport failed. Retrying another server...", 3, {
                                    title = "RETRYING HOP"
                                })
                                task.spawn(function()
                                    task.wait(3)
                                    hopRetryQueued = false
                                    if hopserver then
                                        HopServers(counts)
                                    end
                                end)
                            end
                            v.Visible = false
                        end
                    end
                    v:GetPropertyChangedSignal("Visible"):Connect(function()
                        if v.Visible then
                            local errorTitle = v:FindFirstChild("TitleFrame") and v.TitleFrame:FindFirstChild("ErrorTitle")
                            if errorTitle and errorTitle.Text == "Teleport Failed" then
                                if not hopRetryQueued then
                                    hopRetryQueued = true
                                    DontHop = true
                                    setHopServer(true)
                                    ShowHopNotify("Teleport failed. Retrying another server...", 3, {
                                        title = "RETRYING HOP"
                                    })
                                    task.spawn(function()
                                        task.wait(3)
                                        hopRetryQueued = false
                                        if hopserver then
                                            HopServers(counts)
                                        end
                                    end)
                                end
                                v.Visible = false
                            end
                        end
                    end)
                end
            end
            for _, v in pairs(game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren()) do
                checkPrompt(v)
            end
            game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(checkPrompt)
            getgenv().HopLoaded = true
        end
        while task.wait(0.1) do
            if DontHop then break end
            DoHop()
        end
    end)
end

getgenv().HopServers = HopServers

local _skipDebounce = false
SkipPlayer = function()
    if _skipDebounce then return end
    _skipDebounce = true
    task.delay(0.5, function() _skipDebounce = false end)

    if getgenv().targ then
        if not hasValue(getgenv().checked, getgenv().targ) then
            table.insert(getgenv().checked, getgenv().targ)
        end
        getgenv().killed = getgenv().targ
    end
    getgenv().targ = nil
    print("None")

    local validRemaining = 0
    pcall(function()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and not hasValue(getgenv().checked, v) then
                validRemaining = validRemaining + 1
            end
        end
    end)

    if validRemaining == 0 then
        getgenv().checked = {}
        print("Skipped all targets in server, reset checked then hop")
        ShowHopNotify("No valid targets left in this server.", 3, {
            title = "NO TARGETS FOUND"
        })
        task.spawn(function()
            task.wait(3)
            setHopServer(true)
            stopbypass = true
            SafeHop()
        end)
    else
        target()
    end
end

getgenv().SkipPlayer = SkipPlayer

function target()
    pcall(function()
        if hopserver then return end

        local maxTargetDistance = tonumber(getgenv().Setting.Hunt.MaxDistance) or 30000
        local d = math.huge
        local p = nil
        getgenv().targ = nil
        for _, v in pairs(game.Players:GetPlayers()) do
            local canAttack = false
            if tostring(lp.Team) == "Marines" then
                canAttack = (tostring(v.Team) == "Pirates")
            elseif tostring(lp.Team) == "Pirates" then
                canAttack = (tostring(v.Team) == "Marines" or tostring(v.Team) == "Pirates")
            end

            if v.Team ~= nil and canAttack then
                if v and v:FindFirstChild("Data") and ((getgenv().Setting.Skip.Fruit and hasValue(getgenv().Setting.Skip.FruitList, v.Data.DevilFruit.Value) == false) or not getgenv().Setting.Skip.Fruit) then
                    local targetPvpDisabled = v:GetAttribute("PvpDisabled") == true
                    if getgenv().Setting.Skip.NoPvP and targetPvpDisabled then
                    elseif v ~= lp and v ~= getgenv().targ and
                       v.Character and v.Character:FindFirstChild("HumanoidRootPart") and
                       (v.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < d and
                       (v.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude <= maxTargetDistance and
                       not hasValue(getgenv().checked, v) and
                       v.Character.HumanoidRootPart.CFrame.Y <= 12000 then

                        if (tonumber(lp.Data.Level.Value) - 250) < v.Data.Level.Value then
                            if v.leaderstats["Bounty/Honor"] and
                               v.leaderstats["Bounty/Honor"].Value >= getgenv().Setting.Hunt.Min and
                               v.leaderstats["Bounty/Honor"].Value <= getgenv().Setting.Hunt.Max then

                                if (getgenv().Setting["Skip Race V4"] and not v.Character:FindFirstChild("RaceTransformed")) or not getgenv().Setting["Skip Race V4"] then
                                    p = v
                                    d = (v.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude

                                    if getgenv().Setting.Chat and #getgenv().Setting.Chat > 0 then
                                        local chatMsg = getgenv().Setting.Chat[math.random(1, #getgenv().Setting.Chat)]
                                        if chatMsg then
                                            game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(chatMsg, "All")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if p == nil then
            getgenv().checked = {}
            ShowHopNotify("No targets found in this server.", 3, {
                title = "NO TARGETS FOUND"
            })
            task.wait(3)
            SafeHop()
        else
            print("Found target: " .. p.Name, "success")
        end
        getgenv().targ = p
    end)
end

local function watchPvpAttribute(player)
    player.AttributeChanged:Connect(function(attrName)
        if attrName == "PvpDisabled" then
            local status = player:GetAttribute("PvpDisabled")
            if status == true then
                print("[PvpCheck] " .. player.Name .. ": PvP Disabled")
                if getgenv().Setting.Skip.NoPvP and getgenv().targ == player then
                    print("[PvpCheck] Skip target " .. player.Name .. " because PvP is disabled")
                    SkipPlayer()
                end
            else
                print("[PvpCheck] " .. player.Name .. ": PvP Enabled")
            end
        end
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= lp then
        watchPvpAttribute(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    watchPvpAttribute(player)
end)

Players.PlayerRemoving:Connect(function(removedPlayer)
    task.wait(1)
    pcall(function()
        local others = 0
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= lp then others = others + 1 end
        end
        if others == 0 then
            ShowEmptyServerNotify("No players left, switching server...", 4)
            task.wait(4)
            pcall(function()
                getgenv().checked = {}
                setHopServer(true)
                SafeHop()
            end)
        end
    end)
end)

function CheckSafeZone(nitga)
    local result = false
    pcall(function()
        local safeZones = workspace:FindFirstChild("_WorldOrigin") and workspace["_WorldOrigin"]:FindFirstChild("SafeZones")
        if safeZones then
            for _, v in pairs(safeZones:GetChildren()) do
                if v and v:IsA("BasePart") then
                    if (v.Position - nitga.Position).Magnitude <= 400 then
                        result = true
                        return
                    end
                end
            end
        end
    end)
    return result
end

task.spawn(function()
    while wait() do
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and lp.Character and
               (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < 40 then
                Ken()
            end
        end)
    end
end)

local gunmethod = getgenv().Setting.Gun.GunMode

task.spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and
               lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                if (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < 40 then
                    if not gunmethod then
                        if getgenv().Setting.Melee.Enable then
                            getgenv().weapon = "Melee"
                            wait(getgenv().Setting.Melee.Delay or 0.1)
                        end
                        if getgenv().Setting.Fruit.Enable then
                            getgenv().weapon = "Blox Fruit"
                            wait(getgenv().Setting.Fruit.Delay or 0.1)
                        end
                        if getgenv().Setting.Sword.Enable then
                            getgenv().weapon = "Sword"
                            wait(getgenv().Setting.Sword.Delay or 0.1)
                        end
                        if getgenv().Setting.Gun.Enable then
                            getgenv().weapon = "Gun"
                            wait(getgenv().Setting.Gun.Delay or 0.1)
                        end
                    else
                        pcall(function()
                            EquipWeapon("Melee")
                            EquipWeapon("Gun")
                        end)
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if getgenv().Setting.Another.V3 then
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
                end)
                task.wait(30)
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if getgenv().Setting.Another.V4 and lp.Character then
                local raceEnergy = lp.Character:FindFirstChild("RaceEnergy")
                if raceEnergy and raceEnergy.Value == 1 then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if lp.PlayerGui:FindFirstChild("Main") and
               lp.PlayerGui.Main:FindFirstChild("PvpDisabled") and
               lp.PlayerGui.Main.PvpDisabled.Visible == true then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
            end

            if getgenv().targ and getgenv().targ.Character and lp.Character and
               lp.Character:FindFirstChild("HumanoidRootPart") and
               getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and
               (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < 50 then
                buso()
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        if not hopserver then
            if getgenv().targ and not game:GetService("Players"):FindFirstChild(getgenv().targ.Name) then
                getgenv().targ = nil
            end
            if not getgenv().targ or not getgenv().targ.Character then target() end
        end
        pcall(function()
            if getgenv().targ and getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and
               lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                if (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < 40 then
                    task.spawn(function()
                        if not gunmethod then
                            pcall(function() EquipWeapon("Summon Sea Beast") end)
                            equip(getgenv().weapon)

                            for _, v in pairs(lp.Character:GetChildren()) do
                                if v:IsA("Tool") then
                                    if v.ToolTip == "Melee" then
                                        if getgenv().Setting.Melee.Enable then
                                            if lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("Z") and
                                               lp.PlayerGui.Main.Skills[v.Name].Z.Cooldown.AbsoluteSize.X <= 0 and
                                               getgenv().Setting.Melee.Z.Enable then
                                                down("Z", getgenv().Setting.Melee.Z.HoldTime)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("X") and
                                                   lp.PlayerGui.Main.Skills[v.Name].X.Cooldown.AbsoluteSize.X <= 0 and
                                                   getgenv().Setting.Melee.X.Enable then
                                                down("X", getgenv().Setting.Melee.X.HoldTime)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("C") and
                                                   lp.PlayerGui.Main.Skills[v.Name].C.Cooldown.AbsoluteSize.X <= 0 and
                                                   getgenv().Setting.Melee.C.Enable then
                                                down("C", getgenv().Setting.Melee.C.HoldTime)
                                            elseif getgenv().Setting.Melee.V.Enable and
                                                   lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("V") and
                                                   lp.PlayerGui.Main.Skills[v.Name].V.Cooldown.AbsoluteSize.X <= 0 then
                                                down("V", getgenv().Setting.Melee.V.HoldTime)
                                            end
                                        end
                                    elseif v.ToolTip == "Gun" then
                                        if getgenv().Setting.Gun.Enable then
                                            if lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("Z") and
                                               lp.PlayerGui.Main.Skills[v.Name].Z.Cooldown.AbsoluteSize.X <= 0 and
                                               getgenv().Setting.Gun.Z.Enable then
                                                down("Z", getgenv().Setting.Gun.Z.HoldTime)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("X") and
                                                   lp.PlayerGui.Main.Skills[v.Name].X.Cooldown.AbsoluteSize.X <= 0 and
                                                   getgenv().Setting.Gun.X.Enable then
                                                down("X", getgenv().Setting.Gun.X.HoldTime)
                                            end
                                        end
                                    elseif v.ToolTip == "Sword" then
                                        if getgenv().Setting.Sword.Enable then
                                            if lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("Z") and
                                               lp.PlayerGui.Main.Skills[v.Name].Z.Cooldown.AbsoluteSize.X <= 0 and
                                               getgenv().Setting.Sword.Z.Enable then
                                                down("Z", getgenv().Setting.Sword.Z.HoldTime)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("X") and
                                                   lp.PlayerGui.Main.Skills[v.Name].X.Cooldown.AbsoluteSize.X <= 0 and
                                                   getgenv().Setting.Sword.X.Enable then
                                                down("X", getgenv().Setting.Sword.X.HoldTime)
                                            end
                                        end
                                    elseif v.ToolTip == "Blox Fruit" then
                                        if getgenv().Setting.Fruit.Enable then
                                            if lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("Z") and
                                               lp.PlayerGui.Main.Skills[v.Name].Z.Cooldown.AbsoluteSize.X <= 0 and
                                               getgenv().Setting.Fruit.Z.Enable then
                                                down("Z", getgenv().Setting.Fruit.Z.HoldTime)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("X") and
                                                   lp.PlayerGui.Main.Skills[v.Name].X.Cooldown.AbsoluteSize.X <= 0 and
                                                   getgenv().Setting.Fruit.X.Enable then
                                                down("X", getgenv().Setting.Fruit.X.HoldTime)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("C") and
                                                   lp.PlayerGui.Main.Skills[v.Name].C.Cooldown.AbsoluteSize.X <= 0 and
                                                   getgenv().Setting.Fruit.C.Enable then
                                                down("C", getgenv().Setting.Fruit.C.HoldTime)
                                            elseif lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("V") and
                                                   lp.PlayerGui.Main.Skills[v.Name].V.Cooldown.AbsoluteSize.X <= 0 and
                                                   getgenv().Setting.Fruit.V.Enable then
                                                down("V", getgenv().Setting.Fruit.V.HoldTime)
                                            elseif getgenv().Setting.Fruit.F.Enable and
                                                   lp.PlayerGui.Main.Skills[v.Name]:FindFirstChild("F") and
                                                   lp.PlayerGui.Main.Skills[v.Name].F.Cooldown.AbsoluteSize.X <= 0 then
                                                down("F", getgenv().Setting.Fruit.F.HoldTime)
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if getgenv().Setting.Melee.Enable then
                                if getgenv().Setting.Melee.Z.Enable then down("Z", getgenv().Setting.Melee.Z.HoldTime)
                                elseif getgenv().Setting.Melee.X.Enable then down("X", getgenv().Setting.Melee.X.HoldTime)
                                elseif getgenv().Setting.Melee.C.Enable then down("C", getgenv().Setting.Melee.C.HoldTime)
                                elseif getgenv().Setting.Melee.V.Enable then down("V", getgenv().Setting.Melee.V.HoldTime)
                                end
                            end
                        end

                        if CheckSafeZone(getgenv().targ.Character.HumanoidRootPart) or
                           (lp.PlayerGui:FindFirstChild("Main") and lp.PlayerGui.Main:FindFirstChild("[OLD]SafeZone") and lp.PlayerGui.Main["[OLD]SafeZone"].Visible == true) or
                           getgenv().targ.Character.Humanoid.Sit == true then
                            SkipPlayer()
                        end

                        for _, v in pairs(lp.PlayerGui.Notifications:GetChildren()) do
                            if v:IsA("TextLabel") then
                                local text = v.Text
                                local cleanText = text:gsub("<[^>]+>", ""):gsub("&lt;", "<"):gsub("&gt;", ">")
                                local textLow = string.lower(cleanText)
                                if string.find(textLow, "player") or
                                   string.find(textLow, "cannot attack") or
                                   string.find(textLow, "unable to attack") or
                                   string.find(textLow, "khÃ´ng c") or
                                   string.find(textLow, "nguoi choi") then
                                    print("AUTO-SKIP: " .. string.sub(cleanText, 1, 50))
                                    SkipPlayer()
                                    pcall(function() v:Destroy() end)
                                    break
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end
end)

local a, b
local Nguvc = 5
local helloae = false
local safehealth = false

task.spawn(function()
    while task.wait(0.05) do
        if not getgenv().targ then target() end
        if not getgenv().targ then setHopServer(true) end
        if not lp.PlayerGui.Main.BottomHUDList.PvpDisabled.Visible then
            pcall(function()
                if getgenv().targ.Character and getgenv().targ.Character:FindFirstChild("HumanoidRootPart") and
                lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and
                lp.Character:FindFirstChild("Humanoid") then
                    local maxTargetDistance = tonumber(getgenv().Setting.Hunt.MaxDistance) or 30000
                    local currentDistance = (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude

                    if currentDistance > maxTargetDistance then
                        print("Skip target " .. getgenv().targ.Name .. " because distance is over " .. tostring(maxTargetDistance) .. "m")
                        SkipPlayer()
                        return
                    end

                    if lp.Character.Humanoid.Health > getgenv().Setting.SafeHealth.Health then
                        pcall(function()
                            local targetY = getgenv().targ.Character.HumanoidRootPart.Position.Y
                            if targetY < -1500 and targetY > -2200 then
                                local playerY = lp.Character.HumanoidRootPart.Position.Y
                                if playerY > 0 then
                                    print("Target found in Submerged Island, calling distbyp...")
                                    submergedIslandBypass()
                                    task.wait(3)
                                else
                                    if (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < 40 then
                                        if lp.PlayerGui:FindFirstChild("Main") and lp.PlayerGui.Main:FindFirstChild("SafeZone") and lp.PlayerGui.Main.SafeZone.Visible == true then
                                            SkipPlayer()
                                        end
                                        if getgenv().targ.Character.Humanoid.Health > 0 then
                                            if helloae then
                                                to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0))
                                            else
                                                to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
                                            end
                                        else
                                            SkipPlayer()
                                        end
                                    else
                                        if getgenv().targ.Character.Humanoid.Health > 0 then
                                            to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
                                        else
                                            SkipPlayer()
                                        end
                                    end
                                end
                            elseif not (workspace:FindFirstChild("_WorldOrigin") and workspace["_WorldOrigin"]:FindFirstChild("Locations") and workspace["_WorldOrigin"].Locations:FindFirstChild("Island 1") and
                                getgenv().targ:DistanceFromCharacter(workspace["_WorldOrigin"].Locations["Island 1"].Position) < 10000) then
                                if (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < 40 then
                                    if lp.PlayerGui:FindFirstChild("Main") and lp.PlayerGui.Main:FindFirstChild("SafeZone") and lp.PlayerGui.Main.SafeZone.Visible == true then
                                        SkipPlayer()
                                    end
                                    if getgenv().targ.Character.Humanoid.Health > 0 then
                                        if helloae then
                                            to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0))
                                        else
                                            to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
                                        end
                                    else
                                        SkipPlayer()
                                    end
                                else
                                    if getgenv().targ.Character.Humanoid.Health > 0 then
                                        to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
                                    else
                                        SkipPlayer()
                                    end
                                end
                            else
                                SkipPlayer()
                            end
                        end)
                        a = getgenv().targ.Character.HumanoidRootPart.Position
                        if a ~= b then
                            yTween = 0
                            b = a
                            Nguvc = (getgenv().Setting.Gun.Enable and getgenv().Setting.Gun.GunMode) and 14 or 15
                        else
                            yTween = 5
                            Nguvc = (getgenv().Setting.Gun.Enable and getgenv().Setting.Gun.GunMode) and 3 or 5
                        end
                        helloae = getgenv().targ.Character.HumanoidRootPart.CFrame.Y >= 10
                    else
                        safehealth = true
                        if getgenv().targ.Character:FindFirstChild("HumanoidRootPart") then
                            to(getgenv().targ.Character.HumanoidRootPart.CFrame * CFrame.new(0, math.random(5000, 100000), 0))
                        end
                    end
                end
            end)
        else
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("EnablePvp")
        end
    end
end)

local aim = false
local CFrameHunt

task.spawn(function()
    while task.wait() do
        if getgenv().targ and getgenv().targ.Character and
           lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and
           (getgenv().targ.Character.HumanoidRootPart.CFrame.Position - lp.Character.HumanoidRootPart.CFrame.Position).Magnitude < 40 then
            aim = true
            if getgenv().Setting.Gun.Enable and getgenv().Setting.Gun.GunMode then
                CFrameHunt = CFrame.new(getgenv().targ.Character.HumanoidRootPart.Position + getgenv().targ.Character.HumanoidRootPart.CFrame.LookVector * 2, getgenv().targ.Character.HumanoidRootPart.Position)
            else
                CFrameHunt = CFrame.new(getgenv().targ.Character.HumanoidRootPart.Position + getgenv().targ.Character.HumanoidRootPart.CFrame.LookVector * 5, getgenv().targ.Character.HumanoidRootPart.Position)
            end
        else
            aim = false
        end
    end
end)

task.spawn(function()
    local gg = getrawmetatable(game)
    local old = gg.__namecall
    setreadonly(gg, false)
    gg.__namecall = newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}
        if tostring(method) == "FireServer" then
            if tostring(args[1]) == "RemoteEvent" then
                if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                    if aim and CFrameHunt then
                        args[2] = CFrameHunt.Position
                        return old(unpack(args))
                    end
                end
            end
        end
        return old(...)
    end)
end)

local saishiHookedCharacters = {}
local function hookSaishiOneHit(char)
    if not char or saishiHookedCharacters[char] then
        return
    end
    saishiHookedCharacters[char] = true

    task.spawn(function()
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum then
            saishiHookedCharacters[char] = nil
            return
        end

        hum.AnimationPlayed:Connect(function(track)
            if not track or track.Name ~= "Saddi_Z_Charge" then
                return
            end

            local stoppedConn
            stoppedConn = track.Stopped:Connect(function()
                if stoppedConn then
                    stoppedConn:Disconnect()
                    stoppedConn = nil
                end

                if player.Character ~= char then
                    return
                end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(hrp.Position.X, -99999, hrp.Position.Z)
                end
            end)
        end)
    end)
end

if player.Character then
    hookSaishiOneHit(player.Character)
end
player.CharacterAdded:Connect(function(char)
    saishiHookedCharacters[char] = nil
    hookSaishiOneHit(char)
end)

game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if not hopserver and child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
        TeleportService:Teleport(game.PlaceId)
    end
end)

function sendKillWebhook(targetName, bountyEarned, currentBounty)
    if not getgenv().Setting.Webhook.Enabled or getgenv().Setting.Webhook.Url == "" then
        return
    end
    local url = getgenv().Setting.Webhook.Url
    local function formatBounty(bounty)
        if bounty >= 1000000 then
            return string.format("%.1fM", bounty / 1000000)
        elseif bounty >= 1000 then
            return string.format("%.1fK", bounty / 1000)
        else
            return tostring(bounty)
        end
    end
    local data = {
        ["embeds"] = {{
            ["title"] = "BOUNTY HUNTER NOTIFICATION",
            ["description"] = "Kill Player",
            ["color"] = 0x67eb34,
            ["fields"] = {
                {["name"] = "Target",
                 ["value"] = "```" .. targetName .. "```",
                 ["inline"] = true},
                {["name"] = "Bounty Earned",
                 ["value"] = "```" .. formatBounty(bountyEarned) .. "```",
                 ["inline"] = true},
                {["name"] = "Current Bounty",
                 ["value"] = "```" .. formatBounty(currentBounty) .. "```",
                 ["inline"] = true},
                {["name"] = "Hunter",
                 ["value"] = "```" .. player.Name .. "```",
                 ["inline"] = true},
                {["name"] = "Level",
                 ["value"] = "```" .. tostring(player.Data.Level.Value) .. "```",
                 ["inline"] = true},
                {["name"] = "Time",
                 ["value"] = "```" .. os.date("%H:%M:%S %d/%m/%Y") .. "```",
                 ["inline"] = true}
            },
            ["footer"] = {["text"] = "By Your Name Hub"},
            ["thumbnail"] = {
                ["url"] = THUMBNAIL_IMAGE
            }
        }}
    }
    pcall(function()
        local jsonData = HttpService:JSONEncode(data)
        local success, response = pcall(function()
            if syn then
                return syn.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = jsonData})
            else
                return request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = jsonData})
            end
        end)
        if success then
            print("Sent kill webhook: " .. targetName)
        else
            print("Webhook error: " .. tostring(response))
        end
    end)
end

local lastKilledPlayer = nil
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if getgenv().targ and getgenv().targ.Character then
                local targetPlayer = getgenv().targ
                local character = targetPlayer.Character
                if character:FindFirstChild("Humanoid") and character.Humanoid.Health <= 0 then
                    if lastKilledPlayer ~= targetPlayer.Name then
                        lastKilledPlayer = targetPlayer.Name

                        task.wait(1)
                        local confirmedDead = false
                        pcall(function()
                            if character and character:FindFirstChild("Humanoid") then
                                confirmedDead = character.Humanoid.Health <= 0
                            else
                                confirmedDead = true
                            end
                        end)

                        if confirmedDead then
                            print("ELIMINATED: " .. targetPlayer.Name)
                        end

                        task.wait(2)
                        SkipPlayer()
                    end
                end
            end
        end)
    end
end)

task.wait(8)
pcall(function()
    if getgenv().Setting.Webhook.Enabled and getgenv().Setting.Webhook.Url ~= "" then
        local currentBounty = player.leaderstats["Bounty/Honor"] and player.leaderstats["Bounty/Honor"].Value or 0
        local data = {
            ["embeds"] = {{
                ["title"] = "Your Name Hub - Notify",
                ["description"] = "Bounty Ez",
                ["color"] = 16753920,
                ["fields"] = {
                    {["name"] = "User Name", ["value"] = "```" .. player.Name .. "```", ["inline"] = true},
                    {["name"] = "Level", ["value"] = "```" .. tostring(player.Data.Level.Value) .. "```", ["inline"] = true},
                    {["name"] = "Current Bounty", ["value"] = "```" .. tostring(currentBounty) .. "```", ["inline"] = true},
                    {["name"] = "Check Team", ["value"] = "```" .. getgenv().Setting.Team .. "```", ["inline"] = true}
                },
                ["thumbnail"] = {["url"] = THUMBNAIL_IMAGE},
                ["footer"] = {["text"] = "Auto Bounty By Your Name Hub " .. os.date("%H:%M %d/%m/%Y")}
            }}
        }
        pcall(function()
            local jsonData = HttpService:JSONEncode(data)
            if syn then
                syn.request({Url = getgenv().Setting.Webhook.Url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = jsonData})
            else
                request({Url = getgenv().Setting.Webhook.Url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = jsonData})
            end
            print("Sent startup webhook")
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, v in pairs(lp.PlayerGui.Notifications:GetChildren()) do
                if v:IsA("TextLabel") then
                    local text = v.Text
                    local cleanText = text:gsub("<[^>]+>", ""):gsub("&lt;", "<"):gsub("&gt;", ">")
                    local textLow = string.lower(cleanText)
                    if string.find(textLow, "player") or
                       string.find(textLow, "cannot attack") or
                       string.find(textLow, "unable to attack") or
                       string.find(textLow, "khÃ´ng c") then
                        print("AUTO-SKIP: " .. string.sub(cleanText, 1, 40))
                        SkipPlayer()
                        pcall(function() v:Destroy() end)
                        break
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    local Lighting   = game:GetService("Lighting")
    local RS         = game:GetService("ReplicatedStorage")
    local WS         = game:GetService("Workspace")

    local lastMoon       = ""
    local lastSword      = ""
    local lastKitsune    = false
    local lastPrehis     = false
    local lastMirage     = false
    local lastVolcano    = false
    local lastBoss       = {}
    local fruitSeen      = {}
    local berrySeen      = {}
    local eliteSeen      = {}
    local castleRaidSeen = false

    local BOSSES = {
        {name = "Soul Reaper",         check = function(e) return e:FindFirstChild("Soul Reaper") end,        color = 0x00ffff},
        {name = "Dough King",          check = function(e) return e:FindFirstChild("Dough King")
                                                   or RS:FindFirstChild("Dough King") end,                    color = 0x00ffff},
        {name = "Darkbeard",           check = function(e) return e:FindFirstChild("Darkbeard") end,          color = 0x00ffff},
        {name = "Rip Indra True Form", check = function(e)
                                                   return RS:FindFirstChild("rip_indra True Form")
                                                       or e:FindFirstChild("rip_indra") end,                  color = 0x00ffff},
        {name = "Cursed Captain",      check = function(e) return e:FindFirstChild("Cursed Captain") end,     color = 0x00ffff},
    }

    local MOON_FULL  = "http://www.roblox.com/asset/?id=9709149431"
    local MOON_NEAR4 = "http://www.roblox.com/asset/?id=9709149052"
    local MOON_NEAR3 = "http://www.roblox.com/asset/?id=9709143733"
    local ELITE_NAMES = {
        "Diablo",
        "Deandre",
        "Urban",
    }
    local CASTLE_RAID_ENEMIES = {
        "Galley Pirate",
        "Galley Captain",
        "Raider",
        "Mercenary",
        "Vampire",
        "Zombie",
        "Snow Trooper",
        "Winter Warrior",
        "Lab Subordinate",
        "Horned Warrior",
        "Magma Ninja",
        "Lava Pirate",
        "Ship Deckhand",
        "Ship Engineer",
        "Ship Steward",
        "Ship Officer",
        "Arctic Warrior",
        "Snow Lurker",
        "Sea Soldier",
        "Water Fighter",
    }
    local CASTLE_RAID_CENTER = Vector3.new(-5539.3115234375, 313.80053710938, -2972.3723144531)
    local CASTLE_RAID_RADIUS = 2200

    while true do
        task.wait(5)
        if not WebhookEnabled then continue end

        pcall(function()
            local enemies = WS:FindFirstChild("Enemies")

            local moonId = ""
            pcall(function()
                local sky = Lighting:FindFirstChildOfClass("Sky")
                    or Lighting:FindFirstChild("Sky")
                    or Lighting:FindFirstChild("FantasySky")
                if sky then moonId = sky.MoonTextureId end
            end)
            if moonId ~= lastMoon then
                lastMoon = moonId
                if moonId == MOON_FULL then
                    SendNotify("moon", {key="fullmoon", phase="5/5", become="Full Moon Now!", color=0x00ffff, titleIcon="🌕", authorName="Full Moon Alert"})
                elseif moonId == MOON_NEAR4 then
                    SendNotify("moon", {key="nearmoon4", phase="4/5", become="~1 Minute ( s )", color=0x00ffff, titleIcon="🌔", authorName="Near Full Moon Alert"})
                elseif moonId == MOON_NEAR3 then
                    SendNotify("moon", {key="nearmoon3", phase="3/5", become="~2 Minute ( s )", color=0x00ffff, titleIcon="🌓", authorName="Moon Phase Alert"})
                end
            end

            pcall(function()
                if not World2 then
                    lastSword = ""
                    return
                end
                local remote = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("CommF_")
                if not remote then return end
                local sword = ""
                if remote:InvokeServer("LegendarySwordDealer", "1") then sword = "Shisui"
                elseif remote:InvokeServer("LegendarySwordDealer", "2") then sword = "Wando"
                elseif remote:InvokeServer("LegendarySwordDealer", "3") then sword = "Saddi"
                end
                if sword ~= "" and sword ~= lastSword then
                    lastSword = sword
                    SendNotify("sword", {key="sword_"..sword, name=sword, color=0x9B59B6})
                elseif sword == "" then
                    lastSword = ""
                end
            end)

            if enemies then
                for _, boss in ipairs(BOSSES) do
                    local found = false
                    pcall(function() found = boss.check(enemies) ~= nil end)
                    local key = boss.name
                    if found and not lastBoss[key] then
                        lastBoss[key] = true
                        SendNotify("boss", {key="boss_"..key, name=boss.name, color=boss.color})
                    elseif not found then
                        lastBoss[key] = false
                    end
                end
            end

            pcall(function()
                local found = WS.Map:FindFirstChild("KitsuneIsland") ~= nil
                if found and not lastKitsune then
                    lastKitsune = true
                    local distance = GetIslandDistanceFromTiki("kitsune")
                    SendNotify("island", {key="kitsune", name="Kitsune Island", color=0x00ffff, distance=distance, titleIcon="🦊", authorName="Kitsune Island Alert"})
                elseif not found then lastKitsune = false end
            end)

            pcall(function()
                local loc = WS:FindFirstChild("_WorldOrigin") and WS._WorldOrigin:FindFirstChild("Locations")
                if not loc then return end
                local found = loc:FindFirstChild("Prehistoric Island") ~= nil
                local hasVolcano = false
                pcall(function()
                    hasVolcano = WS.Map
                        and WS.Map:FindFirstChild("PrehistoricIsland")
                        and WS.Map.PrehistoricIsland:FindFirstChild("Core")
                        and WS.Map.PrehistoricIsland.Core:FindFirstChild("VolcanoRocks") ~= nil
                end)
                if found and not lastPrehis then
                    lastPrehis = true
                    lastVolcano = hasVolcano
                    local distance = GetIslandDistanceFromTiki("prehistoric")
                    local islandName = hasVolcano and "Prehistoric Island Volcano" or "Prehistoric Island"
                    SendNotify("island", {
                        key="prehistoric",
                        name=islandName,
                        color=0x00ffff,
                        distance=distance,
                        titleIcon=hasVolcano and "🌋" or "🦕",
                        authorName=hasVolcano and "Prehistoric Volcano Alert" or "Prehistoric Island Alert"
                    })
                elseif found then
                    lastVolcano = hasVolcano
                else
                    lastPrehis = false
                    lastVolcano = false
                end
            end)

            pcall(function()
                local loc = WS:FindFirstChild("_WorldOrigin") and WS._WorldOrigin:FindFirstChild("Locations")
                if not loc then return end
                local found = loc:FindFirstChild("Mirage Island") ~= nil
                if found and not lastMirage then
                    lastMirage = true
                        local distance = GetIslandDistanceFromTiki("mirage")
                        SendNotify("island", {key="mirage", name="Mirage Island", color=0x00ffff, distance=distance, titleIcon="🏝️", authorName="Mirage Island Alert"})
                    elseif not found then lastMirage = false end
                end)

            pcall(function()
                if not (World1 or World2 or World3) then
                    return
                end
                local fruitFolder = WS:FindFirstChild("Fruits")
                    or WS:FindFirstChild("DroppedFruits")
                    or WS:FindFirstChild("Drops")
                if not fruitFolder then return end
                for _, obj in pairs(fruitFolder:GetChildren()) do
                    local fName = obj.Name
                    if not fruitSeen[fName] then
                        fruitSeen[fName] = true
                        SendNotify("fruit", {key="fruit_"..fName, name=fName, color=0x00ffff})
                    end
                end
                if #fruitFolder:GetChildren() == 0 then fruitSeen = {} end
            end)

            pcall(function()
                local taggedBushes = CollectionService:GetTagged("BerryBush")
                local currentBerryKeys = {}

                for _, bush in ipairs(taggedBushes) do
                    if bush and bush.Parent then
                        local bushId = bush:GetDebugId()

                        for attrName, attrValue in pairs(bush:GetAttributes()) do
                            if typeof(attrValue) == "string" and attrValue ~= "" then
                                local berryKey = bushId .. "_attr_" .. attrName .. "_" .. attrValue
                                currentBerryKeys[berryKey] = true
                                if not berrySeen[berryKey] then
                                    berrySeen[berryKey] = true
                                    SendNotify("berry", {key = berryKey, name = attrValue, color = 0x00ffff})
                                end
                            end
                        end

                        for _, child in ipairs(bush:GetChildren()) do
                            if child:IsA("Model") or child:IsA("BasePart") then
                                local berryName = child.Name
                                if berryName and berryName ~= "" and berryName ~= bush.Name then
                                    local berryKey = bushId .. "_child_" .. berryName
                                    currentBerryKeys[berryKey] = true
                                    if not berrySeen[berryKey] then
                                        berrySeen[berryKey] = true
                                        SendNotify("berry", {key = berryKey, name = berryName, color = 0x00ffff})
                                    end
                                end
                            end
                        end
                    end
                end

                for seenKey in pairs(berrySeen) do
                    if not currentBerryKeys[seenKey] then
                        berrySeen[seenKey] = nil
                    end
                end
            end)

            pcall(function()
                local currentEliteKeys = {}
                local eliteProgress = nil
                pcall(function()
                    eliteProgress = RS.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
                end)

                if enemies then
                    for _, eliteName in ipairs(ELITE_NAMES) do
                        local eliteEnemy = enemies:FindFirstChild(eliteName)
                        if eliteEnemy and eliteEnemy:FindFirstChild("Humanoid") and eliteEnemy.Humanoid.Health > 0 then
                            local eliteKey = "elite_" .. eliteName
                            local elitePos = "Unknown"
                            pcall(function()
                                local root = eliteEnemy:FindFirstChild("HumanoidRootPart") or eliteEnemy.PrimaryPart
                                if root then
                                    local pos = root.Position
                                    elitePos = string.format("%d, %d, %d", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
                                end
                            end)
                            currentEliteKeys[eliteKey] = true
                            if not eliteSeen[eliteKey] then
                                eliteSeen[eliteKey] = true
                                SendNotify("elites", {
                                    key = eliteKey,
                                    name = eliteName,
                                    position = elitePos,
                                    color = 0x00ffff
                                })
                            end
                        end
                    end
                end

                for seenKey in pairs(eliteSeen) do
                    if not currentEliteKeys[seenKey] then
                        eliteSeen[seenKey] = nil
                    end
                end
            end)

            pcall(function()
                local castleRaidActive = false
                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        if table.find(CASTLE_RAID_ENEMIES, enemy.Name)
                            and enemy:FindFirstChild("HumanoidRootPart")
                            and enemy:FindFirstChild("Humanoid")
                            and enemy.Humanoid.Health > 0
                            and (enemy.HumanoidRootPart.Position - CASTLE_RAID_CENTER).Magnitude <= CASTLE_RAID_RADIUS then
                            castleRaidActive = true
                            break
                        end
                    end
                end

                if castleRaidActive and not castleRaidSeen then
                    castleRaidSeen = true
                    SendNotify("castleraid", {key = "castle_raid", name = "Castle Raid Active", color = 0x00ffff})
                elseif not castleRaidActive then
                    castleRaidSeen = false
                end
            end)

            pcall(function()
                if not (World2 or World3) then
                    return
                end
                local hakiVal = player:FindFirstChild("BusoHaki")
                    or (player:FindFirstChild("Data") and player.Data:FindFirstChild("BusoHaki"))
                if hakiVal and tonumber(hakiVal.Value) and tonumber(hakiVal.Value) >= 100 then
                    SendNotify("haki", {key="hakiv3", name="Buso Haki V3", color=0x8E44AD})
                end
            end)
        end)
    end
end)
