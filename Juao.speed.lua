-- JuaoSpeed.lua
-- Código do GUI estilo FlyGUI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- === GUI principal ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Juao.Speed"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 120)
frame.Position = UDim2.new(0.5, -150, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true -- deixa arrastável direto

-- Botão fechar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.Parent = frame
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- TextBox velocidade
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 120, 0, 35)
speedBox.Position = UDim2.new(0, 15, 0, 50)
speedBox.PlaceholderText = "Velocidade"
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.Text = ""
speedBox.ClearTextOnFocus = false
speedBox.Parent = frame

-- Botão ativar/desativar
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 35)
toggleButton.Position = UDim2.new(0, 155, 0, 50)
toggleButton.Text = "Ativar"
toggleButton.BackgroundColor3 = Color3.fromRGB(50,180,50)
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.Parent = frame

local speedActive = false
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

toggleButton.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    toggleButton.Text = speedActive and "Desativar" or "Ativar"
    toggleButton.BackgroundColor3 = speedActive and Color3.fromRGB(180,50,50) or Color3.fromRGB(50,180,50)
    if speedActive then
        local inputSpeed = tonumber(speedBox.Text) or 16
        if humanoid then humanoid.WalkSpeed = inputSpeed end
    else
        if humanoid then humanoid.WalkSpeed = 16 end
    end
end)

speedBox.FocusLost:Connect(function()
    if speedActive then
        local inputSpeed = tonumber(speedBox.Text) or 16
        if humanoid then humanoid.WalkSpeed = inputSpeed end
    end
end)
