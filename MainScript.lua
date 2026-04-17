-- [[ SKYJACK OMEGA v3601: STABLE VELOCITY REPAIR ]] --
-- Fix by AI Research: Merombak total fitur Speed menggunakan LinearVelocity 
-- untuk mencegah tembus objek di tangga/tanjakan.

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 15)

local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/57de2421060ced152d4bbcad6a583d452dc6f9d7/gistfile1.txt"

-- [[ 1. UI BUILDER (STRUKTUR ASLI DIPERTAHANKAN) ]] --
local function BuildUI()
    if pgui:FindFirstChild("SKYJACK_V3601") then pgui.SKYJACK_V3601:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_V3601"
    Screen.ResetOnSpawn = false
    local KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 320, 0, 240)
    KeyPanel.Position = UDim2.new(0.5, -160, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel)
    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 45)
    KTitle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    KTitle.Text = "LOGIN SYSTEM"
    KTitle.TextColor3 = Color3.new(1, 1, 1)
    KTitle.Font = Enum.Font.GothamBold
    Instance.new("UICorner", KTitle)
    local KeyInput = Instance.new("TextBox", KeyPanel)
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
    CheckBtn.Text = "VERIFY"
    CheckBtn.TextColor3 = Color3.new(1, 1, 1)
    CheckBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", CheckBtn)
    local Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0.85, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Awaiting Key..."
    Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 240, 0, 480)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.Visible, Main.Active, Main.Draggable = false, true, true
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(200, 0, 0)
    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Title.Text = "SKYJACK REPAIR v3601"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Title)
    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status
end

local Screen, KeyPanel, Main, CheckBtn, KeyInput, Status = BuildUI()

-- [[ 2. MASTER TOGGLES & CONFIG ]] --
getgenv().Toggles = {Speed = false, AutoWalk = false, InfJump = false, Vip = false, HideName = false, Shield = false}
local T = getgenv().Toggles
local Keys = {"Speed", "AutoWalk", "InfJump", "Vip", "HideName", "Shield"}
local Names = {"STABLE SPEED (100)", "AUTO SUMMIT", "PHYSICAL AIR JUMP", "VIP BYPASS", "IDENTITY CLEANER", "ANTI-KICK"}
local Buttons = {}
local Index = 1
local IsAuthed = false
local TargetSpeed = 100 -- Target kecepatan stabil (default 16)
local velocityInstance, attachmentInstance -- Variabel untuk LinearVelocity

-- [[ 3. FIXED LOGIN LOGIC ]] --
CheckBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    task.spawn(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[input] then
                Status.Text = "SUCCESS!"
                IsAuthed = true
                task.wait(0.5)
                KeyPanel:Destroy()
                Main.Visible = true
            else
                Status.Text = "INVALID KEY!"
            end
        else
            Status.Text = "SERVER ERROR!"
        end
    end)
end)

-- [[ 4. CORE REPAIR ENGINE ]] --
task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if T.Shield and (method == "Kick" or method == "kick") then return nil end
            if T.Vip and (method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset") then return true end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end)
end)

rs.Heartbeat:Connect(function()
    if not IsAuthed then return end
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- [CRITICAL-REWORK] Logika Speed menggunakan LinearVelocity
    if T.Speed and velocityInstance then
        if hum.MoveDirection.Magnitude > 0 then
            velocityInstance.VectorVelocity = hum.MoveDirection * TargetSpeed
        else
            velocityInstance.VectorVelocity = Vector3.new(0, 0, 0)
        end
    end

    if T.AutoWalk then
        local target = workspace:FindFirstChild("Summit", true) or workspace:FindFirstChild("Checkpoint", true) or workspace:FindFirstChild("Goal", true)
        if target and target:IsA("BasePart") then
            hum:MoveTo(target.Position)
        end
    end

    if T.HideName then
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v.Name:lower():find("name") or v.Name:lower():find("tag") then
                v.Enabled = false
            end
        end
    end
end)

uis.JumpRequest:Connect(function()
    if T.InfJump and IsAuthed then
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [[ 5. UI CONTROL & REFRESH ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (T[k] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 30)
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -20, 0, 60)
    b.Position = UDim2.new(0, 10, 0, (i * 68) - 20)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 10
    Instance.new("UICorner", b)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.L then Main.Visible = not Main.Visible end
    if g or not Main.Visible then return end
    
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1
    elseif k.KeyCode == Enum.KeyCode.Return then
        local key = Keys[Index]
        T[key] = not T[key]
        
        -- [CRITICAL-REWORK] Logika untuk membuat/menghancurkan LinearVelocity saat Speed di-toggle
        if key == "Speed" then
            if T.Speed then
                local char = lp.Character
                if char and not velocityInstance then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        attachmentInstance = Instance.new("Attachment", root)
                        velocityInstance = Instance.new("LinearVelocity", attachmentInstance)
                        velocityInstance.Attachment0 = attachmentInstance
                        velocityInstance.MaxForce = 100000
                        velocityInstance.RelativeTo = Enum.ActuatorRelativeTo.World
                    end
                end
            else
                if velocityInstance then
                    velocityInstance:Destroy()
                    attachmentInstance:Destroy()
                    velocityInstance = nil
                    attachmentInstance = nil
                end
            end
        end
    end
    Refresh()
end)

Refresh()
