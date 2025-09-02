loadstring([[
-- Juao.Speed & FlyGUI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- === Criar GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Juao.Speed"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

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

-- Botão ativar/desativar velocidade
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
    if speedActive and humanoid then
        humanoid.WalkSpeed = tonumber(speedBox.Text) or 16
    elseif humanoid then
        humanoid.WalkSpeed = 16
    end
end)

speedBox.FocusLost:Connect(function()
    if speedActive and humanoid then
        humanoid.WalkSpeed = tonumber(speedBox.Text) or 16
    end
end)

-- === Fly função ===
local flying = false
local flySpeed = 50
local bodyVelocity

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 120, 0, 35)
flyButton.Position = UDim2.new(0.5, -60, 1, -45)
flyButton.Text = "Voar"
flyButton.BackgroundColor3 = Color3.fromRGB(50,50,180)
flyButton.TextColor3 = Color3.fromRGB(255,255,255)
flyButton.Parent = frame

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    flyButton.Text = flying and "Parar de voar" or "Voar"
    if flying then
        local char = player.Character
        if char then
            local root = char:WaitForChild("HumanoidRootPart")
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.Parent = root
        end
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end)

-- Update loop para voar
game:GetService("RunService").RenderStepped:Connect(function()
    if flying and bodyVelocity and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera.CFrame
        local move = Vector3.new(0,0,0)
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
        bodyVelocity.Velocity = move.Unit * flySpeed
    end
end)

-- === Persistência após morrer ===
player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    if speedActive then
        humanoid.WalkSpeed = tonumber(speedBox.Text) or 16
    end
    if flying then
        local root = char:WaitForChild("HumanoidRootPart")
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = root
    end
end)
]])()
