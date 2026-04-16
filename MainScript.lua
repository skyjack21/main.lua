-- [[ SKYJACK RBX v2400: ELITE-TOTAL - REBUILT FROM ZERO ]] --
task.wait(0.2) -- Stabilizer for Executor

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local Marketplace = game:GetService("MarketplaceService")

-- [[ 1. GLOBAL CORE CONFIG ]] --
getgenv().SkyTotal = {
    Speed = false,
    WallPass = false,
    InfJump = false,
    Vip = false,
    HideName = false,
    Shield = false,
    AutoWalk = false
}

local T = getgenv().SkyTotal
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield", "AutoWalk"}
local Names = {"ELITE SPEED (1.95)", "GHOST NOCLIP", "PHYSICAL INF JUMP", "SYSTEM VIP BYPASS", "IDENTITY CLEANER", "ANTI-KICK SHIELD", "STEALTH AUTO SUMMIT"}
local Buttons = {}
local Index = 1

-- [[ 2. MASTER BYPASS (METATABLE HOOK) ]] --
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- ANTI-KICK SYSTEM
    if T.Shield and (method == "Kick" or method == "kick") then
        return nil
    end

    -- VIP SYSTEM BYPASS
    if T.Vip then
        if method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset" or method == "CheckGamepass" then
            return true
        end
    end

    return oldNamecall(self, unpack(args))
end)

mt.__index = newcclosure(function(t, k)
    if T.Vip and (k == "UserOwnsGamePassAsync" or k == "PlayerOwnsAsset") then
        return function() return true end
    end
    return oldIndex(t, k)
end)

setreadonly(mt, true)

-- [[ 3. MOVEMENT & PHYSICS ENGINE ]] --
rs.Heartbeat:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local hum = lp.Character:FindFirstChildOfClass("Humanoid")

    -- SPEED (Extreme but Grounded)
    if T.Speed and hum.MoveDirection.Magnitude > 0 then
        -- Menggunakan penambahan CFrame untuk stabilitas di tangga/tanjakan
        root.CFrame = root.CFrame + (hum.MoveDirection * 1.95)
    end

    -- STEALTH AUTO WALK (No lines, clean movement)
    if T.AutoWalk then
        local target = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit") or workspace:FindFirstChild("End")
        if target then
            hum:MoveTo(target.Position)
        end
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

-- [[ 4. SPECIAL FEATURES (INF JUMP & GHOST) ]] --
task.spawn(function()
    -- Infinite Jump
    uis.JumpRequest:Connect(function()
        if T.InfJump and lp.Character then
            local hum = lp.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    -- Identity Cleaner (Ghost Mode)
    while task.wait(0.05) do
        if T.HideName and lp.Character then
            pcall(function()
                local char = lp.Character
                -- Force hide default name
                char:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                -- Scrub all tags/guis
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v.Name:lower():find("tag") or v.Name:lower():find("name") then
                        v:Destroy()
                    end
                end
            end)
        end
    end
end)

-- [[ 5. ABSOLUTE UI BUILDER ]] --
local function BuildUI()
    local pgui = lp:WaitForChild("PlayerGui")
    if pgui:FindFirstChild("SKY_ELITE") then pgui.SKY_ELITE:Destroy() end
    
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKY_ELITE"
    Screen.ResetOnSpawn = false
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 185, 0, 400)
    Main.Position = UDim2.new(0.02, 0, 0.25, 0)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Main.Active = true
    Main.Draggable = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(0, 220, 255)
    Stroke.Thickness = 2

    local Header = Instance.new("TextLabel", Main)
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.Text = "SKYJACK ELITE v2400"
    Header.TextColor3 = Color3.new(1, 1, 1)
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 10
    Header.BackgroundTransparency = 1

    for i, name in ipairs(Names) do
        local b = Instance.new("TextButton", Main)
        b.Size = UDim2.new(1, -16, 0, 44)
        b.Position = UDim2.new(0, 8, 0, (i * 50) - 10)
        b.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Text = name .. " [OFF]"
        b.Font = Enum.Font.GothamBold
        b.TextSize = 8
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        table.insert(Buttons, b)
    end

    local function Refresh()
        for i, b in ipairs(Buttons) do
            local key = Keys[i]
            b.Text = Names[i] .. (T[key] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(22, 22, 26)
            b.TextColor3 = (i == Index) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
        end
    end

    uis.InputBegan:Connect(function(k, g)
        if k.KeyCode == Enum.KeyCode.L then Main.Visible = not Main.Visible end
        if g or not Main.Visible then return end
        if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh()
        elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
        elseif k.KeyCode == Enum.KeyCode.Return then 
            local key = Keys[Index] 
            T[key] = not T[key] Refresh()
        end
    end)
    Refresh()
end

BuildUI()
