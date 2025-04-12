local player = game.Players.LocalPlayer
local isFarming = false
local visitedObjects = {}

local function smoothTeleport(targetPosition)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        rootPart.CFrame = CFrame.new(targetPosition)
    end
end

local function scanBlossomColliders()
    local colliders = {}
    local ringsFolder = workspace:WaitForChild("Interiors"):WaitForChild("BlossomShakedownInterior"):WaitForChild("RingPickups")
    for _, ring in pairs(ringsFolder:GetDescendants()) do
        if ring:IsA("BasePart") and not visitedObjects[ring] then
            table.insert(colliders, ring)
        end
    end
    return colliders
end

local function sortByProximity(colliders)
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        table.sort(colliders, function(a, b)
            return (a.Position - rootPart.Position).Magnitude < (b.Position - rootPart.Position).Magnitude
        end)
    end
    return colliders
end

local function collectAllBlossomRings()
    local blossomColliders = scanBlossomColliders()
    blossomColliders = sortByProximity(blossomColliders)
    for _, ringCollider in pairs(blossomColliders) do
        smoothTeleport(ringCollider.Position)
        wait(0.01) -- Tempo mínimo para evitar falhas
        visitedObjects[ringCollider] = true
    end
end

spawn(function()
    while wait(0.1) do
        if isFarming then
            collectAllBlossomRings()
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local Header = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 10)

Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0.3, 0)
Header.BackgroundTransparency = 1
Header.Font = Enum.Font.GothamBold
Header.Text = "Blossom Rings Farm"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 20

ToggleButton.Parent = MainFrame
ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "[ OFF ]"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

local function toggleButtonAnimation()
    if isFarming then
        ToggleButton.Text = "[ ON ]"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        ToggleButton.Text = "[ OFF ]"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    toggleButtonAnimation()
end)
