local v1 = next
local v2 = {
    game.ReplicatedStorage.Util,
    game.ReplicatedStorage.Common,
    game.ReplicatedStorage.Remotes,
    game.ReplicatedStorage.Assets,
    game.ReplicatedStorage.FX,
}
local v3 = nil
local u4 = nil
local u5 = nil

while true do
    local v6

    v3, v6 = v1(v2, v3)

    if v3 == nil then
        break
    end

    local v7 = next
    local v8, v9 = v6:GetChildren()

    while true do
        local v10

        v9, v10 = v7(v8, v9)

        if v9 == nil then
            break
        end
        if v10:IsA('RemoteEvent') and v10:GetAttribute('Id') then
            u5 = v10:GetAttribute('Id')
            u4 = v10
        end
    end

    v6.ChildAdded:Connect(function(p11)
        if p11:IsA('RemoteEvent') and p11:GetAttribute('Id') then
            u5 = p11:GetAttribute('Id')
            u4 = p11
        end
    end)
end

task.spawn(function()
    while task.wait(0.0001) do
        local _Character = game.Players.LocalPlayer.Character
        local v13

        if _Character then
            v13 = _Character:FindFirstChild('HumanoidRootPart')
        else
            v13 = _Character
        end

        local v14, v15, v16 = ipairs({
            workspace.Enemies,
            workspace.Characters,
        })
        local u17 = {}

        while true do
            local v18

            v16, v18 = v14(v15, v16)

            if v16 == nil then
                break
            end

            local v19, v20, v21 = ipairs(v18 and v18:GetChildren() or {})

            while true do
                local v22

                v21, v22 = v19(v20, v21)

                if v21 == nil then
                    break
                end

                local _HumanoidRootPart = v22:FindFirstChild('HumanoidRootPart')
                local _Humanoid = v22:FindFirstChild('Humanoid')

                if v22 ~= _Character and (_HumanoidRootPart and (_Humanoid and (_Humanoid.Health > 0 and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 60))) then
                    local v25, v26, v27 = ipairs(v22:GetChildren())

                    while true do
                        local v28

                        v27, v28 = v25(v26, v27)

                        if v27 == nil then
                            break
                        end
                        if v28:IsA('BasePart') and (_HumanoidRootPart.Position - v13.Position).Magnitude <= 60 then
                            u17[#u17 + 1] = {v22, v28}
                        end
                    end
                end
            end
        end

        local _Tool = _Character:FindFirstChildOfClass('Tool')

        if #u17 > 0 and (_Tool and (_Tool:GetAttribute('WeaponType') == 'Melee' or _Tool:GetAttribute('WeaponType') == 'Sword')) then
            pcall(function()
                require(game.ReplicatedStorage.Modules.Net):RemoteEvent('RegisterHit', true)
                game.ReplicatedStorage.Modules.Net['RE/RegisterAttack']:FireServer()

                local _Head = u17[1][1]:FindFirstChild('Head')

                if _Head then
                    game.ReplicatedStorage.Modules.Net['RE/RegisterHit']:FireServer(_Head, u17, {}, tostring(game.Players.LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                    cloneref(u4):FireServer(string.gsub('RE/RegisterHit', '.', function(p31)
                        return string.char(bit32.bxor(string.byte(p31), math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1))
                    end), bit32.bxor(u5 + 909090, game.ReplicatedStorage.Modules.Net.seed:InvokeServer() * 2), _Head, u17)
                end
            end)
        end
    end
end)
