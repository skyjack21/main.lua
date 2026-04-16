-- [[ SKYJACK RBX v250: FINAL ULTIMATUM - FULLY FUNCTIONAL ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- System State
local Screen, Main, KeyPanel
local Toggles = {Speed = false, WallPass = false, InfJump = false, Vip = false, HideName = false, FakeName = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "FakeName", "Shield"}
local Names = {"OVERDRIVE SPEED", "WALL PASS (NOCLIP)", "INFINITE JUMP", "VIP PASS INJECTION", "HIDE NAMETAG", "FAKE IDENTITY", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index = 1

-- [[ 1. THE CORE: FUNCTIONAL INJECTION ]] --
local function InitializeInjections()
    -- ANTI-BAN: Mematikan fungsi Kick & Crash dari Server
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if Toggles.Shield and (method == "Kick" or method == "kick" or method == "BreakJoints") then
            return nil 
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)

    -- VIP ACCESS: Paksa Trigger sensor pintu VIP
    task.spawn(function()
        while task.wait(0.5) do
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

-- [[ 2. PHYSICS ENGINE: NO-GLITCH MOTION ]] --
rs.PreRender:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if root and hum then
        -- SPEED: Menggunakan kalkulasi posisi murni tanpa merusak gravitasi
        if Toggles.Speed and hum.MoveDirection.Magnitude > 0 then
            local moveOffset = hum.MoveDirection * 1.9
            root.CFrame = root.CFrame + Vector3.new(moveOffset.X, 0, moveOffset.Z)
        end

        -- WALL PASS: Total collision disabler
        if Toggles.WallPass then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end

        -- IDENTITY CONTROL
        if Toggles.HideName then
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            if char:FindFirstChild("Head") and char.Head:FindFirstChildOfClass("BillboardGui") then
                char.Head:FindFirstChildOfClass("BillboardGui").Enabled = false
            end
        end
    end
end)

-- Infinite Jump: Direct State Injection
uis.JumpRequest:Connect(function()
    if Toggles.InfJump and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- [[ 3. DESIGN: 2026 PRESTIGE UI ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "ULTIMATUM_HUB" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "ULTIMATUM_HUB"

    -- LOGIN (ELEGANT DARK)
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 420, 0, 320)
    KeyPanel.Position = UDim2.new(0.5, -210, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 20)
    local sK = Instance.new("UIStroke", KeyPanel)
    sK.Color = Color3.fromRGB(0, 140, 255)
    sK.Thickness = 1.5

    local LHeader = Instance.new("TextLabel", KeyPanel)
    LHeader.Size = UDim2.new(1, 0, 0, 65)
    LHeader.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
    LHeader.Text = "SKYJACK PRESTIGE ACCESS"
    LHeader.TextColor3 = Color3.fromRGB(0, 140, 255)
    LHeader.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LHeader).CornerRadius = UDim.new(0, 20)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 50)
    KeyInput.Position = UDim2.new(0.075, 0, 0.45, 0)
    KeyInput.PlaceholderText = "ENTER PRODUCT LICENSE"
    KeyInput.BackgroundColor3 = Color3.fromRGB(20, 21, 26)
    KeyInput.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 10)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.85, 0, 0, 60)
    LoginBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
    LoginBtn.Text = "VALIDATE & LAUNCH"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 10)

    -- MAIN HUB (ONYX GLASS)
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 320, 0, 640)
    Main.Position = UDim2.new(0.05, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
    local sM = Instance.new("UIStroke", Main)
    sM.Color = Color3.fromRGB(0, 140, 255)
    sM.Thickness = 1.5

    local MTitle = Instance.new("TextLabel", Main)
    MTitle.Size = UDim2.new(1, 0, 0, 65)
    MTitle.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
    MTitle.Text = "ULTIMATUM v250"
    MTitle.TextColor3 = Color3.fromRGB(0, 140, 255)
    MTitle.Font = Enum.Font.GothamBold
    Instance.new("UICorner", MTitle).CornerRadius = UDim.new(0, 20)

    LoginBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy()
                Main.Visible = true
                InitializeInjections()
                Toggles.Shield = true -- Auto-active Anti-Ban
            end
        end
    end)
end

BuildUI()

-- [[ 4. NAVIGATION ENGINE ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ACTIVE]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(20, 21, 26)
        b.BackgroundTransparency = (i == Index) and 0 or 0.6
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -30, 0, 75)
    b.Position = UDim2.new(0, 15, 0, (i * 80) - 10)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.F8 then Screen:Destroy() end
    if g or not Main.Visible then return end
    
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh()
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then 
        local key = Keys[Index]
        Toggles[key] = not Toggles[key]
        Refresh() 
    end
end)

Refresh()
