loadstring([[
-- Juao.Speed & FlyGUI Ninja Atualizado
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Juao.Speed"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 200)
frame.Position = UDim2.new(0.5, -160, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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
closeButton.MouseButton1Click:Connect(function() frame.Visible = false end)

-- TextBox velocidade
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 120, 0, 35)
speedBox.Position = UDim2.new(0, 15, 0, 50)
speedBox.PlaceholderText = "Velocidade"
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.Text = "16"
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
    if speedActive and humanoid then humanoid.WalkSpeed = tonumber(speedBox.Text) or 16
    elseif humanoid then humanoid.WalkSpeed = 16
    end
end)

speedBox.FocusLost:Connect(function()
    if speedActive and humanoid then
        humanoid.WalkSpeed = tonumber(speedBox.Text) or 16
    end
end)

-- === Fly ===
local flying = false
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 120, 0, 35)
flyButton.Position = UDim2.new(0.5, -60, 1, -45)
flyButton.Text = "Voar"
flyButton.BackgroundColor3 = Color3.fromRGB(50,50,180)
flyButton.TextColor3 = Color3.fromRGB(255,255,255)
flyButton.Parent = frame

local bodyVelocity
local bodyGyro
local speed = 50
local height = 0
local maxSpeed = 100
local minSpeed = 10
local maxHeight = 100
local minHeight = 0

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    flyButton.Text = flying and "Parar de voar" or "Voar"
    flyButton.BackgroundColor3 = flying and Color3.fromRGB(50,180,180) or Color3.fromRGB(50,50,180)
    if flying then
        local char = player.Character
        if char then
            local root = char:WaitForChild("HumanoidRootPart")
            bodyVelocity = Instance.new("BodyVelocity")
            bodyGyro = Instance.new("BodyGyro")
            bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
            bodyGyro.CFrame = root.CFrame
            bodyVelocity.Parent = root
            bodyGyro.Parent = root
        end
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end)

-- Update loop voo
RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera.CFrame
        local move = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
        if move.Magnitude > 0 then
            bodyVelocity.Velocity = move.Unit * speed
        else
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- Controle de altura
local heightBox = Instance.new("TextBox")
heightBox.Size = UDim2.new(0, 120, 0, 35)
heightBox.Position = UDim2.new(0, 15, 0, 90)
heightBox.PlaceholderText = "Altura"
heightBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
heightBox.TextColor3 = Color3.fromRGB(255,255,255)
heightBox.Text = "0"
heightBox.ClearTextOnFocus = false
heightBox.Parent = frame

heightBox.FocusLost:Connect(function()
    height = tonumber(heightBox.Text) or 0
    if height > maxHeight then height = maxHeight end
    if height < minHeight then height = minHeight end
    if player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(root.Position.X, height, root.Position.Z)
        end
    end
end)

-- Controle de velocidade
local speedUpButton = Instance.new("TextButton")
speedUpButton.Size = UDim2.new(0, 40, 0, 35)
speedUpButton.Position = UDim2.new(0, 155, 0, 90)
speedUpButton.Text = "+"
speedUpButton.BackgroundColor3 = Color3.fromRGB(50,50,180)
speedUpButton.TextColor3 = Color3.fromRGB(255,255,255)
speedUpButton.Parent = frame

local speedDownButton = Instance.new("TextButton")
speedDownButton.Size = UDim2.new(0, 40, 0, 35)
speedDownButton.Position = UDim2.new(0, 200, 0, 90)
speedDownButton.Text = "-"
speedDownButton.BackgroundColor3 = Color3.fromRGB(50,50,180)
speedDownButton.TextColor3 = Color3.fromRGB(255,255,255)
speedDownButton.Parent = frame

speedUpButton.MouseButton1Click:Connect(function()
    speed = speed + 10
    if speed > maxSpeed then speed = maxSpeed end
    if flying and bodyVelocity then
        bodyVelocity.Velocity = bodyVelocity.Velocity.Unit * speed
    end
end)

speedDownButton.MouseButton1Click:Connect(function()
    speed = speed - 10
    if speed < minSpeed then speed = minSpeed end
    if flying and bodyVelocity then
        bodyVelocity.Velocity = bodyVelocity.Velocity.Unit * speed
    end
end)

-- Persistência após morrer
player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    if speedActive then humanoid.WalkSpeed = tonumber(speedBox.Text) or 16 end
    if flying then
        local root = char:WaitForChild("HumanoidRootPart")
        bodyVelocity = Instance.new("BodyVelocity")
        bodyGyro = Instance.new("BodyGyro")
        bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
        bodyGyro.CFrame = root.CFrame
        bodyVelocity.Parent = root
        bodyGyro.Parent = root
    end
end)
]])()
