-- [[ SKYJACK RBX v300: GHOST - ABSOLUTE STEALTH & JUMP FIX ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Master Logic
local Running = true
local Screen, Main, KeyPanel
local Toggles = {Speed = false, WallPass = false, InfJump = false, Vip = false, HideName = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield"}
local Names = {"OVERDRIVE SPEED", "WALL PASS", "INFINITE JUMP", "VIP INJECTION", "HIDE IDENTITY", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index = 1

-- [[ 1. THE GHOST ENGINE: TOTAL HIDE NAME ]] --
local function GhostIdentity()
    rs.Heartbeat:Connect(function()
        if Running and Toggles.HideName and lp.Character then
            pcall(function()
                local head = lp.Character:FindFirstChild("Head")
                local hum = lp.Character:FindFirstChildOfClass("Humanoid")
                
                -- Sembunyikan Nama Bawaan Roblox
                if hum then 
                    hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None 
                    hum.DisplayName = " "
                end
                
                -- HANCURKAN CUSTOM OVERHEAD (Penyebab nama masih muncul di gambar)
                if head then
                    for _, v in pairs(head:GetChildren()) do
                        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v.Name:lower():find("name") or v.Name:lower():find("gui") then
                            v:Destroy() -- Hapus permanen dari kepala
                        end
                    end
                end
                
                -- Sembunyikan dari Player List & Rank (Optional/Client Side)
                lp.DisplayName = " "
            end)
        end
    end)
end

-- [[ 2. INFINITE JUMP: RE-ENGINEERED ]] --
uis.JumpRequest:Connect(function()
    if Running and Toggles.InfJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Memaksa State Jumping tanpa peduli animasi atau cooldown game
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait()
            hum:ChangeState(Enum.HumanoidStateType.Falling)
        end
    end
end)

-- [[ 3. MOTION & CORE ]] --
local function StartCore()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        if Toggles.Shield and (getnamecallmethod() == "Kick" or getnamecallmethod() == "kick") then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)

    GhostIdentity()

    task.spawn(function()
        while Running and task.wait(0.5) do
            if Toggles.Vip and lp.Character:FindFirstChild("HumanoidRootPart") then
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

rs.Heartbeat:Connect(function()
    if not Running or not lp.Character then return end
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    local hum = lp.Character:FindFirstChild("Humanoid")
    if Toggles.Speed and root and hum and hum.MoveDirection.Magnitude > 0 then
        local target = (hum.SeatPart and hum.SeatPart.Parent:IsA("Model")) and hum.SeatPart.Parent.PrimaryPart or root
        target.CFrame = target.CFrame + (hum.MoveDirection * 2.3)
    end
    if Toggles.WallPass then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- [[ 4. LUXURY COMPACT UI DESIGN ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "GHOST_V300" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "GHOST_V300"
    Screen.IgnoreGuiInset = true

    -- LOGIN PANEL (Minimalist Neon)
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 260, 0, 180)
    KeyPanel.Position = UDim2.new(0.5, -130, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", KeyPanel).Color = Color3.fromRGB(0, 170, 255)

    local LHead = Instance.new("TextLabel", KeyPanel)
    LHead.Size = UDim2.new(1, 0, 0, 40)
    LHead.Text = "GHOST AUTHENTICATION"
    LHead.TextColor3 = Color3.fromRGB(0, 170, 255)
    LHead.BackgroundTransparency = 1
    LHead.Font = Enum.Font.GothamBold
    LHead.TextSize = 12

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
    KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    KeyInput.PlaceholderText = "PRODUCT KEY"
    KeyInput.Text = ""
    KeyInput.BackgroundTransparency = 1
    KeyInput.TextColor3 = Color3.new(1,1,1)
    KeyInput.Font = Enum.Font.Gotham

    local Line = Instance.new("Frame", KeyPanel)
    Line.Size = UDim2.new(0.8, 0, 0, 1)
    Line.Position = UDim2.new(0.1, 0, 0.4, 30)
    Line.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.8, 0, 0, 35)
    LoginBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    LoginBtn.Text = "AUTHENTICATE"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 6)

    -- MAIN HUB (Ramping)
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 170, 0, 360)
    Main.Position = UDim2.new(0.02, 0, 0.3, 0)
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    Main.BackgroundTransparency = 0.1
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 170, 255)

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

-- [[ 5. NAVIGATION ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(20, 20, 20)
        b.BackgroundTransparency = (i == Index) and 0 or 0.7
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -12, 0, 48)
    b.Position = UDim2.new(0, 6, 0, (i * 54) - 20)
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
        Refresh() 
    end
end)

Refresh()
