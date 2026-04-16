-- [[ SKYJACK RBX v270: SPECTRUM - COMPACT PRESTIGE EDITION ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Spectrum States
local Screen, Main, KeyPanel
local Running = true
local Toggles = {Speed = false, WallPass = false, InfJump = false, Vip = false, HideName = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield"}
local Names = {"OVERDRIVE SPEED", "WALL PASS", "INFINITE JUMP", "VIP INJECTION", "HIDE IDENTITY", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index = 1
local SpeedVal = 2.2 -- Precise Top Time Velocity

-- [[ 1. INTERNAL CORE ]] --
local function CoreInjections()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if Toggles.Shield and (method == "Kick" or method == "kick") then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)

    task.spawn(function()
        while Running and task.wait(0.5) do
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

-- [[ 2. MOVEMENT ENGINE ]] --
rs.Heartbeat:Connect(function()
    if not Running or not lp.Character then return end
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    local hum = lp.Character:FindFirstChild("Humanoid")
    
    if Toggles.Speed and root and hum and hum.MoveDirection.Magnitude > 0 then
        -- Mount Support: Pushes the primary part of the mount if seated
        local target = (hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent:IsA("Model")) and hum.SeatPart.Parent.PrimaryPart or root
        target.CFrame = target.CFrame + (hum.MoveDirection * SpeedVal)
    end

    if Toggles.WallPass and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    if Toggles.HideName and hum then
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
end)

uis.JumpRequest:Connect(function()
    if Running and Toggles.InfJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [[ 3. DESIGN: SPECTRUM SLIM UI (DARK GLASS) ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "SPECTRUM_V270" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SPECTRUM_V270"
    Screen.ResetOnSpawn = false

    -- COMPACT LOGIN
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 320, 0, 260)
    KeyPanel.Position = UDim2.new(0.5, -160, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 12)
    local sK = Instance.new("UIStroke", KeyPanel)
    sK.Color = Color3.fromRGB(0, 180, 255)
    sK.Thickness = 1.2

    local LHead = Instance.new("TextLabel", KeyPanel)
    LHead.Size = UDim2.new(1, 0, 0, 50)
    LHead.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LHead.Text = "LICENSE VERIFICATION"
    LHead.TextColor3 = Color3.fromRGB(0, 180, 255)
    LHead.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LHead).CornerRadius = UDim.new(0, 12)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
    KeyInput.Position = UDim2.new(0.075, 0, 0.42, 0)
    KeyInput.PlaceholderText = "ENTER PRODUCT KEY"
    KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    KeyInput.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.85, 0, 0, 50)
    LoginBtn.Position = UDim2.new(0.075, 0, 0.7, 0)
    LoginBtn.Text = "AUTHENTICATE"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 8)

    -- SLIM MAIN HUB (Minimalist)
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 240, 0, 480)
    Main.Position = UDim2.new(0.02, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.BackgroundTransparency = 0.2
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local sM = Instance.new("UIStroke", Main)
    sM.Color = Color3.fromRGB(0, 180, 255)
    sM.Thickness = 1.2

    local MHead = Instance.new("TextLabel", Main)
    MHead.Size = UDim2.new(1, 0, 0, 50)
    MHead.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MHead.Text = "SPECTRUM v270"
    MHead.TextColor3 = Color3.fromRGB(0, 180, 255)
    MHead.Font = Enum.Font.GothamBold
    Instance.new("UICorner", MHead).CornerRadius = UDim.new(0, 12)

    LoginBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy()
                Main.Visible = true
                CoreInjections()
                Toggles.Shield = true
            end
        end
    end)
end

BuildUI()

-- [[ 4. INPUT & TOGGLE ENGINE ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 30, 30)
        b.BackgroundTransparency = (i == Index) and 0 or 0.6
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -24, 0, 60)
    b.Position = UDim2.new(0, 12, 0, (i * 68) - 10)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    -- HARD KILL (F8)
    if k.KeyCode == Enum.KeyCode.F8 then
        Running = false
        Screen:Destroy()
    end

    -- UI TOGGLE (L) - Persistent in Background
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
