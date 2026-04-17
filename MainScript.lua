--[[
    SKYJACK RBX v2404: DIAGNOSTIC-ONLY VERSION
    
    Tujuan: Untuk memeriksa apakah executor dapat menjalankan kode paling dasar.
    Hanya akan membuat UI sederhana. Tidak ada fitur lain.
    
    Jika ini gagal, masalah ada pada executor (Xeno) Anda, bukan pada skrip.
]]

-- Langsung definisikan layanan tanpa pcall untuk diagnosis
local CoreGui = game:GetService("CoreGui")

-- Hancurkan UI lama jika ada
if CoreGui:FindFirstChild("SKY_ELITE_DIAGNOSTIC") then
    CoreGui.SKY_ELITE_DIAGNOSTIC:Destroy()
end

-- Buat UI
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "SKY_ELITE_DIAGNOSTIC"
Screen.ResetOnSpawn = false
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Global

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 300, 0, 120)
Main.Position = UDim2.new(0.5, -150, 0.5, -60) -- Tengah layar
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.ZIndex = 9999
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 100, 0) -- Oranye untuk menandakan mode diagnostik
Stroke.Thickness = 2

local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, -20, 1, -20)
Header.Position = UDim2.new(0.5, -((Main.Size.X.Offset - 20)/2), 0.5, -((Main.Size.Y.Offset - 20)/2))
Header.Text = "DIAGNOSTIC MODE\n\nJika Anda melihat ini, executor Anda bekerja.\nMasalahnya ada pada fitur-fitur canggih di skrip sebelumnya."
Header.TextColor3 = Color3.new(1, 1, 1)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 14
Header.TextWrapped = true
Header.BackgroundTransparency = 1

print("SKYJACK RBX v2404 (Diagnostic Mode): Skrip diagnostik berhasil dijalankan. UI seharusnya muncul.")

-- Tidak ada logika fitur, tidak ada pcall, tidak ada fungsi kompleks.
-- Hanya pembuatan UI paling dasar.
