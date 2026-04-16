-- [[ OMNI v145: MOUNT INDEPENDENCE - ULTIMATE BOOT FIX ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Menunggu PlayerGui dengan proteksi maksimal
local pgui = lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui", 20) [cite: 12]

-- LINK DATABASE
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt" [cite: 12]

-- [[ 1. UI CONSTRUCTOR ]] --
local function BuildUI()
    -- Hapus jejak versi lama
    for _, old in ipairs(pgui:GetChildren()) do
        if old.Name:find("OMNI_SECURE") then old:Destroy() end
    end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "OMNI_SECURE_V145"
    Screen.Parent = pgui
    Screen.ResetOnSpawn = false
    Screen.DisplayOrder = 999
    
    -- PANEL LOGIN (HARUS ADA DULU)
    local KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Name = "LoginFrame"
    KeyPanel.Size = UDim2.new(0, 320, 0, 240) [cite: 13]
    KeyPanel.Position = UDim2.new(0.5, -160, 0.4, 0) [cite: 13]
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20) [cite: 13]
    KeyPanel.Active, KeyPanel.Draggable = true, true [cite: 13]
    Instance.new("UICorner", KeyPanel)

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 45)
    KTitle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    KTitle.Text = "LOGIN SYSTEM v145"
    KTitle.TextColor3 = Color3.new(1, 1, 1)
    KTitle.Font = Enum.Font.GothamBold
    Instance.new("UICorner", KTitle)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45) [cite: 14]
    KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0) [cite: 14]
    KeyInput.PlaceholderText = "Enter Key Here..."
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35) [cite: 14]
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", KeyInput)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(0.85, 0, 0, 45) [cite: 15]
    CheckBtn.Position = UDim2.new(0.075, 0, 0.6, 0) [cite: 15]
    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50) [cite: 15]
    CheckBtn.Text = "CHECK KEY"
    CheckBtn.TextColor3 = Color3.new(1, 1, 1) [cite: 15]
    Instance.new("UICorner", CheckBtn)

    local Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0.85, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Ready to Boot."
    Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)

    -- PANEL CHEAT (HIDDEN)
    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 240, 0, 520) [cite: 16]
    Main.Position = UDim2.new(0.1, 0, 0.2, 0) [cite: 16]
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20) [cite: 16]
    Main.Visible = false [cite: 16]
    Main.Active, Main.Draggable = true, true [cite: 16]
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(200, 0, 0)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Title.Text = "MOUNT INDEPENDENCE"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Title)

    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status
end

-- Eksekusi BuildUI dengan aman
local success_ui, Screen, KeyPanel, Main, CheckBtn, KeyInput, Status = pcall(BuildUI) [cite: 17]
if not success_ui then warn("UI gagal dimuat!") return end

-- [[ 2. FUNCTIONS ]] --
local function SelfDestruct()
    Screen:Destroy()
end

-- [[ 3. VERIFIKASI ]] --
CheckBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    Status.Text = "Verifying..."
    
    local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end) [cite: 18]
    if success then
        local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(result) end) [cite: 18]
        if decodeSuccess and data.KEY_LIST[input] then
            Status.Text = "SUCCESS!" [cite: 19]
            task.wait(0.5)
            KeyPanel.Visible = false
            Main.Visible = true [cite: 19]
        else
            Status.Text = "KEY INVALID!" [cite: 20]
        end
    else
        Status.Text = "SERVER ERROR!" [cite: 21]
    end
end)

-- [[ 4. CORE ENGINE ]] --
local Toggles = {Speed = false, SafeClamp = false}
local Keys = {"Speed", "SafeClamp"}
local Names = {"SPEED ENGINE", "SAFE CLAMP"}
local Buttons = {}
local Index, SpeedMult = 1, 2.5

rs.RenderStepped:Connect(function()
    if not Main.Visible then return end
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid") [cite: 22]
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then
        if Toggles.Speed then root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMult) end [cite: 22]
        if Toggles.SafeClamp then
            local ray = workspace:Raycast(root.Position, hum.MoveDirection * 5)
            if ray then root.Velocity = Vector3.new(0, root.Velocity.Y, 0) end [cite: 22]
        end
    end
end)

-- [[ 5. CONTROLS ]] --
local function Refresh() [cite: 23]
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]") [cite: 23]
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 30) [cite: 23]
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -20, 0, 65)
    b.Position = UDim2.new(0, 10, 0, (i * 75) - 25)
    b.Font = Enum.Font.GothamBold [cite: 24]
    b.TextColor3 = Color3.new(1, 1, 1) [cite: 24]
    Instance.new("UICorner", b)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.F8 then SelfDestruct() end
    if k.KeyCode == Enum.KeyCode.L and not KeyPanel.Visible then Main.Visible = not Main.Visible end
    
    if g or not Main.Visible then return end
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh()
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then Toggles[Keys[Index]] = not Toggles[Keys[Index]] Refresh() end [cite: 25]
end)

Refresh()
