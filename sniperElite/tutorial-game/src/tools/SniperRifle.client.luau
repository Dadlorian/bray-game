-- SNIPER RIFLE: Clean zoom + crosshair + sounds!
-- Right-click = zoom, Left-click = shoot
-- Left-shift = hold breath (steadies aim)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--[[
	LINEAR INTERPOLATION (LERP)

	This smoothly moves from one number to another.

	How it works:
	- 'a' is where you START
	- 'b' is where you want to END
	- 't' is how far along (0 = start, 1 = end, 0.5 = halfway)

	Example: lerp(0, 100, 0.5) = 50 (halfway between 0 and 100)
	Example: lerp(0, 100, 0.25) = 25 (quarter of the way)

	We use this to make scope sway smoothly get steady when holding breath!
]]
local function lerp(a: number, b: number, t: number): number
	return a + (b - a) * t
end

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

-- Scope sway settings (breathing effect)
local SWAY_AMOUNT = 0.15         -- How much the scope moves (in degrees) - gentle breathing
local SWAY_SPEED = 1.5           -- How fast the breathing cycle is - slower, calmer
local STEADY_SWAY = 0.01         -- Sway when holding breath (almost perfectly still!)
local TIRED_SWAY = 0.4           -- Sway when out of breath (shaky but not crazy)

-- Breath holding settings
local MAX_BREATH = 4             -- Seconds you can hold breath
local BREATH_RECOVER_RATE = 0.5  -- How fast breath comes back (per second)
local currentBreath = MAX_BREATH -- Current breath remaining
local isHoldingBreath = false    -- Is the player holding shift?
local currentSwayAmount = SWAY_AMOUNT  -- Current sway (changes smoothly with lerp!)

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

--[[
	BUILD THE VISIBLE SNIPER RIFLE MODEL

	This creates all the parts that make the gun look like a real sniper rifle.
	Each part is welded to the Handle so it moves with the player's hand.
]]
local gunModel = nil  -- Will hold all the gun parts
local muzzlePoint = nil  -- Where bullets come from

local function createGunPart(name: string, size: Vector3, color: Color3, material: Enum.Material, offset: CFrame): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Color = color
	part.Material = material
	part.CanCollide = false
	part.Anchored = false

	-- Weld it to the Handle
	local handle = tool:FindFirstChild("Handle")
	if handle then
		part.CFrame = handle.CFrame * offset
		part.Parent = tool

		local weld = Instance.new("WeldConstraint")
		weld.Part0 = handle
		weld.Part1 = part
		weld.Parent = part
	end

	return part
end

local function buildGunModel()
	-- Don't build twice
	if gunModel then return end

	local handle = tool:FindFirstChild("Handle")
	if not handle then return end

	gunModel = Instance.new("Folder")
	gunModel.Name = "GunModel"
	gunModel.Parent = tool

	-- Main body (receiver)
	local body = createGunPart(
		"Body",
		Vector3.new(0.4, 0.5, 2.0),
		Color3.fromRGB(50, 50, 55),
		Enum.Material.Metal,
		CFrame.new(0, 0.1, 0.3)
	)

	-- Long barrel
	local barrel = createGunPart(
		"Barrel",
		Vector3.new(0.2, 0.2, 2.5),
		Color3.fromRGB(35, 35, 40),
		Enum.Material.Metal,
		CFrame.new(0, 0.15, -1.5)
	)

	-- Muzzle (front of barrel)
	local muzzle = createGunPart(
		"Muzzle",
		Vector3.new(0.3, 0.3, 0.2),
		Color3.fromRGB(25, 25, 30),
		Enum.Material.Metal,
		CFrame.new(0, 0.15, -2.8)
	)
	muzzlePoint = muzzle  -- Save this for bullet spawning!

	-- Stock (back part you hold against shoulder)
	local stock = createGunPart(
		"Stock",
		Vector3.new(0.35, 0.6, 1.0),
		Color3.fromRGB(90, 50, 30),
		Enum.Material.Wood,
		CFrame.new(0, 0, 1.5)
	)

	-- Scope tube
	local scope = createGunPart(
		"Scope",
		Vector3.new(0.3, 0.3, 1.0),
		Color3.fromRGB(20, 20, 25),
		Enum.Material.Metal,
		CFrame.new(0, 0.5, 0)
	)

	-- Scope front lens (glass)
	local lensFront = createGunPart(
		"LensFront",
		Vector3.new(0.25, 0.25, 0.05),
		Color3.fromRGB(100, 150, 200),
		Enum.Material.Glass,
		CFrame.new(0, 0.5, -0.5)
	)
	lensFront.Transparency = 0.4

	-- Scope rear lens
	local lensRear = createGunPart(
		"LensRear",
		Vector3.new(0.2, 0.2, 0.05),
		Color3.fromRGB(100, 150, 200),
		Enum.Material.Glass,
		CFrame.new(0, 0.5, 0.5)
	)
	lensRear.Transparency = 0.4

	-- Trigger guard
	local triggerGuard = createGunPart(
		"TriggerGuard",
		Vector3.new(0.1, 0.3, 0.3),
		Color3.fromRGB(40, 40, 45),
		Enum.Material.Metal,
		CFrame.new(0, -0.2, 0.5)
	)

	-- (Bipod removed - just the arm holding the gun now!)
end

local function destroyGunModel()
	if gunModel then
		gunModel:Destroy()
		gunModel = nil
		muzzlePoint = nil
	end
	-- Also destroy any parts that were created
	for _, part in tool:GetChildren() do
		if part:IsA("Part") and part.Name ~= "Handle" then
			part:Destroy()
		end
	end
end

--[[
	BULLET TRACER EFFECT

	Creates a visible bullet that flies from the gun to where you shot.
	Uses LERP to smoothly move the bullet!
]]
local function createBulletTracer(startPos: Vector3, endPos: Vector3)
	-- Create the bullet
	local bullet = Instance.new("Part")
	bullet.Name = "Bullet"
	bullet.Size = Vector3.new(0.1, 0.1, 1.5)  -- Long and thin like a bullet trail
	bullet.Color = Color3.fromRGB(255, 200, 50)  -- Golden/yellow tracer
	bullet.Material = Enum.Material.Neon
	bullet.CanCollide = false
	bullet.Anchored = true
	bullet.CastShadow = false
	bullet.Parent = workspace

	-- Calculate direction and distance
	local direction = (endPos - startPos).Unit
	local distance = (endPos - startPos).Magnitude

	-- Point the bullet in the right direction
	bullet.CFrame = CFrame.lookAt(startPos, endPos) * CFrame.new(0, 0, -0.75)

	-- Animate the bullet flying using lerp!
	local BULLET_SPEED = 800  -- Studs per second (fast!)
	local travelTime = distance / BULLET_SPEED

	local startTime = tick()

	local connection
	connection = RunService.RenderStepped:Connect(function()
		local elapsed = tick() - startTime
		local t = math.min(elapsed / travelTime, 1)  -- 0 to 1

		-- LERP the position from start to end
		local currentPos = startPos:Lerp(endPos, t)
		bullet.CFrame = CFrame.lookAt(currentPos, endPos) * CFrame.new(0, 0, -0.75)

		-- When bullet reaches target, stop and fade out
		if t >= 1 then
			connection:Disconnect()
			-- Quick fade out
			local fadeOut = TweenService:Create(bullet, TweenInfo.new(0.1), {Transparency = 1})
			fadeOut:Play()
			fadeOut.Completed:Connect(function()
				bullet:Destroy()
			end)
		end
	end)
end

-- Create muzzle flash effect (IMPROVED - bigger, more dramatic)
local function createMuzzleFlash()
	if not muzzlePoint then return end

	-- Main flash
	local flash = Instance.new("Part")
	flash.Name = "MuzzleFlash"
	flash.Size = Vector3.new(0.8, 0.8, 1.2)
	flash.Color = Color3.fromRGB(255, 220, 150)
	flash.Material = Enum.Material.Neon
	flash.CanCollide = false
	flash.Anchored = true
	flash.CastShadow = false
	flash.CFrame = muzzlePoint.CFrame * CFrame.new(0, 0, -0.6)
	flash.Parent = workspace

	-- Add a point light for dramatic effect
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(255, 200, 100)
	light.Brightness = 3
	light.Range = 15
	light.Parent = flash

	-- Quick flash then disappear
	task.delay(0.06, function()
		flash:Destroy()
	end)
end

--[[
	PRO EFFECTS - What makes games feel "juicy" and professional!

	1. Screen Shake - makes impacts feel powerful
	2. Slow-Mo Bullet Cam - makes kills feel epic
	3. Kill Confirmation - satisfying feedback
]]

-- Screen shake effect (makes shots feel powerful!)
local function screenShake(intensity: number, duration: number)
	local startTime = tick()
	local originalCFrame = camera.CFrame

	local shakeConnection
	shakeConnection = RunService.RenderStepped:Connect(function()
		local elapsed = tick() - startTime
		if elapsed > duration then
			shakeConnection:Disconnect()
			return
		end

		-- Shake decreases over time (lerp to 0)
		local remaining = 1 - (elapsed / duration)
		local shakeAmount = intensity * remaining

		-- Random shake offset
		local shakeX = (math.random() - 0.5) * shakeAmount
		local shakeY = (math.random() - 0.5) * shakeAmount

		camera.CFrame = camera.CFrame * CFrame.Angles(math.rad(shakeY), math.rad(shakeX), 0)
	end)
end

-- Kill confirmation popup (shows distance and points!)
local function showKillConfirmation(distance: number)
	local playerGui = player:WaitForChild("PlayerGui")

	-- Create popup
	local popup = Instance.new("ScreenGui")
	popup.Name = "KillPopup"
	popup.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 80)
	frame.Position = UDim2.new(0.5, -150, 0.3, 0)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.4
	frame.BorderSizePixel = 0
	frame.Parent = popup

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	-- "TARGET ELIMINATED" text
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0.5, 0)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "TARGET ELIMINATED"
	title.TextColor3 = Color3.fromRGB(255, 50, 50)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.Parent = frame

	-- Distance and points
	local points = math.floor(distance / 5) * 10  -- More distance = more points!
	local details = Instance.new("TextLabel")
	details.Size = UDim2.new(1, 0, 0.5, 0)
	details.Position = UDim2.new(0, 0, 0.5, 0)
	details.BackgroundTransparency = 1
	details.Text = string.format("%.0f studs  |  +%d points", distance, points)
	details.TextColor3 = Color3.fromRGB(255, 200, 50)
	details.TextSize = 18
	details.Font = Enum.Font.Gotham
	details.Parent = frame

	-- Animate in (scale up)
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = UDim2.new(0.5, 0, 0.3, 40)
	local tweenIn = TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
		Size = UDim2.new(0, 300, 0, 80),
		Position = UDim2.new(0.5, -150, 0.3, 0)
	})
	tweenIn:Play()

	-- Fade out after delay
	task.delay(1.5, function()
		local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3), {
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, -150, 0.25, 0)
		})
		local textFade1 = TweenService:Create(title, TweenInfo.new(0.3), {TextTransparency = 1})
		local textFade2 = TweenService:Create(details, TweenInfo.new(0.3), {TextTransparency = 1})

		tweenOut:Play()
		textFade1:Play()
		textFade2:Play()

		tweenOut.Completed:Connect(function()
			popup:Destroy()
		end)
	end)

	return points
end

--[[
	SLOW-MOTION BULLET CAM

	This is what makes sniper games feel EPIC!
	When you hit a target, time slows down and you watch the bullet fly.

	Why pro developers use this:
	- Rewards the player for good shots
	- Creates "wow" moments
	- Makes long-distance shots feel satisfying
	- Gives time to appreciate what happened
]]
local bulletCamActive = false

local function createBulletCam(startPos: Vector3, endPos: Vector3, hitTarget: boolean)
	-- Only do slow-mo for target hits (not every shot)
	local useBulletCam = hitTarget

	-- Create the bullet
	local bullet = Instance.new("Part")
	bullet.Name = "Bullet"
	bullet.Color = Color3.fromRGB(255, 200, 50)
	bullet.Material = Enum.Material.Neon
	bullet.CanCollide = false
	bullet.Anchored = true
	bullet.CastShadow = false
	bullet.Parent = workspace

	local distance = (endPos - startPos).Magnitude

	if useBulletCam and distance > 30 and not bulletCamActive then
		-- EPIC BULLET CAM MODE!
		bulletCamActive = true

		-- Make bullet bigger and more visible for the cam
		bullet.Size = Vector3.new(0.3, 0.3, 2.0)

		-- Add trail effect
		local trail = Instance.new("Trail")
		local att0 = Instance.new("Attachment")
		local att1 = Instance.new("Attachment")
		att0.Position = Vector3.new(0, 0, -1)
		att1.Position = Vector3.new(0, 0, 1)
		att0.Parent = bullet
		att1.Parent = bullet
		trail.Attachment0 = att0
		trail.Attachment1 = att1
		trail.Color = ColorSequence.new(Color3.fromRGB(255, 200, 100), Color3.fromRGB(255, 100, 50))
		trail.Transparency = NumberSequence.new(0, 1)
		trail.Lifetime = 0.5
		trail.WidthScale = NumberSequence.new(1, 0)
		trail.Parent = bullet

		-- Slower bullet for dramatic effect
		local BULLET_SPEED = 150  -- Much slower for bullet cam!
		local travelTime = distance / BULLET_SPEED

		local startTime = tick()
		local originalCameraType = camera.CameraType

		-- Switch to following the bullet
		camera.CameraType = Enum.CameraType.Scriptable

		local connection
		connection = RunService.RenderStepped:Connect(function()
			local elapsed = tick() - startTime
			local t = math.min(elapsed / travelTime, 1)

			-- Smooth easing (slow at start and end)
			local smoothT = t * t * (3 - 2 * t)  -- Smoothstep function!

			-- Lerp bullet position
			local currentPos = startPos:Lerp(endPos, smoothT)
			bullet.CFrame = CFrame.lookAt(currentPos, endPos) * CFrame.new(0, 0, -1)

			-- Camera follows behind and slightly above bullet
			local cameraOffset = (startPos - endPos).Unit * 8 + Vector3.new(0, 3, 0)
			local targetCameraPos = currentPos + cameraOffset
			camera.CFrame = CFrame.lookAt(targetCameraPos, currentPos)

			if t >= 1 then
				connection:Disconnect()
				bulletCamActive = false

				-- Return camera to normal
				camera.CameraType = Enum.CameraType.Custom
				player.CameraMode = Enum.CameraMode.LockFirstPerson

				-- Impact effect!
				screenShake(0.8, 0.15)

				-- Destroy bullet with flash
				local impactFlash = Instance.new("Part")
				impactFlash.Size = Vector3.new(2, 2, 2)
				impactFlash.Position = endPos
				impactFlash.Color = Color3.fromRGB(255, 255, 200)
				impactFlash.Material = Enum.Material.Neon
				impactFlash.Anchored = true
				impactFlash.CanCollide = false
				impactFlash.Shape = Enum.PartType.Ball
				impactFlash.Parent = workspace

				local flashTween = TweenService:Create(impactFlash, TweenInfo.new(0.2), {
					Size = Vector3.new(4, 4, 4),
					Transparency = 1
				})
				flashTween:Play()
				flashTween.Completed:Connect(function()
					impactFlash:Destroy()
				end)

				bullet:Destroy()
			end
		end)
	else
		-- Normal fast bullet (no slow-mo)
		bullet.Size = Vector3.new(0.1, 0.1, 1.5)

		local BULLET_SPEED = 800
		local travelTime = distance / BULLET_SPEED
		local startTime = tick()

		local connection
		connection = RunService.RenderStepped:Connect(function()
			local elapsed = tick() - startTime
			local t = math.min(elapsed / travelTime, 1)

			local currentPos = startPos:Lerp(endPos, t)
			bullet.CFrame = CFrame.lookAt(currentPos, endPos) * CFrame.new(0, 0, -0.75)

			if t >= 1 then
				connection:Disconnect()
				local fadeOut = TweenService:Create(bullet, TweenInfo.new(0.1), {Transparency = 1})
				fadeOut:Play()
				fadeOut.Completed:Connect(function()
					bullet:Destroy()
				end)
			end
		end)
	end
end

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

--[[
	SCOPE OVERLAY

	Creates a realistic sniper scope view with:
	- Black vignette around edges (like looking through a tube)
	- Crosshairs with mil-dots for range finding
	- Scope ring around the view
]]
local crosshairGui = nil
local function createScopeOverlay()
	local playerGui = player:WaitForChild("PlayerGui")

	if playerGui:FindFirstChild("ScopeOverlay") then
		playerGui.ScopeOverlay:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ScopeOverlay"
	screenGui.Enabled = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 100  -- Show on top
	screenGui.Parent = playerGui

	-- Scope colors
	local scopeBlack = Color3.fromRGB(0, 0, 0)
	local reticleColor = Color3.fromRGB(0, 0, 0)  -- Black crosshairs
	local reticleThickness = 2

	-- Dark overlay for the edges (vignette effect)
	-- Left black bar
	local leftBar = Instance.new("Frame")
	leftBar.Name = "LeftBar"
	leftBar.Size = UDim2.new(0.25, 0, 1, 0)
	leftBar.Position = UDim2.new(0, 0, 0, 0)
	leftBar.BackgroundColor3 = scopeBlack
	leftBar.BorderSizePixel = 0
	leftBar.Parent = screenGui

	-- Right black bar
	local rightBar = Instance.new("Frame")
	rightBar.Name = "RightBar"
	rightBar.Size = UDim2.new(0.25, 0, 1, 0)
	rightBar.Position = UDim2.new(0.75, 0, 0, 0)
	rightBar.BackgroundColor3 = scopeBlack
	rightBar.BorderSizePixel = 0
	rightBar.Parent = screenGui

	-- Top black bar (above scope circle)
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(0.5, 0, 0.15, 0)
	topBar.Position = UDim2.new(0.25, 0, 0, 0)
	topBar.BackgroundColor3 = scopeBlack
	topBar.BorderSizePixel = 0
	topBar.Parent = screenGui

	-- Bottom black bar (below scope circle)
	local bottomBar = Instance.new("Frame")
	bottomBar.Name = "BottomBar"
	bottomBar.Size = UDim2.new(0.5, 0, 0.15, 0)
	bottomBar.Position = UDim2.new(0.25, 0, 0.85, 0)
	bottomBar.BackgroundColor3 = scopeBlack
	bottomBar.BorderSizePixel = 0
	bottomBar.Parent = screenGui

	-- Corner pieces to make it more circular
	local corners = {
		{pos = UDim2.new(0.25, 0, 0.15, 0), size = UDim2.new(0.08, 0, 0.12, 0)},
		{pos = UDim2.new(0.67, 0, 0.15, 0), size = UDim2.new(0.08, 0, 0.12, 0)},
		{pos = UDim2.new(0.25, 0, 0.73, 0), size = UDim2.new(0.08, 0, 0.12, 0)},
		{pos = UDim2.new(0.67, 0, 0.73, 0), size = UDim2.new(0.08, 0, 0.12, 0)},
	}
	for i, corner in ipairs(corners) do
		local c = Instance.new("Frame")
		c.Name = "Corner" .. i
		c.Size = corner.size
		c.Position = corner.pos
		c.BackgroundColor3 = scopeBlack
		c.BorderSizePixel = 0
		c.Parent = screenGui
	end

	-- Scope ring (circular border)
	local scopeRing = Instance.new("ImageLabel")
	scopeRing.Name = "ScopeRing"
	scopeRing.Size = UDim2.new(0.5, 0, 0.7, 0)
	scopeRing.Position = UDim2.new(0.25, 0, 0.15, 0)
	scopeRing.BackgroundTransparency = 1
	scopeRing.Image = "rbxassetid://3570695787"  -- Circle image
	scopeRing.ImageColor3 = Color3.fromRGB(30, 30, 30)
	scopeRing.ImageTransparency = 0.3
	scopeRing.ScaleType = Enum.ScaleType.Fit
	scopeRing.Parent = screenGui

	-- CROSSHAIRS (the aiming reticle)
	-- Main horizontal line (left side)
	local hLeft = Instance.new("Frame")
	hLeft.Name = "CrosshairLeft"
	hLeft.Size = UDim2.new(0.15, 0, 0, reticleThickness)
	hLeft.Position = UDim2.new(0.28, 0, 0.5, -reticleThickness/2)
	hLeft.BackgroundColor3 = reticleColor
	hLeft.BorderSizePixel = 0
	hLeft.Parent = screenGui

	-- Main horizontal line (right side)
	local hRight = Instance.new("Frame")
	hRight.Name = "CrosshairRight"
	hRight.Size = UDim2.new(0.15, 0, 0, reticleThickness)
	hRight.Position = UDim2.new(0.57, 0, 0.5, -reticleThickness/2)
	hRight.BackgroundColor3 = reticleColor
	hRight.BorderSizePixel = 0
	hRight.Parent = screenGui

	-- Main vertical line (top)
	local vTop = Instance.new("Frame")
	vTop.Name = "CrosshairTop"
	vTop.Size = UDim2.new(0, reticleThickness, 0.12, 0)
	vTop.Position = UDim2.new(0.5, -reticleThickness/2, 0.2, 0)
	vTop.BackgroundColor3 = reticleColor
	vTop.BorderSizePixel = 0
	vTop.Parent = screenGui

	-- Main vertical line (bottom) - longer for bullet drop reference
	local vBottom = Instance.new("Frame")
	vBottom.Name = "CrosshairBottom"
	vBottom.Size = UDim2.new(0, reticleThickness, 0.25, 0)
	vBottom.Position = UDim2.new(0.5, -reticleThickness/2, 0.52, 0)
	vBottom.BackgroundColor3 = reticleColor
	vBottom.BorderSizePixel = 0
	vBottom.Parent = screenGui

	-- Center dot (where you aim!)
	local centerDot = Instance.new("Frame")
	centerDot.Name = "CenterDot"
	centerDot.Size = UDim2.new(0, 6, 0, 6)
	centerDot.Position = UDim2.new(0.5, -3, 0.5, -3)
	centerDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red center dot!
	centerDot.BorderSizePixel = 0
	centerDot.Parent = screenGui

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)  -- Make it circular
	dotCorner.Parent = centerDot

	-- Mil-dots on vertical line (for range estimation)
	local milDotPositions = {0.58, 0.64, 0.70}
	for i, yPos in ipairs(milDotPositions) do
		local milDot = Instance.new("Frame")
		milDot.Name = "MilDot" .. i
		milDot.Size = UDim2.new(0, 8, 0, 2)
		milDot.Position = UDim2.new(0.5, -4, yPos, 0)
		milDot.BackgroundColor3 = reticleColor
		milDot.BorderSizePixel = 0
		milDot.Parent = screenGui
	end

	-- Small tick marks on horizontal lines
	local tickPositions = {0.32, 0.36, 0.40, 0.60, 0.64, 0.68}
	for i, xPos in ipairs(tickPositions) do
		local tick = Instance.new("Frame")
		tick.Name = "Tick" .. i
		tick.Size = UDim2.new(0, 2, 0, 6)
		tick.Position = UDim2.new(xPos, -1, 0.5, -3)
		tick.BackgroundColor3 = reticleColor
		tick.BorderSizePixel = 0
		tick.Parent = screenGui
	end

	return screenGui
end

local killLabel = createKillCounter()
crosshairGui = createScopeOverlay()

-- Create breath meter (shows when holding breath)
local breathMeterGui = nil
local breathFill = nil
local function createBreathMeter()
	local playerGui = player:WaitForChild("PlayerGui")

	if playerGui:FindFirstChild("BreathMeter") then
		playerGui.BreathMeter:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "BreathMeter"
	screenGui.Enabled = false  -- Only show when zoomed
	screenGui.Parent = playerGui

	-- Background bar
	local background = Instance.new("Frame")
	background.Name = "Background"
	background.Size = UDim2.new(0, 200, 0, 10)
	background.Position = UDim2.new(0.5, -100, 0.8, 0)  -- Bottom center-ish
	background.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	background.BorderSizePixel = 0
	background.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = background

	-- Fill bar (shows breath remaining)
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(1, 0, 1, 0)  -- Starts full
	fill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)  -- Light blue
	fill.BorderSizePixel = 0
	fill.Parent = background

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 5)
	fillCorner.Parent = fill

	-- Label
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Position = UDim2.new(0, 0, -2.5, 0)
	label.BackgroundTransparency = 1
	label.Text = "HOLD SHIFT TO STEADY"
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextSize = 14
	label.Font = Enum.Font.GothamBold
	label.Parent = background

	breathFill = fill
	return screenGui
end

breathMeterGui = createBreathMeter()

-- Zoom function
-- Hide/show gun parts (when looking through scope, hide the gun)
local function setGunVisible(visible: boolean)
	for _, part in tool:GetChildren() do
		if part:IsA("Part") then
			part.Transparency = visible and 0 or 1
			-- Keep glass parts semi-transparent
			if part.Material == Enum.Material.Glass then
				part.Transparency = visible and 0.4 or 1
			end
		end
	end
end

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

	-- Hide gun when looking through scope (you're looking THROUGH it!)
	setGunVisible(not zoomed)

	-- Smooth zoom animation
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(camera, tweenInfo, {FieldOfView = targetFOV})
	tween:Play()

	-- Show/hide scope overlay and breath meter
	crosshairGui.Enabled = zoomed
	breathMeterGui.Enabled = zoomed
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
	-- Don't shoot during bullet cam
	if bulletCamActive then return end

	-- Play gunshot sound
	gunshotSound:Play()

	-- Create muzzle flash!
	createMuzzleFlash()

	-- Small screen shake on every shot (recoil feel)
	screenShake(0.3, 0.08)

	local mouseLocation = UserInputService:GetMouseLocation()
	local unitRay = camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {player.Character, tool}  -- Don't hit ourselves or the gun!
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local origin = unitRay.Origin
	local direction = unitRay.Direction * BULLET_RANGE
	local result = workspace:Raycast(origin, direction, raycastParams)

	-- Determine where the bullet should go
	local bulletStart = muzzlePoint and muzzlePoint.Position or origin
	local bulletEnd = result and result.Position or (origin + direction)

	-- Check if we hit a target BEFORE creating the bullet
	local hitTarget = false
	if result then
		hitTarget = isTarget(result.Instance)
	end

	-- Create bullet with potential slow-mo cam!
	createBulletCam(bulletStart, bulletEnd, hitTarget)

	if result then
		local hitPart = result.Instance

		createHitMarker(result.Position, hitTarget)

		if hitTarget then
			-- Play hit sound
			hitSound:Play()

			-- Show kill confirmation with distance!
			local distance = (bulletEnd - bulletStart).Magnitude
			showKillConfirmation(distance)

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

	-- Build the visible gun model!
	buildGunModel()

	shootConnection = mouse.Button1Down:Connect(shoot)
	zoomConnection = mouse.Button2Down:Connect(onRightClick)
end)

tool.Unequipped:Connect(function()
	isEquipped = false

	if isZoomed then
		setZoom(false)
	end

	-- Remove the gun model
	destroyGunModel()

	if shootConnection then
		shootConnection:Disconnect()
	end
	if zoomConnection then
		zoomConnection:Disconnect()
	end
end)

--[[
	SCOPE SWAY & BREATHING SYSTEM

	This runs every frame and does:
	1. Checks if player is holding Left Shift (hold breath)
	2. Uses LERP to smoothly change the sway amount
	3. Applies gentle camera movement to simulate breathing
	4. Updates the breath meter UI

	The lerp makes transitions smooth instead of instant!
]]

local swayTime = 0  -- Tracks time for smooth wave motion

RunService.RenderStepped:Connect(function(deltaTime)
	-- Only apply sway when zoomed in with scope
	if not isZoomed or not isEquipped then
		return
	end

	-- Check if player is holding Left Shift
	isHoldingBreath = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)

	-- Determine what our TARGET sway should be
	local targetSway

	if isHoldingBreath and currentBreath > 0 then
		-- Holding breath: aim for steady (low sway)
		targetSway = STEADY_SWAY
		-- Use up breath
		currentBreath = currentBreath - deltaTime
	elseif currentBreath <= 0 then
		-- Out of breath: extra shaky!
		targetSway = TIRED_SWAY
		-- Slowly recover breath (but still shaky until we let go of shift)
		if not isHoldingBreath then
			currentBreath = currentBreath + (BREATH_RECOVER_RATE * deltaTime)
		end
	else
		-- Normal breathing: regular sway
		targetSway = SWAY_AMOUNT
		-- Recover breath when not holding shift
		if not isHoldingBreath and currentBreath < MAX_BREATH then
			currentBreath = currentBreath + (BREATH_RECOVER_RATE * deltaTime)
		end
	end

	-- HERE'S THE LERP! Smoothly transition to target sway
	-- When holding breath, snap to steady faster (0.2 = 20% per frame)
	-- When letting go, ease back slowly (0.08 = 8% per frame)
	local lerpSpeed = isHoldingBreath and 0.2 or 0.08
	currentSwayAmount = lerp(currentSwayAmount, targetSway, lerpSpeed)

	-- Update breath meter UI
	if breathFill then
		local breathPercent = math.clamp(currentBreath / MAX_BREATH, 0, 1)
		breathFill.Size = UDim2.new(breathPercent, 0, 1, 0)

		-- Change color based on breath level
		if breathPercent > 0.5 then
			breathFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)  -- Blue = good
		elseif breathPercent > 0.2 then
			breathFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)  -- Yellow = warning
		else
			breathFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)  -- Red = almost out!
		end
	end

	-- Apply scope sway (gentle wave motion)
	swayTime = swayTime + (deltaTime * SWAY_SPEED)

	-- Use sine waves for smooth, natural breathing motion
	local swayX = math.sin(swayTime) * currentSwayAmount
	local swayY = math.sin(swayTime * 0.7) * currentSwayAmount * 0.5  -- Slower vertical

	-- Apply to camera
	local currentCFrame = camera.CFrame
	local swayRotation = CFrame.Angles(math.rad(swayY), math.rad(swayX), 0)
	camera.CFrame = currentCFrame * swayRotation
end)
