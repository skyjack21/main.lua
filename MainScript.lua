-- [[ OMNI v146: MOUNT INDEPENDENCE - SELF DESTRUCT FIX ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Memastikan PlayerGui benar-benar tersedia [cite: 12]
local pgui = lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui", 20)

-- URL DATABASE KEY KAMU [cite: 12]
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Deklarasi Global untuk mencegah error "nil value" 
local Screen, KeyPanel, Main, Status, KeyInput

-- [[ 1. UI CONSTRUCTOR ]] --
local function InitializeUI()
    -- Hapus versi lama jika ada [cite: 12]
    for _, old in ipairs(pgui:GetChildren()) do
        if old.Name:find("OMNI_SECURE") then old:Destroy() end
    end
    
    Screen = Instance.new("ScreenGui")
    Screen.Name = "OMNI_SECURE_V146"
    Screen.Parent = pgui
    Screen.ResetOnSpawn = false
    Screen.DisplayOrder = 999
    
    -- PANEL LOGIN [cite: 13]
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 320, 0, 240)
    KeyPanel.Position = UDim2.new(0.5, -160, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel)

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 45)
    KTitle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    KTitle.Text = "LOGIN SYSTEM v146"
    KTitle.TextColor3 = Color3.new(1, 1, 1)
    KTitle.Font = Enum.Font.GothamBold
    Instance.new("UICorner", KTitle)

    KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
    KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0)
    KeyInput.PlaceholderText = "Enter Key Here..."
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    KeyInput.Text = "" 
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
    Status.Text = "Awaiting Key..."
    Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)

    -- PANEL CHEAT UTAMA [cite: 16]
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

    -- Logika Cek Key [cite: 18, 19]
    CheckBtn.MouseButton1Click:Connect(function()
        local input = KeyInput.Text
        Status.Text = "Verifying..."
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(result) end)
            if decodeSuccess and data.KEY_LIST[input] then
                KeyPanel.Visible = false
                Main.Visible = true
                Status.Text = "SUCCESS!"
            else
                Status.Text = "INVALID KEY!"
            end
        else
            Status.Text = "SERVER ERROR!"
        end
    end)
    
    return Main
end

local MainFrame = InitializeUI()

-- [[ 2. ENGINE LOGIC ]] --
local Toggles = {Speed = false, SafeClamp = false}
local Keys = {"Speed", "SafeClamp"}
local Names = {"SPEED ENGINE", "SAFE CLAMP"}
local Buttons = {}
local Index, SpeedMult = 1, 2.5

rs.RenderStepped:Connect(function()
    if not MainFrame or not MainFrame.Visible then return end
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then
        if Toggles.Speed then root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMult) end -- [cite: 6]
        if Toggles.SafeClamp then
            local ray = workspace:Raycast(root.Position, hum.MoveDirection * 5)
            if ray then root.Velocity = Vector3.new(0, root.Velocity.Y, 0) end -- [cite: 7, 22]
        end
    end
end)

local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]") -- [cite: 23]
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 30)
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(1, -20, 0, 65)
    b.Position = UDim2.new(0, 10, 0, (i * 75) - 25)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    table.insert(Buttons, b)
end

-- [[ 3. INPUT HANDLER (F8 & L FIX) ]] --
uis.InputBegan:Connect(function(k, g)
    -- FITUR F8: Hapus total skrip dan UI dari game
    if k.KeyCode == Enum.KeyCode.F8 then 
        Screen:Destroy() 
        return -- Keluar agar tidak menjalankan perintah lain
    end

    -- Tombol L: Hanya berfungsi jika Login sudah selesai dan UI belum dihapus F8
    if k.KeyCode == Enum.KeyCode.L and Screen.Parent ~= nil and not KeyPanel.Visible then 
        MainFrame.Visible = not MainFrame.Visible -- 
    end
    
    if g or not MainFrame.Visible then return end
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh() -- [cite: 11]
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then Toggles[Keys[Index]] = not Toggles[Keys[Index]] Refresh() end
end)

Refresh()
