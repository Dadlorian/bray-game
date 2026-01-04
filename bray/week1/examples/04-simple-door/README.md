# Example 4: Simple Door

**Difficulty:** Intermediate

**Time:** 45-60 minutes

**What you'll learn:**
- Event-driven programming with `.Touched` event
- Character detection (finding the player)
- The debounce pattern (preventing spam)
- TweenService for smooth animations
- CFrame for positioning and rotation
- Connecting and disconnecting events
- Asynchronous code execution

---

## Concept: Event-Driven Programming

**What pros call it:** "Event-driven programming" or "event-based architecture"

**What it actually means:** Instead of constantly checking "did something happen?", you set up listeners that automatically run code when events occur.

**Real-world comparison:**

**❌ Polling (bad way):**
```
Every 0.1 seconds:
    Check if doorbell was pressed
    If yes, open door
```
This wastes CPU checking constantly!

**✅ Event-driven (good way):**
```
When doorbell rings:
    Open door
```
Code only runs when needed!

**Why it matters:** Event-driven programming is THE foundation of:
- User interfaces (button clicks, mouse movements)
- Multiplayer networking (player joined, message received)
- Game mechanics (collision, damage, pickup)
- Physics simulations (touch, hit, explosion)

**Pro insight:** Almost all modern software is event-driven. Master this, and you understand how apps, games, and websites work!

---

## What We're Building

An automatic door that:
1. Opens when a player approaches (touch detection)
2. Animates smoothly (TweenService)
3. Closes after the player leaves
4. Prevents bugs from rapid touches (debouncing)
5. Only responds to players (not other parts)

**Goal:** Understand event listeners, character detection, and the debounce pattern.

---

## Step 1: Build the Door in Studio

### Create the Door Model

1. **Insert a Part** →  Name it "Door"
   - Size: `1, 10, 8` (thin, tall, wide)
   - Position: `0, 5, -10`
   - Color: Any color you like
   - Material: Wood or your choice
   - **Anchored:** true (critical!)

2. **Insert another Part** → Name it "Sensor"
   - Size: `10, 1, 10` (flat, large area)
   - Position: `0, 0.5, -10` (on the ground in front of door)
   - **Transparency:** 1 (invisible)
   - **CanCollide:** false (players walk through it)
   - **Anchored:** true

**Pro tip:** The Sensor is an invisible trigger zone. When players step on it, the door opens!

3. **Group them** (optional but recommended):
   - Select both parts
   - Right-click → Group (Ctrl+G)
   - Name the Model "DoorSystem"

**Why group?** Keeps workspace organized, makes it easy to duplicate/move the door.

---

## Step 2: Understanding the .Touched Event

### What is .Touched?

Every `BasePart` (Part, MeshPart, etc.) has a `.Touched` event that fires when something touches it.

**Basic usage:**

```lua
local part = workspace.Part

part.Touched:Connect(function(otherPart)
    print("Something touched me!")
    print("It was:", otherPart.Name)
end)
```

**Breakdown:**
- `part.Touched` - The event (signal)
- `:Connect()` - Register a listener (callback)
- `function(otherPart)` - Code that runs when touched
- `otherPart` - The part that touched our part

**Pro term:** The function passed to `:Connect()` is called a **callback** or **event handler**.

---

### What Fires .Touched?

**The .Touched event fires when:**
- A player's character touches the part
- Another part touches it (if both CanCollide)
- A tool touches it
- An accessory (hat, gear) touches it

**The event does NOT fire when:**
- The part is unanchored and falling
- Both parts have CanCollide = false
- The part is a descendant of the touching object

---

### The otherPart Parameter

```lua
part.Touched:Connect(function(otherPart)
    print("Touched by:", otherPart.Name)
    print("Parent:", otherPart.Parent.Name)
    print("ClassName:", otherPart.ClassName)
end)
```

**Important:** `otherPart` is usually a body part (Head, Torso, LeftFoot, etc.), not the player!

**To get the player:**
```lua
part.Touched:Connect(function(otherPart)
    -- Get the character model
    local character = otherPart.Parent

    -- Get the humanoid (proves it's a character)
    local humanoid = character:FindFirstChild("Humanoid")

    if humanoid then
        -- Get the player
        local player = game.Players:GetPlayerFromCharacter(character)

        if player then
            print("Player touched:", player.Name)
        end
    end
end)
```

**Pro pattern:** Always check for Humanoid to confirm it's a character, not a random part!

---

## Step 3: The Debounce Pattern

### The Problem

```lua
-- ❌ BAD - Fires multiple times per second!
sensor.Touched:Connect(function(otherPart)
    print("Touched!")
    door.Transparency = 0.5
end)
```

**What happens:**
- Player steps on sensor
- `.Touched` fires 5-10 times in one second (as body parts touch repeatedly)
- Code runs 5-10 times
- Console spams "Touched!" messages

**Pro term:** This is called **event spam** or **rapid firing**.

---

### The Solution: Debounce

```lua
local debounce = false  -- "Is the door busy?"

sensor.Touched:Connect(function(otherPart)
    if debounce then
        return  -- Door is busy, ignore touch
    end

    debounce = true  -- Mark as busy

    print("Opening door...")
    -- Do door opening logic

    task.wait(3)  -- Wait for door to finish

    debounce = false  -- Mark as ready again
end)
```

**How it works:**
1. `debounce` starts as `false` (ready)
2. First touch sets it to `true` (busy)
3. Subsequent touches see it's `true` and return early (ignore)
4. After door finishes, set back to `false` (ready)

**Real-world analogy:** Like a bathroom door lock. Once locked (busy), other people can't enter until you unlock it (ready).

**Pro term:** This pattern is called **debouncing** - preventing multiple rapid executions.

---

### Advanced: Per-Player Debounce

The basic debounce blocks ALL players. Better: track per player.

```lua
local playersInZone = {}  -- Table tracking who's inside

sensor.Touched:Connect(function(otherPart)
    local character = otherPart.Parent
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    local player = game.Players:GetPlayerFromCharacter(character)
    if not player then return end

    -- Check if this specific player is already being processed
    if playersInZone[player] then
        return  -- This player already triggered it
    end

    playersInZone[player] = true  -- Mark this player as inside

    print(player.Name, "entered zone")
    -- Open door logic

    task.wait(3)

    playersInZone[player] = nil  -- Remove from tracking
    print(player.Name, "can trigger again")
end)
```

**Pro use case:** Allows multiple players to interact simultaneously, but prevents each player from spamming.

---

## Step 4: Understanding CFrame

**What pros call it:** "CFrame" (Coordinate Frame)

**What it is:** Position AND rotation combined into one data type.

**Why not just Vector3?**

```lua
-- Vector3 = Position only
part.Position = Vector3.new(10, 5, 0)

-- CFrame = Position + Rotation
part.CFrame = CFrame.new(10, 5, 0) * CFrame.Angles(0, math.rad(45), 0)
```

**Key difference:**
- **Position:** Can cause parts to get stuck in walls, won't rotate
- **CFrame:** Moves and rotates smoothly, safer

**Pro insight:** Always use CFrame for moving parts, especially with TweenService!

---

### Creating CFrames

```lua
-- Method 1: Position only
local cf = CFrame.new(10, 5, 0)

-- Method 2: Position + Look At
local cf = CFrame.new(position, lookAtPosition)

-- Method 3: From angles (rotation)
local cf = CFrame.Angles(x, y, z)  -- In radians!

-- Method 4: Combine position and rotation
local cf = CFrame.new(10, 5, 0) * CFrame.Angles(0, math.rad(90), 0)
```

**Important:** Angles are in **radians**, not degrees!
- 90 degrees = `math.rad(90)` = π/2 ≈ 1.57
- 180 degrees = `math.rad(180)` = π ≈ 3.14
- 360 degrees = `math.rad(360)` = 2π ≈ 6.28

---

### Reading CFrame

```lua
local cf = part.CFrame

-- Get position
print(cf.Position)  -- Vector3

-- Get rotation (as angles)
local x, y, z = cf:ToEulerAnglesXYZ()
print("Rotation:", math.deg(x), math.deg(y), math.deg(z))

-- Get individual components
print("X:", cf.X)
print("Y:", cf.Y)
print("Z:", cf.Z)

-- Get look direction
print("LookVector:", cf.LookVector)  -- Direction part is facing
```

---

### CFrame Math

```lua
-- Move part 10 studs right (relative to its current orientation)
part.CFrame = part.CFrame * CFrame.new(10, 0, 0)

-- Rotate 45 degrees around Y axis
part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(45), 0)

-- Combine position and rotation changes
part.CFrame = part.CFrame * CFrame.new(5, 0, 0) * CFrame.Angles(0, math.rad(90), 0)
```

**Pro insight:** Multiplying CFrames applies transformations relative to current orientation!

---

## Step 5: TweenService for Smooth Animation

**What pros call it:** "TweenService" or "tweening"

**What it is:** Smoothly animating property changes over time (position, size, color, etc.).

**Without TweenService (bad):**

```lua
-- Jumpy, instant movement
for i = 1, 10 do
    door.CFrame = door.CFrame * CFrame.new(1, 0, 0)
    task.wait(0.1)
end
-- Moves in choppy 10-step increments
```

**With TweenService (good):**

```lua
local TweenService = game:GetService("TweenService")

local info = TweenInfo.new(1)  -- 1 second duration
local goal = {CFrame = door.CFrame * CFrame.new(10, 0, 0)}

local tween = TweenService:Create(door, info, goal)
tween:Play()
-- Smooth 60 FPS animation!
```

---

### TweenInfo Parameters

```lua
TweenInfo.new(
    time,              -- Duration in seconds
    easingStyle,       -- How it accelerates (Enum.EasingStyle._____)
    easingDirection,   -- In, Out, or InOut (Enum.EasingDirection._____)
    repeatCount,       -- How many times to repeat (0 = once, -1 = forever)
    reverses,          -- true = goes back to start
    delayTime          -- Wait before starting
)
```

**Examples:**

```lua
-- Simple: 2 seconds, default easing
local info = TweenInfo.new(2)

-- Smooth: 1 second, easing in and out
local info = TweenInfo.new(
    1,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.InOut
)

-- Bounce: 1 second, bounces at end
local info = TweenInfo.new(
    1,
    Enum.EasingStyle.Bounce,
    Enum.EasingDirection.Out
)

-- Repeating: 2 seconds, repeats forever, reverses
local info = TweenInfo.new(
    2,
    Enum.EasingStyle.Linear,
    Enum.EasingDirection.In,
    -1,  -- Repeat forever
    true  -- Reverse
)
```

---

### Easing Styles (How It Moves)

**Common styles:**
- **Linear:** Constant speed (boring but predictable)
- **Quad:** Gentle acceleration/deceleration
- **Cubic:** More pronounced curve
- **Quart/Quint:** Even more dramatic
- **Sine:** Smooth, natural movement
- **Expo:** Dramatic acceleration
- **Elastic:** Springs past target, bounces back
- **Bounce:** Bounces at destination
- **Back:** Goes slightly backward before forward

**Pro tip:** Try different styles! `Quad` and `Sine` are most common for natural movement.

---

### Creating and Playing Tweens

```lua
local TweenService = game:GetService("TweenService")

-- 1. Define tweenInfo
local info = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- 2. Define goal (properties to change)
local goal = {
    Position = Vector3.new(10, 5, 0),
    Color = Color3.new(1, 0, 0),
    Transparency = 0.5
}

-- 3. Create tween
local tween = TweenService:Create(part, info, goal)

-- 4. Play it
tween:Play()

-- Optional: Wait for it to finish
tween.Completed:Wait()
print("Tween finished!")
```

---

### Tween Events

```lua
local tween = TweenService:Create(part, info, goal)

tween.Completed:Connect(function(playbackState)
    if playbackState == Enum.PlaybackState.Completed then
        print("Tween finished successfully")
    elseif playbackState == Enum.PlaybackState.Cancelled then
        print("Tween was cancelled")
    end
end)

tween:Play()
```

**Methods:**
- `tween:Play()` - Start the tween
- `tween:Pause()` - Pause it
- `tween:Cancel()` - Stop and reset
- `tween.Completed:Wait()` - Yield until finished

---

## Step 6: The Complete Door Script

Now let's combine everything into a working door!

```lua
-- Simple Automatic Door System
print("🚪 Door System initializing...")

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Get parts
local door = workspace:WaitForChild("Door")
local sensor = workspace:WaitForChild("Sensor")

-- Configuration
local OPEN_DISTANCE = 8  -- How far to move (studs)
local ANIMATION_TIME = 0.5  -- How long to open/close (seconds)
local STAY_OPEN_TIME = 3  -- How long to stay open (seconds)

-- Store original position
local closedCFrame = door.CFrame
local openCFrame = closedCFrame * CFrame.new(0, 0, OPEN_DISTANCE)  -- Move backward

-- Debounce (prevents spam)
local debounce = false

-- Tween info
local tweenInfo = TweenInfo.new(
    ANIMATION_TIME,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

-- Helper function: Open door
local function openDoor()
    local tween = TweenService:Create(door, tweenInfo, {CFrame = openCFrame})
    tween:Play()
    return tween
end

-- Helper function: Close door
local function closeDoor()
    local tween = TweenService:Create(door, tweenInfo, {CFrame = closedCFrame})
    tween:Play()
    return tween
end

-- Main event handler
sensor.Touched:Connect(function(otherPart)
    -- Check if we're in debounce (door busy)
    if debounce then
        return
    end

    -- Verify it's a character with a Humanoid
    local character = otherPart.Parent
    local humanoid = character:FindFirstChild("Humanoid")

    if not humanoid then
        return  -- Not a character, ignore
    end

    -- Get the player
    local player = Players:GetPlayerFromCharacter(character)

    if not player then
        return  -- Not a player (NPC?), ignore
    end

    -- Activate debounce
    debounce = true

    print("🚶", player.Name, "triggered door")

    -- Open door
    local openTween = openDoor()
    openTween.Completed:Wait()  -- Wait for animation to finish

    print("🚪 Door opened")

    -- Stay open
    task.wait(STAY_OPEN_TIME)

    -- Close door
    local closeTween = closeDoor()
    closeTween.Completed:Wait()

    print("🚪 Door closed")

    -- Release debounce
    debounce = false
end)

print("✅ Door system active!")
```

---

## Step 7: Build and Test

### Create the Files

1. Copy the code above into `src/server/DoorScript.server.lua`
2. Create the Rojo config (below)
3. Create the door and sensor in Studio (see Step 1)

### Rojo Configuration

```json
{
  "name": "04-simple-door",
  "tree": {
    "$className": "DataModel",
    "ServerScriptService": {
      "$className": "ServerScriptService",
      "DoorScript": {
        "$path": "src/server/DoorScript.server.lua"
      }
    }
  }
}
```

### Run It!

1. `rojo serve`
2. Connect Studio
3. Press Play (F5)
4. Walk toward the door
5. Watch it automatically open and close!

---

## Step 8: Experiments and Challenges

### Challenge 1: Sliding Door

Make the door slide sideways instead of backward:

```lua
-- Change this line:
local openCFrame = closedCFrame * CFrame.new(OPEN_DISTANCE, 0, 0)  -- Slide right
```

---

### Challenge 2: Rotating Door (Swinging)

Make the door swing open like a real door:

```lua
-- Calculate hinge position (left edge of door)
local doorWidth = door.Size.Z
local hingeCFrame = closedCFrame * CFrame.new(0, 0, doorWidth/2)

-- Rotate 90 degrees around the hinge
local rotation = CFrame.Angles(0, math.rad(90), 0)
local openCFrame = hingeCFrame * rotation * CFrame.new(0, 0, -doorWidth/2)
```

**Pro insight:** Rotating around a point (hinge) requires moving the pivot!

---

### Challenge 3: Sound Effects

Add sound when door opens/closes:

```lua
-- Create sounds
local openSound = Instance.new("Sound")
openSound.SoundId = "rbxassetid://156286438"  -- Door creak
openSound.Parent = door

local closeSound = Instance.new("Sound")
closeSound.SoundId = "rbxassetid://156286438"
closeSound.Parent = door

-- Play when opening/closing
local function openDoor()
    openSound:Play()
    -- ... rest of code
end

local function closeDoor()
    closeSound:Play()
    -- ... rest of code
end
```

**Pro tip:** Find sound IDs on the Roblox library or upload your own!

---

### Challenge 4: Color Change

Make the door change color when opening:

```lua
local function openDoor()
    local tween = TweenService:Create(door, tweenInfo, {
        CFrame = openCFrame,
        Color = Color3.fromRGB(0, 255, 0)  -- Green when open
    })
    tween:Play()
    return tween
end

local function closeDoor()
    local tween = TweenService:Create(door, tweenInfo, {
        CFrame = closedCFrame,
        Color = Color3.fromRGB(255, 0, 0)  -- Red when closed
    })
    tween:Play()
    return tween
end
```

---

### Challenge 5: Pressure Plate Door

Instead of using Sensor.Touched, make a visible button that opens the door when touched:

```lua
-- Create a button part
local button = Instance.new("Part")
button.Size = Vector3.new(3, 0.5, 3)
button.Position = Vector3.new(-5, 0.25, -10)
button.Color = Color3.fromRGB(255, 0, 0)  -- Red
button.Anchored = true
button.Parent = workspace

-- When touched, turn green and open door
button.Touched:Connect(function(otherPart)
    -- ... character detection ...

    if not debounce then
        button.Color = Color3.fromRGB(0, 255, 0)  -- Green
        -- Open door logic
        task.wait(3)
        button.Color = Color3.fromRGB(255, 0, 0)  -- Red again
    end
end)
```

---

### Challenge 6: Keycard Door

Make the door only open for specific players:

```lua
local authorizedPlayers = {"Player1", "Player2", "YourUsername"}

sensor.Touched:Connect(function(otherPart)
    -- ... existing checks ...

    -- Check if player is authorized
    local isAuthorized = table.find(authorizedPlayers, player.Name)

    if not isAuthorized then
        print("❌", player.Name, "is not authorized")
        return  -- Don't open door
    end

    print("✅", player.Name, "is authorized")
    -- ... open door logic ...
end)
```

**Pro pattern:** This is basic **access control** - checking permissions before allowing actions.

---

## Troubleshooting Guide

### Issue: Door Opens Multiple Times from One Touch

**Symptom:** Player touches sensor, door opens 10+ times rapidly

**Cause:** No debounce - `.Touched` fires for each body part

**Solutions:**
```lua
-- ✅ Always add debounce
local debounce = false

sensor.Touched:Connect(function(otherPart)
    if debounce then return end
    debounce = true

    -- Door logic here
    openDoor()
    task.wait(3)

    debounce = false  -- Re-enable
end)
```

---

### Issue: Door Doesn't Open

**Symptom:** Player touches sensor, nothing happens

**Diagnosis:**
1. Check Output (F9) for error messages
2. Verify sensor exists and is named correctly
3. Confirm sensor has `CanCollide = false`
4. Check if Humanoid detection is failing

**Solutions:**
```lua
-- Debug by printing
sensor.Touched:Connect(function(otherPart)
    print("Touched by:", otherPart.Name)

    local character = otherPart.Parent
    print("Character:", character.Name)

    local humanoid = character:FindFirstChild("Humanoid")
    print("Humanoid exists:", humanoid ~= nil)

    if humanoid then
        openDoor()  -- Should reach here if part of character
    end
end)
```

---

### Issue: Door Animation Looks Choppy

**Symptom:** Door movement is stuttery, not smooth

**Causes:**
1. Tween duration too short (less than 0.1 seconds)
2. Easing style inappropriate
3. Door not anchored (physics interference)

**Solutions:**
- Increase duration: `TweenInfo.new(1)` instead of `TweenInfo.new(0.1)`
- Change easing: Use `Enum.EasingStyle.Sine` or `Quad` (smoother)
- Verify anchored: `part.Anchored = true` in properties

---

### Issue: Multiple Players Cause Conflicts

**Symptom:** Door closes while second player is still in sensor zone

**Cause:** Debounce blocks all players (global, not per-player)

**Solution:** Track per-player instead:
```lua
local playersInZone = {}

sensor.Touched:Connect(function(otherPart)
    local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
    if not player then return end

    -- Per-player debounce
    if playersInZone[player] then return end
    playersInZone[player] = true

    openDoor()
    task.wait(3)

    playersInZone[player] = nil
end)
```

---

## Common Mistakes

### Mistake 1: Forgetting Debounce

```lua
-- ❌ Fires 10+ times per second
sensor.Touched:Connect(function(otherPart)
    openDoor()  -- Opens repeatedly!
end)
```

**Always use debounce for .Touched events!**

---

### Mistake 2: Not Checking for Humanoid

```lua
-- ❌ Opens for any part (including dropped tools, accessories)
sensor.Touched:Connect(function(otherPart)
    local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
    -- This might be nil!
end)

-- ✅ Verify it's a character first
sensor.Touched:Connect(function(otherPart)
    local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
    if humanoid then
        -- It's a character!
    end
end)
```

---

### Mistake 3: Not Anchoring the Door

```lua
-- If door is unanchored, it falls when you try to move it!
```

**Always anchor parts you're moving with tweens!**

---

### Mistake 4: Using Degrees Instead of Radians

```lua
-- ❌ WRONG - tiny rotation (45 radians ≈ 2577 degrees!)
CFrame.Angles(0, 45, 0)

-- ✅ RIGHT - 45 degrees
CFrame.Angles(0, math.rad(45), 0)
```

---

### Mistake 5: Not Waiting for Tween to Finish

```lua
-- ❌ Door starts closing immediately (while still opening!)
openDoor()
closeDoor()

-- ✅ Wait for open to finish
local tween = openDoor()
tween.Completed:Wait()
closeDoor()
```

---

## What You Learned

By completing this example, you now know:

- ✅ How event-driven programming works
- ✅ How to use the `.Touched` event
- ✅ How to detect players vs. other parts
- ✅ The debounce pattern (critical for all touch events)
- ✅ How to use CFrame for positioning and rotation
- ✅ How to create smooth animations with TweenService
- ✅ Different easing styles and when to use them
- ✅ How to wait for tweens to complete
- ✅ How to structure interactive game mechanics

---

## Professional Insights

### 1. Event-Driven is Universal

**This pattern works everywhere:**

**Web development:**
```javascript
button.addEventListener("click", function() {
    // Code runs when clicked
});
```

**Unity (C#):**
```csharp
void OnTriggerEnter(Collider other) {
    // Code runs when colliding
}
```

**Roblox (Lua):**
```lua
part.Touched:Connect(function(otherPart)
    -- Code runs when touched
end)
```

**Same pattern, different syntax!**

---

### 2. Memory Leaks from Events

**Problem:** Event connections stay in memory even after the object is destroyed!

```lua
-- ❌ Memory leak
local part = workspace.Part
part.Touched:Connect(function()
    print("Touched!")
end)
part:Destroy()
-- Connection still exists in memory!
```

**Solution:** Disconnect when done:

```lua
local part = workspace.Part
local connection = part.Touched:Connect(function()
    print("Touched!")
end)

-- Later...
connection:Disconnect()
part:Destroy()
```

**Pro tip:** For temporary objects (projectiles, power-ups), always disconnect events before destroying!

---

### 3. Touch Events for Different Use Cases

| Use Case | Best Practice |
|----------|--------------|
| **Door/Gate** | Sensor part + debounce |
| **Collectible (coin, gem)** | Touch once, then destroy |
| **Damage zone (lava)** | Continuous damage, no debounce |
| **Trigger zone (checkpoint)** | Touch once per player, track in table |
| **Button/Switch** | Debounce + visual feedback |

---

### 4. Performance Considerations

**Bad:** 100 doors each with their own script:

```lua
-- DoorScript in each of 100 doors
local door = script.Parent
-- ... door logic ...
-- 100 scripts running!
```

**Good:** One script managing all doors:

```lua
-- In ServerScriptService
local doors = workspace.Doors:GetChildren()
for i, door in ipairs(doors) do
    setupDoor(door)  -- Function that adds event listeners
end
-- 1 script managing 100 doors!
```

**Pro term:** This is **centralized management** vs. **distributed scripts**.

---

## Extensions & Variations

### Extension 1: Two-Way Door (Opens from Both Sides)

Door opens regardless of which side player approaches from:
```lua
local doorLeftSensor = workspace:WaitForChild("DoorSensorLeft")
local doorRightSensor = workspace:WaitForChild("DoorSensorRight")

local function setupSensor(sensor)
    local debounce = false

    sensor.Touched:Connect(function(otherPart)
        if debounce then return end
        debounce = true

        local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
        if humanoid then
            openDoor()  -- Same door opens from both sides
        end

        task.wait(3)
        debounce = false
    end)
end

setupSensor(doorLeftSensor)
setupSensor(doorRightSensor)
```

**Use case:** Double doors, bidirectional passages.

---

### Extension 2: Door Lock System

Door requires key item before opening:
```lua
local function playerHasKey(player)
    -- Check if player's inventory has key
    local backpack = player:FindFirstChild("Backpack")
    if backpack and backpack:FindFirstChild("DoorKey") then
        return true
    end
    return false
end

sensor.Touched:Connect(function(otherPart)
    -- ... humanoid checks ...

    local player = game.Players:GetPlayerFromCharacter(character)
    if not playerHasKey(player) then
        print("Player needs a key!")
        return  -- Don't open
    end

    openDoor()  -- Only if has key
end)
```

**Use case:** Progression systems, locked areas, key hunts.

---

### Variation 1: Door Stays Open While Player Inside

Door only closes when player leaves trigger zone:
```lua
local playersInZone = {}

sensor.Touched:Connect(function(otherPart)
    local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
    if not player or playersInZone[player] then return end

    playersInZone[player] = true
    openDoor()
end)

sensor.TouchEnded:Connect(function(otherPart)
    local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
    if not player then return end

    playersInZone[player] = nil

    -- Check if any players still in zone
    if next(playersInZone) == nil then  -- Empty table
        closeDoor()
    end
end)
```

**Use case:** Automatic doors, sensor-based gates.

---

### Variation 2: Rotating Door (Swinging Action)

Door rotates open instead of sliding:
```lua
local openCFrame = closedCFrame * CFrame.Angles(0, math.rad(90), 0)

local function openDoor()
    local tween = TweenService:Create(door, tweenInfo, {CFrame = openCFrame})
    tween:Play()
    return tween
end

local function closeDoor()
    local tween = TweenService:Create(door, tweenInfo, {CFrame = closedCFrame})
    tween:Play()
    return tween
end
```

**Use case:** Swinging doors, realistic door mechanics.

---

## Performance Tips

### Tip 1: Avoid Over-Debouncing

**Too strict (blocks way too much):**
```lua
local debounce = false

sensor.Touched:Connect(function()
    if debounce then return end
    debounce = true
    openDoor()
    task.wait(10)  -- Block for 10 seconds
    debounce = false
end)
```

**Better (allows quicker re-triggers):**
```lua
task.wait(3)  -- Matches door animation time
debounce = false
```

**Impact:** Players shouldn't have to wait 10 seconds to trigger again.

---

### Tip 2: Disconnect Events for Temporary Objects

**Memory leak (connection stays forever):**
```lua
for i = 1, 1000 do
    local tempDoor = createTemporaryDoor()
    tempDoor.Sensor.Touched:Connect(function()
        -- Door logic
    end)
end
-- 1000 connections in memory!
```

**Better (cleanup after use):**
```lua
local connection = sensor.Touched:Connect(function()
    -- Door logic
end)

-- Later, when door is destroyed:
connection:Disconnect()
door:Destroy()
```

**Impact:** Prevents memory leaks from accumulating connections.

---

### Tip 3: Use Sensor.TouchEnded for Efficiency

**Less efficient (always check debounce):**
```lua
local debounce = false

sensor.Touched:Connect(function()
    if debounce then return end
    debounce = true
    openDoor()
    task.wait(3)
    debounce = false
end)
```

**More efficient (native event handling):**
```lua
local isPlayerInZone = false

sensor.Touched:Connect(function(otherPart)
    if isPlayerInZone then return end
    isPlayerInZone = true
    openDoor()
end)

sensor.TouchEnded:Connect(function(otherPart)
    if otherPart.Parent:FindFirstChild("Humanoid") then
        isPlayerInZone = false
        closeDoor()
    end
end)
```

**Impact:** Uses native Roblox events instead of manual timing.

---

### Tip 4: Cache References to Avoid Repeated Lookups

**Slower (searches hierarchy each frame):**
```lua
sensor.Touched:Connect(function(otherPart)
    local door = workspace:FindFirstChild("Door")
    local position = workspace:FindFirstChild("Door").Position
    -- Door is found twice!
end)
```

**Faster (reference once):**
```lua
local door = workspace:WaitForChild("Door")

sensor.Touched:Connect(function(otherPart)
    local position = door.Position
    -- Single reference
end)
```

**Impact:** Workspace searches are expensive. Reference once, use many times!

---

## Next Steps

**→ [Example 5: Moving Platform](../05-moving-platform/)** - Learn CFrame manipulation and continuous movement!

You've mastered event-driven programming and debouncing - critical skills! Next, you'll learn continuous motion and advanced CFrame techniques for moving platforms!
