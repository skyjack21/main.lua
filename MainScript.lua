-- [[ OMNI v142: MOUNT INDEPENDENCE - TOTAL CONTROL ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 15)

-- PASTE LINK RAW GIST KAMU DI SINI 
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt" 

-- [[ 1. UI BUILDER ]] --
local function BuildUI()
    if pgui:FindFirstChild("OMNI_SECURE_V142") then pgui.OMNI_SECURE_V142:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "OMNI_SECURE_V142"
    Screen.ResetOnSpawn = false [cite: 12]

    -- PANEL LOGIN
    local KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 320, 0, 240) [cite: 13]
    KeyPanel.Position = UDim2.new(0.5, -160, 0.4, 0) [cite: 13]
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20) [cite: 13]
    KeyPanel.Active, KeyPanel.Draggable = true, true [cite: 13]
    Instance.new("UICorner", KeyPanel)

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 45) [cite: 13]
    KTitle.BackgroundColor3 = Color3.fromRGB(200, 0, 0) [cite: 13]
    KTitle.Text = "LOGIN SYSTEM v142"
    KTitle.TextColor3 = Color3.new(1, 1, 1) [cite: 13]
    KTitle.Font = Enum.Font.GothamBold [cite: 13]
    Instance.new("UICorner", KTitle)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45) [cite: 14]
    KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0) [cite: 14]
    KeyInput.PlaceholderText = "Enter Key Here..." [cite: 14]
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35) [cite: 14]
    KeyInput.TextColor3 = Color3.new(1, 1, 1) [cite: 14]
    Instance.new("UICorner", KeyInput)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(0.85, 0, 0, 45) [cite: 14]
    CheckBtn.Position = UDim2.new(0.075, 0, 0.6, 0) [cite: 14]
    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50) [cite: 14]
    CheckBtn.Text = "CHECK KEY"
    CheckBtn.TextColor3 = Color3.new(1, 1, 1) [cite: 14]
    Instance.new("UICorner", CheckBtn)

    local Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30) [cite: 15]
    Status.Position = UDim2.new(0, 0, 0.85, 0) [cite: 15]
    Status.BackgroundTransparency = 1 [cite: 15]
    Status.Text = "Awaiting Key..."
    Status.TextColor3 = Color3.new(0.8, 0.8, 0.8) [cite: 15]

    -- PANEL CHEAT UTAMA
    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 240, 0, 520) [cite: 16]
    Main.Position = UDim2.new(0.1, 0, 0.2, 0) [cite: 16]
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20) [cite: 16]
    Main.Visible, Main.Active, Main.Draggable = false, true, true [cite: 16]
    Instance.new("UICorner", Main)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(200, 0, 0) [cite: 16]
    Stroke.Thickness = 2

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45) [cite: 16]
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0) [cite: 16]
    Title.Text = "MOUNT INDEPENDENCE" [cite: 16]
    Title.TextColor3 = Color3.new(1, 1, 1) [cite: 16]
    Title.Font = Enum.Font.GothamBold [cite: 16]
    Instance.new("UICorner", Title)

    -- TOMBOL CLOSE (X)
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 7)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", CloseBtn)

    -- TOMBOL MINIMIZE (-)
    local MinBtn = Instance.new("TextButton", Main)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 7)
    MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", MinBtn)

    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status, CloseBtn, MinBtn
end

local Screen, KeyPanel, Main, CheckBtn, KeyInput, Status, CloseBtn, MinBtn = BuildUI()

-- [[ 2. LOGIC UI CONTROL ]] --
local IsMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        Main:TweenSize(UDim2.new(0, 240, 0, 45), "Out", "Quad", 0.3, true)
        MinBtn.Text = "+"
    else
        Main:TweenSize(UDim2.new(0, 240, 0, 520), "Out", "Quad", 0.3, true)
        MinBtn.Text = "-"
    end
end)

local function SelfDestruct()
    Screen:Destroy() -- Hapus semua objek UI
    script:Destroy() -- Hapus script dari memori (jika didukung executor)
end

CloseBtn.MouseButton1Click:Connect(SelfDestruct)

-- [[ 3. VALIDATION ]] --
CheckBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text [cite: 17]
    Status.Text = "Verifying..." [cite: 17]
    local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end) [cite: 17]

    if success then
        local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(result) end) [cite: 18]
        if not decodeSuccess then Status.Text = "JSON ERROR!"; return end [cite: 18]
        
        local keyData = data.KEY_LIST[input] [cite: 18]
        if keyData then [cite: 18]
            KeyPanel:Destroy() [cite: 19]
            Main.Visible = true [cite: 19]
        else
            Status.Text = "INVALID KEY!" [cite: 18]
        end
    else
        Status.Text = "SERVER ERROR!" [cite: 21]
    end
end)

-- [[ 4. INDEPENDENT ENGINE ]] --
local Toggles = {Speed = false, SafeClamp = false} [cite: 21]
local Keys = {"Speed", "SafeClamp"} [cite: 21]
local Names = {"SPEED ENGINE", "SAFE CLAMP"} [cite: 21]
local Buttons = {}
local Index, SpeedMult = 1, 2.5 [cite: 21]

rs.RenderStepped:Connect(function()
    if not Main.Visible then return end [cite: 22]
    
    -- UPDATE REFERENSI KARAKTER (FIX MATI/RESPAWN)
    local char = lp.Character [cite: 22]
    local root = char and char:FindFirstChild("HumanoidRootPart") [cite: 22]
    local hum = char and char:FindFirstChild("Humanoid") [cite: 22]
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then [cite: 22]
        if Toggles.Speed then [cite: 22]
            root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMult) [cite: 22]
        end
        if Toggles.SafeClamp then [cite: 22]
            local ray = workspace:Raycast(root.Position, hum.MoveDirection * 5, RaycastParams.new()) [cite: 22]
            if ray then root.Velocity = Vector3.new(0, root.Velocity.Y, 0) end [cite: 22]
        end
    end
end)

-- [[ 5. CONTROLS ]] --
local function Refresh() [cite: 23]
    for i, b in ipairs(Buttons) do [cite: 23]
        local k = Keys[i] [cite: 23]
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]") [cite: 23]
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 30) [cite: 23]
        b.Visible = not IsMinimized [cite: 23]
    end
end

for i = 1, #Names do [cite: 23]
    local b = Instance.new("TextButton", Main) [cite: 24]
    b.Size = UDim2.new(1, -20, 0, 65) [cite: 24]
    b.Position = UDim2.new(0, 10, 0, (i * 75) - 25) [cite: 24]
    b.Font = Enum.Font.GothamBold [cite: 24]
    b.TextColor3 = Color3.new(1, 1, 1) [cite: 24]
    Instance.new("UICorner", b) [cite: 24]
    table.insert(Buttons, b) [cite: 24]
end

uis.InputBegan:Connect(function(k, g) [cite: 24]
    if g or not Main.Visible then return end [cite: 24]
    
    if k.KeyCode == Enum.KeyCode.Up then [cite: 24]
        Index = (Index > 1) and Index - 1 or #Names Refresh() [cite: 24]
    elseif k.KeyCode == Enum.KeyCode.Down then [cite: 24]
        Index = (Index < #Names) and Index + 1 or 1 Refresh() [cite: 25]
    elseif k.KeyCode == Enum.KeyCode.Return then [cite: 25]
        Toggles[Keys[Index]] = not Toggles[Keys[Index]] [cite: 25]
        Refresh() [cite: 25]
    elseif k.KeyCode == Enum.KeyCode.L then [cite: 25]
        Main.Visible = not Main.Visible [cite: 25]
    elseif k.KeyCode == Enum.KeyCode.F8 then -- FITUR SELF DESTRUCT
        SelfDestruct()
    end
end)

Refresh() [cite: 25]
