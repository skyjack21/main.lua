-- [[ SKYJACK RBX v260: ZENITH EDITION - TOP TIME OPTIMIZED ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Zenith States
local Screen, Main, KeyPanel
local Toggles = {Speed = false, WallPass = false, InfJump = false, Vip = false, HideName = false, FakeName = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "FakeName", "Shield"}
local Names = {"ZENITH OVERDRIVE", "NOCLIP OVERRIDE", "AIR JUMP SYSTEM", "PREMIUM VIP INJECT", "GHOST IDENTITY", "RENAME IDENTITY", "SHIELD PROTECT"}
local Buttons = {}
local Index = 1
local TargetSpeed = 2.1 -- Optimal Top Time Speed

-- [[ 1. SYSTEM CORE: PROTECTION & VIP ]] --
local function InitializeSystem()
    -- Anti-Ban Hook
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if Toggles.Shield and (method == "Kick" or method == "kick") then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)

    -- VIP & Mount Logic
    task.spawn(function()
        while task.wait(0.5) do
            if Toggles.Vip then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and (v.Parent.Name:lower():find("vip") or v.Parent.Name:lower():find("pass")) then
                        firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end
        end
    end)
end

-- [[ 2. PHYSICS ENGINE: TOP TIME & MOUNT MODE ]] --
rs.Heartbeat:Connect(function()
    local char = lp.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    
    if Toggles.Speed and root and hum and hum.MoveDirection.Magnitude > 0 then
        -- Cek jika karakter sedang menaiki Mount
        local moveObj = (hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent:IsA("Model")) and hum.SeatPart.Parent.PrimaryPart or root
        
        -- Linear Offset (Top Time Optimization)
        local offset = hum.MoveDirection * TargetSpeed
        moveObj.CFrame = moveObj.CFrame + Vector3.new(offset.X, 0, offset.Z)
    end

    if Toggles.WallPass then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    if Toggles.HideName then
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
end)

-- Infinite Jump
uis.JumpRequest:Connect(function()
    if Toggles.InfJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [[ 3. DESIGN: ZENITH OBSIDIAN UI ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "ZENITH_HUB" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "ZENITH_HUB"
    Screen.ResetOnSpawn = false

    -- LOGIN (OBSIDIAN)
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 400, 0, 320)
    KeyPanel.Position = UDim2.new(0.5, -200, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 15)
    local sK = Instance.new("UIStroke", KeyPanel)
    sK.Color = Color3.fromRGB(0, 150, 255)
    sK.Thickness = 2

    local LHead = Instance.new("TextLabel", KeyPanel)
    LHead.Size = UDim2.new(1, 0, 0, 60)
    LHead.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    LHead.Text = "ZENITH ACCESS PROTOCOL"
    LHead.TextColor3 = Color3.fromRGB(0, 150, 255)
    LHead.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LHead).CornerRadius = UDim.new(0, 15)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 50)
    KeyInput.Position = UDim2.new(0.075, 0, 0.45, 0)
    KeyInput.PlaceholderText = "ENTER LICENSE KEY..."
    KeyInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    KeyInput.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.85, 0, 0, 60)
    LoginBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
    LoginBtn.Text = "VALIDATE & INJECT"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 8)

    -- MAIN HUB
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 300, 0, 620)
    Main.Position = UDim2.new(0.05, 0, 0.15, 0)
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    local sM = Instance.new("UIStroke", Main)
    sM.Color = Color3.fromRGB(0, 150, 255)
    sM.Thickness = 2

    local MHead = Instance.new("TextLabel", Main)
    MHead.Size = UDim2.new(1, 0, 0, 60)
    MHead.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    MHead.Text = "ZENITH HUB v260"
    MHead.TextColor3 = Color3.fromRGB(0, 150, 255)
    MHead.Font = Enum.Font.GothamBold
    Instance.new("UICorner", MHead).CornerRadius = UDim.new(0, 15)

    LoginBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy()
                Main.Visible = true
                InitializeSystem()
                Toggles.Shield = true
            end
        end
    end)
end

BuildUI()

-- [[ 4. NAVIGATION ENGINE & TOGGLE FIXED ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ACTIVE]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(15, 15, 20)
        b.BackgroundTransparency = (i == Index) and 0 or 0.6
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -30, 0, 75)
    b.Position = UDim2.new(0, 15, 0, (i * 80) - 10)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    -- Global UI Toggle (L)
    if k.KeyCode == Enum.KeyCode.L then
        if Main then Main.Visible = not Main.Visible end
    end
    
    if g or not Main or not Main.Visible then return end
    
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh()
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then 
        local key = Keys[Index]
        Toggles[key] = not Toggles[key]
        Refresh() 
    end
end)

Refresh()
