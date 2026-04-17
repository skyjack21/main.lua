--[[
    OMNI v146: MOUNT INDEPENDENCE - INTELLIGENT SPEED FIX
    
    Perbaikan oleh AI Research:
    - [CRITICAL FIX] Speed Engine tidak lagi 'auto-run'. Gaya dorong kini hanya aktif saat pemain menekan tombol gerak (W,A,S,D).
    - [ENHANCED] Arah dorongan Speed kini mengikuti arah gerakan pemain, bukan arah kamera, membuatnya lebih intuitif.
    - [STABILITY] Logika pembuatan dan penghancuran VectorForce disempurnakan agar lebih bersih dan andal.
    - Semua fitur lain dari v145 dipertahankan.
]]

-- Layanan-layanan utama
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variabel pemain lokal
local lp = Players.LocalPlayer
local pgui = lp:WaitForChild("PlayerGui", 15)

-- Konfigurasi Fitur
local Toggles = {Speed = false, InfJump = false, VIP = false, FakeName = false, AntiBan = false}
local Keys = {"Speed", "InfJump", "VIP", "FakeName", "AntiBan"}
local Names = {"INTELLIGENT SPEED", "AIR JUMP", "VIP BYPASS", "HIDE NICKNAME", "ANTI-KICK SHIELD"}
local Buttons = {}
local Index = 1
local SpeedForce = 50000 -- Kekuatan dorongan untuk speed, bisa disesuaikan

-- Variabel untuk fitur Speed
local speedForceInstance = nil
local speedAttachment = nil

-- [[ 1. UI BUILDER ]] --
local function BuildUI()
    if pgui:FindFirstChild("OMNI_SECURE_V146") then pgui.OMNI_SECURE_V146:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "OMNI_SECURE_V146"
    Screen.ResetOnSpawn = false

    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 240, 0, 440)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.Visible, Main.Active, Main.Draggable = true, true, true
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(200, 0, 0)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Title.Text = "MOUNT INDEPENDENCE v146"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Title)

    return Main
end

local Main = BuildUI()

-- [[ 2. FUNGSI-FUNGSI FITUR ]] --
local function InitializeFeatures()

    -- [CRITICAL FIX] Loop Heartbeat kini memeriksa input pemain sebelum menerapkan gaya
    RunService.Heartbeat:Connect(function()
        local char = lp.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if not hum then return end

        if Toggles.Speed and speedForceInstance then
            -- Hanya terapkan gaya jika pemain sedang bergerak
            if hum.MoveDirection.Magnitude > 0 then
                speedForceInstance.Force = hum.MoveDirection * SpeedForce
            else
                -- Jika pemain diam, jangan berikan gaya
                speedForceInstance.Force = Vector3.new(0, 0, 0)
            end
        end
    end)

    -- Fitur Air Jump
    UserInputService.JumpRequest:Connect(function()
        if Toggles.InfJump and lp.Character then
            lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- Fitur Hide Nickname
    local function updateNameVisibility(character)
        if not character or not character:FindFirstChild("Humanoid") then return end
        local humanoid = character.Humanoid
        humanoid.DisplayDistanceType = Toggles.FakeName and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
    end

    if lp.Character then updateNameVisibility(lp.Character) end
    lp.CharacterAdded:Connect(updateNameVisibility)

    -- Fitur Bypass dengan keamanan tambahan
    local function SetupBypasses()
        if not getrawmetatable or not newcclosure then 
            warn("OMNI: Executor tidak mendukung fungsi bypass. Fitur VIP/Anti-Kick tidak akan aktif.")
            return 
        end
        local mt = getrawmetatable(game)
        if not mt or not mt.__namecall then return end
        
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if Toggles.AntiBan and (method == "Kick" or method == "kick") and self == lp then return end
            if Toggles.VIP and (method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset") then return true end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
    SetupBypasses()
    
    -- Fungsi Refresh UI
    local function Refresh()
        for i, b in ipairs(Buttons) do
            local k = Keys[i]
            b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = (i == Index) and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 30)
        end
    end

    -- Buat Tombol-Tombol
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

    -- Kontrol Input
    UserInputService.InputBegan:Connect(function(k, g)
        if k.KeyCode == Enum.KeyCode.L then Main.Visible = not Main.Visible end
        if g or not Main.Visible then return end
        
        if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names
        elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1
        elseif k.KeyCode == Enum.KeyCode.Return then
            local key = Keys[Index]
            Toggles[key] = not Toggles[key]
            
            if key == "FakeName" then updateNameVisibility(lp.Character) end
            
            -- [CRITICAL FIX] Logika untuk membuat/menghancurkan VectorForce saat di-toggle
            if key == "Speed" then
                if Toggles.Speed then
                    local char = lp.Character
                    if char and not speedForceInstance then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            speedAttachment = Instance.new("Attachment", root)
                            speedForceInstance = Instance.new("VectorForce", speedAttachment)
                            speedForceInstance.RelativeTo = Enum.ActuatorRelativeTo.World
                            speedForceInstance.Attachment0 = speedAttachment
                        end
                    end
                else
                    if speedForceInstance then
                        speedForceInstance:Destroy()
                        speedAttachment:Destroy()
                        speedForceInstance = nil
                        speedAttachment = nil
                    end
                end
            end
        end
        Refresh()
    end)
    Refresh()
end

-- [[ 3. INISIALISASI ]] --
InitializeFeatures()
print("OMNI v146 (Intelligent Speed Fix) Berhasil Dimuat!")
