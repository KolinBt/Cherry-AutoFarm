local player = game.Players.LocalPlayer
local isFarming = false
local antiAfkEnabled = false
local visitedObjects = {}
local VirtualUser = game:GetService("VirtualUser")

-- Anti-AFK
local function enableAntiAfk()
	if antiAfkEnabled then return end
	antiAfkEnabled = true
	player.Idled:Connect(function()
		if antiAfkEnabled then
			VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
			wait(1)
			VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		end
	end)
end

-- Teleporte suave
local function smoothTeleport(targetPosition)
	local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if rootPart then
		rootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
	end
end

-- Buscar e ordenar anéis
local function getRings()
	local rings = {}
	local folder = workspace:WaitForChild("Interiors"):WaitForChild("BlossomShakedownInterior"):WaitForChild("RingPickups")

	for _, ring in pairs(folder:GetDescendants()) do
		if ring:IsA("BasePart") and not visitedObjects[ring] then
			table.insert(rings, ring)
		end
	end

	table.sort(rings, function(a, b)
		return (a.Position - player.Character.HumanoidRootPart.Position).Magnitude < (b.Position - player.Character.HumanoidRootPart.Position).Magnitude
	end)

	return rings
end

-- Coletar anéis
local function autoFarmRings()
	for _, ring in pairs(getRings()) do
		smoothTeleport(ring.Position)
		wait(0.1)
		visitedObjects[ring] = true
	end
end

-- Loop do farm
task.spawn(function()
	while true do
		if isFarming then
			autoFarmRings()
		end
		task.wait(0.5)
	end
end)

-- GUI Blossom
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BlossomGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 160)
frame.Position = UDim2.new(0.05, 0, 0.45, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 240, 250)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.2, 0)
title.BackgroundTransparency = 1
title.Text = "Blossom Farm"
title.Font = Enum.Font.FredokaOne
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(180, 90, 130)

-- Área dos Botões
local buttonsFrame = Instance.new("Frame", frame)
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(1, 0, 0.55, 0)
buttonsFrame.Position = UDim2.new(0, 0, 0.2, 0)
buttonsFrame.BackgroundTransparency = 1

-- Botão Auto Farm
local toggleFarm = Instance.new("TextButton", buttonsFrame)
toggleFarm.Position = UDim2.new(0.1, 0, 0.1, 0)
toggleFarm.Size = UDim2.new(0.8, 0, 0.35, 0)
toggleFarm.BackgroundColor3 = Color3.fromRGB(240, 200, 220)
toggleFarm.TextColor3 = Color3.fromRGB(120, 60, 90)
toggleFarm.Text = "Ativar Farm"
toggleFarm.Font = Enum.Font.FredokaOne
toggleFarm.TextSize = 16
Instance.new("UICorner", toggleFarm).CornerRadius = UDim.new(0, 10)

toggleFarm.MouseButton1Click:Connect(function()
	isFarming = not isFarming
	toggleFarm.Text = isFarming and "Desativar Farm" or "Ativar Farm"
	toggleFarm.BackgroundColor3 = isFarming and Color3.fromRGB(255, 210, 230) or Color3.fromRGB(240, 200, 220)
end)

-- Botão Anti-AFK
local toggleAfk = Instance.new("TextButton", buttonsFrame)
toggleAfk.Position = UDim2.new(0.1, 0, 0.55, 0)
toggleAfk.Size = UDim2.new(0.8, 0, 0.35, 0)
toggleAfk.BackgroundColor3 = Color3.fromRGB(230, 210, 255)
toggleAfk.TextColor3 = Color3.fromRGB(100, 70, 150)
toggleAfk.Text = "Ativar Anti-AFK"
toggleAfk.Font = Enum.Font.FredokaOne
toggleAfk.TextSize = 16
Instance.new("UICorner", toggleAfk).CornerRadius = UDim.new(0, 10)

toggleAfk.MouseButton1Click:Connect(function()
	if not antiAfkEnabled then
		enableAntiAfk()
		toggleAfk.Text = "Anti-AFK Ativado"
		toggleAfk.BackgroundColor3 = Color3.fromRGB(250, 220, 250)
	end
end)

-- Footer
local footer = Instance.new("TextLabel", frame)
footer.Size = UDim2.new(1, 0, 0.12, 0)
footer.Position = UDim2.new(0, 0, 0.88, 0)
footer.BackgroundTransparency = 1
footer.Text = "By KolinBt"
footer.Font = Enum.Font.GothamSemibold
footer.TextSize = 13
footer.TextColor3 = Color3.fromRGB(180, 130, 150)
footer.TextXAlignment = Enum.TextXAlignment.Center

-- Botão Minimizar
local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -30, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(220, 190, 230)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(100, 50, 120)
minimizeButton.Font = Enum.Font.FredokaOne
minimizeButton.TextSize = 20
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 6)

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	buttonsFrame.Visible = not minimized
	frame.Size = minimized and UDim2.new(0, 200, 0, 60) or UDim2.new(0, 200, 0, 160)
	minimizeButton.Text = minimized and "+" or "-"
end)
