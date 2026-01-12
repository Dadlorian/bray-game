-- SNIPER RIFLE: Clean zoom + crosshair + sounds!
-- Right-click = zoom, Left-click = shoot

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local tool = script.Parent
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local TargetHit = ReplicatedStorage:WaitForChild("Events"):WaitForChild("TargetHit")

local BULLET_RANGE = 1000
local kills = 0

-- Zoom settings
local NORMAL_FOV = 70
local ZOOMED_FOV = 20
local isZoomed = false
local isEquipped = false

-- Sound IDs
local GUNSHOT_SOUND = "rbxassetid://168143115"   -- Sniper shot
local HIT_SOUND = "rbxassetid://166221646"       -- Hit marker sound
local ZOOM_IN_SOUND = "rbxassetid://169310252"   -- Scope zoom

-- Create and cache sounds
local gunshotSound = Instance.new("Sound")
gunshotSound.SoundId = GUNSHOT_SOUND
gunshotSound.Volume = 0.8
gunshotSound.Parent = player:WaitForChild("PlayerGui")

local hitSound = Instance.new("Sound")
hitSound.SoundId = HIT_SOUND
hitSound.Volume = 0.6
hitSound.Parent = player:WaitForChild("PlayerGui")

local zoomSound = Instance.new("Sound")
zoomSound.SoundId = ZOOM_IN_SOUND
zoomSound.Volume = 0.3
zoomSound.Parent = player:WaitForChild("PlayerGui")

-- Create the kill counter GUI
local function createKillCounter()
	local playerGui = player:WaitForChild("PlayerGui")

	if playerGui:FindFirstChild("KillCounter") then
		return playerGui.KillCounter.Frame.KillLabel
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "KillCounter"
	screenGui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Name = "Frame"
	frame.Size = UDim2.new(0, 200, 0, 60)
	frame.Position = UDim2.new(0, 20, 0, 20)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.5
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local label = Instance.new("TextLabel")
	label.Name = "KillLabel"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "KILLS: 0"
	label.TextColor3 = Color3.fromRGB(255, 50, 50)
	label.TextSize = 32
	label.Font = Enum.Font.GothamBold
	label.Parent = frame

	return label
end

-- Create simple crosshair
local crosshairGui = nil
local function createCrosshair()
	local playerGui = player:WaitForChild("PlayerGui")

	if playerGui:FindFirstChild("Crosshair") then
		playerGui.Crosshair:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Crosshair"
	screenGui.Enabled = false
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = playerGui

	local lineColor = Color3.fromRGB(255, 0, 0)
	local lineThickness = 2
	local lineLength = 20
	local gapSize = 8

	-- Horizontal line (left)
	local hLeft = Instance.new("Frame")
	hLeft.Size = UDim2.new(0, lineLength, 0, lineThickness)
	hLeft.Position = UDim2.new(0.5, -gapSize - lineLength, 0.5, -lineThickness/2)
	hLeft.BackgroundColor3 = lineColor
	hLeft.BorderSizePixel = 0
	hLeft.Parent = screenGui

	-- Horizontal line (right)
	local hRight = Instance.new("Frame")
	hRight.Size = UDim2.new(0, lineLength, 0, lineThickness)
	hRight.Position = UDim2.new(0.5, gapSize, 0.5, -lineThickness/2)
	hRight.BackgroundColor3 = lineColor
	hRight.BorderSizePixel = 0
	hRight.Parent = screenGui

	-- Vertical line (top)
	local vTop = Instance.new("Frame")
	vTop.Size = UDim2.new(0, lineThickness, 0, lineLength)
	vTop.Position = UDim2.new(0.5, -lineThickness/2, 0.5, -gapSize - lineLength)
	vTop.BackgroundColor3 = lineColor
	vTop.BorderSizePixel = 0
	vTop.Parent = screenGui

	-- Vertical line (bottom)
	local vBottom = Instance.new("Frame")
	vBottom.Size = UDim2.new(0, lineThickness, 0, lineLength)
	vBottom.Position = UDim2.new(0.5, -lineThickness/2, 0.5, gapSize)
	vBottom.BackgroundColor3 = lineColor
	vBottom.BorderSizePixel = 0
	vBottom.Parent = screenGui

	-- Center dot
	local centerDot = Instance.new("Frame")
	centerDot.Size = UDim2.new(0, 4, 0, 4)
	centerDot.Position = UDim2.new(0.5, -2, 0.5, -2)
	centerDot.BackgroundColor3 = lineColor
	centerDot.BorderSizePixel = 0
	centerDot.Parent = screenGui

	return screenGui
end

local killLabel = createKillCounter()
crosshairGui = createCrosshair()

-- Zoom function
local function setZoom(zoomed: boolean)
	isZoomed = zoomed
	local targetFOV = zoomed and ZOOMED_FOV or NORMAL_FOV

	-- Play zoom sound
	zoomSound:Play()

	-- Switch camera mode
	if zoomed then
		player.CameraMode = Enum.CameraMode.LockFirstPerson
	else
		player.CameraMode = Enum.CameraMode.Classic
	end

	-- Smooth zoom animation
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(camera, tweenInfo, {FieldOfView = targetFOV})
	tween:Play()

	-- Show/hide crosshair
	crosshairGui.Enabled = zoomed
end

-- Update the kill display
local function updateKillCounter()
	kills = kills + 1
	killLabel.Text = "KILLS: " .. kills
end

-- Create a visual hit marker
local function createHitMarker(position: Vector3, isTarget: boolean)
	local marker = Instance.new("Part")
	marker.Name = "HitMarker"
	marker.Size = Vector3.new(0.5, 0.5, 0.5)
	marker.Position = position
	marker.Anchored = true
	marker.CanCollide = false
	marker.Color = isTarget and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	marker.Material = Enum.Material.Neon
	marker.Shape = Enum.PartType.Ball
	marker.Parent = workspace

	task.delay(0.5, function()
		marker:Destroy()
	end)
end

-- Check if the part we hit is a Target
local function isTarget(part: Part): boolean
	if part.Name == "Target" then
		return true
	end
	if part.Parent and part.Parent.Name == "Targets" then
		return true
	end
	return false
end

-- FIRE THE GUN
local function shoot()
	-- Play gunshot sound
	gunshotSound:Play()

	local mouseLocation = UserInputService:GetMouseLocation()
	local unitRay = camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {player.Character}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local origin = unitRay.Origin
	local direction = unitRay.Direction * BULLET_RANGE
	local result = workspace:Raycast(origin, direction, raycastParams)

	if result then
		local hitPart = result.Instance
		local hitTarget = isTarget(hitPart)

		createHitMarker(result.Position, hitTarget)

		if hitTarget then
			-- Play hit sound
			hitSound:Play()

			TargetHit:FireServer(hitPart)
			updateKillCounter()
		end
	end
end

-- Toggle zoom on right-click
local function onRightClick()
	if isEquipped then
		setZoom(not isZoomed)
	end
end

-- Tool equip/unequip
local shootConnection = nil
local zoomConnection = nil

tool.Equipped:Connect(function()
	isEquipped = true
	shootConnection = mouse.Button1Down:Connect(shoot)
	zoomConnection = mouse.Button2Down:Connect(onRightClick)
end)

tool.Unequipped:Connect(function()
	isEquipped = false

	if isZoomed then
		setZoom(false)
	end

	if shootConnection then
		shootConnection:Disconnect()
	end
	if zoomConnection then
		zoomConnection:Disconnect()
	end
end)
