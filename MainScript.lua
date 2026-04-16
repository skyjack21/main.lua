-- [[ SKYJACK RBX v1400: PRO-LIVE - STEALTH AUTO WALK & STABLE SPEED ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Master Reset
local Running = true
local Screen, Main, KeyPanel
local Toggles = {Speed = false, WallPass = false, InfJump = false, Vip = false, HideName = false, Shield = false, AutoWalk = false}
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield", "AutoWalk"}
local Names = {"ULTRA FAST SPEED", "WALL PASS", "INFINITE JUMP", "VIP AUTO PASS", "GHOST IDENTITY", "ANTI-KICK SHIELD", "STEALTH AUTO WALK"}
local Buttons = {}
local Index = 1

-- [[ 1. STEALTH GHOST LOGIC ]] --
local function GhostLogic()
    task.spawn(function()
        while Running do
            if Toggles.HideName and lp.Character then
                pcall(function()
                    lp.Character:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    for _, v in pairs(lp.Character:GetDescendants()) do
                        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v.Name:lower():find("name") then v:Destroy() end
                    end
                end)
            end
            task.wait(0.1)
        end
    end)
end

-- [[ 2. PRO PHYSICS & AUTO WALK (NO LINES) ]] --
local PathfindingService = game:GetService("PathfindingService")
rs.Heartbeat:Connect(function()
    if not Running or not lp.Character then return end
    local hum = lp.Character:FindFirstChildOfClass("Humanoid")
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- ULTRA SPEED (Normal physics, no flipping)
    if Toggles.Speed and hum.MoveDirection.Magnitude > 0 then
        local target = (hum.SeatPart and hum.SeatPart.Parent:IsA("Model")) and (hum.SeatPart.Parent.PrimaryPart or hum.SeatPart) or root
        local moveDir = hum.MoveDirection
        -- Speed disetel kencang (115) tapi tetap memijak tangga
        target.AssemblyLinearVelocity = Vector3.new(moveDir.X * 115, target.AssemblyLinearVelocity.Y, moveDir.Z * 115)
    end

    -- AUTO WALK LOGIC (Stealth Mode)
    if Toggles.AutoWalk and not Toggles.Speed then
        -- Mencari checkpoint atau tujuan tertinggi (Summit) secara otomatis
        local targetObj = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit")
        if targetObj then
            hum:MoveTo(targetObj.Position)
        end
    end

    -- NOCLIP
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

-- [[ 3. VIP & ANTI-KICK INJECTION ]] --
local function StartInjections()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        if Toggles.Shield and (getnamecallmethod() == "Kick" or getnamecallmethod() == "kick") then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)
    
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

-- [[ 4. PRO UI BUILD ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "PRO_LIVE_V1400" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "PRO_LIVE_V1400"
    Screen.IgnoreGuiInset = true

    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 240, 0, 150)
    KeyPanel.Position = UDim2.new(0.5, -120, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", KeyPanel).Color = Color3.fromRGB(0, 160, 255)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
    KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
    KeyInput.PlaceholderText = "ENTER PRODUCT KEY"
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.new(1,1,1)
    KeyInput.BackgroundTransparency = 1
    KeyInput.Font = Enum.Font.Gotham

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.8, 0, 0, 35)
    LoginBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    LoginBtn.Text = "LOG IN"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 5)

    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 170, 0, 380)
    Main.Position = UDim2.new(0.02, 0, 0.25, 0)
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 160, 255)

    LoginBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy() Main.Visible = true StartInjections() GhostLogic() Toggles.Shield = true
            end
        end
    end)
end

BuildUI()

local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(20, 20, 25)
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -12, 0, 45)
    b.Position = UDim2.new(0, 6, 0, (i * 50) - 30)
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
        local key = Keys[Index] Toggles[key] = not Toggles[key] Refresh() 
    end
end)

Refresh()
