-- [[ SKYJACK RBX v370: ELEVATE-PRO - STAIRS & SLOPE MASTER ]] --
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
local Names = {"OVERDRIVE SPEED", "WALL PASS", "INFINITE JUMP", "VIP PASS INJECT", "HIDE IDENTITY", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index = 1
local SpeedFactor = 2.3 -- Optimized Top Time Speed

-- [[ 1. THE STEALTH ENGINE (HIDE NAME FIX) ]] --
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
                    -- Hancurkan custom overhead (Tag Nama Game)
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

-- [[ 2. PHYSICS ENGINE: STEP & STAIRS CORRECTION ]] --
rs.Heartbeat:Connect(function()
    if not Running or not lp.Character then return end
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    local hum = lp.Character:FindFirstChild("Humanoid")

    if Toggles.Speed and root and hum and hum.MoveDirection.Magnitude > 0 then
        local moveObj = (hum.SeatPart and hum.SeatPart.Parent:IsA("Model")) and hum.SeatPart.Parent.PrimaryPart or root
        
        -- Kalkulasi pergerakan horizontal
        local moveDir = hum.MoveDirection * SpeedFactor
        local nextPos = moveObj.Position + moveDir
        
        -- SLOPE & STAIRS FIX: Deteksi media di depan kaki (agar tidak nembus)
        local rayAhead = workspace:Raycast(moveObj.Position, hum.MoveDirection * 3)
        local floorY = moveObj.Position.Y
        local targetYOffset = 3 -- Default Height
        
        if rayAhead and not Toggles.WallPass then
            -- Jika menabrak media (tanjakan/tangga), beri boost vertikal
            targetYOffset = 4.8 -- Lift character over steps
        else
            -- Menjaga agar karakter tetap menempel di tanah (jika tidak nembus)
            local rayDown = workspace:Raycast(moveObj.Position, Vector3.new(0, -5, 0))
            if rayDown then floorY = rayDown.Position.Y end
        end
        
        moveObj.CFrame = CFrame.new(nextPos.X, floorY + targetYOffset, nextPos.Z) * moveObj.CFrame.Rotation
    end

    -- Wall Pass Control
    if Toggles.WallPass then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    else
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.CanCollide = true end
        end
    end
end)

-- Infinite Jump
uis.JumpRequest:Connect(function()
    if Running and Toggles.InfJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [[ 3. DESIGN: APEX SLIM UI (THE FINAL DESIGN) ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "ELEVATE_V370" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "ELEVATE_V370"
    Screen.IgnoreGuiInset = true

    -- LUXURY LOGIN (250px Compact)
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 250, 0, 160)
    KeyPanel.Position = UDim2.new(0.5, -125, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", KeyPanel).Color = Color3.fromRGB(0, 160, 255)

    local LHead = Instance.new("TextLabel", KeyPanel)
    LHead.Size = UDim2.new(1, 0, 0, 35)
    LHead.Text = "SPECTRUM AUTH"
    LHead.TextColor3 = Color3.fromRGB(0, 160, 255)
    LHead.BackgroundTransparency = 1
    LHead.Font = Enum.Font.GothamBold

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
    KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    KeyInput.PlaceholderText = "ACCESS KEY"
    KeyInput.Text = ""
    KeyInput.BackgroundTransparency = 1
    KeyInput.TextColor3 = Color3.new(1,1,1)
    KeyInput.Font = Enum.Font.Gotham

    local Line = Instance.new("Frame", KeyPanel)
    Line.Size = UDim2.new(0.8, 0, 0, 1)
    Line.Position = UDim2.new(0.1, 0, 0.4, 30)
    Line.BackgroundColor3 = Color3.fromRGB(0, 160, 255)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.8, 0, 0, 32)
    LoginBtn.Position = UDim2.new(0.1, 0, 0.72, 0)
    LoginBtn.Text = "AUTHENTICATE"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 4)

    -- MAIN HUB
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 160, 0, 340)
    Main.Position = UDim2.new(0.02, 0, 0.3, 0)
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
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
                KeyPanel:Destroy() Main.Visible = true
                if Toggles.HideName then StealthLogic(lp.Character) end
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
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(20, 20, 20)
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
        local key = Keys[Index] Toggles[key] = not Toggles[key] Refresh() 
    end
end)

Refresh()
