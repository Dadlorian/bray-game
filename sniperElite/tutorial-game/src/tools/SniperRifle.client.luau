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

--[[
	DAMAGE NUMBER POPUP

	Shows floating damage numbers when you hit an enemy.
	- Yellow for normal hits
	- RED + bigger for HEADSHOTS!
	- Floats up and fades out
]]
local function showDamageNumber(position: Vector3, damage: number, isHeadshot: boolean)
	-- Create a BillboardGui at the hit position
	local part = Instance.new("Part")
	part.Name = "DamageAnchor"
	part.Size = Vector3.new(0.1, 0.1, 0.1)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Parent = workspace

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "DamageNumber"
	billboard.Size = UDim2.new(0, 100, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 0, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = part

	-- Damage text
	local damageLabel = Instance.new("TextLabel")
	damageLabel.Size = UDim2.new(1, 0, 1, 0)
	damageLabel.BackgroundTransparency = 1
	damageLabel.Font = Enum.Font.GothamBold
	damageLabel.TextScaled = false
	damageLabel.Parent = billboard

	if isHeadshot then
		-- HEADSHOT! Big red text with skull
		damageLabel.Text = "💀 " .. damage
		damageLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
		damageLabel.TextSize = 32
		damageLabel.TextStrokeColor3 = Color3.fromRGB(100, 0, 0)
		damageLabel.TextStrokeTransparency = 0
	else
		-- Normal hit - yellow
		damageLabel.Text = "-" .. damage
		damageLabel.TextColor3 = Color3.fromRGB(255, 220, 50)
		damageLabel.TextSize = 24
		damageLabel.TextStrokeColor3 = Color3.fromRGB(100, 80, 0)
		damageLabel.TextStrokeTransparency = 0.3
	end

	-- Animate: float up and fade out
	local startY = billboard.StudsOffset.Y
	local floatTween = TweenService:Create(billboard, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		StudsOffset = Vector3.new(0, startY + 3, 0)
	})
	local fadeTween = TweenService:Create(damageLabel, TweenInfo.new(1), {
		TextTransparency = 1,
		TextStrokeTransparency = 1
	})

	floatTween:Play()
	fadeTween:Play()

	-- Clean up after animation
	fadeTween.Completed:Connect(function()
		part:Destroy()
	end)
end

-- Listen for damage feedback from server
TargetHit.OnClientEvent:Connect(function(damageInfo)
	if damageInfo and damageInfo.damage then
		showDamageNumber(damageInfo.position, damageInfo.damage, damageInfo.isHeadshot)

		-- Play extra sound for headshots
		if damageInfo.isHeadshot then
			-- Satisfying "ding" sound first
			local headshotDing = Instance.new("Sound")
			headshotDing.SoundId = "rbxassetid://166221646"
			headshotDing.Volume = 0.8
			headshotDing.PlaybackSpeed = 1.5  -- Higher pitch
			headshotDing.Parent = player:WaitForChild("PlayerGui")
			headshotDing:Play()
			headshotDing.Ended:Connect(function()
				headshotDing:Destroy()
			end)

			-- HEADSHOT VOICE! Says "HEADSHOT!" in a cool announcer voice
			local headshotVoice = Instance.new("Sound")
			headshotVoice.SoundId = "rbxassetid://616594208"  -- Classic "HEADSHOT!" announcer
			headshotVoice.Volume = 1.2  -- Nice and loud!
			headshotVoice.PlaybackSpeed = 1.0
			headshotVoice.Parent = player:WaitForChild("PlayerGui")

			-- Small delay so the ding plays first, then the voice
			task.delay(0.1, function()
				headshotVoice:Play()
			end)

			headshotVoice.Ended:Connect(function()
				headshotVoice:Destroy()
			end)
		end
	end
end)

local BULLET_RANGE = 1000
local kills = 0
local totalPoints = 0  -- Tracks your total score!
local pointsLabel = nil  -- Reference to update points display

-- Zoom settings
local NORMAL_FOV = 70
local ZOOMED_FOV = 20
local isZoomed = false
local isEquipped = false

-- Scope sway settings (breathing effect) - ONLY when zoomed!
local SWAY_AMOUNT = 0.12         -- How much the scope moves (in degrees) - gentle breathing
local SWAY_SPEED = 1.2           -- How fast the breathing cycle is - slower, calmer
local STEADY_SWAY = 0.002        -- Sway when holding breath (SUPER steady - almost none!)
local TIRED_SWAY = 0.3           -- Sway when out of breath

-- Breath holding settings - LONGER breath time!
local MAX_BREATH = 8             -- Seconds you can hold breath (doubled!)
local BREATH_RECOVER_RATE = 1.0  -- How fast breath comes back (faster recovery!)
local currentBreath = MAX_BREATH -- Current breath remaining
local isHoldingBreath = false    -- Is the player holding shift?
local currentSwayAmount = 0      -- Start with NO sway (only sway when zoomed!)

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

	-- Calculate points (more distance = more points!)
	local points = math.floor(distance / 5) * 10

	-- ADD TO TOTAL POINTS!
	totalPoints = totalPoints + points

	-- Update the points display at the top of screen
	if pointsLabel then
		pointsLabel.Text = "POINTS: " .. totalPoints
	end

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
	BRAYDEN'S CUSTOM BULLET CAM

	Settings chosen by Brayden:
	- Camera: BEHIND the bullet (chase view)
	- Speed: SUPER SLOW (dramatic)
	- Effects: Fire trail + Smoke trail + Glowing trail
	- Impact: Time freeze + Sparks + Big explosion
]]
local bulletCamActive = false

-- Create sparks that fly out on impact
local function createSparks(position: Vector3)
	for i = 1, 12 do
		local spark = Instance.new("Part")
		spark.Name = "Spark"
		spark.Size = Vector3.new(0.15, 0.15, 0.15)
		spark.Color = Color3.fromRGB(255, 200, 50)
		spark.Material = Enum.Material.Neon
		spark.CanCollide = false
		spark.Anchored = false
		spark.Position = position
		spark.Parent = workspace

		-- Random direction for each spark
		local randomDir = Vector3.new(
			math.random() - 0.5,
			math.random() * 0.5 + 0.3,
			math.random() - 0.5
		).Unit * (math.random() * 30 + 20)

		spark.AssemblyLinearVelocity = randomDir

		-- Fade out and destroy
		task.delay(0.3, function()
			local fade = TweenService:Create(spark, TweenInfo.new(0.2), {Transparency = 1})
			fade:Play()
			fade.Completed:Connect(function()
				spark:Destroy()
			end)
		end)
	end
end

-- Create big explosion effect
local function createExplosion(position: Vector3)
	-- Main explosion flash
	local explosion = Instance.new("Part")
	explosion.Name = "Explosion"
	explosion.Size = Vector3.new(1, 1, 1)
	explosion.Position = position
	explosion.Color = Color3.fromRGB(255, 150, 50)
	explosion.Material = Enum.Material.Neon
	explosion.Anchored = true
	explosion.CanCollide = false
	explosion.Shape = Enum.PartType.Ball
	explosion.Parent = workspace

	-- Add bright light
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(255, 200, 100)
	light.Brightness = 5
	light.Range = 30
	light.Parent = explosion

	-- Expand and fade
	local expandTween = TweenService:Create(explosion, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		Size = Vector3.new(8, 8, 8),
		Transparency = 1
	})
	expandTween:Play()
	expandTween.Completed:Connect(function()
		explosion:Destroy()
	end)

	-- Secondary orange ring
	local ring = Instance.new("Part")
	ring.Name = "ExplosionRing"
	ring.Size = Vector3.new(0.5, 0.5, 0.5)
	ring.Position = position
	ring.Color = Color3.fromRGB(255, 100, 0)
	ring.Material = Enum.Material.Neon
	ring.Anchored = true
	ring.CanCollide = false
	ring.Shape = Enum.PartType.Ball
	ring.Parent = workspace

	local ringTween = TweenService:Create(ring, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
		Size = Vector3.new(12, 12, 12),
		Transparency = 1
	})
	ringTween:Play()
	ringTween.Completed:Connect(function()
		ring:Destroy()
	end)
end

local function createBulletCam(startPos: Vector3, endPos: Vector3, hitTarget: boolean, onImpact: (() -> ())?)
	local useBulletCam = hitTarget
	local distance = (endPos - startPos).Magnitude

	-- Create the bullet
	local bullet = Instance.new("Part")
	bullet.Name = "Bullet"
	bullet.Color = Color3.fromRGB(255, 200, 50)
	bullet.Material = Enum.Material.Neon
	bullet.CanCollide = false
	bullet.Anchored = true
	bullet.CastShadow = false
	bullet.Parent = workspace

	if useBulletCam and distance > 100 and not bulletCamActive then
		-- BRAYDEN'S EPIC BULLET CAM!
		bulletCamActive = true

		-- UNZOOM the camera so we can see the whole scene!
		-- Reset FOV to normal (no scope view)
		camera.FieldOfView = NORMAL_FOV
		-- Hide the scope overlay during bullet cam
		if crosshairGui then
			crosshairGui.Enabled = false
		end
		if breathMeterGui then
			breathMeterGui.Enabled = false
		end

		-- Make bullet visible
		bullet.Size = Vector3.new(0.3, 0.3, 2.0)

		-- Attachments for trails
		local att0 = Instance.new("Attachment")
		local att1 = Instance.new("Attachment")
		att0.Position = Vector3.new(0, 0, -1)
		att1.Position = Vector3.new(0, 0, 1)
		att0.Parent = bullet
		att1.Parent = bullet

		-- TRAIL 1: FIRE TRAIL (orange/red)
		local fireTrail = Instance.new("Trail")
		fireTrail.Attachment0 = att0
		fireTrail.Attachment1 = att1
		fireTrail.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 200)),
			ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 150, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 0))
		})
		fireTrail.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.5, 0.3),
			NumberSequenceKeypoint.new(1, 1)
		})
		fireTrail.Lifetime = 1.0
		fireTrail.WidthScale = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0)
		})
		fireTrail.Parent = bullet

		-- TRAIL 2: SMOKE TRAIL (grey, wider)
		local att2 = Instance.new("Attachment")
		local att3 = Instance.new("Attachment")
		att2.Position = Vector3.new(0, 0.1, -0.8)
		att3.Position = Vector3.new(0, 0.1, 0.8)
		att2.Parent = bullet
		att3.Parent = bullet

		local smokeTrail = Instance.new("Trail")
		smokeTrail.Attachment0 = att2
		smokeTrail.Attachment1 = att3
		smokeTrail.Color = ColorSequence.new(Color3.fromRGB(100, 100, 100), Color3.fromRGB(50, 50, 50))
		smokeTrail.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(1, 1)
		})
		smokeTrail.Lifetime = 1.5
		smokeTrail.WidthScale = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(0.5, 1.5),
			NumberSequenceKeypoint.new(1, 0)
		})
		smokeTrail.Parent = bullet

		-- TRAIL 3: GLOW TRAIL (bright yellow core)
		local att4 = Instance.new("Attachment")
		local att5 = Instance.new("Attachment")
		att4.Position = Vector3.new(0, 0, -0.5)
		att5.Position = Vector3.new(0, 0, 0.5)
		att4.Parent = bullet
		att5.Parent = bullet

		local glowTrail = Instance.new("Trail")
		glowTrail.Attachment0 = att4
		glowTrail.Attachment1 = att5
		glowTrail.Color = ColorSequence.new(Color3.fromRGB(255, 255, 150), Color3.fromRGB(255, 200, 50))
		glowTrail.Transparency = NumberSequence.new(0, 1)
		glowTrail.Lifetime = 0.4
		glowTrail.WidthScale = NumberSequence.new(0.3, 0)
		glowTrail.LightEmission = 1
		glowTrail.Parent = bullet

		-- Add point light to bullet (makes it glow!)
		local bulletLight = Instance.new("PointLight")
		bulletLight.Color = Color3.fromRGB(255, 200, 100)
		bulletLight.Brightness = 2
		bulletLight.Range = 10
		bulletLight.Parent = bullet

		-- SUPER SLOW speed (dramatic!)
		local BULLET_SPEED = 80
		local travelTime = distance / BULLET_SPEED

		local startTime = tick()
		camera.CameraType = Enum.CameraType.Scriptable

		local connection
		connection = RunService.RenderStepped:Connect(function()
			local elapsed = tick() - startTime
			local t = math.min(elapsed / travelTime, 1)

			-- Smooth easing
			local smoothT = t * t * (3 - 2 * t)

			-- Move bullet
			local currentPos = startPos:Lerp(endPos, smoothT)
			bullet.CFrame = CFrame.lookAt(currentPos, endPos) * CFrame.new(0, 0, -1)

			-- CINEMATIC CAMERA - zoomed out to see the whole journey!
			-- Camera sits to the side and above, watching bullet fly toward target
			local bulletDirection = (endPos - startPos).Unit
			local rightDirection = bulletDirection:Cross(Vector3.new(0, 1, 0)).Unit

			-- Start far back, move closer as bullet travels
			local cameraDistance = lerp(25, 12, smoothT)  -- Starts 25 studs away, ends 12
			local cameraHeight = lerp(8, 4, smoothT)      -- Starts 8 studs up, ends 4
			local sideOffset = rightDirection * 8         -- 8 studs to the side

			local cameraPos = currentPos + (-bulletDirection * cameraDistance) + sideOffset + Vector3.new(0, cameraHeight, 0)

			-- Look slightly ahead of the bullet (toward the target)
			local lookTarget = currentPos:Lerp(endPos, 0.3)
			camera.CFrame = CFrame.lookAt(cameraPos, lookTarget)

			-- When bullet reaches target
			if t >= 1 then
				connection:Disconnect()

				-- TIME FREEZE! (pause for dramatic effect)
				bullet.CFrame = CFrame.lookAt(endPos, endPos + bulletDirection)

				task.wait(0.3)  -- Freeze for 0.3 seconds!

				-- NOW the impact effects!
				createSparks(endPos)
				createExplosion(endPos)
				screenShake(1.2, 0.25)

				-- Call the impact callback (destroys target, plays sounds, etc.)
				if onImpact then
					onImpact()
				end

				-- Clean up
				bullet:Destroy()
				bulletCamActive = false

				-- Return camera
				camera.CameraType = Enum.CameraType.Custom
				player.CameraMode = Enum.CameraMode.LockFirstPerson

				-- Restore zoom state if player was zoomed in
				if isZoomed then
					camera.FieldOfView = ZOOMED_FOV
					if crosshairGui then
						crosshairGui.Enabled = true
					end
					if breathMeterGui then
						breathMeterGui.Enabled = true
					end
				end
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

-- Create the score display GUI (KILLS and POINTS at top!)
local function createKillCounter()
	local playerGui = player:WaitForChild("PlayerGui")

	if playerGui:FindFirstChild("ScoreDisplay") then
		return playerGui.ScoreDisplay.Frame.KillLabel, playerGui.ScoreDisplay.Frame.PointsLabel
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ScoreDisplay"
	screenGui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Name = "Frame"
	frame.Size = UDim2.new(0, 250, 0, 80)
	frame.Position = UDim2.new(0, 20, 0, 20)
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.4
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	-- KILLS label (top)
	local killLabel = Instance.new("TextLabel")
	killLabel.Name = "KillLabel"
	killLabel.Size = UDim2.new(1, 0, 0.5, 0)
	killLabel.Position = UDim2.new(0, 0, 0, 0)
	killLabel.BackgroundTransparency = 1
	killLabel.Text = "KILLS: 0"
	killLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
	killLabel.TextSize = 28
	killLabel.Font = Enum.Font.GothamBold
	killLabel.Parent = frame

	-- POINTS label (bottom)
	local ptsLabel = Instance.new("TextLabel")
	ptsLabel.Name = "PointsLabel"
	ptsLabel.Size = UDim2.new(1, 0, 0.5, 0)
	ptsLabel.Position = UDim2.new(0, 0, 0.5, 0)
	ptsLabel.BackgroundTransparency = 1
	ptsLabel.Text = "POINTS: 0"
	ptsLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
	ptsLabel.TextSize = 24
	ptsLabel.Font = Enum.Font.GothamBold
	ptsLabel.Parent = frame

	pointsLabel = ptsLabel
	return killLabel
end

--[[
	SCOPE OVERLAY - SUPER CLEAN VERSION

	No weird images - just clean black border and crosshairs!
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
	screenGui.DisplayOrder = 100
	screenGui.Parent = playerGui

	local scopeBlack = Color3.fromRGB(0, 0, 0)
	local reticleThickness = 2

	-- Just simple black bars on left and right (no weird image!)
	local leftBar = Instance.new("Frame")
	leftBar.Size = UDim2.new(0.2, 0, 1, 0)
	leftBar.Position = UDim2.new(0, 0, 0, 0)
	leftBar.BackgroundColor3 = scopeBlack
	leftBar.BorderSizePixel = 0
	leftBar.Parent = screenGui

	local rightBar = Instance.new("Frame")
	rightBar.Size = UDim2.new(0.2, 0, 1, 0)
	rightBar.Position = UDim2.new(0.8, 0, 0, 0)
	rightBar.BackgroundColor3 = scopeBlack
	rightBar.BorderSizePixel = 0
	rightBar.Parent = screenGui

	-- SIMPLE CROSSHAIRS
	local hLeft = Instance.new("Frame")
	hLeft.Size = UDim2.new(0.15, 0, 0, reticleThickness)
	hLeft.Position = UDim2.new(0.22, 0, 0.5, -reticleThickness/2)
	hLeft.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	hLeft.BorderSizePixel = 0
	hLeft.Parent = screenGui

	local hRight = Instance.new("Frame")
	hRight.Size = UDim2.new(0.15, 0, 0, reticleThickness)
	hRight.Position = UDim2.new(0.63, 0, 0.5, -reticleThickness/2)
	hRight.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	hRight.BorderSizePixel = 0
	hRight.Parent = screenGui

	local vTop = Instance.new("Frame")
	vTop.Size = UDim2.new(0, reticleThickness, 0.2, 0)
	vTop.Position = UDim2.new(0.5, -reticleThickness/2, 0.15, 0)
	vTop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	vTop.BorderSizePixel = 0
	vTop.Parent = screenGui

	local vBottom = Instance.new("Frame")
	vBottom.Size = UDim2.new(0, reticleThickness, 0.2, 0)
	vBottom.Position = UDim2.new(0.5, -reticleThickness/2, 0.65, 0)
	vBottom.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	vBottom.BorderSizePixel = 0
	vBottom.Parent = screenGui

	-- RED CENTER DOT
	local centerDot = Instance.new("Frame")
	centerDot.Size = UDim2.new(0, 8, 0, 8)
	centerDot.Position = UDim2.new(0.5, -4, 0.5, -4)
	centerDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	centerDot.BorderSizePixel = 0
	centerDot.Parent = screenGui

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = centerDot

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
-- Hide/show gun parts (when looking through scope, show just the barrel tip!)
local function setGunVisible(visible: boolean, showBarrelOnly: boolean)
	for _, part in tool:GetChildren() do
		if part:IsA("Part") then
			-- When zoomed (showBarrelOnly = true), only show barrel and muzzle
			if showBarrelOnly then
				if part.Name == "Barrel" or part.Name == "Muzzle" then
					part.Transparency = 0  -- Show the barrel tip!
				else
					part.Transparency = 1  -- Hide other parts
				end
			else
				-- Normal mode - show everything
				part.Transparency = visible and 0 or 1
				-- Keep glass parts semi-transparent
				if part.Material == Enum.Material.Glass then
					part.Transparency = visible and 0.4 or 1
				end
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

	-- When zoomed, show only the barrel tip (so you can see where you're aiming!)
	if zoomed then
		setGunVisible(false, true)  -- Show barrel only
	else
		setGunVisible(true, false)  -- Show full gun
	end

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

-- Check if the part we hit is a Target (NPC or old-style target)
local function isTarget(part: Part): boolean
	-- Old style: Part named Target or in Targets folder
	if part.Name == "Target" then
		return true
	end
	if part.Parent and part.Parent.Name == "Targets" then
		return true
	end

	-- NEW: Check if it's an NPC (has a Humanoid)
	-- The part could be Head, Torso, Arm, Leg, etc.
	local model = part.Parent
	if model and model:IsA("Model") then
		local humanoid = model:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 then
			return true
		end
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
	local hitPart = nil
	if result then
		hitTarget = isTarget(result.Instance)
		hitPart = result.Instance
	end

	-- Calculate distance for bullet cam decision
	local distance = (bulletEnd - bulletStart).Magnitude
	local willUseBulletCam = hitTarget and distance > 100 and not bulletCamActive

	-- If using bullet cam on a moving target, FREEZE it in place!
	if willUseBulletCam and hitPart then
		-- Freeze the target so bullet visually hits it
		hitPart.Anchored = true
		-- If target is in a model, freeze all parts
		if hitPart.Parent and hitPart.Parent:IsA("Model") then
			for _, part in hitPart.Parent:GetDescendants() do
				if part:IsA("BasePart") then
					part.Anchored = true
				end
			end
		end
	end

	-- Function to handle the actual hit (destroy target, play sounds, etc.)
	local function handleTargetHit()
		if hitPart then
			createHitMarker(bulletEnd, hitTarget)
		end

		if hitTarget and hitPart then
			-- Play hit sound
			hitSound:Play()

			-- Show kill confirmation with distance!
			showKillConfirmation(distance)

			TargetHit:FireServer(hitPart)
			updateKillCounter()
		end
	end

	-- Create bullet with potential slow-mo cam!
	if willUseBulletCam then
		-- Long-range shot: delay hit effects until bullet arrives
		createBulletCam(bulletStart, bulletEnd, hitTarget, handleTargetHit)
	else
		-- Short-range or miss: immediate effects
		createBulletCam(bulletStart, bulletEnd, hitTarget, nil)
		if result then
			handleTargetHit()
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
