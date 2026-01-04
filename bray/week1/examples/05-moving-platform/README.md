# Example 5: Moving Platform

**Difficulty:** Intermediate

**Time:** 45-60 minutes

**What you'll learn:**
- Continuous CFrame manipulation
- Back-and-forth movement patterns
- Circular/orbital movement (trigonometry!)
- Advanced TweenService usage
- RunService for frame-by-frame updates
- Delta time and frame-independent movement
- Relative vs. absolute positioning
- Creating multiple movement patterns

---

## Concept: Continuous Motion

**What pros call it:** "Continuous animation" or "procedural animation"

**What it actually means:** Movement that runs constantly in a loop, not triggered by events.

**Comparison:**

| Event-Driven (Door) | Continuous (Platform) |
|---------------------|----------------------|
| Waits for player | Always moving |
| Triggered by touch | Runs on its own |
| One-shot action | Infinite loop |
| Reactive | Proactive |

**Real-world examples:**
- **Continuous:** Elevator constantly going up/down, carousel spinning, escalator moving
- **Event-driven:** Automatic door (waits for trigger), button-activated elevator

**Why it matters:** Most game mechanics that create challenge or spectacle are continuous:
- Moving platforms (obby games)
- Patrolling enemies (AI)
- Rotating hazards (saw blades)
- Day/night cycles
- Idle animations

---

## What We're Building

A platform that demonstrates different movement patterns:

1. **Linear back-and-forth** - Moves between two points
2. **Circular orbit** - Moves in a circle (uses trig!)
3. **Figure-8 pattern** - Complex path
4. **Floating bob** - Gentle up/down motion
5. **Rotating platform** - Spins while stationary

Each teaches different CFrame techniques!

**Goal:** Master CFrame manipulation and understand different animation approaches.

---

## Step 1: Create the Platform in Studio

### Basic Setup

1. **Insert a Part** → Name it "MovingPlatform"
   - Size: `8, 1, 8` (flat platform)
   - Position: `0, 5, 0`
   - Color: Any color (suggest bright to see easily)
   - Material: SmoothPlastic or Neon
   - **Anchored:** true (CRITICAL!)

**Why anchored?** Unanchored parts fall due to gravity. We're controlling position with code, not physics.

**Pro tip:** Make it stand out visually so players know it's special!

2. **Optional:** Add a Trail effect
   - Insert ParticleEmitter or Trail into the platform
   - Makes it easier to see the movement pattern

---

## Step 2: Understanding Movement Approaches

There are three main ways to move parts continuously:

### Approach 1: TweenService (Best for Simple Back-and-Forth)

**Pros:**
- Smooth, automatic interpolation
- Easing functions built-in
- Simple to implement

**Cons:**
- Limited to predefined paths
- Can't easily change direction mid-tween

**Best for:** Back-and-forth, defined waypoints

```lua
local TweenService = game:GetService("TweenService")

local info = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
local goal = {Position = Vector3.new(20, 5, 0)}

local tween = TweenService:Create(platform, info, goal)
tween:Play()
-- Platform moves 20 studs right, then back, repeating forever
```

---

### Approach 2: RunService (Best for Complex Patterns)

**Pros:**
- Full control every frame
- Can create any pattern (circles, spirals, etc.)
- Easy to adjust based on game state

**Cons:**
- More complex to implement
- Need to handle timing yourself

**Best for:** Circular motion, complex paths, responsive movement

```lua
local RunService = game:GetService("RunService")

local angle = 0
RunService.Heartbeat:Connect(function(deltaTime)
    angle = angle + deltaTime  -- Increases over time

    local x = math.cos(angle) * 10  -- 10 stud radius
    local z = math.sin(angle) * 10
    platform.Position = Vector3.new(x, 5, z)
    -- Platform moves in a circle!
end)
```

---

### Approach 3: Hybrid (TweenService + Manual Control)

**Pros:**
- Combines smoothness of tweens with flexibility of manual control
- Can chain tweens for complex paths

**Cons:**
- More code to manage
- Tween timing can get complex

**Best for:** Waypoint systems, patrol routes

```lua
local waypoints = {
    Vector3.new(0, 5, 0),
    Vector3.new(20, 5, 0),
    Vector3.new(20, 5, 20),
    Vector3.new(0, 5, 20)
}

local function moveToWaypoint(index)
    local goal = {Position = waypoints[index]}
    local tween = TweenService:Create(platform, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()

    -- Move to next waypoint
    local nextIndex = index % #waypoints + 1
    moveToWaypoint(nextIndex)
end

moveToWaypoint(1)  -- Start the loop
```

---

## Step 3: Pattern 1 - Linear Back-and-Forth (TweenService)

The simplest moving platform - goes from A to B and back.

```lua
print("🔄 Linear Platform starting...")

local TweenService = game:GetService("TweenService")
local platform = workspace:WaitForChild("MovingPlatform")

-- Configuration
local START_POS = platform.Position
local END_POS = START_POS + Vector3.new(20, 0, 0)  -- 20 studs to the right
local TRAVEL_TIME = 3  -- Seconds for one-way trip

-- Create tween info
local tweenInfo = TweenInfo.new(
    TRAVEL_TIME,
    Enum.EasingStyle.Sine,  -- Smooth acceleration/deceleration
    Enum.EasingDirection.InOut,
    -1,  -- Repeat forever
    true  -- Reverse (go back and forth)
)

-- Create and play tween
local tween = TweenService:Create(platform, tweenInfo, {Position = END_POS})
tween:Play()

print("✅ Platform moving between", START_POS, "and", END_POS)
```

**What's happening:**
1. Stores start position
2. Calculates end position (20 studs right)
3. Creates tween with `reverses = true` (automatically goes back)
4. Repeats forever (`repeatCount = -1`)

**Pro insight:** `reverses = true` is KEY for back-and-forth movement with tweens!

---

## Step 4: Pattern 2 - Circular Orbit (RunService + Trig)

Uses sine and cosine to create perfect circular motion.

```lua
print("⭕ Circular Platform starting...")

local RunService = game:GetService("RunService")
local platform = workspace:WaitForChild("MovingPlatform")

-- Configuration
local CENTER = Vector3.new(0, 5, 0)  -- Center of circle
local RADIUS = 15  -- Size of circle (studs)
local SPEED = 1  -- Revolutions per second (higher = faster)

-- State
local angle = 0  -- Current angle in radians

-- Update every frame
RunService.Heartbeat:Connect(function(deltaTime)
    -- Increment angle based on time (frame-independent)
    angle = angle + (deltaTime * SPEED * math.pi * 2)

    -- Keep angle in 0-2π range (optional, prevents overflow)
    if angle > math.pi * 2 then
        angle = angle - math.pi * 2
    end

    -- Calculate position using trig
    local x = CENTER.X + (math.cos(angle) * RADIUS)
    local z = CENTER.Z + (math.sin(angle) * RADIUS)

    -- Update platform position
    platform.Position = Vector3.new(x, CENTER.Y, z)
end)

print("✅ Platform orbiting around", CENTER, "with radius", RADIUS)
```

**Breaking down the math:**

**Circle formula:**
```
x = centerX + cos(angle) * radius
y = centerY (constant height)
z = centerZ + sin(angle) * radius
```

**Why it works:**
- `cos(angle)` oscillates between -1 and 1
- `sin(angle)` also oscillates between -1 and 1
- They're 90° out of phase (creates circular motion)
- Multiplying by radius scales the circle size

**Visual:**
```
     Z
     ↑
     |    angle=0°
     |    cos=1, sin=0
     |    → Point to the right
←----+----→ X
     |    angle=90°
     |    cos=0, sin=1
     |    → Point up
```

**Pro term:** This is **parametric equations** - defining position as a function of a parameter (angle).

---

### Understanding Trigonometry in Game Development

**What pros call it:** "Trig functions" or "circular motion math"

**Common uses:**
- Circular paths (orbits, carousels)
- Rotating objects (fans, wheels)
- Looking at targets (turrets, cameras)
- Wave patterns (ocean, bobbing)
- Projectile arcs (cannons, basketballs)

**Key functions:**

```lua
-- Sine: Oscillates -1 to 1 (vertical component of circle)
math.sin(0) = 0
math.sin(math.pi/2) = 1  -- 90 degrees
math.sin(math.pi) = 0  -- 180 degrees
math.sin(3*math.pi/2) = -1  -- 270 degrees

-- Cosine: Oscillates -1 to 1 (horizontal component of circle)
math.cos(0) = 1
math.cos(math.pi/2) = 0  -- 90 degrees
math.cos(math.pi) = -1  -- 180 degrees

-- Together they make a circle!
for angle = 0, math.pi * 2, 0.1 do
    local x = math.cos(angle)
    local z = math.sin(angle)
    -- Traces a circle of radius 1
end
```

**Pro tip:** Don't memorize - visualize! Cosine is X (left-right), Sine is Z (forward-back) when making circles.

---

## Step 5: Pattern 3 - Floating Bob (Sine Wave)

Gentle up-and-down motion, like something floating on water.

```lua
print("🌊 Floating Platform starting...")

local RunService = game:GetService("RunService")
local platform = workspace:WaitForChild("MovingPlatform")

-- Configuration
local BASE_HEIGHT = 5  -- Center height
local BOB_DISTANCE = 2  -- How far up/down (studs)
local BOB_SPEED = 1  -- How fast (cycles per second)

-- Store starting position
local startPos = platform.Position

-- State
local time = 0

-- Update every frame
RunService.Heartbeat:Connect(function(deltaTime)
    time = time + deltaTime

    -- Calculate height using sine wave
    local offset = math.sin(time * BOB_SPEED * math.pi * 2) * BOB_DISTANCE

    -- Update Y position only
    platform.Position = Vector3.new(
        startPos.X,
        BASE_HEIGHT + offset,  -- Oscillates up and down
        startPos.Z
    )
end)

print("✅ Platform bobbing between", BASE_HEIGHT - BOB_DISTANCE, "and", BASE_HEIGHT + BOB_DISTANCE)
```

**What's happening:**
- `math.sin(time * ...)` creates a wave that repeats
- Multiplying by `BOB_DISTANCE` scales how far it moves
- Adding to `BASE_HEIGHT` centers the motion

**Wave visualization:**
```
Height
  ↑
7 |     *           *
  |   *   *       *   *
5 | *       *   *       *   (base)
  |           *           *
3 |
  └────────────────────────→ Time
```

**Pro use cases:**
- Floating islands
- Collectible items (coins, gems)
- Breathing animation (character idle)
- Ocean waves
- Magic crystals hovering

---

## Step 6: Pattern 4 - Figure-8 (Lissajous Curve)

Two sine waves at different frequencies create complex patterns!

```lua
print("∞ Figure-8 Platform starting...")

local RunService = game:GetService("RunService")
local platform = workspace:WaitForChild("MovingPlatform")

-- Configuration
local CENTER = Vector3.new(0, 5, 0)
local SIZE = 15  -- Size of pattern
local SPEED = 0.5  -- Pattern speed

-- State
local time = 0

-- Update every frame
RunService.Heartbeat:Connect(function(deltaTime)
    time = time + deltaTime * SPEED

    -- Figure-8 uses different frequencies for X and Z
    local x = CENTER.X + (math.sin(time) * SIZE)
    local z = CENTER.Z + (math.sin(time * 2) * SIZE)  -- 2x frequency!

    platform.Position = Vector3.new(x, CENTER.Y, z)
end)

print("✅ Platform moving in figure-8 pattern")
```

**Why it makes a figure-8:**
- X oscillates at 1x frequency
- Z oscillates at 2x frequency
- When X completes 1 cycle, Z completes 2
- This creates the crossing pattern!

**Pro term:** This is a **Lissajous curve** - patterns created by combining sine waves.

**Experiment:** Try different frequency ratios:
- `1:1` = Circle
- `1:2` = Figure-8
- `2:3` = Pretzel shape
- `3:4` = Flower pattern

---

## Step 7: Pattern 5 - Rotating Platform

Platform stays in place but spins around.

```lua
print("🔄 Rotating Platform starting...")

local RunService = game:GetService("RunService")
local platform = workspace:WaitForChild("MovingPlatform")

-- Configuration
local ROTATION_SPEED = 45  -- Degrees per second

-- State
local currentAngle = 0

-- Store original position
local originalPos = platform.Position

-- Update every frame
RunService.Heartbeat:Connect(function(deltaTime)
    -- Increase angle
    currentAngle = currentAngle + (ROTATION_SPEED * deltaTime)

    -- Keep angle in 0-360 range
    if currentAngle >= 360 then
        currentAngle = currentAngle - 360
    end

    -- Create CFrame with rotation
    platform.CFrame = CFrame.new(originalPos) * CFrame.Angles(0, math.rad(currentAngle), 0)
end)

print("✅ Platform rotating at", ROTATION_SPEED, "degrees/second")
```

**Key difference:** Using `CFrame` instead of `Position` because we're rotating!

**CFrame.Angles(X, Y, Z):**
- X = Rotation around X axis (pitch - nose up/down)
- Y = Rotation around Y axis (yaw - turning left/right)
- Z = Rotation around Z axis (roll - tilting left/right)

---

## Step 8: Understanding Delta Time

**What pros call it:** "Delta time" or "frame delta"

**What it is:** The time elapsed since the last frame (usually ~0.016 seconds at 60 FPS).

**Why it matters:** Makes your animations run at the same speed regardless of frame rate!

**Without delta time (bad):**

```lua
-- ❌ Moves different speeds on different computers!
RunService.Heartbeat:Connect(function()
    angle = angle + 0.1  -- Fixed increment
    -- On 60 FPS: 6 per second
    -- On 30 FPS: 3 per second (half speed!)
end)
```

**With delta time (good):**

```lua
-- ✅ Same speed on all computers!
RunService.Heartbeat:Connect(function(deltaTime)
    angle = angle + (deltaTime * 6)  -- Scale by time
    -- On 60 FPS: 0.016 * 6 = 0.096 per frame → 6 per second
    -- On 30 FPS: 0.033 * 6 = 0.198 per frame → 6 per second
end)
```

**Formula:**
```
newValue = oldValue + (rate * deltaTime)
```

**Pro insight:** ALWAYS use delta time with RunService! This is how professionals ensure consistent gameplay across different hardware.

---

## Step 9: Combining Patterns

The real power: combine multiple movements!

### Orbiting + Bobbing

```lua
local angle = 0
local bobTime = 0

RunService.Heartbeat:Connect(function(deltaTime)
    -- Circular orbit
    angle = angle + deltaTime
    local x = math.cos(angle) * 15
    local z = math.sin(angle) * 15

    -- Vertical bob
    bobTime = bobTime + deltaTime * 2  -- Faster bob
    local y = 5 + (math.sin(bobTime) * 2)

    platform.Position = Vector3.new(x, y, z)
end)
-- Platform orbits while bobbing up and down!
```

### Rotating + Moving

```lua
local moveAngle = 0
local rotateAngle = 0

RunService.Heartbeat:Connect(function(deltaTime)
    -- Move in circle
    moveAngle = moveAngle + deltaTime
    local x = math.cos(moveAngle) * 15
    local z = math.sin(moveAngle) * 15

    -- Rotate while moving
    rotateAngle = rotateAngle + (deltaTime * 90)  -- 90 deg/sec

    platform.CFrame = CFrame.new(x, 5, z) * CFrame.Angles(0, math.rad(rotateAngle), 0)
end)
-- Platform orbits while spinning!
```

**Pro term:** This is **compositing animations** - layering multiple movements for complex behavior.

---

## Step 10: The Complete Moving Platform Script

Here's a complete script with multiple patterns you can switch between:

```lua
-- Moving Platform System
-- Demonstrates various continuous motion patterns

print("🎢 Moving Platform System starting...")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local platform = workspace:WaitForChild("MovingPlatform")

-- Choose a pattern to use (uncomment one)
local PATTERN = "circular"  -- circular, linear, bob, figure8, rotate, combo

-- Configuration
local CENTER = platform.Position
local SPEED = 1  -- General speed multiplier

print("✅ Platform found, using pattern:", PATTERN)

-- Pattern: Linear Back-and-Forth
if PATTERN == "linear" then
    local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local goal = {Position = CENTER + Vector3.new(20, 0, 0)}
    TweenService:Create(platform, tweenInfo, goal):Play()

-- Pattern: Circular Orbit
elseif PATTERN == "circular" then
    local angle = 0
    RunService.Heartbeat:Connect(function(deltaTime)
        angle = angle + (deltaTime * SPEED * math.pi * 2)
        local x = CENTER.X + (math.cos(angle) * 15)
        local z = CENTER.Z + (math.sin(angle) * 15)
        platform.Position = Vector3.new(x, CENTER.Y, z)
    end)

-- Pattern: Vertical Bob
elseif PATTERN == "bob" then
    local time = 0
    RunService.Heartbeat:Connect(function(deltaTime)
        time = time + deltaTime
        local y = CENTER.Y + (math.sin(time * SPEED * math.pi * 2) * 2)
        platform.Position = Vector3.new(CENTER.X, y, CENTER.Z)
    end)

-- Pattern: Figure-8
elseif PATTERN == "figure8" then
    local time = 0
    RunService.Heartbeat:Connect(function(deltaTime)
        time = time + (deltaTime * SPEED)
        local x = CENTER.X + (math.sin(time) * 15)
        local z = CENTER.Z + (math.sin(time * 2) * 15)
        platform.Position = Vector3.new(x, CENTER.Y, z)
    end)

-- Pattern: Rotating
elseif PATTERN == "rotate" then
    local angle = 0
    RunService.Heartbeat:Connect(function(deltaTime)
        angle = angle + (deltaTime * SPEED * 90)  -- 90 deg/sec
        platform.CFrame = CFrame.new(CENTER) * CFrame.Angles(0, math.rad(angle), 0)
    end)

-- Pattern: Combo (Orbit + Bob + Rotate)
elseif PATTERN == "combo" then
    local orbitAngle = 0
    local bobTime = 0
    local rotateAngle = 0

    RunService.Heartbeat:Connect(function(deltaTime)
        orbitAngle = orbitAngle + (deltaTime * SPEED)
        bobTime = bobTime + (deltaTime * SPEED * 2)
        rotateAngle = rotateAngle + (deltaTime * SPEED * 45)

        local x = CENTER.X + (math.cos(orbitAngle) * 15)
        local y = CENTER.Y + (math.sin(bobTime) * 2)
        local z = CENTER.Z + (math.sin(orbitAngle) * 15)

        platform.CFrame = CFrame.new(x, y, z) * CFrame.Angles(0, math.rad(rotateAngle), 0)
    end)
end

print("🎯 Pattern active:", PATTERN)
```

---

## Step 11: Build and Test

### Create Files

1. Copy one of the pattern scripts into `src/server/MovingPlatform.server.lua`
2. Create the Rojo config (below)
3. Create the platform in Studio

### Rojo Configuration

```json
{
  "name": "05-moving-platform",
  "tree": {
    "$className": "DataModel",
    "ServerScriptService": {
      "$className": "ServerScriptService",
      "MovingPlatform": {
        "$path": "src/server/MovingPlatform.server.lua"
      }
    }
  }
}
```

### Run It!

1. `rojo serve`
2. Connect Studio
3. Press Play
4. Watch your platform move!

**Testing tip:** Stand on the platform while it moves to see how it feels to ride!

---

## Step 12: Challenges

### Challenge 1: Waypoint System

Create a platform that visits multiple waypoints in sequence:

```lua
local waypoints = {
    Vector3.new(0, 5, 0),
    Vector3.new(20, 5, 0),
    Vector3.new(20, 5, 20),
    Vector3.new(0, 5, 20)
}

local currentWaypoint = 1

local function moveToNext()
    local goal = {Position = waypoints[currentWaypoint]}
    local tween = TweenService:Create(platform, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()

    currentWaypoint = currentWaypoint % #waypoints + 1
    moveToNext()  -- Recursive!
end

moveToNext()
```

---

### Challenge 2: Speed Boost Zones

Make the platform speed up/slow down based on where it is:

```lua
local baseSpeed = 1
local currentSpeed = baseSpeed

RunService.Heartbeat:Connect(function(deltaTime)
    -- Speed up if Y > 10
    if platform.Position.Y > 10 then
        currentSpeed = 2
    else
        currentSpeed = baseSpeed
    end

    angle = angle + (deltaTime * currentSpeed * math.pi * 2)
    -- ... rest of orbit code
end)
```

---

### Challenge 3: Disappearing Platform

Make platform transparent when moving, visible when stopped:

```lua
-- In linear pattern, between movements:
tween.Completed:Wait()
platform.Transparency = 0  -- Visible
task.wait(1)  -- Stay visible for 1 second
platform.Transparency = 0.8  -- Nearly invisible while moving
```

---

### Challenge 4: Spiral Staircase

Platform moves in expanding spiral:

```lua
local angle = 0
local radius = 5

RunService.Heartbeat:Connect(function(deltaTime)
    angle = angle + deltaTime

    -- Expanding radius
    radius = radius + (deltaTime * 0.5)
    if radius > 20 then
        radius = 5  -- Reset
    end

    local x = math.cos(angle) * radius
    local z = math.sin(angle) * radius
    local y = radius  -- Height increases with radius!

    platform.Position = Vector3.new(x, y, z)
end)
```

---

### Challenge 5: Player-Activated Platform

Make platform start moving only when player stands on it:

```lua
local isActive = false

platform.Touched:Connect(function(otherPart)
    local humanoid = otherPart.Parent:FindFirstChildOfClass("Humanoid")
    if humanoid and not isActive then
        isActive = true
        print("Platform activated!")
        -- Start movement
    end
end)
```

---

## Troubleshooting Guide

### Issue: Platform Doesn't Move

**Symptom:** Script runs but platform stays stationary

**Diagnosis:**
1. Check Output (F9) for errors
2. Verify platform is named correctly
3. Confirm platform is anchored
4. Check if RunService is actually connected

**Solutions:**
```lua
-- Add debug output
print("Platform:", platform)
print("Position:", platform.Position)

RunService.Heartbeat:Connect(function(deltaTime)
    print("Updating position...")
    -- Position change code
end)
```

---

### Issue: Platform Moves Too Fast or Too Slow

**Symptom:** Platform zooms across world or crawls

**Cause:** Speed multiplier or deltaTime calculation is wrong

**Solutions:**
```lua
-- Adjust speed constant
local SPEED = 0.5  -- Decrease to slow down
-- or
local SPEED = 2    -- Increase to speed up

-- Verify deltaTime is being used
angle = angle + (deltaTime * SPEED * math.pi * 2)
-- Not: angle = angle + SPEED
```

---

### Issue: Platform Rotates Incorrectly

**Symptom:** Platform spins the wrong direction or axis

**Causes:**
1. Using degrees instead of radians
2. Wrong axis specified
3. CFrame multiplied in wrong order

**Solutions:**
```lua
-- ✅ Correct - radians for CFrame.Angles
CFrame.Angles(0, math.rad(currentAngle), 0)

-- ✅ Correct - Y axis for vertical rotation
CFrame.Angles(0, math.rad(angle), 0)  -- Yaw (turning)

-- ❌ Wrong - degrees without conversion
CFrame.Angles(0, 45, 0)  -- 45 radians ≈ 2577 degrees!
```

---

### Issue: Player Can't Stand on Moving Platform

**Symptom:** Player falls through platform while it's moving

**Causes:**
1. Platform moves too fast (exceeds physics update rate)
2. Platform not anchored (creates physics conflicts)
3. Player jittering/unstable

**Solutions:**
```lua
-- Reduce max speed
local MAX_SPEED = 10  -- studs per second (safe limit)

-- Ensure anchored
platform.Anchored = true

-- Use CFrame instead of Position for moving
platform.CFrame = CFrame.new(newX, newY, newZ)  -- Better stability
```

---

## Common Mistakes

### Mistake 1: Forgetting to Anchor

```lua
-- Platform falls immediately!
local platform = Instance.new("Part")
platform.Position = Vector3.new(0, 50, 0)
platform.Parent = workspace
-- Falls due to gravity!
```

**Always anchor moving platforms!**

---

### Mistake 2: Not Using Delta Time

```lua
-- ❌ Runs at different speeds on different FPS
RunService.Heartbeat:Connect(function()
    angle = angle + 0.1
end)

-- ✅ Consistent speed
RunService.Heartbeat:Connect(function(deltaTime)
    angle = angle + (deltaTime * 6)
end)
```

---

### Mistake 3: Degrees Instead of Radians

```lua
-- ❌ Tiny rotation (math expects radians)
CFrame.Angles(0, 90, 0)

-- ✅ 90 degree rotation
CFrame.Angles(0, math.rad(90), 0)
```

---

### Mistake 4: Modifying Position on Rotating Parts

```lua
-- ❌ Won't rotate if you only change Position
platform.Position = newPosition

-- ✅ Use CFrame to preserve rotation
platform.CFrame = CFrame.new(newPosition) * originalRotation
```

---

## What You Learned

By completing this example, you now know:

- ✅ Three approaches to continuous motion (TweenService, RunService, Hybrid)
- ✅ How to create circular motion with sine/cosine
- ✅ What delta time is and why it's critical
- ✅ How to combine multiple motion patterns
- ✅ CFrame manipulation for position AND rotation
- ✅ Trigonometry basics for game development
- ✅ Frame-independent animation techniques
- ✅ Different RunService events (Heartbeat, RenderStepped, Stepped)

---

## Professional Insights

### 1. RunService Events

| Event | When It Fires | Use Case |
|-------|---------------|----------|
| **Heartbeat** | After physics, before render | General server/client logic |
| **RenderStepped** | Before render (client only) | Camera updates, UI |
| **Stepped** | Before physics | Physics-related calculations |

**Pro tip:** Use Heartbeat for most things. It's the most versatile.

---

### 2. Physics vs. Code-Driven Motion

**Choosing the right approach:**

| Situation | Best Method |
|-----------|-------------|
| Predictable path | Code-driven (CFrame) |
| Realistic physics | BodyMovers (deprecated) or Constraints |
| Player-influenced | Physics (unanchored) |
| Precise timing | Code-driven (CFrame) |

**Pro insight:** For gameplay-critical platforms (obby), always use code-driven (anchored + CFrame). Physics can be unpredictable!

---

### 3. Performance Considerations

**Bad: 100 platforms, each with own Heartbeat:**

```lua
-- In each platform's script
RunService.Heartbeat:Connect(function(deltaTime)
    -- Update this platform
end)
-- 100 connections running!
```

**Good: One script managing all platforms:**

```lua
-- One script in ServerScriptService
local platforms = workspace.Platforms:GetChildren()

RunService.Heartbeat:Connect(function(deltaTime)
    for i, platform in ipairs(platforms) do
        updatePlatform(platform, deltaTime)
    end
end)
-- 1 connection, updates 100 platforms!
```

**Pro term:** This is **batching** - processing multiple objects in one loop.

---

### 4. Trig in Real Games

**Where you'll use sine/cosine:**
- Idle animations (characters breathing, items floating)
- Camera shake (earthquakes, explosions)
- Projectile arcs (grenades, arrows)
- Enemy AI (circular patrols, bobbing drones)
- Visual effects (pulsing lights, spinning props)
- Steering behaviors (smooth turning)

**Pro tip:** Learn to "see" sine waves in games. Notice breathing animations, floating items, camera effects - they're all sine waves!

---

## Extensions & Variations

### Extension 1: Obstacle-Avoidant Platform

Platform detects obstacles and changes direction:
```lua
local platform = workspace:WaitForChild("MovingPlatform")
local heading = 1  -- 1 = right, -1 = left

RunService.Heartbeat:Connect(function(deltaTime)
    local targetPos = platform.Position + Vector3.new(heading * 10, 0, 0)

    -- Check if position is safe
    local rayResult = workspace:FindPartOnRay(
        Ray.new(platform.Position, targetPos - platform.Position)
    )

    if rayResult and rayResult.Parent ~= workspace then
        heading = -heading  -- Change direction
    end

    platform.Position = platform.Position + Vector3.new(heading * 5 * deltaTime, 0, 0)
end)
```

**Use case:** Intelligent platforms, obstacle navigation, dynamic routes.

---

### Extension 2: Speed-Based on Player Distance

Platform moves faster when players are near:
```lua
local Players = game:GetService("Players")
local platform = workspace:WaitForChild("MovingPlatform")
local baseSpeed = 0.5
local maxSpeed = 2

RunService.Heartbeat:Connect(function(deltaTime)
    local nearestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local distance = (player.Character.PrimaryPart.Position - platform.Position).Magnitude
            nearestDistance = math.min(nearestDistance, distance)
        end
    end

    -- Faster when closer
    local speedMultiplier = 1 - (nearestDistance / 100)  -- 0-1
    local currentSpeed = baseSpeed + (speedMultiplier * (maxSpeed - baseSpeed))

    angle = angle + (deltaTime * currentSpeed * math.pi * 2)
    -- ... update position ...
end)
```

**Use case:** Dynamic difficulty, adaptive gameplay, challenge scaling.

---

### Variation 1: Platform with Checkpoint Waypoints

Platform visits specific waypoints in order:
```lua
local waypoints = {
    Vector3.new(0, 5, 0),
    Vector3.new(20, 5, 0),
    Vector3.new(20, 15, 0),
    Vector3.new(0, 15, 0)
}

local currentWaypoint = 1
local moveSpeed = 10  -- studs per second

RunService.Heartbeat:Connect(function(deltaTime)
    local target = waypoints[currentWaypoint]
    local direction = (target - platform.Position).Unit

    platform.Position = platform.Position + (direction * moveSpeed * deltaTime)

    -- Check if reached waypoint
    if (platform.Position - target).Magnitude < 1 then
        currentWaypoint = currentWaypoint % #waypoints + 1
    end
end)
```

**Use case:** Patrol routes, puzzle platforms, scripted sequences.

---

### Variation 2: Disappearing/Reappearing Platform

Platform becomes transparent and intangible, then returns:
```lua
local showTime = 3
local hideTime = 3
local elapsedTime = 0
local isVisible = true

RunService.Heartbeat:Connect(function(deltaTime)
    elapsedTime = elapsedTime + deltaTime

    local maxTime = isVisible and showTime or hideTime

    if elapsedTime >= maxTime then
        elapsedTime = 0
        isVisible = not isVisible

        platform.Transparency = isVisible and 0 or 1
        platform.CanCollide = isVisible
    end

    -- Movement code (optional)
    angle = angle + (deltaTime * SPEED * math.pi * 2)
    -- ...
end)
```

**Use case:** Timing-based challenges, disappearing obstacles, rhythm games.

---

## Performance Tips

### Tip 1: Use Heartbeat Instead of Custom Loops

**Less efficient (custom infinite loop):**
```lua
while true do
    angle = angle + 0.1
    platform.Position = Vector3.new(math.cos(angle) * 15, 5, 0)
    task.wait(0.016)  -- Approximate 60 FPS
end
```

**More efficient (sync with game loop):**
```lua
RunService.Heartbeat:Connect(function(deltaTime)
    angle = angle + (deltaTime * SPEED * math.pi * 2)
    platform.Position = Vector3.new(math.cos(angle) * 15, 5, 0)
end)
```

**Impact:** Heartbeat is optimized for game updates, cleaner and more accurate!

---

### Tip 2: Limit Calculation Frequency for Many Platforms

**Inefficient (every platform calculates every frame):**
```lua
-- Script in each of 50 platforms
RunService.Heartbeat:Connect(function(deltaTime)
    angle = angle + deltaTime
    -- Position update
end)
-- 50 connections, 50 calculations per frame!
```

**Efficient (one manager script):**
```lua
-- One script in ServerScriptService
local platforms = workspace.Platforms:GetChildren()

RunService.Heartbeat:Connect(function(deltaTime)
    for _, platform in ipairs(platforms) do
        updatePlatform(platform, deltaTime)
    end
end)
-- Single connection, batch updates!
```

**Impact:** Single connection vs. fifty reduces overhead significantly.

---

### Tip 3: Pre-Calculate Expensive Operations

**Slower (recalculates math constants every frame):**
```lua
RunService.Heartbeat:Connect(function(deltaTime)
    angle = angle + (deltaTime * 1.5 * 3.14159 * 2)  -- Recalculates each frame
    platform.Position = Vector3.new(math.cos(angle) * 15, 5, 0)
end)
```

**Faster (pre-calculate once):**
```lua
local SPEED_MULTIPLIER = 1.5 * math.pi * 2

RunService.Heartbeat:Connect(function(deltaTime)
    angle = angle + (deltaTime * SPEED_MULTIPLIER)  -- Single multiplication
    platform.Position = Vector3.new(math.cos(angle) * 15, 5, 0)
end)
```

**Impact:** Eliminates redundant calculations, especially important for heavy physics!

---

### Tip 4: Use CFrame Over Position for Moving Parts

**Slower (only updates position):**
```lua
platform.Position = platform.Position + Vector3.new(moveX, moveY, moveZ)
```

**Faster (updates position AND rotation together):**
```lua
platform.CFrame = platform.CFrame * CFrame.new(moveX, moveY, moveZ)
```

**Impact:** CFrame is a single operation vs. position update that doesn't preserve rotation.

---

### Tip 5: Cache Vector3 Values

**Inefficient (creates new Vector3 every frame):**
```lua
local CENTER = Vector3.new(0, 5, 0)

RunService.Heartbeat:Connect(function(deltaTime)
    local x = CENTER.X + (math.cos(angle) * 15)
    local y = CENTER.Y
    local z = CENTER.Z + (math.sin(angle) * 15)

    platform.Position = Vector3.new(x, y, z)  -- New Vector3 every frame!
end)
```

**More efficient (construct fewer Vector3s):**
```lua
local CENTER = Vector3.new(0, 5, 0)
local RADIUS = 15

RunService.Heartbeat:Connect(function(deltaTime)
    platform.Position = CENTER + Vector3.new(
        math.cos(angle) * RADIUS,
        0,
        math.sin(angle) * RADIUS
    )  -- Still creates Vector3 but more direct
end)
```

**Impact:** Memory allocation overhead for millions of Vector3 creations per minute!

---

## Next Steps

**Congratulations!** You've completed all 5 fundamental examples!

**→ Continue to [02-PLAYER-MECHANICS](../../02-PLAYER-MECHANICS/README.md)** - Learn player interaction!

You now have a solid foundation in:
- ✅ Scripts and code execution
- ✅ Property manipulation
- ✅ Loops and timing
- ✅ Event-driven programming
- ✅ Continuous motion and animation

**Ready to level up?** The next section teaches player-specific mechanics: detecting touches, modifying character properties, creating interactive game elements!
