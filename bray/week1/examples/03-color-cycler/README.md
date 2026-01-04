# Example 3: Color Cycler

**Difficulty:** Beginner

**Time:** 20-30 minutes

**What you'll learn:**
- Infinite loops with `while true do`
- Using `task.wait()` to control timing
- Random number generation with `math.random()`
- Creating smooth color transitions
- The game loop pattern
- Frame-independent vs. time-based updates

---

## Concept: The Game Loop

**What pros call it:** "Game loop" or "update loop"

**What it actually means:** Code that runs continuously, over and over, forever - updating the game state each frame or at timed intervals.

**Real-world comparison:**

Think of a traffic light:
```
while true do
    Turn green → wait 30 seconds
    Turn yellow → wait 5 seconds
    Turn red → wait 30 seconds
    repeat forever
end
```

The light doesn't just change once - it loops forever, checking the time and changing states.

**Why it matters:** Almost EVERY game has loops running continuously:
- Enemies patrol routes (loop through waypoints)
- UI updates health bars (loop checking player health)
- Day/night cycle (loop through time of day)
- Particle effects (loop creating particles)

**Pro insight:** Understanding loops separates static worlds from dynamic, living games!

---

## What We're Building

A script that makes a part cycle through colors continuously, demonstrating:

1. **Rainbow cycle** - Smoothly transition through spectrum
2. **Random colors** - Jump to random colors
3. **Timed sequences** - Change colors at specific intervals
4. **Smooth interpolation** - Blend between colors gradually

**Goal:** Master loops and timing - the foundation of game animations and behavior.

---

## Step 1: Create the Part

Same as before - you need a part to color!

### In Roblox Studio:

1. Insert a Part → Name it **"ColorPart"**
2. Make it **Anchored** (so it doesn't fall)
3. Position it somewhere visible: `0, 5, 0`
4. Optional: Make it bigger for visibility: Size `10, 10, 10`

---

## Step 2: Understanding Infinite Loops

### The Pattern

```lua
while true do
    -- This code runs forever
    print("Loop iteration")
    task.wait(1)  -- CRITICAL - prevents freezing!
end

print("This never runs!")  -- Never reached
```

**Key points:**

1. **`while true do`** - Condition is always true, so loop never ends
2. **Code inside runs repeatedly**
3. **MUST include `task.wait()`** or Studio freezes!
4. **Code after the loop never runs**

---

### Why `task.wait()` is Critical

```lua
-- ❌ FREEZES STUDIO - NO WAIT
while true do
    print("Spam!")  -- Prints millions of times per second
end
-- Studio becomes unresponsive and crashes!

-- ✅ SAFE - Has wait
while true do
    print("Once per second")
    task.wait(1)  -- Yields for 1 second
end
```

**What `task.wait()` does:**
1. Pauses the script
2. Lets other code run
3. Lets the game render frames
4. Resumes after specified time

**Pro term:** `task.wait()` is a **yield function** - it **yields** (gives up) control temporarily.

---

### task.wait() vs. wait()

**Both work, but `task.wait()` is newer and better:**

```lua
-- Old way (still works)
wait(1)

-- New way (recommended)
task.wait(1)
```

**Pro tip:** Use `task.wait()` for new code. It's more accurate and has better performance.

**Returns the actual time waited:**
```lua
local timePassed = task.wait(1)
print(timePassed)  -- Usually ~1.001 or 1.002 (slightly over)
```

---

## Step 3: The Complete Scripts

We'll create multiple examples, each teaching a different concept.

### Example A: Rainbow Cycle (Predefined Colors)

```lua
print("🌈 Rainbow Cycler starting...")

local part = workspace:WaitForChild("ColorPart")

-- Define rainbow colors
local colors = {
    Color3.fromRGB(255, 0, 0),    -- Red
    Color3.fromRGB(255, 127, 0),  -- Orange
    Color3.fromRGB(255, 255, 0),  -- Yellow
    Color3.fromRGB(0, 255, 0),    -- Green
    Color3.fromRGB(0, 0, 255),    -- Blue
    Color3.fromRGB(75, 0, 130),   -- Indigo
    Color3.fromRGB(148, 0, 211),  -- Violet
}

print("✅ Starting rainbow cycle (7 colors, 0.5s each)")

-- Infinite loop
while true do
    -- Loop through each color in the array
    for i, color in ipairs(colors) do
        part.Color = color
        print("Color", i, "of", #colors)
        task.wait(0.5)  -- Wait half a second
    end

    print("🔄 Restarting rainbow cycle...")
end
```

**What's happening:**
1. Creates array of 7 colors
2. Infinite `while true` loop
3. Inner `for` loop iterates through colors
4. Changes part color, waits 0.5 seconds
5. After all 7 colors, repeats from start

**Pro pattern:** Nested loops - outer loop runs forever, inner loop handles the sequence.

---

### Example B: Random Colors

```lua
print("🎲 Random Color Cycler starting...")

local part = workspace:WaitForChild("ColorPart")

print("✅ Changing to random color every second")

while true do
    -- Generate random RGB values (0-255)
    local r = math.random(0, 255)
    local g = math.random(0, 255)
    local b = math.random(0, 255)

    part.Color = Color3.fromRGB(r, g, b)

    print(string.format("Color: R=%d, G=%d, B=%d", r, g, b))

    task.wait(1)
end
```

**What's happening:**
1. Infinite loop
2. Each iteration generates 3 random numbers (0-255)
3. Creates Color3 from random RGB
4. Waits 1 second, repeats

**Pro insight:** `math.random()` is **pseudorandom** - appears random but is deterministic. Good enough for games!

---

### Example C: Smooth Color Transition (Interpolation)

```lua
print("✨ Smooth Color Transition starting...")

local part = workspace:WaitForChild("ColorPart")

-- Start and end colors
local colorA = Color3.fromRGB(255, 0, 0)    -- Red
local colorB = Color3.fromRGB(0, 0, 255)    -- Blue

print("✅ Smoothly transitioning between red and blue")

while true do
    -- Fade from A to B
    for alpha = 0, 1, 0.01 do  -- 0.00, 0.01, 0.02, ..., 1.00
        part.Color = colorA:Lerp(colorB, alpha)
        task.wait(0.02)  -- 50 FPS (1/0.02 = 50)
    end

    -- Fade from B to A
    for alpha = 0, 1, 0.01 do
        part.Color = colorB:Lerp(colorA, alpha)
        task.wait(0.02)
    end

    print("🔄 Restarting smooth transition...")
end
```

**What's happening:**
1. Defines start (red) and end (blue) colors
2. `alpha` goes from 0 to 1 in steps of 0.01 (100 steps)
3. `:Lerp()` blends between colors
   - alpha = 0 → 100% colorA (red)
   - alpha = 0.5 → 50/50 mix (purple)
   - alpha = 1 → 100% colorB (blue)
4. Reverses direction for continuous cycle

**Pro term:** `:Lerp()` means **linear interpolation** - blending smoothly from A to B.

**Math behind Lerp:**
```lua
result = A + (B - A) * alpha

-- When alpha = 0: A + (B - A) * 0 = A
-- When alpha = 0.5: A + (B - A) * 0.5 = midpoint
-- When alpha = 1: A + (B - A) * 1 = B
```

**Pro insight:** Lerp is EVERYWHERE in game development. Moving objects, fading UI, blending animations - all use interpolation!

---

### Example D: Rainbow Smooth (Best of Both)

```lua
print("🌈✨ Smooth Rainbow Cycler starting...")

local part = workspace:WaitForChild("ColorPart")

local colors = {
    Color3.fromRGB(255, 0, 0),    -- Red
    Color3.fromRGB(255, 127, 0),  -- Orange
    Color3.fromRGB(255, 255, 0),  -- Yellow
    Color3.fromRGB(0, 255, 0),    -- Green
    Color3.fromRGB(0, 0, 255),    -- Blue
    Color3.fromRGB(75, 0, 130),   -- Indigo
    Color3.fromRGB(148, 0, 211),  -- Violet
}

local transitionSpeed = 0.02  -- Seconds per step
local steps = 50  -- Steps for each transition

print("✅ Smoothly cycling through rainbow")

while true do
    -- Loop through pairs of colors
    for i = 1, #colors do
        local colorA = colors[i]
        local colorB = colors[i % #colors + 1]  -- Next color (wraps to 1)

        -- Smooth transition
        for alpha = 0, 1, 1/steps do
            part.Color = colorA:Lerp(colorB, alpha)
            task.wait(transitionSpeed)
        end
    end

    print("🔄 Rainbow cycle complete")
end
```

**What's happening:**
1. Loops through color array
2. For each pair (current, next), smoothly transitions
3. `i % #colors + 1` wraps around (after violet, goes to red)
4. Creates seamless infinite rainbow

**Pro technique:** Modulo (`%`) for circular indexing - critical for cyclic animations!

---

## Step 4: Understanding math.random()

### Syntax Variations

```lua
-- No arguments: Random decimal 0 to 1
local chance = math.random()  -- e.g., 0.7349281

-- One argument: Random integer 1 to N
local diceRoll = math.random(6)  -- 1, 2, 3, 4, 5, or 6

-- Two arguments: Random integer M to N
local age = math.random(13, 18)  -- 13-18 inclusive

-- RGB example
local r = math.random(0, 255)  -- 0-255
local g = math.random(0, 255)
local b = math.random(0, 255)
local color = Color3.fromRGB(r, g, b)
```

---

### Seeding (Making it Different Each Time)

By default, `math.random()` produces the same sequence every time you run:

```lua
-- This prints the same numbers every time you run Studio!
for i = 1, 5 do
    print(math.random())
end
```

**Solution:** Seed with current time:

```lua
math.randomseed(tick())  -- tick() = seconds since epoch

for i = 1, 5 do
    print(math.random())  -- Different numbers each run!
end
```

**Pro term:** Setting the **random seed** changes the starting point of the pseudorandom sequence.

**Modern alternative (Lua 5.1+):**
```lua
math.randomseed(os.time())  -- os.time() also works
```

**Roblox best practice:**
```lua
-- At the top of your script, seed once
math.randomseed(tick())

-- Then use math.random() throughout
```

---

### Weighted Random (Advanced)

Sometimes you want some results more likely than others:

```lua
-- 70% chance red, 30% chance blue
local function getWeightedColor()
    local roll = math.random()  -- 0-1

    if roll < 0.7 then  -- 70%
        return Color3.fromRGB(255, 0, 0)  -- Red
    else  -- 30%
        return Color3.fromRGB(0, 0, 255)  -- Blue
    end
end

while true do
    part.Color = getWeightedColor()
    task.wait(1)
end
```

**Pro use case:** Loot drops (70% common, 20% rare, 10% legendary), enemy spawns, procedural generation.

---

## Step 5: Performance Considerations

### Loop Speed vs. Frame Rate

**Frame rate:** How many times per second the game renders (60 FPS = 60 frames per second)

**Your loop:** How often your code runs

**Match them:**

```lua
-- 60 FPS = ~0.0167 seconds per frame
while true do
    part.Color = getRandomColor()
    task.wait(1/60)  -- Run 60 times per second
end
```

**But be careful:**

```lua
-- ❌ Too fast - wastes CPU
while true do
    part.Color = getRandomColor()
    task.wait(0.001)  -- 1000 times per second! Overkill!
end
```

**Pro insight:** Color changes are only visible at screen refresh rate (60 Hz usually). Changing color 1000x/second is pointless - you won't see the difference!

**Good practice:**
- **Visual updates:** 30-60 times per second
- **Gameplay updates:** 10-30 times per second
- **Slow effects:** 1-10 times per second

---

### Multiple Parts

What if you have 100 parts all running color cycles?

**❌ Bad - 100 loops:**
```lua
for i = 1, 100 do
    task.spawn(function()
        while true do
            part.Color = getRandomColor()
            task.wait(1)
        end
    end)
end
-- 100 infinite loops running!
```

**✅ Good - 1 loop managing all:**
```lua
local parts = {}  -- Array of parts

while true do
    for i, part in ipairs(parts) do
        part.Color = getRandomColor()
    end
    task.wait(1)  -- All parts update together
end
```

**Pro term:** This is **batch processing** - updating many objects in one loop instead of many loops.

---

## Step 6: Build and Test

### Choose Your Example

Pick ONE of the examples above (A, B, C, or D) to start with.

### Create Files

1. Copy the code into `src/server/ColorCycler.server.lua`
2. Create the Rojo config:

```json
{
  "name": "03-color-cycler",
  "tree": {
    "$className": "DataModel",
    "ServerScriptService": {
      "$className": "ServerScriptService",
      "ColorCycler": {
        "$path": "src/server/ColorCycler.server.lua"
      }
    }
  }
}
```

### Run It!

1. Create "ColorPart" in workspace
2. `rojo serve`
3. Connect Studio
4. Watch your part change colors continuously!

**Troubleshooting:**
- **Part not changing:** Check name matches exactly ("ColorPart")
- **Studio frozen:** You forgot `task.wait()` - restart Studio
- **Too fast/slow:** Adjust the wait time

---

## Step 7: Experiments and Challenges

### Challenge 1: Traffic Light

Make a part cycle through traffic light colors:

```lua
-- Red (3 seconds) → Yellow (1 second) → Green (3 seconds) → repeat
```

**Bonus:** Add a print statement showing current light status.

---

### Challenge 2: Random Timer

Change colors at random intervals (0.5 to 3 seconds):

```lua
while true do
    part.Color = Color3.fromRGB(
        math.random(0, 255),
        math.random(0, 255),
        math.random(0, 255)
    )

    local waitTime = math.random() * 2.5 + 0.5  -- 0.5 to 3.0
    print("Waiting", waitTime, "seconds")
    task.wait(waitTime)
end
```

---

### Challenge 3: Pulsing Neon

Cycle between bright neon and dark, simulating a pulsing light:

```lua
local baseColor = Color3.fromRGB(0, 255, 255)  -- Cyan

while true do
    -- Fade to bright
    for brightness = 0, 1, 0.05 do
        part.Color = Color3.new(
            baseColor.R * brightness,
            baseColor.G * brightness,
            baseColor.B * brightness
        )
        task.wait(0.05)
    end

    -- Fade to dark
    for brightness = 1, 0, -0.05 do
        part.Color = Color3.new(
            baseColor.R * brightness,
            baseColor.G * brightness,
            baseColor.B * brightness
        )
        task.wait(0.05)
    end
end
```

**What you're learning:** Multiplying colors to change brightness (dimming).

---

### Challenge 4: HSV Color Cycle

Cycle through the entire color spectrum using HSV (Hue, Saturation, Value):

```lua
local hue = 0

while true do
    part.Color = Color3.fromHSV(hue, 1, 1)

    hue = hue + 0.01
    if hue > 1 then
        hue = 0  -- Wrap around
    end

    task.wait(0.03)
end
```

**Pro insight:** HSV is better for smooth color transitions than RGB!

**HSV explained:**
- **Hue:** 0-1 represents position on color wheel (red→yellow→green→cyan→blue→magenta→red)
- **Saturation:** 0-1, how vivid (0=gray, 1=pure color)
- **Value:** 0-1, how bright (0=black, 1=full brightness)

---

### Challenge 5: Multi-Part Synchronized Rainbow

Create 7 parts, each a different rainbow color, all cycling together:

```lua
local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 127, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(75, 0, 130),
    Color3.fromRGB(148, 0, 211),
}

-- Create 7 parts
local parts = {}
for i = 1, 7 do
    local part = Instance.new("Part")
    part.Size = Vector3.new(4, 10, 4)
    part.Position = Vector3.new(i * 5 - 20, 5, 0)
    part.Anchored = true
    part.Material = Enum.Material.Neon
    part.Parent = workspace
    table.insert(parts, part)
end

-- Cycle colors with offset
local offset = 0
while true do
    for i, part in ipairs(parts) do
        local colorIndex = (i + offset - 1) % #colors + 1
        part.Color = colors[colorIndex]
    end

    offset = offset + 1
    if offset > #colors then
        offset = 1
    end

    task.wait(0.2)
end
```

**What you're learning:** Creating instances dynamically, synchronized animations.

---

## Troubleshooting Guide

### Issue: Studio Freezes When Running Script

**Symptom:** Studio becomes unresponsive, buttons don't work

**Cause:** Infinite loop without `task.wait()` - code runs millions of times per second

**Solutions:**
1. **Immediate fix:** Force-close Studio (loss of unsaved work)
2. **Prevention:** Always include `task.wait()` in every infinite loop:
```lua
while true do
    -- Some code
    task.wait(0.1)  -- REQUIRED!
end
```
3. **Check:** Search your code for `while true do` - each MUST have `task.wait()`

**Pro tip:** Unbind a connection if needed:
```lua
local connection = RunService.Heartbeat:Connect(function()
    -- Code
end)

-- Later, disconnect to stop
connection:Disconnect()
```

---

### Issue: Color Changes Are Invisible

**Symptom:** Script runs but part stays same color

**Causes:**
1. Part doesn't exist (not found)
2. Color isn't changing (starting color equals ending color)
3. Transparency = 1 (invisible)
4. Wait time is too short (changes too fast to see)

**Solutions:**
- Verify part name matches exactly: `print(workspace:FindFirstChild("ColorPart"))`
- Check initial color: `print(part.Color)`
- Increase wait time: Change `task.wait(0.1)` to `task.wait(1)`
- Make transparency visible: `part.Transparency = 0`

---

### Issue: Script Behaves Erratically

**Symptom:** Color changes random timing, sometimes skips colors, stutters

**Causes:**
1. Multiple scripts running same code
2. Rojo connected while file is being edited
3. frame rate varies (computer performing other tasks)

**Solutions:**
- Only run ONE instance of the script
- Check ServerScriptService - is script duplicated?
- Disconnect Rojo, edit, reconnect
- Use `delta time` for frame-independent behavior (see Performance Tips)

---

### Issue: "Index out of bounds" Error

**Symptom:**
```
attempt to index nil with 'nil'
```

**Cause:** Usually happens with array indexing errors in modulo operations

**Solution:**
```lua
-- ❌ Can result in index 0 (doesn't exist in Lua)
local nextIndex = (i + 1) % #colors

-- ✅ Always 1 to #colors
local nextIndex = i % #colors + 1
```

---

## Common Mistakes

### Mistake 1: Forgetting task.wait()

```lua
-- ❌ FREEZES STUDIO
while true do
    part.Color = getRandomColor()
end
```

**Always include a wait in infinite loops!**

---

### Mistake 2: Waiting Inside Inner Loop

```lua
-- ❌ Waits 7 seconds total per cycle (1s × 7 colors)
while true do
    for i, color in ipairs(colors) do
        part.Color = color
    end
    task.wait(1)  -- Only waits once after all 7 colors!
end

-- ✅ Waits between each color
while true do
    for i, color in ipairs(colors) do
        part.Color = color
        task.wait(1)  -- Waits after EACH color
    end
end
```

---

### Mistake 3: Not Anchoring the Part

```lua
-- Part falls through world while changing colors!
```

**Always anchor parts you're manipulating!**

---

### Mistake 4: Using wait(0)

```lua
-- ❌ wait(0) is NOT zero time - it yields one frame
while true do
    part.Color = getRandomColor()
    wait(0)  -- Actually waits ~0.017 seconds
end
```

**Pro insight:** `wait(0)` or `task.wait()` (no argument) yields for the next frame - minimum ~0.017s at 60 FPS.

---

### Mistake 5: Modulo Confusion

```lua
-- ❌ Index out of bounds
local nextIndex = (i + 1) % #colors  -- Can be 0!
local color = colors[nextIndex]  -- ERROR if 0

-- ✅ Correct
local nextIndex = i % #colors + 1  -- Always 1 to #colors
```

**Lua arrays start at 1, not 0!**

---

## Extensions & Variations

### Extension 1: Color Cycling with Fade-In/Fade-Out

Gradually fade to transparent between colors:
```lua
local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 0, 255)
}

while true do
    for i, color in ipairs(colors) do
        -- Fade in
        for t = 0, 1, 0.1 do
            part.Color = color
            part.Transparency = 1 - t
            task.wait(0.05)
        end

        task.wait(1)  -- Hold color

        -- Fade out
        for t = 0, 1, 0.1 do
            part.Transparency = t
            task.wait(0.05)
        end
    end
end
```

**Use case:** Smoother transitions, fade effects, disappearing objects.

---

### Extension 2: Speed Control via Humanoid Health

Change color cycle speed based on player health:
```lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local humanoid = player.Character:WaitForChild("Humanoid")
local part = workspace:WaitForChild("ColorPart")

local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 0, 255)
}

while true do
    local healthPercent = humanoid.Health / humanoid.MaxHealth
    local baseWait = 1
    local adjustedWait = baseWait * (1 - healthPercent)  -- Faster when hurt

    for i, color in ipairs(colors) do
        part.Color = color
        task.wait(adjustedWait)
    end
end
```

**Use case:** Status indicators, dynamic responses to game state.

---

### Variation 1: Color Tweening with TweenService

Instead of instant color changes, smooth transitions:
```lua
local TweenService = game:GetService("TweenService")
local part = workspace:WaitForChild("ColorPart")

local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 0, 255)
}

local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

while true do
    for i, color in ipairs(colors) do
        local tween = TweenService:Create(part, tweenInfo, {Color = color})
        tween:Play()
        tween.Completed:Wait()
    end
end
```

**Use case:** Smooth color transitions, cinematic effects.

---

### Variation 2: Size Pulsing with Color

Combine size changes with color cycle:
```lua
while true do
    for i, color in ipairs(colors) do
        part.Color = color

        -- Pulse effect
        for size = 5, 8, 0.5 do
            part.Size = Vector3.new(size, size, size)
            task.wait(0.05)
        end

        for size = 8, 5, -0.5 do
            part.Size = Vector3.new(size, size, size)
            task.wait(0.05)
        end
    end
end
```

**Use case:** Breathing animations, heartbeat effects, visual emphasis.

---

## Performance Tips

### Tip 1: Optimize Loop Frequency

**Too frequent (wastes CPU):**
```lua
while true do
    part.Color = getRandomColor()
    task.wait(0.001)  -- 1000 times per second!
end
```

**Appropriate frequency:**
```lua
while true do
    part.Color = getRandomColor()
    task.wait(0.5)  -- 2 times per second
    -- Colors invisible at monitor refresh anyway
end
```

**Impact:** Reduce unnecessary updates. Eyes can't see faster than 60 Hz!

---

### Tip 2: Use Arrays Instead of Generating Values

**Slow (generates random values per cycle):**
```lua
while true do
    part.Color = Color3.fromRGB(
        math.random(0, 255),
        math.random(0, 255),
        math.random(0, 255)
    )
    task.wait(1)
end
```

**Fast (pre-generated array):**
```lua
local colors = {}
for i = 1, 50 do
    table.insert(colors, Color3.fromRGB(
        math.random(0, 255),
        math.random(0, 255),
        math.random(0, 255)
    ))
end

while true do
    part.Color = colors[math.random(#colors)]
    task.wait(1)
end
```

**Impact:** Pre-generating eliminates per-cycle overhead.

---

### Tip 3: Single Loop vs. Multiple Scripts

**Slower (3 separate infinite loops):**
```lua
-- Script 1
while true do
    part1.Color = color1
    task.wait(1)
end

-- Script 2
while true do
    part2.Color = color2
    task.wait(1)
end

-- Script 3
while true do
    part3.Color = color3
    task.wait(1)
end
-- Three independent loops, all competing for resources
```

**Faster (one loop updating all):**
```lua
local parts = {part1, part2, part3}
local colors = {color1, color2, color3}

while true do
    for i, part in ipairs(parts) do
        part.Color = colors[i]
    end
    task.wait(1)
end
```

**Impact:** One loop beats three loops - better CPU scheduling, easier to manage.

---

### Tip 4: Use Heartbeat for Continuous Motion

**Less efficient (manual wait timing):**
```lua
while true do
    part.Color = getNextColor()
    task.wait(0.016)  -- Approximate 60 FPS
end
```

**More efficient (game loop integration):**
```lua
local RunService = game:GetService("RunService")
local frameCount = 0

RunService.Heartbeat:Connect(function()
    frameCount = frameCount + 1
    if frameCount % 60 == 0 then  -- Every 60 frames = 1 second at 60 FPS
        part.Color = getNextColor()
    end
end)
```

**Impact:** Heartbeat syncs with game rendering - smoother and more efficient!

---

## What You Learned

By completing this example, you now know:

- ✅ How to create infinite loops with `while true do`
- ✅ Why `task.wait()` is critical (prevents freezing)
- ✅ How to use `math.random()` for randomization
- ✅ What linear interpolation (Lerp) is and how to use it
- ✅ How to create smooth color transitions
- ✅ The game loop pattern
- ✅ Performance considerations for loops
- ✅ How to cycle through arrays with modulo

---

## Professional Insights

### 1. The Update Loop Pattern

**This is THE fundamental game development pattern:**

```lua
-- Initialization (once)
local gameState = initializeGame()

-- Game loop (forever)
while gameState.isRunning do
    handleInput()
    updateGameLogic()
    renderGraphics()
    task.wait(1/60)  -- 60 FPS
end

-- Cleanup (once)
cleanup()
```

**Every game engine works this way:** Unity, Unreal, Godot, custom engines - all use update loops.

---

### 2. Frame-Independent Updates

**Problem:** Different computers run at different FPS.

**Solution:** Use delta time:

```lua
local hue = 0

RunService.Heartbeat:Connect(function(deltaTime)
    hue = hue + deltaTime * 0.1  -- Scale by time, not frames

    if hue > 1 then
        hue = 0
    end

    part.Color = Color3.fromHSV(hue, 1, 1)
end)
```

**Why:** This runs at the same speed on 60 FPS and 30 FPS computers.

**Pro term:** This is **frame-rate independent** or **time-based** animation.

---

### 3. State Machines

Loops often implement **state machines** - systems that have different states:

```lua
local state = "red"

while true do
    if state == "red" then
        part.Color = Color3.new(1, 0, 0)
        task.wait(3)
        state = "yellow"

    elseif state == "yellow" then
        part.Color = Color3.new(1, 1, 0)
        task.wait(1)
        state = "green"

    elseif state == "green" then
        part.Color = Color3.new(0, 1, 0)
        task.wait(3)
        state = "red"
    end
end
```

**Pro use cases:** AI behavior (patrol, chase, attack), game modes (waiting, playing, ending), animation states.

---

### 4. Coroutines for Advanced Control

For complex animations, use coroutines (advanced):

```lua
local function fadeColor(part, targetColor, duration)
    local startColor = part.Color
    local elapsed = 0

    while elapsed < duration do
        elapsed = elapsed + task.wait()
        local alpha = elapsed / duration
        part.Color = startColor:Lerp(targetColor, alpha)
    end
end

-- Usage
task.spawn(function()
    fadeColor(part, Color3.new(1, 0, 0), 2)  -- Fade to red over 2 seconds
end)
```

**Pro term:** This is a **tween** - time-based interpolation.

---

## Next Steps

**→ [Example 4: Simple Door](../04-simple-door/)** - Learn event-driven programming!

You've mastered loops and timing. Next, you'll learn how to respond to player actions with events - touching, clicking, colliding. This is where games become interactive!
