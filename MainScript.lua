-- [[ SKYJACK RBX v280: SPECTRUM PRESTIGE ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- System Control
local Running = true
local Screen, Main, KeyPanel
local Toggles = {Speed = false, WallPass = false, InfJump = false, Vip = false, HideName = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield"}
local Names = {"OVERDRIVE SPEED", "WALL PASS", "INFINITE JUMP", "VIP INJECTION", "HIDE IDENTITY", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index = 1
local SpeedVal = 2.25

-- [[ 1. THE CORE: FUNCTIONAL FIXES ]] --
local function StartCore()
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

    -- Persistent Loop for VIP & Hide Name
    task.spawn(function()
        while Running do
            if Toggles.Vip then
                pcall(function()
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("TouchTransmitter") and (v.Parent.Name:lower():find("vip") or v.Parent.Name:lower():find("pass")) then
                            firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 0)
                            firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 1)
                        end
                    end
                end)
            end
            if Toggles.HideName and lp.Character then
                pcall(function()
                    local hum = lp.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
                    for _, v in pairs(lp.Character:GetDescendants()) do
                        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then v.Enabled = false end
                    end
                end)
            end
            task.wait(0.5)
        end
    end)
end

-- [[ 2. MOTION ENGINE ]] --
rs.Heartbeat:Connect(function()
    if not Running or not lp.Character then return end
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    local hum = lp.Character:FindFirstChild("Humanoid")
    
    if Toggles.Speed and root and hum and hum.MoveDirection.Magnitude > 0 then
        local target = (hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent:IsA("Model")) and hum.SeatPart.Parent.PrimaryPart or root
        target.CFrame = target.CFrame + (hum.MoveDirection * SpeedVal)
    end

    if Toggles.WallPass then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

uis.JumpRequest:Connect(function()
    if Running and Toggles.InfJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [[ 3. DESIGN: SPECTRUM PRESTIGE UI ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "SPECTRUM_ULTRA" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SPECTRUM_ULTRA"
    Screen.ResetOnSpawn = false

    -- LUXURY KEY INTERFACE
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 340, 0, 240)
    KeyPanel.Position = UDim2.new(0.5, -170, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 12)
    local sK = Instance.new("UIStroke", KeyPanel)
    sK.Color = Color3.fromRGB(0, 170, 255)
    sK.Thickness = 1.2

    local LHead = Instance.new("TextLabel", KeyPanel)
    LHead.Size = UDim2.new(1, 0, 0, 45)
    LHead.Text = "SPECTRUM PRESTIGE"
    LHead.TextColor3 = Color3.fromRGB(0, 170, 255)
    LHead.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    LHead.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LHead).CornerRadius = UDim.new(0, 12)

    -- Modern Key Input (No Border, Custom Underline)
    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.8, 0, 0, 35)
    KeyInput.Position = UDim2.new(0.1, 0, 0.45, 0)
    KeyInput.PlaceholderText = "ENTER ACCESS KEY"
    KeyInput.Text = ""
    KeyInput.BackgroundTransparency = 1
    KeyInput.TextColor3 = Color3.new(1,1,1)
    KeyInput.Font = Enum.Font.Gotham

    local Line = Instance.new("Frame", KeyPanel)
    Line.Size = UDim2.new(0.8, 0, 0, 2)
    Line.Position = UDim2.new(0.1, 0, 0.45, 35)
    Line.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.8, 0, 0, 45)
    LoginBtn.Position = UDim2.new(0.1, 0, 0.72, 0)
    LoginBtn.Text = "AUTHENTICATE"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 8)

    -- MINIMALIST HUB
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 210, 0, 420)
    Main.Position = UDim2.new(0.02, 0, 0.25, 0)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Main.BackgroundTransparency = 0.1
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local sM = Instance.new("UIStroke", Main)
    sM.Color = Color3.fromRGB(0, 170, 255)
    sM.Thickness = 1.2

    local MHead = Instance.new("TextLabel", Main)
    MHead.Size = UDim2.new(1, 0, 0, 40)
    MHead.Text = "SPECTRUM v280"
    MHead.TextColor3 = Color3.fromRGB(0, 170, 255)
    MHead.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    MHead.Font = Enum.Font.GothamBold
    Instance.new("UICorner", MHead).CornerRadius = UDim.new(0, 12)

    LoginBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy()
                Main.Visible = true
                StartCore()
                Toggles.Shield = true
            end
        end
    end)
end

BuildUI()

-- [[ 4. NAVIGATION SYSTEM ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(20, 20, 22)
        b.BackgroundTransparency = (i == Index) and 0 or 0.6
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -20, 0, 55)
    b.Position = UDim2.new(0, 10, 0, (i * 62) - 15)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 9
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.F8 then Running = false Screen:Destroy() end
    if k.KeyCode == Enum.KeyCode.L then if Main then Main.Visible = not Main.Visible end end
    
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
