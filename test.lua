local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
local enemiesFolder = workspace:WaitForChild("Enemies")

local ATTACK_RANGE = 650
local SEARCH_RADIUS = 2500
local PLAYER_PRIORITY_RADIUS = 1200
local MAX_HIT_TARGETS = 20
local PLAYER_AUTO_ATTACK_DISTANCE = 1000
local MOB_AUTO_ATTACK_DISTANCE = 200
local STICKY_TARGET_RANGE = 3000

local Net
local registerHit
local registerAttack

pcall(function()
    Net = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"))
    registerHit = Net:RemoteEvent("RegisterHit")
    registerAttack = ReplicatedStorage.Modules.Net:FindFirstChild("RE/RegisterAttack")
end)

local function getRoot(model)
    return model and (model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso"))
end

local function getHumanoid(model)
    return model and model:FindFirstChildOfClass("Humanoid")
end

local function hrp()
    local char = plr.Character
    return getRoot(char)
end

local function aliveModel(model)
    local hum = getHumanoid(model)
    local root = getRoot(model)
    return hum and root and hum.Health > 0
end

local function dir(a, b)
    local v = b - a
    if v.Magnitude == 0 then
        return Vector3.zero
    end
    return v.Magnitude > ATTACK_RANGE and (v.Unit * ATTACK_RANGE) or v
end

local function getRemote()
    local char = plr.Character
    if char then
        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("Tool") then
                local remote = v:FindFirstChild("LeftClickRemote", true)
                if remote then
                    return remote, v
                end
            end
        end
    end

    for _, v in ipairs(plr.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            local remote = v:FindFirstChild("LeftClickRemote", true)
            if remote then
                return remote, v
            end
        end
    end
end

local function getEnv()
    if typeof(getgenv) == "function" then
        local ok, env = pcall(getgenv)
        if ok and type(env) == "table" then
            return env
        end
    end

    return nil
end

local function getTeamName(player)
    local team = player and player.Team
    return team and tostring(team.Name) or nil
end

local function isPvPEnabled(player)
    return player and player:GetAttribute("PvpDisabled") ~= true
end

local function isEnemyPlayer(other)
    if not other or other == plr then
        return false
    end

    local selfTeam = getTeamName(plr)
    local otherTeam = getTeamName(other)
    local canAttack = false

    if selfTeam == "Marines" then
        canAttack = otherTeam == "Pirates"
    elseif selfTeam == "Pirates" then
        canAttack = otherTeam == "Marines" or otherTeam == "Pirates"
    else
        canAttack = plr.Team ~= nil and other.Team ~= nil and plr.Team ~= other.Team
    end

    if not canAttack then
        return false
    end

    if not isPvPEnabled(other) then
        return false
    end

    return aliveModel(other.Character)
end

local function getBountyTarget()
    local env = getEnv()
    local targetPlayer = env and env.targ
    if typeof(targetPlayer) == "Instance" and targetPlayer:IsA("Player") and isEnemyPlayer(targetPlayer) then
        return targetPlayer.Character, getRoot(targetPlayer.Character), "player"
    end
end

local function getAutoAttackDistance(kind)
    return kind == "player" and PLAYER_AUTO_ATTACK_DISTANCE or MOB_AUTO_ATTACK_DISTANCE
end

local function isValidTargetEntry(entry)
    return entry
        and entry.model
        and entry.root
        and entry.root.Parent
        and aliveModel(entry.model)
end

local function getTargetDistance(root, targetRoot)
    if not root or not targetRoot then
        return math.huge
    end

    return (targetRoot.Position - root.Position).Magnitude
end

local function gatherTargets(root)
    local targets = {}
    local forcedModel, forcedRoot, forcedKind = getBountyTarget()

    local function push(model, targetRoot, kind, priority)
        if not model or not targetRoot then
            return
        end

        local distance = (targetRoot.Position - root.Position).Magnitude
        local maxDistance = kind == "player" and SEARCH_RADIUS or math.min(SEARCH_RADIUS, getAutoAttackDistance(kind))
        if distance > maxDistance then
            return
        end

        local finalPriority = priority
        if kind == "player" and priority > 0 and distance <= PLAYER_PRIORITY_RADIUS then
            finalPriority = -1
        end

        table.insert(targets, {
            model = model,
            root = targetRoot,
            kind = kind,
            priority = finalPriority,
            distance = distance
        })
    end

    if forcedModel and forcedRoot then
        push(forcedModel, forcedRoot, forcedKind, 0)
    end

    for _, other in ipairs(Players:GetPlayers()) do
        if isEnemyPlayer(other) and other.Character ~= forcedModel then
            push(other.Character, getRoot(other.Character), "player", 1)
        end
    end

    for _, mob in ipairs(enemiesFolder:GetChildren()) do
        if aliveModel(mob) then
            push(mob, getRoot(mob), "mob", 2)
        end
    end

    table.sort(targets, function(a, b)
        if a.priority ~= b.priority then
            return a.priority < b.priority
        end
        return a.distance < b.distance
    end)

    return targets
end

local function getPrimaryTarget(targets)
    for i = 1, #targets do
        local entry = targets[i]
        if isValidTargetEntry(entry) then
            return entry
        end
    end
end

local function getPriorityPlayerTarget(targets)
    for i = 1, #targets do
        local entry = targets[i]
        if isValidTargetEntry(entry) and entry.kind == "player" then
            return entry
        end
    end
end

local function buildHitList(targets)
    local hitData = {}

    for i = 1, #targets do
        local entry = targets[i]
        if isValidTargetEntry(entry) and (entry.kind == "player" or entry.distance <= getAutoAttackDistance(entry.kind)) then
            hitData[#hitData + 1] = {entry.model, entry.root}
            if #hitData >= MAX_HIT_TARGETS then
                break
            end
        end
    end

    return hitData
end

local currentTargetModel

local function canKeepCurrentTarget(root, entry)
    if not root or not isValidTargetEntry(entry) then
        return false
    end

    return getTargetDistance(root, entry.root) <= STICKY_TARGET_RANGE
end

local function getLockedTarget(root, targets)
    local playerTarget = getPriorityPlayerTarget(targets)
    if playerTarget then
        currentTargetModel = playerTarget.model
        return playerTarget
    end

    if currentTargetModel then
        for i = 1, #targets do
            local entry = targets[i]
            if entry.model == currentTargetModel and canKeepCurrentTarget(root, entry) then
                return entry
            end
        end
    end

    local primary = getPrimaryTarget(targets)
    currentTargetModel = primary and primary.model or nil
    return primary
end

local function shouldAttackNow(root, entry)
    if not entry then
        return false
    end

    if entry.kind == "player" then
        return true
    end

    return getTargetDistance(root, entry.root) <= getAutoAttackDistance(entry.kind)
end

local function fireAt(remote, origin, targetRoot)
    if remote and origin and targetRoot then
        remote:FireServer(dir(origin, targetRoot.Position), 1, true)
    end
end

task.spawn(function()
    while task.wait(0.03) do
        pcall(function()
            local root = hrp()
            local remote = getRemote()
            if not root or not remote then
                return
            end

            local targets = gatherTargets(root)
            local primary = getLockedTarget(root, targets)
            if not primary then
                currentTargetModel = nil
                return
            end

            if shouldAttackNow(root, primary) then
                fireAt(remote, root.Position, primary.root)
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.08) do
        pcall(function()
            local root = hrp()
            if not root then
                return
            end

            local targets = gatherTargets(root)
            local primary = getLockedTarget(root, targets)
            if not primary then
                currentTargetModel = nil
                return
            end

            local remote, tool = getRemote()
            if not shouldAttackNow(root, primary) then
                return
            end

            fireAt(remote, root.Position, primary.root)

            local toolRemote = tool and tool:FindFirstChild("LeftClickRemote", true)
            if toolRemote then
                local fireVec = dir(root.Position, primary.root.Position)
                fireVec = Vector3.new(fireVec.X, 0, fireVec.Z)
                if fireVec.Magnitude > 0 then
                    toolRemote:FireServer(fireVec, 1, true)
                end
            end

            local hitData = buildHitList(targets)
            if #hitData > 0 then
                if registerHit then
                    if registerAttack then
                        registerAttack:FireServer()
                    end
                    registerHit:FireServer(primary.root, hitData, nil, nil, tostring(math.random(100000, 999999)))
                elseif remote then
                    for i = 2, #hitData do
                        local extraRoot = hitData[i][2]
                        if extraRoot then
                            fireAt(remote, root.Position, extraRoot)
                        end
                    end
                end
            end
        end)
    end
end)
