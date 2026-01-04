-- Moving Platform System
-- Demonstrates various continuous motion patterns using RunService and TweenService

print("🎢 Moving Platform System starting...")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local platform = workspace:WaitForChild("MovingPlatform")

-- ============================================================================
-- CONFIGURATION - Choose which pattern to use
-- ============================================================================

local PATTERN = "circular"  -- Options: linear, circular, bob, figure8, rotate, combo
local SPEED = 1  -- Speed multiplier (1 = normal, 2 = twice as fast, etc.)

-- ============================================================================

local CENTER = platform.Position  -- Store original position

print("✅ Platform found at", CENTER)
print("🎯 Using pattern:", PATTERN)

-- ============================================================================
-- PATTERN 1: Linear Back-and-Forth (TweenService)
-- ============================================================================

if PATTERN == "linear" then
    print("📏 Activating linear back-and-forth pattern")

    local DISTANCE = 20  -- How far to move (studs)
    local TRAVEL_TIME = 3  -- Seconds for one-way trip

    local tweenInfo = TweenInfo.new(
        TRAVEL_TIME,
        Enum.EasingStyle.Sine,  -- Smooth easing
        Enum.EasingDirection.InOut,
        -1,  -- Repeat forever
        true  -- Reverse (go back and forth)
    )

    local goal = {Position = CENTER + Vector3.new(DISTANCE, 0, 0)}
    local tween = TweenService:Create(platform, tweenInfo, goal)
    tween:Play()

    print("✅ Platform moving between", CENTER, "and", goal.Position)

-- ============================================================================
-- PATTERN 2: Circular Orbit (RunService + Trigonometry)
-- ============================================================================

elseif PATTERN == "circular" then
    print("⭕ Activating circular orbit pattern")

    local RADIUS = 15  -- Circle radius (studs)
    local angle = 0  -- Starting angle

    RunService.Heartbeat:Connect(function(deltaTime)
        -- Increment angle (frame-independent)
        angle = angle + (deltaTime * SPEED * math.pi * 2)

        -- Keep angle in 0-2π range (optional optimization)
        if angle > math.pi * 2 then
            angle = angle - math.pi * 2
        end

        -- Calculate position using circle formula
        local x = CENTER.X + (math.cos(angle) * RADIUS)
        local z = CENTER.Z + (math.sin(angle) * RADIUS)

        platform.Position = Vector3.new(x, CENTER.Y, z)
    end)

    print("✅ Platform orbiting at radius", RADIUS)

-- ============================================================================
-- PATTERN 3: Vertical Bob (Sine Wave)
-- ============================================================================

elseif PATTERN == "bob" then
    print("🌊 Activating vertical bob pattern")

    local BOB_DISTANCE = 2  -- How far up/down (studs)
    local time = 0

    RunService.Heartbeat:Connect(function(deltaTime)
        time = time + deltaTime

        -- Calculate offset using sine wave
        local offset = math.sin(time * SPEED * math.pi * 2) * BOB_DISTANCE

        -- Update Y position only
        platform.Position = Vector3.new(
            CENTER.X,
            CENTER.Y + offset,
            CENTER.Z
        )
    end)

    print("✅ Platform bobbing between", CENTER.Y - BOB_DISTANCE, "and", CENTER.Y + BOB_DISTANCE)

-- ============================================================================
-- PATTERN 4: Figure-8 (Lissajous Curve)
-- ============================================================================

elseif PATTERN == "figure8" then
    print("∞ Activating figure-8 pattern")

    local SIZE = 15  -- Pattern size (studs)
    local time = 0

    RunService.Heartbeat:Connect(function(deltaTime)
        time = time + (deltaTime * SPEED)

        -- Figure-8 uses different frequencies for X and Z
        local x = CENTER.X + (math.sin(time) * SIZE)
        local z = CENTER.Z + (math.sin(time * 2) * SIZE)  -- 2x frequency!

        platform.Position = Vector3.new(x, CENTER.Y, z)
    end)

    print("✅ Platform moving in figure-8 pattern")

-- ============================================================================
-- PATTERN 5: Rotating (Spin in Place)
-- ============================================================================

elseif PATTERN == "rotate" then
    print("🔄 Activating rotation pattern")

    local ROTATION_SPEED = 45  -- Degrees per second
    local currentAngle = 0

    RunService.Heartbeat:Connect(function(deltaTime)
        -- Increase angle
        currentAngle = currentAngle + (ROTATION_SPEED * SPEED * deltaTime)

        -- Keep angle in 0-360 range
        if currentAngle >= 360 then
            currentAngle = currentAngle - 360
        end

        -- Apply rotation using CFrame
        platform.CFrame = CFrame.new(CENTER) * CFrame.Angles(0, math.rad(currentAngle), 0)
    end)

    print("✅ Platform rotating at", ROTATION_SPEED * SPEED, "degrees/second")

-- ============================================================================
-- PATTERN 6: Combo (Orbit + Bob + Rotate)
-- ============================================================================

elseif PATTERN == "combo" then
    print("🎪 Activating combo pattern (orbit + bob + rotate)")

    local ORBIT_RADIUS = 15
    local BOB_DISTANCE = 2
    local ROTATION_SPEED = 45

    local orbitAngle = 0
    local bobTime = 0
    local rotateAngle = 0

    RunService.Heartbeat:Connect(function(deltaTime)
        -- Update all angles
        orbitAngle = orbitAngle + (deltaTime * SPEED)
        bobTime = bobTime + (deltaTime * SPEED * 2)  -- Bob faster
        rotateAngle = rotateAngle + (deltaTime * ROTATION_SPEED * SPEED)

        -- Calculate position (orbit + bob)
        local x = CENTER.X + (math.cos(orbitAngle) * ORBIT_RADIUS)
        local y = CENTER.Y + (math.sin(bobTime) * BOB_DISTANCE)
        local z = CENTER.Z + (math.sin(orbitAngle) * ORBIT_RADIUS)

        -- Apply position and rotation
        platform.CFrame = CFrame.new(x, y, z) * CFrame.Angles(0, math.rad(rotateAngle), 0)
    end)

    print("✅ Platform orbiting, bobbing, and rotating!")

else
    warn("❌ Unknown pattern:", PATTERN)
    warn("Available patterns: linear, circular, bob, figure8, rotate, combo")
end

-- ============================================================================
-- BONUS: Visual Enhancements (Uncomment to add)
-- ============================================================================

-- Add a trail to visualize path
--[[
local trail = Instance.new("Trail")
local attachment0 = Instance.new("Attachment")
local attachment1 = Instance.new("Attachment")

attachment0.Position = Vector3.new(-4, 0, 0)
attachment1.Position = Vector3.new(4, 0, 0)

attachment0.Parent = platform
attachment1.Parent = platform

trail.Attachment0 = attachment0
trail.Attachment1 = attachment1
trail.Lifetime = 2
trail.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
trail.Parent = platform

print("✨ Trail effect added")
]]

-- Make platform glow
--[[
platform.Material = Enum.Material.Neon
platform.Color = Color3.fromRGB(0, 255, 255)
print("✨ Neon material applied")
]]

-- Add particles
--[[
local particles = Instance.new("ParticleEmitter")
particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
particles.Rate = 20
particles.Lifetime = NumberRange.new(1, 2)
particles.Speed = NumberRange.new(2, 4)
particles.Color = ColorSequence.new(Color3.fromRGB(100, 200, 255))
particles.Transparency = NumberSequence.new(0, 1)
particles.Parent = platform
print("✨ Particle effects added")
]]

print("🎉 Pattern fully activated and running!")
