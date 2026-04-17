-- [[ SKYJACK RBX v2700: TITAN-CORE - ABSOLUTE STABILITY ]] --
repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")

-- Global State (Anti-Reset)
getgenv().TitanConfig = {
    Speed = false,
    WallPass = false,
    InfJump = false,
    Vip = false,
    HideName = false,
    Shield = false,
    AutoWalk = false
}

local T = getgenv().TitanConfig
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield", "AutoWalk"}
local Names = {"SUPREME SPEED (2.2)", "GHOST NOCLIP", "PHYSICAL INF JUMP", "ULTRA VIP BYPASS", "GHOST IDENTITY", "ANTI-KICK SHIELD", "STEALTH AUTO WALK"}
local Buttons = {}
local Index = 1

-- [[ 1. MASTER ENGINE: BYPASS & METATABLE ]] --
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if T.Shield and (method == "Kick" or method == "kick") then return nil end
    if T.Vip and (method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset" or method == "CheckGamepass") then
        return true
    end
    return oldNamecall(self, ...)
end)

mt.__index = newcclosure(function(t, k)
    if T.Vip and (k == "UserOwnsGamePassAsync" or k == "PlayerOwnsAsset") then
        return function() return true end
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

-- [[ 2. PHYSICS & FEATURES ENGINE ]] --
rs.Heartbeat:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local hum = lp.Character:FindFirstChildOfClass("Humanoid")

    -- SPEED GOD (2.2) - Frame Independent
    if T.Speed and hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + (hum.MoveDirection * 2.2)
    end

    -- AUTO WALK (Target Finder)
    if T.AutoWalk then
        local target = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit") or workspace:FindFirstChild("End")
        if target then hum:MoveTo(target.Position) end
    end

    -- NOCLIP
    if T.WallPass then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    else
        for _, v in pairs(lp.Character:GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.CanCollide = true end
        end
    end
end)

-- INFINITE JUMP
uis.JumpRequest:Connect(function()
    if T.InfJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- GHOST IDENTITY (DEEP SCAN)
task.spawn(function()
    while task.wait(0.1) do
        if T.HideName and lp.Character then
            pcall(function()
                lp.Character:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v.Name:lower():find("tag") then
                        v:Destroy()
                    end
                end
            end)
        end
    end
end)

-- [[ 3. STABLE UI (CORE-GUI INJECTION) ]] --
local function CreateUI()
    -- Pastikan UI diletakkan di tempat yang executor Anda (Xeno) bisa render
    local Screen = Instance.new("ScreenGui")
    pcall(function() Screen.Parent = cg:FindFirstChild("RobloxGui") or cg end)
    if not Screen.Parent then Screen.Parent = lp:WaitForChild("PlayerGui") end
    
    Screen.Name = "TITAN_V2700"
    Screen.ResetOnSpawn = false

    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 190, 0, 410)
    Main.Position = UDim2.new(0.05, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Main.Active = true
    Main.Draggable = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(0, 255, 120)
    Stroke.Thickness = 2

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "SKYJACK TITAN v2700"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 10
    Title.BackgroundTransparency = 1

    for i, name in ipairs(Names) do
        local b = Instance.new("TextButton", Main)
        b.Size = UDim2.new(1, -16, 0, 44)
        b.Position = UDim2.new(0, 8, 0, (i * 50) - 5)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        b.Text = name .. " [OFF]"
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 8
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        table.insert(Buttons, b)
    end

    local function Refresh()
        for i, b in ipairs(Buttons) do
            local key = Keys[i]
            b.Text = Names[i] .. (T[key] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(25, 25, 30)
            b.TextColor3 = (i == Index) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
        end
    end

    uis.InputBegan:Connect(function(k, g)
        if k.KeyCode == Enum.KeyCode.L then Main.Visible = not Main.Visible end
        if g or not Main.Visible then return end
        if k.KeyCode == Enum.KeyCode.Up then 
            Index = (Index > 1) and Index - 1 or #Names Refresh()
        elseif k.KeyCode == Enum.KeyCode.Down then 
            Index = (Index < #Names) and Index + 1 or 1 Refresh()
        elseif k.KeyCode == Enum.KeyCode.Return then 
            local key = Keys[Index] 
            T[key] = not T[key] Refresh()
        end
    end)
    Refresh()
end

task.defer(CreateUI)
