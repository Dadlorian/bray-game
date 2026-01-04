# 👋 Welcome to Your First Week, Bray!

**Hey Bray! Welcome to the amazing world of game development!**

This is your personal space to start learning how to create your own Roblox games. It's going to be a super fun journey, and it all starts right here.

Think of this first week as getting your superpowers. You'll learn the basic ingredients that all games are made of. Don't worry if some of it seems tricky at first—that's totally normal! Every pro developer started right where you are.

**Your mission, should you choose to accept it:**
- Follow the guides below.
- **Don't be afraid to experiment!** Change the code, break things, and see what happens. That's the best way to learn.
- **Most importantly, have fun!**

Let's build something awesome!

---

# 01-FUNDAMENTALS - Core Roblox Concepts

**Time to complete:** 1-2 weeks

**What you'll learn:** The foundation of Roblox game development - how games work, basic Lua programming, and the client-server model.

**What you'll build:** 5 small example projects that teach core concepts

---

## Learning Objectives

By the end of this section, you'll be able to:

- ✅ Explain how Roblox games work (client-server architecture)
- ✅ Write basic Lua code (variables, functions, loops, conditionals)
- ✅ Manipulate parts (change position, size, color, etc.)
- ✅ Use the Roblox API to interact with the game world
- ✅ Understand the difference between client and server scripts
- ✅ Use TweenService for smooth animations

---

## Concepts Covered

Before diving into the examples, read these concept guides:

### 1. [How Roblox Works](./concepts/how-roblox-works.md)
**What you'll learn:**
- The workspace and object hierarchy
- What parts, models, and scripts are
- How the game engine runs your code
- The difference between Studio and the actual game

**Pro terms:** Workspace, Instance, DataModel, hierarchy, parent-child relationships

**Time:** 15-20 minutes

---

### 2. [Lua Basics](./concepts/lua-basics.md)
**What you'll learn:**
- Variables and data types (strings, numbers, booleans, tables)
- Functions and how to call them
- Loops (for, while) and conditionals (if/else)
- Tables (Lua's version of arrays and dictionaries)

**Pro terms:** Variable declaration, function signature, control flow, iteration, key-value pairs

**Time:** 30-40 minutes

---

### 3. [Client-Server Model](./concepts/client-server-model.md)
**What you'll learn:**
- Why games have clients and servers
- What runs on the client vs. server
- How to prevent exploits
- When to use LocalScript vs. Script

**Pro terms:** Client-server architecture, server-authoritative, replication, exploit prevention

**Time:** 20-30 minutes

---

## Example Projects

Build these in order! Each one teaches a specific skill.

### Example 1: [Hello World](./examples/01-hello-world/)
**Difficulty:** Beginner

**What it teaches:**
- Your first script
- Using `print()` to output messages
- Understanding the Output window
- Server vs. client scripts

**Time:** 15 minutes

**Pro skills:** Script execution, console output, debugging basics

---

### Example 2: [Part Manipulator](./examples/02-part-manipulator/)
**Difficulty:** Beginner

**What it teaches:**
- Accessing parts in the workspace
- Changing properties (Color, Size, Position)
- Using `WaitForChild()` safely
- Roblox's coordinate system (CFrame basics)

**Time:** 20-30 minutes

**Pro skills:** Object property manipulation, safe instance access, 3D coordinate systems

---

### Example 3: [Color Cycler](./examples/03-color-cycler/)
**Difficulty:** Beginner

**What it teaches:**
- Loops (`while true do`)
- `wait()` function for timing
- Randomization (`math.random`)
- Color3 for colors

**Time:** 20-30 minutes

**Pro skills:** Game loops, frame-independent timing, random number generation

---

### Example 4: [Simple Door](./examples/04-simple-door/)
**Difficulty:** Intermediate

**What it teaches:**
- Touch events (`.Touched`)
- Character detection (finding the player)
- Debounce pattern (preventing spam)
- TweenService for smooth animations

**Time:** 45-60 minutes

**Pro skills:** Event-driven programming, debouncing, animation tweening

---

### Example 5: [Moving Platform](./examples/05-moving-platform/)
**Difficulty:** Intermediate

**What it teaches:**
- CFrame manipulation (position and rotation)
- TweenService advanced usage
- Looping animations
- Anchored vs. unanchored parts

**Time:** 45-60 minutes

**Pro skills:** CFrame math, interpolation, platform mechanics

---

## How to Use This Section

### Recommended Path (Complete Beginner)

1. **Read all three concept guides first** (1-2 hours)
   - Take notes on terms you don't understand
   - Re-read sections that confuse you
   - Ask questions when stuck

2. **Build Example 1: Hello World** (15 min)
   - Type all the code yourself (don't copy-paste!)
   - Experiment: change the messages, add more print statements
   - Make sure you see output in Studio

3. **Build Example 2: Part Manipulator** (30 min)
   - Understand every line before moving on
   - Try changing different properties
   - Break it intentionally to see what errors look like

4. **Build Example 3: Color Cycler** (30 min)
   - This introduces loops - a big concept!
   - Play with the timing, colors, patterns
   - Understand why we use `wait()`

5. **Build Example 4: Simple Door** (1 hour)
   - First event-driven code! Important pattern.
   - The debounce pattern is used everywhere
   - Test it thoroughly (what happens if you touch it fast?)

6. **Build Example 5: Moving Platform** (1 hour)
   - CFrame is confusing at first - that's normal!
   - TweenService makes things smooth (this is how pros do it)
   - Combine this with what you learned in door example

7. **Experiment and mix!**
   - Combine concepts: Color-changing moving platform?
   - Door that changes color when opened?
   - Moving part that prints when you touch it?

---

### Alternate Path (Have Coded Before)

If you've coded in Lua or Roblox Studio before:

1. **Skim concept guides** - just review the "pro terms"
2. **Jump to Example 4 or 5** - the interesting ones
3. **Go back if you get stuck** - maybe you missed something!

---

### Parent/Teacher Path

If you're helping someone learn:

1. **Read the concept guides yourself first**
2. **Help them set up Example 1** (make sure their workflow is smooth)
3. **Let them struggle a bit** on Examples 2-3 (learning happens here!)
4. **Step in for Example 4** (debounce is a tough concept)
5. **Celebrate Example 5 completion** - they now know the fundamentals!

---

## Success Criteria

You're ready for **02-PLAYER-MECHANICS** when you can:

- [ ] Explain the difference between a LocalScript and a Script
- [ ] Write a working while loop that doesn't crash Studio
- [ ] Use `print()` to debug your code
- [ ] Change a part's Color, Position, and Size from code
- [ ] Set up a Touched event listener
- [ ] Explain what "debounce" means and why it's needed
- [ ] Use TweenService to smoothly move a part
- [ ] Open a project in VS Code, edit code, sync to Studio, and test

---

## Common Mistakes (And How to Fix Them)

### "I don't see any output!"

**Problem:** You're using a LocalScript when you should use a Script (or vice versa).

**Solution:**
- **ServerScriptService** → Use **Script** (shows output in Command Bar when testing)
- **StarterPlayer/StarterPlayerScripts** → Use **LocalScript** (shows output in Output window)

---

### "Studio froze!"

**Problem:** You have an infinite loop without a `wait()`:

```lua
-- ❌ BAD - freezes Studio
while true do
    print("Infinite spam!")
end

-- ✅ GOOD - runs forever but doesn't freeze
while true do
    print("This is fine!")
    wait(1)  -- Pauses for 1 second
end
```

**Solution:** Always include `wait()` in infinite loops!

---

### "WaitForChild timed out"

**Problem:** You're trying to access something that doesn't exist.

```lua
-- If "MyPart" doesn't exist, this errors after 5 seconds
local part = workspace:WaitForChild("MyPart")
```

**Solution:**
- Check spelling (case matters! "myPart" ≠ "MyPart")
- Make sure the part exists in workspace
- Check that the part loaded before your script ran

---

### "Attempted to index nil"

**Problem:** You tried to use something that's `nil` (doesn't exist).

```lua
local part = workspace:FindFirstChild("MyPart")  -- Returns nil if not found
print(part.Color)  -- ERROR! Can't get .Color of nil
```

**Solution:**
```lua
local part = workspace:FindFirstChild("MyPart")
if part then
    print(part.Color)  -- Only runs if part exists
else
    print("Part not found!")
end
```

---

## Resources

### Official Roblox Documentation
- [Roblox Lua Docs](https://create.roblox.com/docs)
- [API Reference](https://create.roblox.com/docs/reference/engine)

### Community Resources
- [Roblox DevForum](https://devforum.roblox.com/) - Ask questions
- [Roblox OSS Discord](https://discord.gg/roblox-oss) - Community help

### When to Ask for Help

**Try these first:**
1. Read the error message carefully (it usually tells you what's wrong!)
2. Use `print()` to debug (print variables to see their values)
3. Re-read the example code and compare to yours
4. Check spelling and capitalization

**Ask for help if:**
- You've been stuck for more than 30 minutes
- You don't understand the error message
- Something works in the example but not in your code
- You want to know "why" something works a certain way

---

## Next Steps

Once you've completed all 5 examples and checked off the success criteria:

**→ Continue to [02-PLAYER-MECHANICS](../02-PLAYER-MECHANICS/README.md)**

You'll learn how to make players interact with your game world!

---

**Pro tip:** These fundamentals are the foundation for EVERYTHING in game development. Masters of any craft always go back to the fundamentals. Even after you build 100 games, you'll still use these exact patterns every single day!

---

## Comprehensive Lua API Reference for Roblox Fundamentals

### Core Functions You'll Use Constantly

**print(value1, value2, ...)**
- Outputs text to Studio Output window
- Comma-separated multiple values
- Professional debugging tool
- Example: `print("Player HP:", humanoid.Health)`
- Performance: Minimal impact, safe to leave in development

**wait(seconds)**
- Pauses script execution for specified time
- 1 second = reasonable default for game loops
- 0.1 seconds = faster for responsive mechanics
- Must use in loops to prevent freezing
- Example: `wait(1)` pauses for 1 second

**task.wait(seconds)**
- Modern replacement for wait() (recommended)
- More precise timing (microsecond accuracy)
- Better for performance-critical code
- Equivalent to wait() for most purposes
- Example: `task.wait(0.5)` for precise half-second pause

**script (global variable)**
- Reference to the script itself
- Use to find script properties
- Example: `local parent = script.Parent`

**game (global variable)**
- Root of entire Roblox hierarchy
- Access services: `game:GetService("Players")`
- Access workspace: `game.Workspace` or `workspace`
- Access game data: `game:GetPlaceId()`

### Part and Instance Manipulation

**Instance.new(classname, parent)**
- Creates new instance in game world
- Example: `local part = Instance.new("Part", workspace)`
- Common classes: Part, Model, Folder, StringValue, NumberValue

**part.Position = Vector3.new(x, y, z)**
- Sets part location in 3D space
- Coordinates: X (left-right), Y (up-down), Z (depth)
- Example: `part.Position = Vector3.new(0, 5, 0)` moves to height 5

**part.Size = Vector3.new(x, y, z)**
- Sets width, height, depth
- Default: Vector3.new(2, 2, 2) for typical parts
- Example: `part.Size = Vector3.new(4, 1, 10)` wide platform

**part.Color = Color3.new(r, g, b)**
- RGB values 0-1 (not 0-255!)
- Example: `Color3.new(1, 0, 0)` = pure red
- Common: `Color3.fromRGB(255, 0, 0)` = pure red (easier syntax)

**part.Material = Enum.Material.COLOR_NAME**
- Changes surface appearance
- Examples: Plastic, Metal, Neon, Wood, Brick, Concrete
- Neon = bright/glowing effect

**part.Anchored = true/false**
- true = doesn't fall or move (fixed in place)
- false = affected by gravity (falls down)
- Set to true for platforms, doors, non-physics objects

**part:Destroy()**
- Completely removes part from game
- Cannot be undone without recreating
- Cleans up memory

**parent:WaitForChild(name, timeout)**
- Safely access children before they exist
- Waits up to 5 seconds by default (can customize)
- Returns nil if timeout exceeded
- Professional way to handle loading delays
- Example: `local part = workspace:WaitForChild("MyPart", 10)`

**parent:FindFirstChild(name)**
- Finds child by name if it exists
- Returns nil if not found (doesn't wait)
- Example: `local found = folder:FindFirstChild("Item")`

### Data Types You'll Work With

**strings**
- Text data: `"Hello World"`
- Concatenate with ..: `"Hello " .. "World"`
- Get length: `#"text"` = 4
- Example: `local message = "Player " .. player.Name .. " joined"`

**numbers**
- Integer: `42`, Decimal: `3.14`
- Math: `10 + 5`, `10 * 2`, `10 / 2`
- Example: `local hp = 100`, `local speed = 16.2`

**booleans**
- true or false
- Used in conditions: `if humanoid.Health > 0 then`
- Example: `local isAlive = humanoid.Health > 0`

**tables**
- Collections of data: `{1, 2, 3}` or `{name = "Bob", age = 25}`
- Access: `array[1]`, `dict.name`
- Add items: `table.insert(array, value)`
- Example: `local playerData = {name = "Alice", level = 5}`

**Vector3**
- 3D position/direction: `Vector3.new(x, y, z)`
- Math works: `vector1 + vector2`
- Get distance: `(vector1 - vector2).Magnitude`

**CFrame**
- Position AND rotation combined
- More complex than Vector3, used for precise orientation
- Example: Part position is Position, but to include rotation use CFrame

### Control Flow

**if statements**
```lua
if humanoid.Health > 0 then
    print("Alive!")
elseif humanoid.Health == 0 then
    print("Dead!")
else
    print("Invalid health")
end
```

**for loops (numeric)**
```lua
-- Count from 1 to 5
for i = 1, 5 do
    print(i)
end

-- Count with step: 1, 3, 5
for i = 1, 10, 2 do
    print(i)
end
```

**for loops (table iteration)**
```lua
local colors = {"red", "green", "blue"}
for index, color in pairs(colors) do
    print(index, color)  -- 1, "red" then 2, "green" etc
end
```

**while loops**
```lua
while humanoid.Health > 0 do
    print("Still alive!")
    wait(1)  -- ALWAYS include wait() to prevent freeze!
end
```

### Events (Reacting to Things Happening)

**part.Touched:Connect(function)**
- Fires when something touches the part
- Parameter: otherPart = what touched it
- Example: `part.Touched:Connect(function(otherPart) print(otherPart.Name) end)`

**Humanoid.Died:Connect(function)**
- Fires when character dies
- No parameters passed
- Example: `humanoid.Died:Connect(function() print("Dead!") end)`

**game.Players.PlayerAdded:Connect(function)**
- Fires when player joins game
- Parameter: player = new player
- Example: `game.Players.PlayerAdded:Connect(function(player) print(player.Name) end)`

**connection:Disconnect()**
- Stops an event from firing
- Important for cleanup when character dies
- Example: `local connection = part.Touched:Connect(...) ... connection:Disconnect()`

---

## Troubleshooting Guide for Fundamentals

### Problem: "Attempted to index nil with..."

**What it means:** You tried to access something that doesn't exist

**Common causes:**
```lua
-- ❌ BAD
local part = workspace:FindFirstChild("NonExistent")
print(part.Color)  -- ERROR! part is nil

-- ✅ GOOD
local part = workspace:FindFirstChild("NonExistent")
if part then
    print(part.Color)
else
    print("Part not found!")
end
```

**Solution:**
- Always check if something exists before using it
- Use `if variable then` before accessing properties
- Use `WaitForChild` if it's just loading slowly

---

### Problem: "Loop exceeded timeout"

**What it means:** `wait()` or loop is taking too long, script was stopped

**Common causes:**
```lua
-- ❌ BAD - infinite loop without task.wait
while true do
    print("Infinite!")
end

-- ✅ GOOD
while true do
    print("This works!")
    task.wait(1)  -- Don't forget the wait!
end
```

**Solution:** Always include `task.wait()` in loops

---

### Problem: "Can't call nil value"

**What it means:** You tried to call a function on something that's nil

**Example:**
```lua
-- ❌ BAD
local func = workspace:FindFirstChild("NotAFunction")
func()  -- ERROR! func is nil, not a function

-- ✅ GOOD
local func = workspace:FindFirstChild("NotAFunction")
if func and typeof(func) == "function" then
    func()
end
```

---

### Problem: Colors Look Wrong

**Common mistake:** Using 0-255 instead of 0-1
```lua
-- ❌ WRONG - values too large
part.Color = Color3.new(255, 0, 0)  -- Black!

-- ✅ CORRECT
part.Color = Color3.new(1, 0, 0)  -- Red!

-- ✅ ALSO CORRECT (easier)
part.Color = Color3.fromRGB(255, 0, 0)  -- Red!
```

---

## Frequently Asked Questions (FAQ)

### What's the difference between a Script and LocalScript?

**Script:**
- Runs on server
- Can't access client properties (like camera)
- Safe for game logic, security-sensitive operations
- Use in: ServerScriptService

**LocalScript:**
- Runs on each player's computer
- Can access camera, user input, local properties
- Less safe (player can modify)
- Use in: StarterPlayer scripts, GUI scripts

**Rule of thumb:** Server = trusted logic, Client = user interface

---

### Why do I get "infinite yield" warnings?

**Cause:** `WaitForChild` waiting for something that never appears

**Example:**
```lua
-- If "MissingPart" doesn't exist, waits forever
local part = workspace:WaitForChild("MissingPart")
```

**Solution:**
1. Check spelling (case-sensitive!)
2. Check the part actually exists in workspace
3. Use timeout: `workspace:WaitForChild("Part", 5)` stops after 5 seconds

---

### Can I mix LocalScript and Script code?

**Yes! Here's how:**

```lua
-- Server Script
local remoteEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
remoteEvent.Name = "PrintMessage"

remoteEvent.OnServerEvent:Connect(function(player, message)
    print(player.Name .. ": " .. message)
end)

-- LocalScript
local remoteEvent = game.ReplicatedStorage:WaitForChild("PrintMessage")
remoteEvent:FireServer("Hello from client!")
```

---

### How do I debug Lua code?

**Techniques:**
1. **Print debugging:** `print("Value:", variable)` to see values
2. **Check studio output:** View → Output in Studio shows all prints
3. **Script suspension:** F9 in Studio stops script execution for debugging

---

## Best Practices for Fundamentals

### 1. Always Use Safe Accessors

```lua
-- ❌ RISKY
local part = workspace.MyPart  -- Error if MyPart doesn't exist
print(part.Color)

-- ✅ SAFE
local part = workspace:WaitForChild("MyPart")  -- Waits for it
print(part.Color)

-- ✅ ALSO SAFE
local part = workspace:FindFirstChild("MyPart")
if part then
    print(part.Color)
end
```

### 2. Always Clean Up Connections

```lua
-- ❌ BAD - Memory leak!
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character.Humanoid.Died:Connect(function()
            print("Dead!")
        end)
    end)
end)
-- Creates new Died connection every respawn, memory accumulates

-- ✅ GOOD - Disconnect old connection
local connections = {}

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- Disconnect old if exists
        if connections[player] then
            connections[player]:Disconnect()
        end

        -- Create new
        connections[player] = character.Humanoid.Died:Connect(function()
            print("Dead!")
        end)
    end)

    player.PlayerRemoving:Connect(function()
        if connections[player] then
            connections[player]:Disconnect()
        end
    end)
end)
```

### 3. Use Meaningful Variable Names

```lua
-- ❌ BAD
local h = game.Players:GetChildren()[1]:WaitForChild("Humanoid")
h.Health = 100

-- ✅ GOOD
local firstPlayer = game.Players:GetChildren()[1]
local humanoid = firstPlayer:WaitForChild("Humanoid")
humanoid.Health = 100
```

### 4. Comment Non-Obvious Code

```lua
-- ✅ GOOD - explains WHY
-- Multiply by 0.95 to account for gravity while jumping
local jumpForce = 50 * 0.95

-- ❌ BAD - just restates code
-- Multiply by 0.95
local jumpForce = 50 * 0.95
```

### 5. Use Constants for Magic Numbers

```lua
-- ❌ BAD - 50 means... what?
part.Color = Color3.fromRGB(255, 50, 50)
wait(50)

-- ✅ GOOD - clear intent
local CUSTOM_RED = Color3.fromRGB(255, 50, 50)
local RESPAWN_DELAY = 50

part.Color = CUSTOM_RED
wait(RESPAWN_DELAY)
```

---

## Advanced Topics (After Mastering Basics)

### Understanding Coroutines

Pause and resume code execution:

```lua
local function slowPrint()
    print("A")
    coroutine.yield()  -- Pause here
    print("B")
end

local thread = coroutine.create(slowPrint)
coroutine.resume(thread)  -- Prints "A"
coroutine.resume(thread)  -- Prints "B"
```

### Metatables (Advanced)

Customize table behavior (rarely needed for fundamentals, but powerful):

```lua
local myTable = {x = 5}
setmetatable(myTable, {
    __index = function(t, key)
        print("Accessed: " .. key)
        return 0
    end
})

print(myTable.y)  -- Prints "Accessed: y", returns 0
```

---

## Performance Tips

### Efficient Loops

```lua
-- ✅ GOOD - only gets service once
local Players = game:GetService("Players")
for _, player in pairs(Players:GetPlayers()) do
    print(player.Name)
end

-- ❌ BAD - gets service every iteration (slower)
for _, player in pairs(game:GetService("Players"):GetPlayers()) do
    print(player.Name)
end
```

### Avoid Expensive Operations in Loops

```lua
-- ❌ BAD - FindFirstChild called 1000 times
for i = 1, 1000 do
    local part = workspace:FindFirstChild("MyPart")  -- Slow!
end

-- ✅ GOOD - Find once, reuse
local part = workspace:FindFirstChild("MyPart")
for i = 1, 1000 do
    print(part.Name)  -- Fast!
end
```

---

## Common Patterns Reference

### Pattern: Debounce

Prevent event from firing too frequently:

```lua
local debounce = false

part.Touched:Connect(function(otherPart)
    if debounce then return end
    debounce = true

    print("Touched!")

    task.wait(1)  -- Debounce for 1 second
    debounce = false
end)
```

### Pattern: Safe Event Cleanup

```lua
local touchConnection

part.Touched:Connect(function()
    -- Disconnect previous if exists
    if touchConnection then
        touchConnection:Disconnect()
    end

    -- Create new connection
    touchConnection = workspace.OtherPart.Touched:Connect(function()
        print("Chained event!")
    end)
end)
```

---
