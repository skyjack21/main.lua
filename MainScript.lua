-- [[ SKYJACK RBX v290: PHANTOM - THE STEALTH ULTIMATUM ]] --
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
local SpeedVal = 2.3 -- Optimized Top Time Speed

-- [[ 1. THE STEALTH ENGINE (HIDE NAME FIX) ]] --
local function SecureIdentity()
    rs.RenderStepped:Connect(function()
        if Running and Toggles.HideName and lp.Character then
            pcall(function()
                local hum = lp.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    hum.DisplayName = "" -- Menghapus nama di papan nama
                end
                -- Menghapus semua BillboardGui di kepala (Tag Nama Game)
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BillboardGui") then v.Enabled = false end
                end
            end)
        end
    end)
end

-- [[ 2. PHYSICS & CORE ]] --
local function StartCore()
    -- Anti-Ban (Staff Deflector)
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        if Toggles.Shield and (getnamecallmethod() == "Kick" or getnamecallmethod() == "kick") then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)

    SecureIdentity() -- Jalankan fungsi hide name

    -- VIP Injector Loop
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
        target.CFrame = target.CFrame + (hum.MoveDirection * SpeedVal)
    end
    if Toggles.WallPass then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- [[ 3. DESIGN: PHANTOM MINIMALIST (TINY & CLEAN) ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "PHANTOM_HUB" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "PHANTOM_HUB"

    -- TINY LOGIN PANEL (260px Width)
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 260, 0, 180)
    KeyPanel.Position = UDim2.new(0.5, -130, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", KeyPanel).Color = Color3.fromRGB(0, 170, 255)

    local LHead = Instance.new("TextLabel", KeyPanel)
    LHead.Size = UDim2.new(1, 0, 0, 35)
    LHead.Text = "PHANTOM ACCESS"
    LHead.TextColor3 = Color3.fromRGB(0, 170, 255)
    LHead.BackgroundTransparency = 1
    LHead.Font = Enum.Font.GothamBold

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
    KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
    KeyInput.PlaceholderText = "PRODUCT KEY"
    KeyInput.Text = ""
    KeyInput.BackgroundTransparency = 1
    KeyInput.TextColor3 = Color3.new(1,1,1)
    KeyInput.Font = Enum.Font.Gotham

    local Line = Instance.new("Frame", KeyPanel)
    Line.Size = UDim2.new(0.8, 0, 0, 1)
    Line.Position = UDim2.new(0.1, 0, 0.35, 30)
    Line.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.8, 0, 0, 35)
    LoginBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    LoginBtn.Text = "AUTHENTICATE"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 6)

    -- RAMPING MAIN HUB (180px Width)
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 180, 0, 360)
    Main.Position = UDim2.new(0.02, 0, 0.3, 0)
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    Main.BackgroundTransparency = 0.15
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 170, 255)

    local MHead = Instance.new("TextLabel", Main)
    MHead.Size = UDim2.new(1, 0, 0, 35)
    MHead.Text = "PHANTOM v290"
    MHead.TextColor3 = Color3.fromRGB(0, 170, 255)
    MHead.BackgroundTransparency = 1
    MHead.Font = Enum.Font.GothamBold

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

-- [[ 4. NAVIGATION ]] --
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
    b.Size = UDim2.new(1, -16, 0, 45)
    b.Position = UDim2.new(0, 8, 0, (i * 52) - 10)
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
