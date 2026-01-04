# Example 2: Part Manipulator

**Difficulty:** Beginner

**Time:** 20-30 minutes

**What you'll learn:**
- Accessing parts in the workspace
- Changing part properties (Color, Size, Position, Material, Transparency)
- Using `WaitForChild()` safely
- Understanding Roblox's coordinate system (Vector3 basics)
- Color3 for colors
- The difference between `FindFirstChild()` and `WaitForChild()`

---

## Concept: Manipulating Instance Properties

**What pros call it:** "Instance property manipulation" or "runtime object modification"

**What it actually means:** Changing how objects look and behave using code, while the game is running.

**Real-world comparison:**

Think of a part like a physical object:
- **Color** = Paint it a different color
- **Size** = Make it bigger or smaller
- **Position** = Move it to a different location
- **Material** = Change from wood to metal to glass
- **Transparency** = Make it see-through

Instead of clicking and changing these in Studio, you write code to do it automatically!

**Why it matters:** 99% of games manipulate parts with code. Platforms that move, doors that open, effects that appear - all done by changing properties.

---

## What We're Building

A script that finds a part in the workspace and dramatically transforms it:
1. Changes its color
2. Resizes it
3. Moves it to a new position
4. Changes its material
5. Makes it semi-transparent
6. Demonstrates different ways to do this safely

**Goal:** Understand how to safely access and modify game objects from code.

---

## Step 1: Create the Part in Studio

Before writing code, you need a part to manipulate!

### In Roblox Studio:

1. Insert a Part into Workspace:
   - Home tab → Part (or press Ctrl+D)

2. Name it **"MyPart"** (exact spelling, capitalization matters!):
   - Select the part
   - In Properties panel, change Name to "MyPart"

3. Position it somewhere visible:
   - Use the Move tool (Ctrl+2) to position it where you can see it
   - Suggested position: `0, 5, 0` (center of baseplate, 5 studs up)

4. Make sure it's **Anchored**:
   - In Properties, check "Anchored" (so it doesn't fall)

**Pro tip:** When testing code that modifies parts, always use anchored parts so they don't fall through the world!

---

## Step 2: Understanding the Code

### The Complete Script

We'll build this incrementally, but here's the full script:

```lua
-- Script to demonstrate part property manipulation
print("🔧 Part Manipulator starting...")

-- Step 1: Safely access the part
local workspace = game:GetService("Workspace")
local part = workspace:WaitForChild("MyPart")

print("✅ Found part:", part.Name)

-- Step 2: Read current properties
print("📊 Original Properties:")
print("  Color:", part.Color)
print("  Size:", part.Size)
print("  Position:", part.Position)
print("  Material:", part.Material)
print("  Transparency:", part.Transparency)

-- Wait a moment so you can see the original
task.wait(2)

-- Step 3: Change color
print("🎨 Changing color to red...")
part.Color = Color3.new(1, 0, 0)  -- RGB: Red=1, Green=0, Blue=0
task.wait(1)

-- Step 4: Change size
print("📏 Making it bigger...")
part.Size = Vector3.new(10, 10, 10)  -- 10x10x10 studs
task.wait(1)

-- Step 5: Change position
print("📍 Moving it up...")
part.Position = Vector3.new(0, 20, 0)  -- Move to Y=20
task.wait(1)

-- Step 6: Change material
print("✨ Changing material to neon...")
part.Material = Enum.Material.Neon
task.wait(1)

-- Step 7: Change transparency
print("👻 Making it semi-transparent...")
part.Transparency = 0.5  -- 0 = opaque, 1 = invisible
task.wait(1)

-- Step 8: Do it all at once!
print("🎯 Transforming completely...")
part.Color = Color3.fromRGB(0, 255, 0)  -- Green (using RGB 0-255)
part.Size = Vector3.new(5, 15, 5)
part.Position = Vector3.new(10, 10, 10)
part.Material = Enum.Material.Glass
part.Transparency = 0.7

print("✅ Part manipulation complete!")
```

---

## Step 3: Breaking Down Each Concept

### Concept 1: Safely Accessing the Part

```lua
local workspace = game:GetService("Workspace")
local part = workspace:WaitForChild("MyPart")
```

**What's happening:**

1. **`game:GetService("Workspace")`** - Gets the Workspace service (standard way)
2. **`:WaitForChild("MyPart")`** - Waits for "MyPart" to exist (up to 5 seconds by default)

**Why not just `workspace.MyPart`?**

```lua
-- ❌ Risky - errors if part doesn't exist yet
local part = workspace.MyPart

-- ❌ Also risky - errors if part never exists
local part = workspace:FindFirstChild("MyPart")
print(part.Color)  -- ERROR if part is nil

-- ✅ Safe - waits for it to load
local part = workspace:WaitForChild("MyPart")

-- ✅ Also safe - checks if it exists first
local part = workspace:FindFirstChild("MyPart")
if part then
    print(part.Color)
else
    print("Part not found!")
end
```

**Pro term:** `:WaitForChild()` is called a **blocking function** - it pauses the script until the part loads or times out.

**When to use each:**

| Method | When to Use | What Happens if Missing |
|--------|-------------|------------------------|
| `workspace.MyPart` | Never (unsafe) | Error immediately |
| `:FindFirstChild()` | When part might not exist | Returns nil |
| `:WaitForChild()` | When part should exist, might load late | Waits 5 sec, then errors |

---

### Concept 2: Color3 (Colors in Roblox)

**What pros call it:** "Color3 data type"

**What it is:** How Roblox represents colors using Red, Green, Blue values.

#### Method 1: Color3.new() (0-1 scale)

```lua
part.Color = Color3.new(1, 0, 0)    -- Red
part.Color = Color3.new(0, 1, 0)    -- Green
part.Color = Color3.new(0, 0, 1)    -- Blue
part.Color = Color3.new(1, 1, 0)    -- Yellow (Red + Green)
part.Color = Color3.new(1, 1, 1)    -- White
part.Color = Color3.new(0, 0, 0)    -- Black
part.Color = Color3.new(0.5, 0.5, 0.5)  -- Gray

-- Parameters: Red, Green, Blue (each 0-1)
```

**Pro insight:** Each value is a percentage - `1` means 100% of that color, `0` means 0%.

---

#### Method 2: Color3.fromRGB() (0-255 scale)

```lua
part.Color = Color3.fromRGB(255, 0, 0)    -- Red
part.Color = Color3.fromRGB(0, 255, 0)    -- Green
part.Color = Color3.fromRGB(0, 0, 255)    -- Blue
part.Color = Color3.fromRGB(128, 128, 128)  -- Gray

-- Parameters: Red, Green, Blue (each 0-255)
```

**When to use:** When you have RGB values from an image editor (Photoshop, GIMP, etc.) which use 0-255.

**Conversion:** `RGB 255 = 1.0`, `RGB 128 = 0.5`, `RGB 0 = 0`

---

#### Method 3: BrickColor (Legacy)

```lua
part.BrickColor = BrickColor.new("Bright red")
part.BrickColor = BrickColor.new("Dark green")
```

**Pro tip:** Don't use BrickColor for new code - use Color3! BrickColor is limited to ~200 preset colors.

---

#### Reading Color Values

```lua
local color = part.Color
print("R:", color.R)  -- Red component (0-1)
print("G:", color.G)  -- Green component (0-1)
print("B:", color.B)  -- Blue component (0-1)

-- Convert to RGB 0-255
print("R:", color.R * 255)
print("G:", color.G * 255)
print("B:", color.B * 255)
```

---

### Concept 3: Vector3 (3D Positions and Sizes)

**What pros call it:** "Vector3 data type" or "3D vector"

**What it is:** A point in 3D space with X, Y, Z coordinates.

**Used for:**
- **Position** - Where the part is
- **Size** - How big the part is

#### Understanding Coordinates

```
       Y (Up/Down)
       |
       |
       |_________ X (Right/Left)
      /
     /
    Z (Forward/Back)
```

**Roblox coordinate system:**
- **X** = Left (-) to Right (+)
- **Y** = Down (-) to Up (+)
- **Z** = Forward (-) to Back (+)

---

#### Creating Vector3s

```lua
-- Syntax: Vector3.new(X, Y, Z)

part.Position = Vector3.new(0, 5, 0)    -- Center, 5 studs up
part.Position = Vector3.new(10, 0, 0)   -- 10 studs to the right
part.Position = Vector3.new(0, 0, -20)  -- 20 studs forward

-- Size works the same way
part.Size = Vector3.new(4, 1, 2)  -- 4 wide, 1 tall, 2 deep
```

---

#### Reading Vector3 Values

```lua
local pos = part.Position
print("X:", pos.X)
print("Y:", pos.Y)
print("Z:", pos.Z)

-- Or all at once
print("Position:", part.Position)  -- Prints: 0, 5, 0
```

---

#### Vector3 Math

You can do math with Vector3s!

```lua
-- Move part 10 studs up
part.Position = part.Position + Vector3.new(0, 10, 0)

-- Double the size
part.Size = part.Size * 2

-- Combine positions
local offset = Vector3.new(5, 0, 5)
part.Position = workspace.Baseplate.Position + offset
```

**Pro insight:** This is called **vector arithmetic** - fundamental to 3D game development!

---

### Concept 4: Materials

**What pros call it:** "Material enum" or "surface material"

**What it is:** How the part looks (plastic, metal, wood, etc.)

**Common materials:**

```lua
part.Material = Enum.Material.Plastic   -- Default
part.Material = Enum.Material.Wood
part.Material = Enum.Material.Metal
part.Material = Enum.Material.Grass
part.Material = Enum.Material.Neon      -- Glows!
part.Material = Enum.Material.Glass     -- See-through effect
part.Material = Enum.Material.Ice
part.Material = Enum.Material.Marble
part.Material = Enum.Material.Granite
part.Material = Enum.Material.Fabric
```

**Pro tip:** Materials affect how light reflects. Neon glows, Glass is reflective, etc.

**See all materials:** https://create.roblox.com/docs/reference/engine/enums/Material

---

### Concept 5: Transparency

**What it is:** How see-through the part is.

```lua
part.Transparency = 0    -- Fully opaque (solid)
part.Transparency = 0.5  -- Half transparent
part.Transparency = 1    -- Fully invisible
```

**Range:** 0 (solid) to 1 (invisible)

**Pro insight:** Transparency of 1 makes it invisible but it's still there! Collisions still work.

**Common use cases:**
- Invisible walls/barriers: `Transparency = 1, CanCollide = true`
- Ghost effects: `Transparency = 0.7`
- Fade in/out animations: Gradually change transparency

---

## Step 4: Build and Test

### Create the Project

1. In the `02-part-manipulator` folder, create the file structure shown
2. Copy the code into `src/server/PartManipulator.server.lua`
3. Create the `default.project.json` (see below)

### Rojo Configuration

```json
{
  "name": "02-part-manipulator",
  "tree": {
    "$className": "DataModel",
    "ServerScriptService": {
      "$className": "ServerScriptService",
      "PartManipulator": {
        "$path": "src/server/PartManipulator.server.lua"
      }
    }
  }
}
```

---

### Run It!

1. **Create the part in Studio** (see Step 1 above)
2. **Start Rojo:** `rojo serve`
3. **Connect Studio:** Plugins → Rojo → Connect
4. **Open Output:** Press F9
5. **Watch the magic:** The part should transform in stages!

**What you'll see:**
- Console logs showing each step
- Part changes color to red
- Part grows larger
- Part moves up
- Part becomes neon and semi-transparent
- Final transformation to green glass

---

## Step 5: Experiment!

Now that it works, try these challenges:

### Challenge 1: Rainbow Cycle

Make the part cycle through rainbow colors:

```lua
local colors = {
    Color3.fromRGB(255, 0, 0),    -- Red
    Color3.fromRGB(255, 127, 0),  -- Orange
    Color3.fromRGB(255, 255, 0),  -- Yellow
    Color3.fromRGB(0, 255, 0),    -- Green
    Color3.fromRGB(0, 0, 255),    -- Blue
    Color3.fromRGB(75, 0, 130),   -- Indigo
    Color3.fromRGB(148, 0, 211),  -- Violet
}

while true do
    for i, color in ipairs(colors) do
        part.Color = color
        task.wait(0.5)
    end
end
```

**What you're learning:** Loops and arrays to create animations.

---

### Challenge 2: Grow and Shrink

Make the part pulse (grow and shrink repeatedly):

```lua
while true do
    -- Grow
    for size = 4, 10, 0.5 do
        part.Size = Vector3.new(size, size, size)
        task.wait(0.1)
    end

    -- Shrink
    for size = 10, 4, -0.5 do
        part.Size = Vector3.new(size, size, size)
        task.wait(0.1)
    end
end
```

**What you're learning:** Numeric for loops to create smooth transitions.

---

### Challenge 3: Orbit Around Center

Make the part orbit around the origin:

```lua
local angle = 0
local radius = 10

while true do
    local x = math.cos(angle) * radius
    local z = math.sin(angle) * radius
    part.Position = Vector3.new(x, 5, z)

    angle = angle + 0.1
    task.wait(0.05)
end
```

**What you're learning:** Trigonometry (sine/cosine) for circular motion.

**Pro insight:** This is how orbiting objects, circular platforms, and clock hands work in games!

---

### Challenge 4: Random Properties

Randomize all properties continuously:

```lua
while true do
    part.Color = Color3.new(math.random(), math.random(), math.random())
    part.Size = Vector3.new(
        math.random(2, 10),
        math.random(2, 10),
        math.random(2, 10)
    )
    part.Position = Vector3.new(
        math.random(-20, 20),
        math.random(5, 15),
        math.random(-20, 20)
    )
    part.Transparency = math.random()  -- 0 to 1

    task.wait(1)
end
```

**What you're learning:** `math.random()` for procedural generation.

**Pro term:** Randomizing properties is called **procedural generation** - creating variety through code, not manual design.

---

### Challenge 5: Copy and Modify

Create multiple parts programmatically:

```lua
for i = 1, 10 do
    local newPart = part:Clone()
    newPart.Position = Vector3.new(i * 5, 5, 0)
    newPart.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    newPart.Parent = workspace
    task.wait(0.2)
end
```

**What you're learning:** `:Clone()` to duplicate objects.

**Pro pattern:** Cloning templates is how pros spawn enemies, coins, bullets, etc.

---

## Troubleshooting Guide

### Issue: Part Not Found Error

**Symptom:**
```
[Workspace].PartManipulator: attempt to index nil
```

**Causes:**
1. Part name doesn't match exactly (capitals matter!)
2. Part doesn't exist yet when script runs
3. Part is in wrong location in workspace

**Solutions:**
- Check Studio: Is part named exactly "MyPart"? (Case-sensitive!)
- Use `:WaitForChild()` instead of direct access: `workspace:WaitForChild("MyPart")`
- Make sure part is directly in Workspace, not in a folder
- Add debug print: `print(workspace:FindFirstChild("MyPart"))` to verify existence

---

### Issue: Part Changes Don't Appear

**Symptom:** You run the script but the part doesn't change color/size/position

**Causes:**
1. Script not running (check Output, no messages?)
2. Color is same as current color (no visible change)
3. Part is behind camera view
4. Transparency = 1 (invisible!)

**Solutions:**
- Check Output (F9) for error messages
- Try a VERY different color (red `Color3.new(1, 0, 0)`) to see change
- Add `print("Changing color...")` before modifications
- Make sure `part.Transparency < 1` (not fully invisible)

---

### Issue: Part Falls Through World

**Symptom:** Part drops immediately and disappears below the baseplate

**Causes:**
1. Part not anchored
2. Gravity affecting unanchored part

**Solutions:**
- In Studio Properties: Check "Anchored" is enabled
- In code: `part.Anchored = true` before moving
- Use CFrame instead of Position for physics-aware movement

---

### Issue: RGB Color Values Are Wrong

**Symptom:** Colors look wrong or extremely bright

**Common mistake:**
```lua
-- WRONG - Color3.new expects 0-1, not 0-255!
part.Color = Color3.new(255, 0, 0)  -- Way too bright!

-- RIGHT - Use either:
part.Color = Color3.fromRGB(255, 0, 0)  -- 0-255 scale
part.Color = Color3.new(1, 0, 0)        -- 0-1 scale
```

**Solutions:**
- Use `Color3.fromRGB()` when copying from image editors
- Use `Color3.new()` when working with normalized values (0-1)
- Test one color at a time to verify

---

## Common Mistakes

### Mistake 1: Spelling or Capitalization

```lua
-- ❌ WRONG - case matters!
local part = workspace:WaitForChild("mypart")  -- Won't find "MyPart"

-- ✅ RIGHT
local part = workspace:WaitForChild("MyPart")
```

**Solution:** Exact spelling and capitalization!

---

### Mistake 2: Modifying Unanchored Parts

```lua
-- ❌ Part falls through world
local part = Instance.new("Part")
part.Position = Vector3.new(0, 50, 0)
part.Parent = workspace
-- Falls immediately due to gravity!

-- ✅ Anchor it first
local part = Instance.new("Part")
part.Anchored = true
part.Position = Vector3.new(0, 50, 0)
part.Parent = workspace
```

**Solution:** Set `Anchored = true` or use `CFrame` instead (explained later).

---

### Mistake 3: Part Not Found

```lua
-- ❌ Errors if part doesn't exist
local part = workspace.MyPart
part.Color = Color3.new(1, 0, 0)  -- ERROR: attempt to index nil

-- ✅ Check if it exists
local part = workspace:FindFirstChild("MyPart")
if part then
    part.Color = Color3.new(1, 0, 0)
else
    warn("Part 'MyPart' not found!")
end
```

---

### Mistake 4: RGB Values Wrong

```lua
-- ❌ WRONG - Color3.new uses 0-1, not 0-255
part.Color = Color3.new(255, 0, 0)  -- This is way overblown!

-- ✅ RIGHT - Use fromRGB for 0-255
part.Color = Color3.fromRGB(255, 0, 0)

-- ✅ OR - Use 0-1 scale
part.Color = Color3.new(1, 0, 0)
```

---

### Mistake 5: Transparency Confusion

```lua
-- ❌ This makes it invisible (1 = fully transparent)
part.Transparency = 100  -- Clamped to 1, invisible

-- ✅ Transparency is 0-1
part.Transparency = 0.5  -- Half transparent
```

---

## What You Learned

By completing this example, you now know:

- ✅ How to safely access parts with `:WaitForChild()` and `:FindFirstChild()`
- ✅ How to change part colors using `Color3.new()` and `Color3.fromRGB()`
- ✅ How to work with `Vector3` for positions and sizes
- ✅ How to change materials and transparency
- ✅ How to read and modify part properties
- ✅ The difference between blocking and non-blocking access methods
- ✅ How to use `task.wait()` to create timed sequences

---

## Professional Insights

### 1. Always Use WaitForChild for Critical Parts

**Pro pattern:**

```lua
-- Critical parts that MUST exist
local spawnPoint = workspace:WaitForChild("SpawnPoint")

-- Optional parts
local secretArea = workspace:FindFirstChild("SecretArea")
if secretArea then
    -- Secret area exists
end
```

---

### 2. Store Original Values for Resetting

```lua
-- Save original state
local originalColor = part.Color
local originalSize = part.Size
local originalPosition = part.Position

-- Modify
part.Color = Color3.new(1, 0, 0)
part.Size = Vector3.new(10, 10, 10)

-- Reset later
task.wait(5)
part.Color = originalColor
part.Size = originalSize
part.Position = originalPosition
```

**Pro use case:** Respawning objects to their original state.

---

### 3. Use Constants for Repeated Values

```lua
-- ❌ Magic numbers scattered everywhere
part.Position = Vector3.new(0, 5, 0)
otherPart.Position = Vector3.new(0, 5, 10)

-- ✅ Named constants
local SPAWN_HEIGHT = 5
local ORIGIN = Vector3.new(0, SPAWN_HEIGHT, 0)

part.Position = ORIGIN
otherPart.Position = ORIGIN + Vector3.new(0, 0, 10)
```

**Pro term:** Hardcoded values are called **magic numbers** - avoid them! Use named constants.

---

### 4. Batch Property Changes

**When changing multiple properties, Roblox replicates each change separately:**

```lua
-- ❌ Slower - 5 separate replications
part.Color = Color3.new(1, 0, 0)
part.Size = Vector3.new(10, 10, 10)
part.Position = Vector3.new(0, 20, 0)
part.Material = Enum.Material.Neon
part.Transparency = 0.5
```

**For simple cases, this is fine. For optimized code:**

```lua
-- ✅ Faster - batch changes (advanced)
-- We'll learn this pattern later with attributes or single-frame updates
```

**Pro insight:** For this beginner example, don't worry about optimization. But know that every property change is network traffic in a multiplayer game!

---

## Extensions & Variations

### Extension 1: Dynamic Size Based on Distance

Make part size increase/decrease based on distance from origin:
```lua
local part = workspace:WaitForChild("MyPart")

while true do
    local distance = part.Position.Magnitude  -- Distance from origin
    local newSize = distance / 2

    part.Size = Vector3.new(newSize, newSize, newSize)
    print("Distance:", distance, "Size:", newSize)

    task.wait(0.5)
end
```

**Use case:** Dynamic difficulty, responsive puzzles, visual feedback systems.

---

### Extension 2: Color Gradient Based on Height

Change color intensity based on Y position:
```lua
local part = workspace:WaitForChild("MyPart")
local minHeight = 0
local maxHeight = 50

while true do
    local normalizedHeight = (part.Position.Y - minHeight) / (maxHeight - minHeight)
    normalizedHeight = math.clamp(normalizedHeight, 0, 1)

    -- Blue at bottom, red at top
    part.Color = Color3.new(normalizedHeight, 0, 1 - normalizedHeight)
    task.wait(0.1)
end
```

**Use case:** Visual indicators, height-based feedback, heatmaps.

---

### Variation 1: Material Cycling

Cycle through different materials automatically:
```lua
local part = workspace:WaitForChild("MyPart")
local materials = {
    Enum.Material.Plastic,
    Enum.Material.Metal,
    Enum.Material.Neon,
    Enum.Material.Glass,
    Enum.Material.Wood
}

local index = 1
while true do
    part.Material = materials[index]
    print("Material:", tostring(part.Material))

    index = index % #materials + 1
    task.wait(2)
end
```

**Use case:** Visual effects, material transitions, debugging.

---

### Variation 2: Smooth Position Transitions

Gradually move to target position:
```lua
local part = workspace:WaitForChild("MyPart")
local targetPos = Vector3.new(20, 10, 0)
local speed = 5  -- studs per second

while true do
    local direction = (targetPos - part.Position).Unit
    part.Position = part.Position + (direction * speed * 0.016)

    -- Stop when close enough
    if (targetPos - part.Position).Magnitude < 1 then
        part.Position = targetPos
        break
    end

    task.wait()
end
```

**Use case:** Smooth animations, physics-independent movement, tweening alternatives.

---

## Performance Tips

### Tip 1: Batch Property Changes

**Slower approach (5 separate updates):**
```lua
part.Color = Color3.new(1, 0, 0)
task.wait(0.1)
part.Size = Vector3.new(10, 10, 10)
task.wait(0.1)
part.Position = Vector3.new(0, 20, 0)
task.wait(0.1)
part.Material = Enum.Material.Neon
task.wait(0.1)
part.Transparency = 0.5
```

**Faster approach (changes at once):**
```lua
part.Color = Color3.new(1, 0, 0)
part.Size = Vector3.new(10, 10, 10)
part.Position = Vector3.new(0, 20, 0)
part.Material = Enum.Material.Neon
part.Transparency = 0.5
-- All replicate in one network frame!
```

**Impact:** Less network traffic, smoother appearance, reduced server load.

---

### Tip 2: Use References Instead of Repeated Searches

**Slow (searches workspace every time):**
```lua
while true do
    workspace:FindFirstChild("MyPart").Color = Color3.new(math.random(), math.random(), math.random())
    task.wait(1)
end
```

**Fast (finds once, stores reference):**
```lua
local part = workspace:WaitForChild("MyPart")

while true do
    part.Color = Color3.new(math.random(), math.random(), math.random())
    task.wait(1)
end
```

**Impact:** Each search scans the entire workspace hierarchy. References are instant!

---

### Tip 3: Cloning is Fast, Creating is Slow

**Slow (creates 100 parts from scratch):**
```lua
for i = 1, 100 do
    local newPart = Instance.new("Part")
    newPart.Size = Vector3.new(4, 1, 4)
    newPart.Position = Vector3.new(i * 5, 5, 0)
    newPart.Parent = workspace
end
```

**Faster (clones one template):**
```lua
local template = Instance.new("Part")
template.Size = Vector3.new(4, 1, 4)

for i = 1, 100 do
    local newPart = template:Clone()
    newPart.Position = Vector3.new(i * 5, 5, 0)
    newPart.Parent = workspace
end
```

**Impact:** Instance.new() has overhead. Cloning is optimized!

---

### Tip 4: Avoid Excessive Color Conversions

**Inefficient (converts every frame):**
```lua
while true do
    local r = math.random(0, 255)
    local g = math.random(0, 255)
    local b = math.random(0, 255)
    part.Color = Color3.fromRGB(r, g, b)  -- Converts every time
    task.wait(0.1)
end
```

**More efficient (convert when needed):**
```lua
local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 0, 255)
}

while true do
    part.Color = colors[math.random(#colors)]  -- Use pre-converted
    task.wait(0.1)
end
```

**Impact:** Pre-converting colors eliminates per-frame conversion overhead.

---

## Next Steps

**→ [Example 3: Color Cycler](../03-color-cycler/)** - Learn loops and timing!

You've mastered basic property manipulation. Next, you'll learn how to create continuous animations with loops!
