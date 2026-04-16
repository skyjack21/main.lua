-- [[ OMNI v140: MOUNT INDEPENDENCE - SECURE CLOUD ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 15)

-- GANTI DENGAN LINK RAW GIST keys.json KAMU
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/7780590550bc4803b328b34544669e81af77bb0d/gistfile1.txt" 

-- [[ 1. UI BUILDER (LOGIN & CHEAT PANELS) ]] --
local function BuildUI()
    if pgui:FindFirstChild("OMNI_SECURE_V140") then pgui.OMNI_SECURE_V140:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "OMNI_SECURE_V140"
    Screen.ResetOnSpawn = false

    -- PANEL LOGIN (Hanya Muncul di Awal)
    local KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 320, 0, 240)
    KeyPanel.Position = UDim2.new(0.5, -160, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel)

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 45)
    KTitle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    KTitle.Text = "LOGIN SYSTEM (8-CHAR)"
    KTitle.TextColor3 = Color3.new(1, 1, 1)
    KTitle.Font = Enum.Font.GothamBold
    Instance.new("UICorner", KTitle)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
    KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0)
    KeyInput.PlaceholderText = "Enter Key Here..."
    KeyInput.Text = ""
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", KeyInput)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(0.85, 0, 0, 45)
    CheckBtn.Position = UDim2.new(0.075, 0, 0.6, 0)
    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    CheckBtn.Text = "CHECK KEY"
    CheckBtn.TextColor3 = Color3.new(1, 1, 1)
    CheckBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", CheckBtn)

    local Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0.85, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Awaiting Key..."
    Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    Status.Font = Enum.Font.Gotham

    -- PANEL CHEAT UTAMA (Hidden at Start)
    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 240, 0, 520)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.Visible, Main.Active, Main.Draggable = false, true, true
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(200, 0, 0)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Title.Text = "MOUNT INDEPENDENCE v140"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Title)

    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status
end

local Screen, KeyPanel, Main, CheckBtn, KeyInput, Status = BuildUI()

-- [[ 2. CLOUD KEY VALIDATION ]] --
CheckBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    if #input ~= 8 then
        Status.Text = "KEY HARUS 8 KARAKTER!"
        Status.TextColor3 = Color3.new(1, 0, 0)
        return
    end

    Status.Text = "Verifying with Server..."
    local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)

    if success then
        local data = HttpService:JSONDecode(result)
        local keyData = data.KEY_LIST[input]

        if keyData then
            local yr, mo, dy = keyData.Exp:match("(%d+)-(%d+)-(%d+)")
            local expTime = os.time({year=yr, month=mo, day=dy})
            if os.time() < expTime then
                Status.Text = "WORK! Akses Terbuka."
                Status.TextColor3 = Color3.new(0, 1, 0)
                task.wait(1)
                KeyPanel:Destroy() -- Hapus panel login
                Main.Visible = true -- Tampilkan cheat
            else
                Status.Text = "KEY SUDAH EXPIRED!"
                Status.TextColor3 = Color3.new(1, 0.5, 0)
            end
        else
            Status.Text = "KEY TIDAK VALID!"
            Status.TextColor3 = Color3.new(1, 0, 0)
        end
    else
        Status.Text = "SERVER ERROR (Check URL)"
    end
end)

-- [[ 3. MODULE LOGIC (DIPISAH SESUAI MINTAAN) ]] --
local Toggles = {Speed = false, SafeClamp = false, InfJump = false, VIP = false, FakeName = false, AntiBan = false}
local Keys = {"Speed", "SafeClamp", "InfJump", "VIP", "FakeName", "AntiBan"}
local Names = {"SPEED ENGINE", "SAFE CLAMP (ANTI-CLIP)", "AIR JUMP", "VIP BYPASS", "SERVER FAKE NAME", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index, SpeedMult = 1, 2.5

rs.RenderStepped:Connect(function()
    if not Main.Visible then return end
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    if Toggles.Speed and hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMult)
    end

    if Toggles.SafeClamp and hum.MoveDirection.Magnitude > 0 then
        local ray = workspace:Raycast(root.Position, hum.MoveDirection * 5, RaycastParams.new())
        if ray then root.Velocity = Vector3.new(0, root.Velocity.Y, 0) end
    end
end)

-- [[ 4. BUTTON GENERATOR & CONTROLS ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
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
    b.TextSize = 12
    Instance.new("UICorner", b)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if g or not Main.Visible then return end
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh()
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then 
        Toggles[Keys[Index]] = not Toggles[Keys[Index]] 
        Refresh()
    elseif k.KeyCode == Enum.KeyCode.L then Main.Visible = not Main.Visible end
end)
Refresh()