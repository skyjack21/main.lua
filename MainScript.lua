-- [[ OMNI v147: MOUNT INDEPENDENCE - STABILITY & CONTROLS ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Memastikan PlayerGui siap
local pgui = lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui", 20)

-- Link Database Key kamu
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Deklarasi Global agar tidak error "nil"
local Screen, KeyPanel, Main, Status, KeyInput, MinBtn

-- [[ 1. UI BUILDER ]] --
local function BuildUI()
    -- Hapus versi lama
    for _, old in ipairs(pgui:GetChildren()) do
        if old.Name:find("OMNI_SECURE") then old:Destroy() end
    end
    
    Screen = Instance.new("ScreenGui")
    Screen.Name = "OMNI_SECURE_V147"
    Screen.Parent = pgui
    Screen.ResetOnSpawn = false
    Screen.DisplayOrder = 999
    
    -- PANEL LOGIN
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 320, 0, 240)
    KeyPanel.Position = UDim2.new(0.5, -160, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel)

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 45)
    KTitle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    KTitle.Text = "LOGIN SYSTEM v147"
    KTitle.TextColor3 = Color3.new(1, 1, 1)
    KTitle.Font = Enum.Font.GothamBold
    Instance.new("UICorner", KTitle)

    KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
    KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0)
    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", KeyInput)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(0.85, 0, 0, 45)
    CheckBtn.Position = UDim2.new(0.075, 0, 0.6, 0)
    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    CheckBtn.Text = "CHECK KEY"
    CheckBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", CheckBtn)

    Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0.85, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Ready."
    Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)

    -- PANEL CHEAT UTAMA
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 240, 0, 520)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(200, 0, 0)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Title.Text = "MOUNT INDEPENDENCE"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Title)

    -- TOMBOL CLOSE (X)
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 7)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", CloseBtn)
    CloseBtn.MouseButton1Click:Connect(function() Screen:Destroy() end)

    -- TOMBOL MINIMIZE (-)
    MinBtn = Instance.new("TextButton", Main)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 7)
    MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", MinBtn)

    -- Logika Cek Key
    CheckBtn.MouseButton1Click:Connect(function()
        Status.Text = "Verifying..."
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy()
                Main.Visible = true
            else
                Status.Text = "INVALID KEY!"
            end
        else
            Status.Text = "HTTP ERROR!"
        end
    end)
end

BuildUI()

-- [[ 2. MINIMIZE LOGIC ]] --
local IsMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    Main:TweenSize(IsMinimized and UDim2.new(0, 240, 0, 45) or UDim2.new(0, 240, 0, 520), "Out", "Quad", 0.3, true)
    MinBtn.Text = IsMinimized and "+" or "-"
end)

-- [[ 3. ENGINE LOGIC ]] --
local Toggles = {Speed = false, SafeClamp = false}
local Keys = {"Speed", "SafeClamp"}
local Names = {"SPEED ENGINE", "SAFE CLAMP"}
local Buttons = {}
local Index, SpeedMult = 1, 2.5

rs.RenderStepped:Connect(function()
    if not Main.Visible or IsMinimized then return end
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then
        if Toggles.Speed then root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMult) end
        if Toggles.SafeClamp then
            local ray = workspace:Raycast(root.Position, hum.MoveDirection * 5)
            if ray then root.Velocity = Vector3.new(0, root.Velocity.Y, 0) end
        end
    end
end)

-- [[ 4. CONTROLS ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Visible = not IsMinimized
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 30)
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -20, 0, 65)
    b.Position = UDim2.new(0, 10, 0, (i * 75) - 25)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.F8 then Screen:Destroy() end
    if k.KeyCode == Enum.KeyCode.L and Screen:IsDescendantOf(game) then 
        if KeyPanel == nil or not KeyPanel.Parent then Main.Visible = not Main.Visible end
    end
    
    if g or not Main.Visible or IsMinimized then return end
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh()
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then Toggles[Keys[Index]] = not Toggles[Keys[Index]] Refresh() end
end)

Refresh()
