-- SERVER: NPC Enemies with patrol AI, animations, and death effects
print("Server started!")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")

local TargetHit = ReplicatedStorage:WaitForChild("Events"):WaitForChild("TargetHit")

--[[
	NPC SYSTEM

	Creates humanoid NPCs that:
	1. Walk around naturally (using PathfindingService)
	2. Have proper animations
	3. Can be shot and killed
	4. Respawn after death
]]

-- NPC Settings
local NPC_RESPAWN_TIME = 5
local NPC_WALK_SPEED = 8
local NPC_PATROL_RADIUS = 50  -- How far NPCs will wander from spawn

-- Store NPC data for respawning
local npcSpawnData = {}
local activeNPCs = {}

-- Sound IDs
local DEATH_SOUND = "rbxassetid://5030067442"  -- Death sound

--[[
	CREATE NPC CHARACTER

	Builds a humanoid NPC from scratch with:
	- HumanoidRootPart (main physics part)
	- Head, Torso, Arms, Legs
	- Humanoid (for health, animations, death)
]]
local function createNPCCharacter(name: string, position: Vector3, color: Color3): Model
	local npc = Instance.new("Model")
	npc.Name = name

	-- Create the HumanoidRootPart (invisible, controls movement)
	local rootPart = Instance.new("Part")
	rootPart.Name = "HumanoidRootPart"
	rootPart.Size = Vector3.new(2, 2, 1)
	rootPart.Transparency = 1
	rootPart.CanCollide = false
	rootPart.Position = position
	rootPart.Parent = npc

	-- Create the Head
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(1.5, 1.5, 1.5)
	head.Position = position + Vector3.new(0, 4, 0)
	head.Color = Color3.fromRGB(255, 205, 148)  -- Skin color
	head.Material = Enum.Material.SmoothPlastic
	head.Parent = npc

	-- Add face to head (classic Roblox face)
	local face = Instance.new("Decal")
	face.Name = "face"
	face.Texture = "rbxassetid://144080495"  -- Classic smile face
	face.Face = Enum.NormalId.Front
	face.Parent = head

	-- Make head a bit rounder looking
	local headMesh = Instance.new("SpecialMesh")
	headMesh.MeshType = Enum.MeshType.Head
	headMesh.Scale = Vector3.new(1.25, 1.25, 1.25)
	headMesh.Parent = head

	-- Create the Torso
	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Size = Vector3.new(2, 2, 1)
	torso.Position = position + Vector3.new(0, 2.5, 0)
	torso.Color = color  -- Enemy team color
	torso.Material = Enum.Material.SmoothPlastic
	torso.Parent = npc

	-- Create Left Arm
	local leftArm = Instance.new("Part")
	leftArm.Name = "Left Arm"
	leftArm.Size = Vector3.new(1, 2, 1)
	leftArm.Position = position + Vector3.new(-1.5, 2.5, 0)
	leftArm.Color = Color3.fromRGB(255, 205, 148)
	leftArm.Material = Enum.Material.SmoothPlastic
	leftArm.Parent = npc

	-- Create Right Arm
	local rightArm = Instance.new("Part")
	rightArm.Name = "Right Arm"
	rightArm.Size = Vector3.new(1, 2, 1)
	rightArm.Position = position + Vector3.new(1.5, 2.5, 0)
	rightArm.Color = Color3.fromRGB(255, 205, 148)
	rightArm.Material = Enum.Material.SmoothPlastic
	rightArm.Parent = npc

	-- Create Left Leg
	local leftLeg = Instance.new("Part")
	leftLeg.Name = "Left Leg"
	leftLeg.Size = Vector3.new(1, 2, 1)
	leftLeg.Position = position + Vector3.new(-0.5, 0.5, 0)
	leftLeg.Color = Color3.fromRGB(30, 30, 30)  -- Dark pants
	leftLeg.Material = Enum.Material.SmoothPlastic
	leftLeg.Parent = npc

	-- Create Right Leg
	local rightLeg = Instance.new("Part")
	rightLeg.Name = "Right Leg"
	rightLeg.Size = Vector3.new(1, 2, 1)
	rightLeg.Position = position + Vector3.new(0.5, 0.5, 0)
	rightLeg.Color = Color3.fromRGB(30, 30, 30)  -- Dark pants
	rightLeg.Material = Enum.Material.SmoothPlastic
	rightLeg.Parent = npc

	-- Create joints to connect body parts (Motor6D for animations)
	local function createMotor(name: string, part0: Part, part1: Part, c0: CFrame, c1: CFrame)
		local motor = Instance.new("Motor6D")
		motor.Name = name
		motor.Part0 = part0
		motor.Part1 = part1
		motor.C0 = c0
		motor.C1 = c1
		motor.Parent = part0
		return motor
	end

	-- Root to Torso
	createMotor("RootJoint", rootPart, torso,
		CFrame.new(0, 0, 0),
		CFrame.new(0, 0, 0))

	-- Torso to Head (Neck)
	createMotor("Neck", torso, head,
		CFrame.new(0, 1, 0),
		CFrame.new(0, -0.75, 0))

	-- Torso to Arms
	createMotor("Left Shoulder", torso, leftArm,
		CFrame.new(-1, 0.5, 0),
		CFrame.new(0.5, 0.5, 0))
	createMotor("Right Shoulder", torso, rightArm,
		CFrame.new(1, 0.5, 0),
		CFrame.new(-0.5, 0.5, 0))

	-- Torso to Legs
	createMotor("Left Hip", torso, leftLeg,
		CFrame.new(-0.5, -1, 0),
		CFrame.new(0, 1, 0))
	createMotor("Right Hip", torso, rightLeg,
		CFrame.new(0.5, -1, 0),
		CFrame.new(0, 1, 0))

	-- Create the Humanoid (handles health, animations, death state)
	local humanoid = Instance.new("Humanoid")
	humanoid.WalkSpeed = NPC_WALK_SPEED
	humanoid.MaxHealth = 100
	humanoid.Health = 100
	humanoid.Parent = npc

	-- Set the PrimaryPart (required for MoveTo)
	npc.PrimaryPart = rootPart

	-- CREATE HEALTH BAR above head
	local healthGui = Instance.new("BillboardGui")
	healthGui.Name = "HealthBar"
	healthGui.Size = UDim2.new(0, 80, 0, 12)
	healthGui.StudsOffset = Vector3.new(0, 2.5, 0)  -- Above the head
	healthGui.AlwaysOnTop = true
	healthGui.Parent = head

	-- Background (dark)
	local bgFrame = Instance.new("Frame")
	bgFrame.Name = "Background"
	bgFrame.Size = UDim2.new(1, 0, 1, 0)
	bgFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	bgFrame.BorderSizePixel = 0
	bgFrame.Parent = healthGui

	local bgCorner = Instance.new("UICorner")
	bgCorner.CornerRadius = UDim.new(0, 4)
	bgCorner.Parent = bgFrame

	-- Health fill (green -> yellow -> red)
	local healthFill = Instance.new("Frame")
	healthFill.Name = "HealthFill"
	healthFill.Size = UDim2.new(1, -4, 1, -4)  -- Slightly smaller for border effect
	healthFill.Position = UDim2.new(0, 2, 0, 2)
	healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green = full health
	healthFill.BorderSizePixel = 0
	healthFill.Parent = bgFrame

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 3)
	fillCorner.Parent = healthFill

	-- Update health bar when health changes
	humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)

		-- Animate the health bar width
		TweenService:Create(healthFill, TweenInfo.new(0.2), {
			Size = UDim2.new(healthPercent, -4, 1, -4)
		}):Play()

		-- Change color based on health (green -> yellow -> red)
		local healthColor
		if healthPercent > 0.6 then
			healthColor = Color3.fromRGB(0, 255, 0)  -- Green
		elseif healthPercent > 0.3 then
			healthColor = Color3.fromRGB(255, 255, 0)  -- Yellow
		else
			healthColor = Color3.fromRGB(255, 0, 0)  -- Red
		end

		TweenService:Create(healthFill, TweenInfo.new(0.2), {
			BackgroundColor3 = healthColor
		}):Play()
	end)

	return npc
end

--[[
	NPC PATROL AI

	Makes the NPC walk to random points within their patrol radius.
	Uses PathfindingService for smart navigation around obstacles.
]]
local function startPatrol(npc: Model, spawnPosition: Vector3)
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	-- Patrol loop
	task.spawn(function()
		while npc and npc.Parent and humanoid and humanoid.Health > 0 do
			-- Pick a random destination within patrol radius
			local randomOffset = Vector3.new(
				math.random(-NPC_PATROL_RADIUS, NPC_PATROL_RADIUS),
				0,
				math.random(-NPC_PATROL_RADIUS, NPC_PATROL_RADIUS)
			)
			local destination = spawnPosition + randomOffset

			-- Make sure destination is on the ground
			local rayOrigin = destination + Vector3.new(0, 50, 0)
			local rayDirection = Vector3.new(0, -100, 0)
			local rayResult = workspace:Raycast(rayOrigin, rayDirection)

			if rayResult then
				destination = rayResult.Position + Vector3.new(0, 3, 0)
			end

			-- Try pathfinding first (smarter navigation)
			local path = PathfindingService:CreatePath({
				AgentRadius = 2,
				AgentHeight = 5,
				AgentCanJump = false,
			})

			local success, errorMessage = pcall(function()
				path:ComputeAsync(npc.PrimaryPart.Position, destination)
			end)

			if success and path.Status == Enum.PathStatus.Success then
				-- Follow the path waypoints
				local waypoints = path:GetWaypoints()
				for _, waypoint in waypoints do
					if not npc or not npc.Parent or humanoid.Health <= 0 then
						break
					end
					humanoid:MoveTo(waypoint.Position)
					humanoid.MoveToFinished:Wait()
				end
			else
				-- Fallback: just walk directly toward destination
				humanoid:MoveTo(destination)
				humanoid.MoveToFinished:Wait()
			end

			-- Small pause before next patrol point
			task.wait(math.random(1, 3))
		end
	end)
end

--[[
	NPC DEATH EFFECTS

	When NPC dies:
	1. Play death sound
	2. Turn into ragdoll (unanchor all parts)
	3. Add red highlight effect
	4. Fade out and destroy
]]
local function handleNPCDeath(npc: Model, position: Vector3)
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Dead)
	end

	-- Play death sound
	local sound = Instance.new("Sound")
	sound.SoundId = DEATH_SOUND
	sound.Volume = 0.6
	sound.Parent = npc.PrimaryPart or npc:FindFirstChild("Torso")
	sound:Play()

	-- Ragdoll effect - unanchor all parts and add velocity
	for _, part in npc:GetDescendants() do
		if part:IsA("BasePart") then
			part.CanCollide = true
			part.Anchored = false

			-- Add some ragdoll impulse
			local impulse = Vector3.new(
				math.random(-20, 20),
				math.random(10, 30),
				math.random(-20, 20)
			)
			part:ApplyImpulse(impulse)
		end

		-- Break the joints for ragdoll
		if part:IsA("Motor6D") then
			part:Destroy()
		end
	end

	-- Red death highlight
	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(255, 0, 0)
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 1
	highlight.Parent = npc

	-- Fade out and destroy after delay
	task.delay(3, function()
		if npc and npc.Parent then
			-- Fade out all parts
			for _, part in npc:GetDescendants() do
				if part:IsA("BasePart") then
					TweenService:Create(part, TweenInfo.new(0.5), {Transparency = 1}):Play()
				end
			end
			task.wait(0.5)
			npc:Destroy()
		end
	end)
end

--[[
	SPAWN NPC

	Creates a new NPC at the given position and starts their patrol AI.
]]
local function spawnNPC(spawnData)
	local npc = createNPCCharacter(spawnData.name, spawnData.position, spawnData.color)
	npc.Parent = workspace:FindFirstChild("Targets") or workspace

	-- Track this NPC
	activeNPCs[npc] = spawnData

	-- Start patrol behavior
	startPatrol(npc, spawnData.position)

	-- Handle death
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Died:Connect(function()
			-- Remove from active NPCs
			activeNPCs[npc] = nil

			-- Handle death effects
			handleNPCDeath(npc, npc.PrimaryPart and npc.PrimaryPart.Position or spawnData.position)

			-- Schedule respawn
			task.delay(NPC_RESPAWN_TIME, function()
				spawnNPC(spawnData)
			end)
		end)
	end

	print("NPC spawned:", spawnData.name)
	return npc
end

--[[
	INITIALIZE NPC SPAWN POINTS

	Looks for existing targets in workspace and converts them to NPC spawn points.
	Or creates default spawn points if none exist.
]]
local function initializeSpawnPoints()
	local targetsFolder = workspace:FindFirstChild("Targets")

	-- Create targets folder if it doesn't exist
	if not targetsFolder then
		targetsFolder = Instance.new("Folder")
		targetsFolder.Name = "Targets"
		targetsFolder.Parent = workspace
	end

	-- CLEAN UP: Remove ALL old Part targets (the square ones)
	for _, target in targetsFolder:GetChildren() do
		if target:IsA("BasePart") then
			print("Removing old target:", target.Name)
			target:Destroy()
		end
	end

	-- Create NPC spawn points - 8 enemies spread around the map!
	local defaultSpawns = {
		-- Front area (closer to spawn)
		{name = "Enemy_1", position = Vector3.new(40, 5, 40), color = Color3.fromRGB(255, 0, 0)},
		{name = "Enemy_2", position = Vector3.new(-40, 5, 40), color = Color3.fromRGB(200, 0, 0)},

		-- Back area (further out)
		{name = "Enemy_3", position = Vector3.new(60, 5, -60), color = Color3.fromRGB(255, 50, 50)},
		{name = "Enemy_4", position = Vector3.new(-60, 5, -60), color = Color3.fromRGB(180, 0, 0)},

		-- Side areas
		{name = "Enemy_5", position = Vector3.new(80, 5, 0), color = Color3.fromRGB(220, 20, 20)},
		{name = "Enemy_6", position = Vector3.new(-80, 5, 0), color = Color3.fromRGB(200, 30, 30)},

		-- Long range targets (for bullet cam shots!)
		{name = "Enemy_7", position = Vector3.new(120, 5, 80), color = Color3.fromRGB(170, 0, 0)},
		{name = "Enemy_8", position = Vector3.new(-120, 5, -80), color = Color3.fromRGB(150, 0, 0)},
	}

	for _, spawn in defaultSpawns do
		table.insert(npcSpawnData, spawn)
	end

	print("Created", #npcSpawnData, "NPC spawn points")
end

--[[
	DAMAGE VALUES BY BODY PART

	Headshots are deadly! Body shots hurt. Limb shots are weaker.
]]
local DAMAGE_VALUES = {
	["Head"] = 100,           -- Instant kill!
	["Torso"] = 50,           -- 2 shots to kill
	["Left Arm"] = 30,        -- Limb shots
	["Right Arm"] = 30,
	["Left Leg"] = 25,
	["Right Leg"] = 25,
	["HumanoidRootPart"] = 40, -- If they hit the invisible root
}

--[[
	HANDLE TARGET HIT EVENT

	When player shoots an NPC, deal damage based on where they hit.
	Returns damage info to client for visual feedback.
]]
TargetHit.OnServerEvent:Connect(function(player, hitPart)
	if not hitPart or not hitPart:IsA("BasePart") then
		return
	end

	-- Find the NPC model (parent of the hit part)
	local npc = hitPart.Parent
	if not npc or not npc:IsA("Model") then
		return
	end

	-- Find the humanoid
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	-- Check if this is an active NPC
	if not activeNPCs[npc] then
		return
	end

	-- Calculate damage based on body part hit
	local bodyPart = hitPart.Name
	local damage = DAMAGE_VALUES[bodyPart] or 35  -- Default damage if unknown part

	-- Check if it's a headshot
	local isHeadshot = (bodyPart == "Head")

	print(player.Name, "shot", npc.Name, "in the", bodyPart, "for", damage, "damage!")

	-- Deal damage
	humanoid:TakeDamage(damage)

	-- Send damage info back to client for visual feedback
	TargetHit:FireClient(player, {
		damage = damage,
		isHeadshot = isHeadshot,
		position = hitPart.Position,
		remainingHealth = math.max(0, humanoid.Health),
		maxHealth = humanoid.MaxHealth,
		npc = npc,
		killed = humanoid.Health <= 0
	})
end)

-- Initialize the game
initializeSpawnPoints()

-- Spawn all NPCs
task.defer(function()
	for _, spawnData in npcSpawnData do
		spawnNPC(spawnData)
		task.wait(0.5)  -- Stagger spawns
	end
end)

print("NPC system initialized!")
