
local lighting = game:GetService("Lighting")
local terrain = workspace:FindFirstChildOfClass("Terrain")

lighting.GlobalShadows = false
lighting.FogEnd = 100000
lighting.Brightness = 1

for i,v in pairs(game:GetDescendants()) do
    if v:IsA("ParticleEmitter") 
    or v:IsA("Trail") 
    or v:IsA("Smoke") 
    or v:IsA("Fire") 
    or v:IsA("Sparkles") then
        v.Enabled = false
    end
end

for i,v in pairs(game:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.Plastic
        v.Reflectance = 0
    end
end

for i,v in pairs(game:GetDescendants()) do
    if v:IsA("Decal") or v:IsA("Texture") then
        v.Transparency = 1
    end
end

if terrain then
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
    terrain.WaterTransparency = 1
end

print("✅ FIX LAG ACTIVATED")
