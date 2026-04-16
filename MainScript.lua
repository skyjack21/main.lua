-- [[ SKYJACK RBX v320: APEX - THE FINAL CORE AUDIT ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Apex Global Control
local Running = true
local Screen, Main, KeyPanel
local Toggles = {Speed = false, WallPass = false, InfJump = false, Vip = false, HideName = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield"}
local Names = {"OVERDRIVE SPEED", "WALL PASS (NOCLIP)", "INFINITE JUMP", "VIP PASS INJECT", "GHOST IDENTITY", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index = 1
local SpeedFactor = 2.45

-- [[ 1. ABSOLUTE STEALTH & IDENTITY ENGINE ]] --
local function StealthLogic(char)
    if not char then return end
    task.spawn(function()
        while Running and char.Parent do
            if Toggles.HideName then
                pcall(function()
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        hum.DisplayName = " "
                    end
                    -- Menghancurkan semua Tag secara agresif
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v.Name:lower():find("name") then
                            v:Destroy()
                        end
                    end
                end)
            end
            task.wait(0.1)
        end
    end)
end

lp.CharacterAdded:Connect(StealthLogic)

-- [[ 2. CORE FUNCTIONALITY (VIP, JUMP, SHIELD) ]] --
local function InitializeApexCore()
    -- ANTI-BAN (Staff/Owner Shield)
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if Toggles.Shield and (method == "Kick" or method == "kick") then
            return nil 
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)

    -- VIP Pass Injector
    task.spawn(function()
        while Running and task.wait(0.5) do
            if Toggles.Vip and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
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

-- Infinite Jump (Always Functional)
uis.JumpRequest:Connect(function()
    if Running and Toggles.InfJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Physics Loop (Speed & Noclip)
rs.Heartbeat:Connect(function()
    if not Running or not lp.Character then return end
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    local hum = lp.Character:FindFirstChild("Humanoid")

    if Toggles.Speed and root and hum and hum.MoveDirection.Magnitude > 0 then
        -- Mount Compatibility: Detect if riding something
        local moveTarget = (hum.SeatPart and hum.SeatPart.Parent:IsA("Model")) and hum.SeatPart.Parent.PrimaryPart or root
        moveTarget.CFrame = moveTarget.CFrame + (hum.MoveDirection * SpeedFactor)
    end

    if Toggles.WallPass then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- [[ 3. DESIGN: APEX SLIM UI (THE ULTIMATE DESIGN) ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "APEX_V320" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "APEX_V320"
    Screen.IgnoreGuiInset = true

    -- LUXURY LOGIN (250px Compact)
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 250, 0, 160)
    KeyPanel.Position = UDim2.new(0.5, -125, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", KeyPanel).Color = Color3.fromRGB(0, 160, 255)

    local LHead = Instance.new("TextLabel", KeyPanel)
    LHead.Size = UDim2.new(1, 0, 0, 35)
    LHead.Text = "APEX AUTHENTICATION"
    LHead.TextColor3 = Color3.fromRGB(0, 160, 255)
    LHead.BackgroundTransparency = 1
    LHead.Font = Enum.Font.GothamBold
    LHead.TextSize = 10

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.8, 0, 0, 25)
    KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    KeyInput.PlaceholderText = "PRODUCT LICENSE"
    KeyInput.Text = ""
    KeyInput.BackgroundTransparency = 1
    KeyInput.TextColor3 = Color3.new(1,1,1)
    KeyInput.Font = Enum.Font.Gotham

    local Line = Instance.new("Frame", KeyPanel)
    Line.Size = UDim2.new(0.8, 0, 0, 1)
    Line.Position = UDim2.new(0.1, 0, 0.4, 25)
    Line.BackgroundColor3 = Color3.fromRGB(0, 160, 255)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.8, 0, 0, 32)
    LoginBtn.Position = UDim2.new(0.1, 0, 0.72, 0)
    LoginBtn.Text = "AUTHENTICATE"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 4)

    -- FLOATING HUB (165px Width)
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 165, 0, 340)
    Main.Position = UDim2.new(0.02, 0, 0.3, 0)
    Main.BackgroundColor3 = Color3.fromRGB(8, 9, 11)
    Main.BackgroundTransparency = 0.1
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 160, 255)

    LoginBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy()
                Main.Visible = true
                InitializeApexCore()
                StealthLogic(lp.Character)
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
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(15, 16, 20)
        b.BackgroundTransparency = (i == Index) and 0 or 0.6
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -12, 0, 45)
    b.Position = UDim2.new(0, 6, 0, (i * 50) - 15)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 8
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
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
        if key == "HideName" then StealthLogic(lp.Character) end
        Refresh() 
    end
end)

Refresh()
