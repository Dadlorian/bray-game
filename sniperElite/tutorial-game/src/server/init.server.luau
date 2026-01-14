-- SERVER: ZOMBIE DEFENSE - Sniper tower + zombie hordes!
-- Brayden's Dream Game: Spawn in a tower and snipe zombies!
print("Server started - ZOMBIE DEFENSE MODE!")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")

local TargetHit = ReplicatedStorage:WaitForChild("Events"):WaitForChild("TargetHit")

--[[
	===========================================
	BRAYDEN'S ZOMBIE DEFENSE v3 - BORDER WALL
	===========================================

	Layout:
	- SAFE SIDE (behind wall) - flat ground
	- GIANT BORDER WALL running across the map
	- SNIPER TOWER on top of the wall
	- FOREST on the DANGEROUS SIDE (in front of wall)
	- Zombies spawn in forest, walk toward wall

	You snipe DOWN into the forest from the wall!
]]

-- Map layout settings
local WALL_POSITION_Z = 0  -- Wall runs along Z=0
local WALL_HEIGHT = 80     -- MASSIVE wall! Zombies look tiny from up here!
local WALL_THICKNESS = 15  -- Thick ancient stone
local WALL_LENGTH = 400    -- Long wall stretching across the land

local TOWER_HEIGHT = 45    -- TALL tower - the ONE sniper spot, way up high!
local FOREST_START_Z = 30  -- Forest starts this far from wall
local FOREST_END_Z = 300   -- Forest goes this far out (bigger for massive wall!)
local FOREST_WIDTH = 380   -- How wide the forest is (matches wall length)

--[[
	THE GIANT BORDER WALL

	A massive thick wall dividing safe side from danger side.
	Like the Wall from Game of Thrones but for zombies!
]]

local function createBorderWall()
	local wall = Instance.new("Model")
	wall.Name = "BorderWall"

	-- GREAT WALL - Ancient stone bricks, plain and massive!
	-- Main wall section - just one big solid wall
	local mainWall = Instance.new("Part")
	mainWall.Name = "MainWall"
	mainWall.Size = Vector3.new(WALL_LENGTH, WALL_HEIGHT, WALL_THICKNESS)
	mainWall.Position = Vector3.new(0, WALL_HEIGHT / 2, WALL_POSITION_Z)
	mainWall.Color = Color3.fromRGB(155, 140, 120)  -- Ancient tan/brown stone
	mainWall.Material = Enum.Material.Brick  -- BRICK texture!
	mainWall.Anchored = true
	mainWall.Parent = wall

	-- Simple flat top (walkway) - no fancy stuff
	local wallTop = Instance.new("Part")
	wallTop.Name = "WallTop"
	wallTop.Size = Vector3.new(WALL_LENGTH, 2, WALL_THICKNESS + 4)
	wallTop.Position = Vector3.new(0, WALL_HEIGHT + 1, WALL_POSITION_Z)
	wallTop.Color = Color3.fromRGB(145, 130, 110)  -- Slightly darker stone top
	wallTop.Material = Enum.Material.Brick
	wallTop.Anchored = true
	wallTop.Parent = wall

	-- NO battlements - Brayden wants it PLAIN!

	--[[
		DESTROYED TOWERS (Lore!)

		These towers USED to have guards... but something happened.
		Now they're ruins. Only YOUR tower remains standing.
		What happened to the others? The zombies know...
	]]

	for _, xPos in ipairs({-WALL_LENGTH/2 + 15, WALL_LENGTH/2 - 15}) do
		-- Ruined tower base (still standing but damaged)
		local ruinBase = Instance.new("Part")
		ruinBase.Name = "RuinedTowerBase"
		ruinBase.Size = Vector3.new(16, 25, 16)  -- Shorter than it used to be
		ruinBase.Position = Vector3.new(xPos, WALL_HEIGHT + 12.5, WALL_POSITION_Z)
		ruinBase.Color = Color3.fromRGB(130, 115, 95)  -- Darker, weathered stone
		ruinBase.Material = Enum.Material.Brick
		ruinBase.Anchored = true
		ruinBase.Parent = wall

		-- Broken wall piece 1 (jagged remains)
		local broken1 = Instance.new("Part")
		broken1.Name = "BrokenWall1"
		broken1.Size = Vector3.new(6, 12, 5)
		broken1.Position = Vector3.new(xPos - 4, WALL_HEIGHT + 31, WALL_POSITION_Z + 4)
		broken1.Color = Color3.fromRGB(120, 105, 85)
		broken1.Material = Enum.Material.Brick
		broken1.Rotation = Vector3.new(8, 0, -5)  -- Tilted like it's falling
		broken1.Anchored = true
		broken1.Parent = wall

		-- Broken wall piece 2 (other side)
		local broken2 = Instance.new("Part")
		broken2.Name = "BrokenWall2"
		broken2.Size = Vector3.new(5, 8, 6)
		broken2.Position = Vector3.new(xPos + 3, WALL_HEIGHT + 28, WALL_POSITION_Z - 3)
		broken2.Color = Color3.fromRGB(125, 110, 90)
		broken2.Material = Enum.Material.Brick
		broken2.Rotation = Vector3.new(-5, 0, 10)  -- Tilted the other way
		broken2.Anchored = true
		broken2.Parent = wall

		-- Rubble pieces on the ground (fallen stones)
		for j = 1, 4 do
			local rubble = Instance.new("Part")
			rubble.Name = "Rubble" .. j
			rubble.Size = Vector3.new(
				math.random(2, 5),
				math.random(2, 4),
				math.random(2, 5)
			)
			rubble.Position = Vector3.new(
				xPos + math.random(-10, 10),
				rubble.Size.Y / 2,
				WALL_POSITION_Z + WALL_THICKNESS/2 + math.random(5, 20)
			)
			rubble.Color = Color3.fromRGB(
				math.random(110, 140),
				math.random(95, 120),
				math.random(75, 100)
			)
			rubble.Material = Enum.Material.Brick
			rubble.Rotation = Vector3.new(
				math.random(-20, 20),
				math.random(0, 90),
				math.random(-20, 20)
			)
			rubble.Anchored = true
			rubble.Parent = wall
		end
	end

	wall.Parent = workspace
	print("Great Wall built! Length:", WALL_LENGTH, "Height:", WALL_HEIGHT)
	print("  ...with 2 DESTROYED towers. What happened here?")
	return wall
end

--[[
	THE GREAT WATCHTOWER

	A TALL stone watchtower - the ONE sniper spot!
	Rises high above the wall. You can see EVERYTHING from up here!
]]

local function createWallTower()
	local tower = Instance.new("Model")
	tower.Name = "WallTower"

	-- Tower sits on top of wall
	local towerBaseY = WALL_HEIGHT + 2
	local TOWER_WIDTH = 18  -- How wide the tower is

	-- Main tower body - solid stone rising from the wall!
	local towerBody = Instance.new("Part")
	towerBody.Name = "TowerBody"
	towerBody.Size = Vector3.new(TOWER_WIDTH, TOWER_HEIGHT, TOWER_WIDTH)
	towerBody.Position = Vector3.new(0, towerBaseY + TOWER_HEIGHT/2, WALL_POSITION_Z)
	towerBody.Color = Color3.fromRGB(145, 130, 110)  -- Same ancient stone as wall
	towerBody.Material = Enum.Material.Brick
	towerBody.Anchored = true
	towerBody.Parent = tower

	-- Top platform (where you stand and snipe!)
	local platform = Instance.new("Part")
	platform.Name = "Platform"
	platform.Size = Vector3.new(TOWER_WIDTH + 4, 2, TOWER_WIDTH + 4)
	platform.Position = Vector3.new(0, towerBaseY + TOWER_HEIGHT + 1, WALL_POSITION_Z)
	platform.Color = Color3.fromRGB(135, 120, 100)  -- Slightly different stone
	platform.Material = Enum.Material.Brick
	platform.Anchored = true
	platform.Parent = tower

	-- Low stone walls around the edge (you can peek over to shoot!)
	local wallHeight = 4
	local railY = towerBaseY + TOWER_HEIGHT + 2 + wallHeight/2

	-- NO FRONT WALLS! Instead we have a sniper ledge!

	--[[
		SNIPER LEDGE (Wooden Lookout)

		A wooden platform that sticks out from the front of the tower.
		COMPLETELY OPEN - you can look down, left, right - perfect for sniping!
		Supported by wooden beams underneath.
	]]

	local LEDGE_DEPTH = 10   -- How far it sticks out
	local LEDGE_WIDTH = 14   -- How wide the ledge is
	local ledgeY = towerBaseY + TOWER_HEIGHT + 2  -- Same level as main platform

	-- Main wooden ledge platform
	local ledgePlatform = Instance.new("Part")
	ledgePlatform.Name = "SniperLedge"
	ledgePlatform.Size = Vector3.new(LEDGE_WIDTH, 2, LEDGE_DEPTH)
	ledgePlatform.Position = Vector3.new(0, ledgeY, WALL_POSITION_Z + TOWER_WIDTH/2 + LEDGE_DEPTH/2)
	ledgePlatform.Color = Color3.fromRGB(90, 70, 50)  -- Dark wood
	ledgePlatform.Material = Enum.Material.WoodPlanks
	ledgePlatform.Anchored = true
	ledgePlatform.Parent = tower

	-- Support beams underneath (holds up the ledge!)
	local beam1 = Instance.new("Part")
	beam1.Name = "SupportBeam1"
	beam1.Size = Vector3.new(2, 8, 2)
	beam1.Position = Vector3.new(-LEDGE_WIDTH/2 + 2, ledgeY - 5, WALL_POSITION_Z + TOWER_WIDTH/2 + LEDGE_DEPTH - 2)
	beam1.Color = Color3.fromRGB(80, 60, 45)
	beam1.Material = Enum.Material.Wood
	beam1.Rotation = Vector3.new(25, 0, 0)  -- Angled for support
	beam1.Anchored = true
	beam1.Parent = tower

	local beam2 = Instance.new("Part")
	beam2.Name = "SupportBeam2"
	beam2.Size = Vector3.new(2, 8, 2)
	beam2.Position = Vector3.new(LEDGE_WIDTH/2 - 2, ledgeY - 5, WALL_POSITION_Z + TOWER_WIDTH/2 + LEDGE_DEPTH - 2)
	beam2.Color = Color3.fromRGB(80, 60, 45)
	beam2.Material = Enum.Material.Wood
	beam2.Rotation = Vector3.new(25, 0, 0)  -- Angled for support
	beam2.Anchored = true
	beam2.Parent = tower

	-- Center support beam
	local beam3 = Instance.new("Part")
	beam3.Name = "SupportBeam3"
	beam3.Size = Vector3.new(2, 10, 2)
	beam3.Position = Vector3.new(0, ledgeY - 6, WALL_POSITION_Z + TOWER_WIDTH/2 + LEDGE_DEPTH/2)
	beam3.Color = Color3.fromRGB(80, 60, 45)
	beam3.Material = Enum.Material.Wood
	beam3.Rotation = Vector3.new(30, 0, 0)  -- Angled for support
	beam3.Anchored = true
	beam3.Parent = tower

	-- Tiny rail on sides ONLY (so you don't fall off the sides, but front is OPEN!)
	local leftRail = Instance.new("Part")
	leftRail.Name = "LedgeRailLeft"
	leftRail.Size = Vector3.new(1, 2, LEDGE_DEPTH)
	leftRail.Position = Vector3.new(-LEDGE_WIDTH/2, ledgeY + 2, WALL_POSITION_Z + TOWER_WIDTH/2 + LEDGE_DEPTH/2)
	leftRail.Color = Color3.fromRGB(70, 55, 40)
	leftRail.Material = Enum.Material.Wood
	leftRail.Anchored = true
	leftRail.Parent = tower

	local rightRail = Instance.new("Part")
	rightRail.Name = "LedgeRailRight"
	rightRail.Size = Vector3.new(1, 2, LEDGE_DEPTH)
	rightRail.Position = Vector3.new(LEDGE_WIDTH/2, ledgeY + 2, WALL_POSITION_Z + TOWER_WIDTH/2 + LEDGE_DEPTH/2)
	rightRail.Color = Color3.fromRGB(70, 55, 40)
	rightRail.Material = Enum.Material.Wood
	rightRail.Anchored = true
	rightRail.Parent = tower

	-- FRONT IS COMPLETELY OPEN! Look down at zombies freely!

	-- Back wall (solid)
	local backWall = Instance.new("Part")
	backWall.Name = "BackWall"
	backWall.Size = Vector3.new(TOWER_WIDTH + 4, wallHeight, 2)
	backWall.Position = Vector3.new(0, railY, WALL_POSITION_Z - TOWER_WIDTH/2 - 1)
	backWall.Color = Color3.fromRGB(145, 130, 110)
	backWall.Material = Enum.Material.Brick
	backWall.Anchored = true
	backWall.Parent = tower

	-- Side walls
	local leftWall = Instance.new("Part")
	leftWall.Name = "LeftWall"
	leftWall.Size = Vector3.new(2, wallHeight, TOWER_WIDTH + 4)
	leftWall.Position = Vector3.new(-TOWER_WIDTH/2 - 1, railY, WALL_POSITION_Z)
	leftWall.Color = Color3.fromRGB(145, 130, 110)
	leftWall.Material = Enum.Material.Brick
	leftWall.Anchored = true
	leftWall.Parent = tower

	local rightWall = Instance.new("Part")
	rightWall.Name = "RightWall"
	rightWall.Size = Vector3.new(2, wallHeight, TOWER_WIDTH + 4)
	rightWall.Position = Vector3.new(TOWER_WIDTH/2 + 1, railY, WALL_POSITION_Z)
	rightWall.Color = Color3.fromRGB(145, 130, 110)
	rightWall.Material = Enum.Material.Brick
	rightWall.Anchored = true
	rightWall.Parent = tower

	--[[
		SNIPER ROOF

		A tall roof with open sides - you can see and shoot everywhere!
		Creates shade and looks awesome. Plenty of room to move around.
	]]

	local ROOF_HEIGHT = 12  -- How tall the roof area is (lots of room!)
	local roofBaseY = towerBaseY + TOWER_HEIGHT + 2 + wallHeight  -- Sits on top of the walls
	local POST_SIZE = 2

	-- Four corner posts holding up the roof
	local postPositions = {
		Vector3.new(-TOWER_WIDTH/2, 0, TOWER_WIDTH/2),      -- Front left
		Vector3.new(TOWER_WIDTH/2, 0, TOWER_WIDTH/2),       -- Front right
		Vector3.new(-TOWER_WIDTH/2, 0, -TOWER_WIDTH/2),     -- Back left
		Vector3.new(TOWER_WIDTH/2, 0, -TOWER_WIDTH/2),      -- Back right
	}

	for i, pos in postPositions do
		local post = Instance.new("Part")
		post.Name = "RoofPost" .. i
		post.Size = Vector3.new(POST_SIZE, ROOF_HEIGHT, POST_SIZE)
		post.Position = Vector3.new(pos.X, roofBaseY + ROOF_HEIGHT/2, WALL_POSITION_Z + pos.Z)
		post.Color = Color3.fromRGB(130, 115, 95)  -- Darker stone posts
		post.Material = Enum.Material.Brick
		post.Anchored = true
		post.Parent = tower
	end

	-- Main roof (big flat top that creates shade!)
	local mainRoof = Instance.new("Part")
	mainRoof.Name = "MainRoof"
	mainRoof.Size = Vector3.new(TOWER_WIDTH + 6, 2, TOWER_WIDTH + 6)
	mainRoof.Position = Vector3.new(0, roofBaseY + ROOF_HEIGHT + 1, WALL_POSITION_Z)
	mainRoof.Color = Color3.fromRGB(100, 85, 70)  -- Darker roof color
	mainRoof.Material = Enum.Material.Slate  -- Different material for the roof
	mainRoof.Anchored = true
	mainRoof.Parent = tower

	-- Roof overhang edges (makes it look more finished)
	local overhang = Instance.new("Part")
	overhang.Name = "RoofOverhang"
	overhang.Size = Vector3.new(TOWER_WIDTH + 8, 1, TOWER_WIDTH + 8)
	overhang.Position = Vector3.new(0, roofBaseY + ROOF_HEIGHT, WALL_POSITION_Z)
	overhang.Color = Color3.fromRGB(90, 75, 60)  -- Even darker edge
	overhang.Material = Enum.Material.Slate
	overhang.Anchored = true
	overhang.Parent = tower

	-- OPEN SIDES! No walls between the posts - you can look and shoot everywhere!
	-- The gaps between corner posts let you see:
	--   - FRONT: Into the forest (main sniping direction)
	--   - LEFT: Along the wall
	--   - RIGHT: Along the wall
	--   - BACK: The safe side

	-- SPAWN POINT - you spawn WAY up high with room to move!
	local spawnPoint = Instance.new("SpawnLocation")
	spawnPoint.Name = "TowerSpawn"
	spawnPoint.Size = Vector3.new(10, 1, 10)
	spawnPoint.Position = Vector3.new(0, towerBaseY + TOWER_HEIGHT + 2 + wallHeight + 0.5, WALL_POSITION_Z)
	spawnPoint.Color = Color3.fromRGB(50, 150, 50)
	spawnPoint.Material = Enum.Material.Neon
	spawnPoint.Transparency = 0.9
	spawnPoint.Anchored = true
	spawnPoint.Neutral = true
	spawnPoint.Parent = tower

	-- Ladder inside the tower (goes all the way up!)
	local ladder = Instance.new("TrussPart")
	ladder.Name = "Ladder"
	ladder.Size = Vector3.new(2, TOWER_HEIGHT + WALL_HEIGHT + wallHeight + 10, 2)
	ladder.Position = Vector3.new(0, (TOWER_HEIGHT + WALL_HEIGHT + wallHeight + 10)/2, WALL_POSITION_Z - TOWER_WIDTH/2 + 2)
	ladder.Color = Color3.fromRGB(100, 85, 70)
	ladder.Material = Enum.Material.DiamondPlate
	ladder.Anchored = true
	ladder.Parent = tower

	tower.Parent = workspace
	local totalHeight = WALL_HEIGHT + TOWER_HEIGHT + wallHeight + ROOF_HEIGHT
	print("Great Watchtower built! Total height:", totalHeight, "studs!")
	print("  Roof with open sides - see and shoot in ALL directions!")
	return tower
end

--[[
	THE DANGEROUS FOREST

	Dense forest on ONE SIDE of the wall only.
	Zombies spawn here and walk toward your wall!
]]

local function createForest()
	local forest = Instance.new("Model")
	forest.Name = "Forest"

	local trunkColor = Color3.fromRGB(80, 55, 35)
	local leafColors = {
		Color3.fromRGB(45, 90, 40),
		Color3.fromRGB(35, 80, 35),
		Color3.fromRGB(55, 100, 45),
		Color3.fromRGB(40, 70, 35),
		Color3.fromRGB(30, 65, 30),
	}

	-- Trees only on the DANGEROUS SIDE (positive Z)
	local numTrees = 120

	for i = 1, numTrees do
		-- Random position in the forest (in front of wall)
		local x = math.random(-FOREST_WIDTH/2, FOREST_WIDTH/2)
		local z = math.random(FOREST_START_Z, FOREST_END_Z)

		-- Random tree size
		local trunkHeight = math.random(12, 28)
		local trunkWidth = math.random(2, 4)
		local leafSize = math.random(8, 14)

		-- Create trunk
		local trunk = Instance.new("Part")
		trunk.Name = "Trunk" .. i
		trunk.Size = Vector3.new(trunkWidth, trunkHeight, trunkWidth)
		trunk.Position = Vector3.new(x, trunkHeight / 2, z)
		trunk.Color = trunkColor
		trunk.Material = Enum.Material.Wood
		trunk.Anchored = true
		trunk.Parent = forest

		-- Create leaves
		local leaves = Instance.new("Part")
		leaves.Name = "Leaves" .. i
		leaves.Size = Vector3.new(leafSize, leafSize, leafSize)
		leaves.Position = Vector3.new(x, trunkHeight + leafSize / 3, z)
		leaves.Color = leafColors[math.random(1, #leafColors)]
		leaves.Material = Enum.Material.Grass
		leaves.Shape = Enum.PartType.Ball
		leaves.Anchored = true
		leaves.Parent = forest

		-- Extra leaf clusters
		if math.random() > 0.4 then
			local extra = Instance.new("Part")
			extra.Name = "ExtraLeaves" .. i
			extra.Size = Vector3.new(leafSize * 0.6, leafSize * 0.6, leafSize * 0.6)
			extra.Position = Vector3.new(x + math.random(-3, 3), trunkHeight + leafSize * 0.6, z + math.random(-3, 3))
			extra.Color = leafColors[math.random(1, #leafColors)]
			extra.Material = Enum.Material.Grass
			extra.Shape = Enum.PartType.Ball
			extra.Anchored = true
			extra.Parent = forest
		end
	end

	-- Add bushes near the edge of forest (where zombies emerge!)
	for i = 1, 50 do
		local x = math.random(-FOREST_WIDTH/2, FOREST_WIDTH/2)
		local z = math.random(FOREST_START_Z, FOREST_START_Z + 40)

		local bush = Instance.new("Part")
		bush.Name = "Bush" .. i
		bush.Size = Vector3.new(math.random(3, 6), math.random(2, 4), math.random(3, 6))
		bush.Position = Vector3.new(x, bush.Size.Y / 2, z)
		bush.Color = leafColors[math.random(1, #leafColors)]
		bush.Material = Enum.Material.Grass
		bush.Anchored = true
		bush.Parent = forest
	end

	forest.Parent = workspace
	print("Forest created on dangerous side! Trees:", numTrees)
	return forest
end

--[[
	GROUND / TERRAIN
]]

local function createGround()
	-- Safe side ground (behind wall - negative Z)
	local safeGround = Instance.new("Part")
	safeGround.Name = "SafeGround"
	safeGround.Size = Vector3.new(500, 1, 250)  -- Bigger to match massive wall!
	safeGround.Position = Vector3.new(0, -0.5, -125 - WALL_THICKNESS/2)
	safeGround.Color = Color3.fromRGB(90, 110, 75)  -- Nicer grass
	safeGround.Material = Enum.Material.Grass
	safeGround.Anchored = true
	safeGround.Parent = workspace

	-- Danger side ground (forest side - positive Z)
	local dangerGround = Instance.new("Part")
	dangerGround.Name = "DangerGround"
	dangerGround.Size = Vector3.new(500, 1, 350)  -- Bigger forest area!
	dangerGround.Position = Vector3.new(0, -0.5, 175 + WALL_THICKNESS/2)
	dangerGround.Color = Color3.fromRGB(55, 75, 45)  -- Darker, scarier grass
	dangerGround.Material = Enum.Material.Grass
	dangerGround.Anchored = true
	dangerGround.Parent = workspace

	print("Ground created - safe side and danger side! MASSIVE map!")
end

--[[
	ZOMBIE SYSTEM

	Creates zombie NPCs that:
	1. Look like zombies (green skin, scary!)
	2. Walk TOWARD the tower (attack mode!)
	3. Can be shot and killed
	4. Respawn and keep coming!
]]

-- Zombie Settings
local ZOMBIE_RESPAWN_TIME = 3
local ZOMBIE_WALK_SPEED = 6  -- Slower than normal NPCs (zombies shamble!)
local ZOMBIE_SPAWN_RADIUS = 150  -- How far from tower zombies spawn

-- Store zombie data for respawning
local zombieSpawnData = {}
local activeZombies = {}

-- Sound IDs
local ZOMBIE_DEATH_SOUND = "rbxassetid://131314452"  -- Zombie death groan
local ZOMBIE_MOAN_SOUND = "rbxassetid://131314452"   -- Zombie moan

-- Zombie skin colors (various shades of undead green/grey)
local ZOMBIE_SKIN_COLORS = {
	Color3.fromRGB(85, 120, 85),   -- Sickly green
	Color3.fromRGB(95, 130, 95),   -- Pale green
	Color3.fromRGB(75, 100, 75),   -- Dark green
	Color3.fromRGB(100, 110, 90),  -- Greenish grey
	Color3.fromRGB(80, 95, 80),    -- Muted green
}

-- Zombie shirt colors (tattered, dirty clothes)
local ZOMBIE_SHIRT_COLORS = {
	Color3.fromRGB(60, 50, 45),    -- Dirty brown
	Color3.fromRGB(70, 70, 65),    -- Grey
	Color3.fromRGB(50, 55, 50),    -- Dark green-grey
	Color3.fromRGB(80, 60, 50),    -- Muddy brown
	Color3.fromRGB(45, 45, 40),    -- Almost black
}

--[[
	CREATE ZOMBIE CHARACTER

	Builds a scary zombie from scratch with:
	- Green/grey rotting skin
	- Scary zombie face
	- Tattered clothes
	- Shambling movement
]]
local function createZombieCharacter(name: string, position: Vector3): Model
	local zombie = Instance.new("Model")
	zombie.Name = name

	-- Pick random zombie colors
	local skinColor = ZOMBIE_SKIN_COLORS[math.random(1, #ZOMBIE_SKIN_COLORS)]
	local shirtColor = ZOMBIE_SHIRT_COLORS[math.random(1, #ZOMBIE_SHIRT_COLORS)]

	-- Create the HumanoidRootPart (invisible, controls movement)
	local rootPart = Instance.new("Part")
	rootPart.Name = "HumanoidRootPart"
	rootPart.Size = Vector3.new(2, 2, 1)
	rootPart.Transparency = 1
	rootPart.CanCollide = false
	rootPart.Position = position
	rootPart.Parent = zombie

	-- Create the Head (zombie green!)
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(1.5, 1.5, 1.5)
	head.Position = position + Vector3.new(0, 4, 0)
	head.Color = skinColor  -- ZOMBIE GREEN SKIN!
	head.Material = Enum.Material.SmoothPlastic
	head.Parent = zombie

	-- Add SCARY ZOMBIE FACE!
	local face = Instance.new("Decal")
	face.Name = "face"
	face.Texture = "rbxassetid://129242640"  -- Scary zombie/monster face
	face.Face = Enum.NormalId.Front
	face.Parent = head

	-- Make head a bit rounder looking
	local headMesh = Instance.new("SpecialMesh")
	headMesh.MeshType = Enum.MeshType.Head
	headMesh.Scale = Vector3.new(1.25, 1.25, 1.25)
	headMesh.Parent = head

	-- Create the Torso (tattered shirt)
	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Size = Vector3.new(2, 2, 1)
	torso.Position = position + Vector3.new(0, 2.5, 0)
	torso.Color = shirtColor  -- Dirty tattered shirt
	torso.Material = Enum.Material.Fabric
	torso.Parent = zombie

	-- Create Left Arm (zombie green skin!)
	local leftArm = Instance.new("Part")
	leftArm.Name = "Left Arm"
	leftArm.Size = Vector3.new(1, 2, 1)
	leftArm.Position = position + Vector3.new(-1.5, 2.5, 0)
	leftArm.Color = skinColor  -- GREEN!
	leftArm.Material = Enum.Material.SmoothPlastic
	leftArm.Parent = zombie

	-- Create Right Arm (zombie green skin!)
	local rightArm = Instance.new("Part")
	rightArm.Name = "Right Arm"
	rightArm.Size = Vector3.new(1, 2, 1)
	rightArm.Position = position + Vector3.new(1.5, 2.5, 0)
	rightArm.Color = skinColor  -- GREEN!
	rightArm.Material = Enum.Material.SmoothPlastic
	rightArm.Parent = zombie

	-- Create Left Leg (tattered pants)
	local leftLeg = Instance.new("Part")
	leftLeg.Name = "Left Leg"
	leftLeg.Size = Vector3.new(1, 2, 1)
	leftLeg.Position = position + Vector3.new(-0.5, 0.5, 0)
	leftLeg.Color = Color3.fromRGB(50, 45, 40)  -- Dirty brown pants
	leftLeg.Material = Enum.Material.Fabric
	leftLeg.Parent = zombie

	-- Create Right Leg (tattered pants)
	local rightLeg = Instance.new("Part")
	rightLeg.Name = "Right Leg"
	rightLeg.Size = Vector3.new(1, 2, 1)
	rightLeg.Position = position + Vector3.new(0.5, 0.5, 0)
	rightLeg.Color = Color3.fromRGB(50, 45, 40)  -- Dirty brown pants
	rightLeg.Material = Enum.Material.Fabric
	rightLeg.Parent = zombie

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
	humanoid.WalkSpeed = ZOMBIE_WALK_SPEED  -- Slow shambling zombie speed!
	humanoid.MaxHealth = 100
	humanoid.Health = 100
	humanoid.Parent = zombie

	-- Set the PrimaryPart (required for MoveTo)
	zombie.PrimaryPart = rootPart

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

	return zombie
end

--[[
	ZOMBIE ATTACK AI

	Zombies walk from the forest TOWARD THE WALL!
	They emerge from the trees and shamble toward you.
]]
local function startZombieAttack(zombie: Model)
	local humanoid = zombie:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	-- Attack loop - keep walking toward the wall!
	task.spawn(function()
		while zombie and zombie.Parent and humanoid and humanoid.Health > 0 do
			-- Target is the wall (Z = near the wall, random X position along the wall)
			local destination = Vector3.new(
				math.random(-WALL_LENGTH/2 + 20, WALL_LENGTH/2 - 20),
				3,
				WALL_THICKNESS/2 + 5  -- Just in front of the wall
			)

			-- Try pathfinding to wall
			local path = PathfindingService:CreatePath({
				AgentRadius = 2,
				AgentHeight = 5,
				AgentCanJump = false,
			})

			local success, errorMessage = pcall(function()
				path:ComputeAsync(zombie.PrimaryPart.Position, destination)
			end)

			if success and path.Status == Enum.PathStatus.Success then
				-- Follow the path waypoints
				local waypoints = path:GetWaypoints()
				for _, waypoint in waypoints do
					if not zombie or not zombie.Parent or humanoid.Health <= 0 then
						break
					end
					humanoid:MoveTo(waypoint.Position)
					humanoid.MoveToFinished:Wait()
				end
			else
				-- Fallback: just walk directly toward wall
				humanoid:MoveTo(destination)
				humanoid.MoveToFinished:Wait()
			end

			-- Brief pause then keep attacking
			task.wait(0.5)
		end
	end)
end

--[[
	ZOMBIE DEATH EFFECTS

	When zombie dies:
	1. Play zombie death groan
	2. Turn into ragdoll
	3. Green death highlight (they're already green!)
	4. Fade out and destroy
]]
local function handleZombieDeath(zombie: Model, position: Vector3)
	local humanoid = zombie:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Dead)
	end

	-- Play zombie death sound
	local sound = Instance.new("Sound")
	sound.SoundId = ZOMBIE_DEATH_SOUND
	sound.Volume = 0.8
	sound.Parent = zombie.PrimaryPart or zombie:FindFirstChild("Torso")
	sound:Play()

	-- Ragdoll effect - unanchor all parts and add velocity
	for _, part in zombie:GetDescendants() do
		if part:IsA("BasePart") then
			part.CanCollide = true
			part.Anchored = false

			-- Add some ragdoll impulse (zombies fall dramatically!)
			local impulse = Vector3.new(
				math.random(-30, 30),
				math.random(15, 40),
				math.random(-30, 30)
			)
			part:ApplyImpulse(impulse)
		end

		-- Break the joints for ragdoll
		if part:IsA("Motor6D") then
			part:Destroy()
		end
	end

	-- Green death highlight (zombie color!)
	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(100, 150, 100)  -- Sickly green
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 1
	highlight.Parent = zombie

	-- Fade out and destroy after delay
	task.delay(3, function()
		if zombie and zombie.Parent then
			-- Fade out all parts
			for _, part in zombie:GetDescendants() do
				if part:IsA("BasePart") then
					TweenService:Create(part, TweenInfo.new(0.5), {Transparency = 1}):Play()
				end
			end
			task.wait(0.5)
			zombie:Destroy()
		end
	end)
end

--[[
	SPAWN ZOMBIE

	Creates a new zombie at a random position around the tower and sends it to attack!
]]
local function spawnZombie(spawnData)
	local zombie = createZombieCharacter(spawnData.name, spawnData.position)

	-- Create zombies folder if needed
	local zombiesFolder = workspace:FindFirstChild("Zombies")
	if not zombiesFolder then
		zombiesFolder = Instance.new("Folder")
		zombiesFolder.Name = "Zombies"
		zombiesFolder.Parent = workspace
	end

	zombie.Parent = zombiesFolder

	-- Track this zombie
	activeZombies[zombie] = spawnData

	-- Start attack behavior - GO TO TOWER!
	startZombieAttack(zombie)

	-- Handle death
	local humanoid = zombie:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Died:Connect(function()
			-- Remove from active zombies
			activeZombies[zombie] = nil

			-- Handle death effects
			handleZombieDeath(zombie, zombie.PrimaryPart and zombie.PrimaryPart.Position or spawnData.position)

			-- Schedule respawn (zombies keep coming!)
			task.delay(ZOMBIE_RESPAWN_TIME, function()
				spawnZombie(spawnData)
			end)
		end)
	end

	print("ZOMBIE spawned:", spawnData.name, "- ATTACKING TOWER!")
	return zombie
end

--[[
	INITIALIZE ZOMBIE DEFENSE GAME

	Brayden's Dream Game v3 - BORDER WALL:
	1. Giant border wall dividing the map
	2. Sniper tower ON TOP of the wall
	3. Forest on ONE SIDE only (the danger side)
	4. Zombies spawn in forest, walk toward wall
	5. You snipe DOWN at them from the wall!
]]
local function initializeZombieDefense()
	-- Clean up old stuff
	local oldStuff = {"Targets", "SniperTower", "Watchtower", "WallTower", "BorderWall",
					  "CompoundWalls", "Forest", "Baseplate", "Ground", "SafeGround",
					  "DangerGround", "CompoundFloor", "Zombies"}

	for _, name in oldStuff do
		local old = workspace:FindFirstChild(name)
		if old then old:Destroy() end
	end

	-- BUILD THE MAP!
	print("")
	print("===========================================")
	print("  Building Brayden's Border Wall...")
	print("===========================================")

	createGround()       -- Safe side + danger side ground
	createBorderWall()   -- THE GIANT WALL
	createWallTower()    -- Sniper tower ON the wall
	createForest()       -- Forest on danger side

	-- Create zombie spawn points IN THE FOREST (danger side)
	local numZombies = 15
	for i = 1, numZombies do
		-- Spawn zombies spread across the forest
		local x = math.random(-FOREST_WIDTH/2 + 20, FOREST_WIDTH/2 - 20)
		local z = math.random(FOREST_START_Z + 30, FOREST_END_Z - 30)

		local spawnData = {
			name = "Zombie_" .. i,
			position = Vector3.new(x, 3, z)
		}
		table.insert(zombieSpawnData, spawnData)
	end

	print("")
	print("===========================================")
	print("  ZOMBIE DEFENSE v3 - BORDER WALL!")
	print("===========================================")
	print("  You're on the wall looking DOWN")
	print("  Forest is in front of you")
	print("  Zombies emerge from the trees!")
	print("  SNIPE THEM before they reach the wall!")
	print("===========================================")
	print("")
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
	HANDLE ZOMBIE HIT EVENT

	When player shoots a zombie, deal damage based on where they hit.
	Returns damage info to client for visual feedback.
]]
TargetHit.OnServerEvent:Connect(function(player, hitPart)
	if not hitPart or not hitPart:IsA("BasePart") then
		return
	end

	-- Find the zombie model (parent of the hit part)
	local zombie = hitPart.Parent
	if not zombie or not zombie:IsA("Model") then
		return
	end

	-- Find the humanoid
	local humanoid = zombie:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	-- Check if this is an active zombie
	if not activeZombies[zombie] then
		return
	end

	-- Calculate damage based on body part hit
	local bodyPart = hitPart.Name
	local damage = DAMAGE_VALUES[bodyPart] or 35  -- Default damage if unknown part

	-- Check if it's a headshot
	local isHeadshot = (bodyPart == "Head")

	print(player.Name, "shot", zombie.Name, "in the", bodyPart, "for", damage, "damage!")

	-- Deal damage
	humanoid:TakeDamage(damage)

	-- Send damage info back to client for visual feedback
	TargetHit:FireClient(player, {
		damage = damage,
		isHeadshot = isHeadshot,
		position = hitPart.Position,
		remainingHealth = math.max(0, humanoid.Health),
		maxHealth = humanoid.MaxHealth,
		zombie = zombie,
		killed = humanoid.Health <= 0
	})
end)

-- INITIALIZE ZOMBIE DEFENSE GAME!
initializeZombieDefense()

-- Spawn all zombies (they'll attack the tower!)
task.defer(function()
	for _, spawnData in zombieSpawnData do
		spawnZombie(spawnData)
		task.wait(0.3)  -- Stagger spawns for dramatic effect
	end
end)

print("===========================================")
print("  ZOMBIE DEFENSE v3 - BRAYDEN'S DREAM!")
print("  You're on THE WALL!")
print("  Snipe zombies emerging from the forest!")
print("  DEFEND THE BORDER!")
print("===========================================")
