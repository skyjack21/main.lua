-- [[ SKYJACK RBX v2100: SUPREME-OVERLOAD - NO CODE CUT ]] --
-- Global Setup & Services
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local PathfindingService = game:GetService("PathfindingService")
local StarterGui = game:GetService("StarterGui")

-- Global Environment (Persistent across resets)
getgenv().SkyjackToggles = getgenv().SkyjackToggles or {
    Speed = false,
    WallPass = false,
    InfJump = false,
    Vip = false,
    HideName = false,
    Shield = false,
    AutoWalk = false
}

local Toggles = getgenv().SkyjackToggles
local Running = true
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield", "AutoWalk"}
local Names = {"SUPREME SPEED (EXTREME)", "GHOST NOCLIP (ALL)", "PHYSICAL INF JUMP", "ULTRA VIP BYPASS", "GHOST IDENTITY (DEEP)", "ANTI-KICK SHIELD", "AUTO SUMMIT (STEALTH)"}
local Buttons = {}
local Index = 1

-- [[ 1. SECURITY & BYPASS MODULE (METATABLE) ]] --
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- ANTI-KICK BYPASS
    if Toggles.Shield and (method == "Kick" or method == "kick") then
        warn("SKYJACK: Blocked an attempt to kick you.")
        return nil
    end
    
    -- VIP & GAMEPASS BYPASS
    if Toggles.Vip then
        if method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset" or method == "CheckGamepass" or method == "GetProductInfo" then
            return true
        end
    end
    
    return oldNamecall(self, unpack(args))
end)

mt.__index = newcclosure(function(t, k)
    if Toggles.Vip then
        if k == "UserOwnsGamePassAsync" or k == "PlayerOwnsAsset" then
            return function() return true end
        end
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

-- [[ 2. IDENTITY MASKING MODULE (GHOST) ]] --
task.spawn(function()
    while task.wait(0.01) do -- Ultra fast scan for live stream
        if Toggles.HideName and lp.Character then
            pcall(function()
                local char = lp.Character
                -- Hide Humanoid Name
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
                
                -- Recursive Clean
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("TextLabel") or v:IsA("ImageLabel") or v.Name:lower():find("tag") or v.Name:lower():find("name") then
                        if v:IsA("GuiObject") then
                            v.Visible = false
                        elseif v:IsA("LayerCollector") then
                            v.Enabled = false
                        end
                        v:Destroy()
                    end
                end
            end)
        end
    end
end)

-- [[ 3. PHYSICAL MOVEMENT MODULE (SPEED & AUTO) ]] --
rs.RenderStepped:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local hum = lp.Character:FindFirstChildOfClass("Humanoid")
    
    -- SPEED EXTREME (1.55 Scale) - Optimized for Stairs
    if Toggles.Speed and hum.MoveDirection.Magnitude > 0 then
        local activeObj = (hum.SeatPart and hum.SeatPart.Parent:IsA("Model")) and (hum.SeatPart.Parent.PrimaryPart or hum.SeatPart) or root
        -- Menggunakan pergerakan Frame-Alignment agar tidak terlempar
        activeObj.CFrame = activeObj.CFrame + (hum.MoveDirection * 1.55)
    end

    -- AUTO SUMMIT (Stealth Mode)
    if Toggles.AutoWalk then
        local target = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit") or workspace:FindFirstChild("End") or workspace:FindFirstChild("Finish")
        if target then
            hum:MoveTo(target.Position)
        end
    end

    -- NOCLIP LOGIC
    if Toggles.WallPass then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    else
        for _, v in pairs(lp.Character:GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.CanCollide = true end
        end
    end
end)

-- [[ 4. JUMP & UTILITY MODULE ]] --
task.spawn(function()
    uis.JumpRequest:Connect(function()
        if Toggles.InfJump and lp.Character then
            local hum = lp.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end)

-- [[ 5. SUPREME UI INTERFACE ]] --
local function BuildUI()
    local pgui = lp:WaitForChild("PlayerGui")
    if pgui:FindFirstChild("SKYJACK_SUPREME") then pgui.SKYJACK_SUPREME:Destroy() end
    
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_SUPREME"
    Screen.IgnoreGuiInset = true
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 190, 0, 400)
    Main.Position = UDim2.new(0.02, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(0, 255, 150)
    Stroke.Thickness = 1.5

    local Header = Instance.new("TextLabel", Main)
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.Text = "SKYJACK SUPREME v2100"
    Header.TextColor3 = Color3.new(1,1,1)
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 10
    Header.BackgroundTransparency = 1

    for i, name in ipairs(Names) do
        local b = Instance.new("TextButton", Main)
        b.Size = UDim2.new(1, -16, 0, 42)
        b.Position = UDim2.new(0, 8, 0, (i * 48) - 5)
        b.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Text = name .. " [OFF]"
        b.Font = Enum.Font.GothamBold
        b.TextSize = 8
        b.AutoButtonColor = true
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        table.insert(Buttons, b)
    end

    local function Refresh()
        for i, b in ipairs(Buttons) do
            local key = Keys[i]
            b.Text = Names[i] .. (Toggles[key] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(20, 20, 25)
            b.TextColor3 = (i == Index) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
        end
    end

    uis.InputBegan:Connect(function(k, g)
        if k.KeyCode == Enum.KeyCode.L then Main.Visible = not Main.Visible end
        if g or not Main.Visible then return end
        if k.KeyCode == Enum.KeyCode.Up then 
            Index = (Index > 1) and Index - 1 or #Names 
            Refresh()
        elseif k.KeyCode == Enum.KeyCode.Down then 
            Index = (Index < #Names) and Index + 1 or 1 
            Refresh()
        elseif k.KeyCode == Enum.KeyCode.Return then 
            local key = Keys[Index] 
            Toggles[key] = not Toggles[key] 
            Refresh()
        end
    end)
    Refresh()
end

-- Start Script
BuildUI()
StarterGui:SetCore("SendNotification", {
    Title = "SKYJACK SUPREME",
    Text = "Press 'L' to Toggle Menu",
    Duration = 5
})
