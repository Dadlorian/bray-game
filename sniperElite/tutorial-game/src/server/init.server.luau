-- SERVER: Moving targets, explosions, sounds, and respawns
print("Server started!")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local TargetHit = ReplicatedStorage:WaitForChild("Events"):WaitForChild("TargetHit")

-- Store original target info for respawning
local targetData = {}
local activeTargets = {}

-- Sound IDs (Roblox library sounds)
local EXPLOSION_SOUND = "rbxassetid://262562442"  -- Explosion

-- Save all target positions when game starts
local function saveTargetData()
	local targetsFolder = workspace:WaitForChild("Targets")
	for _, target in targetsFolder:GetChildren() do
		if target:IsA("BasePart") then
			targetData[target] = {
				name = target.Name,
				position = target.Position,
				size = target.Size,
				color = target.Color,
				material = target.Material,
				parent = target.Parent
			}
			activeTargets[target] = true
		end
	end
	print("Loaded", #targetData, "targets")
end

-- Play explosion sound at position
local function playExplosionSound(position: Vector3)
	local sound = Instance.new("Sound")
	sound.SoundId = EXPLOSION_SOUND
	sound.Volume = 0.5
	sound.RollOffMaxDistance = 200

	local anchor = Instance.new("Part")
	anchor.Position = position
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.Transparency = 1
	anchor.Size = Vector3.new(1, 1, 1)
	anchor.Parent = workspace

	sound.Parent = anchor
	sound:Play()

	-- Clean up after sound finishes
	task.delay(3, function()
		anchor:Destroy()
	end)
end

-- Create explosion effect
local function explodeTarget(target: BasePart)
	local position = target.Position
	local color = target.Color

	-- Play sound
	playExplosionSound(position)

	-- Create debris pieces
	for i = 1, 8 do
		local piece = Instance.new("Part")
		piece.Size = Vector3.new(
			math.random(5, 15) / 10,
			math.random(5, 15) / 10,
			math.random(5, 15) / 10
		)
		piece.Position = position + Vector3.new(
			math.random(-2, 2),
			math.random(0, 3),
			math.random(-2, 2)
		)
		piece.Color = color
		piece.Material = Enum.Material.Neon
		piece.Anchored = false
		piece.CanCollide = true
		piece.Parent = workspace

		-- Flying debris velocity
		local velocity = Instance.new("BodyVelocity")
		velocity.Velocity = Vector3.new(
			math.random(-40, 40),
			math.random(30, 60),
			math.random(-40, 40)
		)
		velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		velocity.Parent = piece

		task.delay(0.1, function()
			velocity:Destroy()
		end)

		task.delay(2, function()
			piece:Destroy()
		end)
	end
end

-- Move a target back and forth
local function startMovingTarget(target: BasePart, data)
	-- Random movement parameters
	local moveDistance = math.random(10, 30)
	local moveSpeed = math.random(2, 6)
	local moveAxis = math.random(1, 2) == 1 and "X" or "Z"

	local startPos = data.position
	local endPos

	if moveAxis == "X" then
		endPos = startPos + Vector3.new(moveDistance, 0, 0)
	else
		endPos = startPos + Vector3.new(0, 0, moveDistance)
	end

	-- Forward declare for mutual recursion
	local moveToEnd
	local moveToStart

	moveToEnd = function()
		if not target or not target.Parent then return end

		local tweenInfo = TweenInfo.new(moveSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		local tween = TweenService:Create(target, tweenInfo, {Position = endPos})
		tween:Play()
		tween.Completed:Connect(function()
			moveToStart()
		end)
	end

	moveToStart = function()
		if not target or not target.Parent then return end

		local tweenInfo = TweenInfo.new(moveSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		local tween = TweenService:Create(target, tweenInfo, {Position = startPos})
		tween:Play()
		tween.Completed:Connect(function()
			moveToEnd()
		end)
	end

	-- Start moving (50% chance to start moving to end or stay at start first)
	if math.random(1, 2) == 1 then
		moveToEnd()
	else
		task.delay(math.random(0, 3), moveToEnd)
	end
end

-- Respawn a target
local function respawnTarget(data)
	task.delay(3, function()
		local newTarget = Instance.new("Part")
		newTarget.Name = data.name
		newTarget.Position = data.position
		newTarget.Size = data.size
		newTarget.Color = data.color
		newTarget.Material = data.material
		newTarget.Anchored = true
		newTarget.Parent = data.parent

		-- Save for future respawns
		targetData[newTarget] = data
		activeTargets[newTarget] = true

		-- Start it moving again
		startMovingTarget(newTarget, data)

		print("Target respawned!")
	end)
end

-- Track kills per player
local playerKills = {}

-- When a player hits a target
TargetHit.OnServerEvent:Connect(function(player, target)
	-- Validate
	if not target or not target:IsA("BasePart") then
		return
	end
	if not target.Parent or target.Parent.Name ~= "Targets" then
		return
	end
	if not activeTargets[target] then
		return  -- Already destroyed
	end

	-- Mark as inactive to prevent double-hits
	activeTargets[target] = nil

	print(player.Name, "destroyed a target!")

	-- Track kills
	playerKills[player] = (playerKills[player] or 0) + 1

	-- Save data for respawn, explode, then destroy
	local data = targetData[target]
	if data then
		explodeTarget(target)
		target:Destroy()
		respawnTarget(data)
	end
end)

-- Initialize
saveTargetData()

-- Start all targets moving
task.defer(function()
	for target, data in pairs(targetData) do
		if target and target.Parent then
			startMovingTarget(target, data)
		end
	end
end)
