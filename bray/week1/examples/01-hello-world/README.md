# Example 1: Hello World

**Difficulty:** Beginner

**Time:** 15 minutes

**What you'll learn:**
- How to write your first Roblox script
- Using `print()` to output messages
- Understanding the Output window
- Difference between server and client scripts

---

## Concept: Your First Script

**What pros call it:** "Hello World program"

**What it is:** The traditional first program every developer writes. It just displays a message to prove the code is running.

**Why it matters:** You'll use `print()` constantly for debugging. It's how you see what your code is doing!

**Real developer talk:** "Let me add a print statement to debug this" or "Check the console output."

---

## What We're Building

Two simple scripts:
1. **Server script** - Prints a message that the server can see
2. **Client script** - Prints a message that each player can see

**Goal:** Understand WHERE code runs (server vs. client) and HOW to see output.

---

## Step 1: Understanding the Code

### Server Script (`src/server/HelloWorld.server.lua`)

```lua
-- This is a server script! It runs on the server.
-- The server is the computer that hosts the game for everyone.

print("🎮 [SERVER] Hello from the server!")
print("🎮 [SERVER] This message prints once when the server starts.")
print("🎮 [SERVER] All players are connected to this one server.")

-- Let's print some info about the game
print("🎮 [SERVER] Game name:", game.Name)
print("🎮 [SERVER] Workspace name:", workspace.Name)
```

**Breaking it down:**

- `--` creates a comment (text that doesn't run, just explains)
- `print()` outputs a message to the Output window
- We use `[SERVER]` prefix to clearly show where this is running
- `game.Name` and `workspace.Name` are properties we can access

**Pro term:** The `print()` function is called a "logging function" or "console output." Professionals say "log it" or "print to console."

---

### Client Script (`src/client/HelloWorld.client.lua`)

```lua
-- This is a client script (LocalScript)! It runs on each player's computer.
-- If 10 players join, this script runs 10 times (once per player).

print("👤 [CLIENT] Hello from the client!")
print("👤 [CLIENT] This message prints once for EACH player who joins.")
print("👤 [CLIENT] Each player sees their own copy of this message.")

-- Let's get info about THIS player
local Players = game:GetService("Players")
local player = Players.LocalPlayer  -- The player on THIS computer

if player then
    print("👤 [CLIENT] Your name is:", player.Name)
    print("👤 [CLIENT] Your User ID is:", player.UserId)
else
    print("👤 [CLIENT] Player not loaded yet!")
end
```

**Breaking it down:**

- This runs on each player's computer separately
- `game:GetService("Players")` gets the Players service (standard way to access services)
- `Players.LocalPlayer` gets the player on THIS computer
- `if player then` checks if the player exists before using it
- Each player sees their own name printed

**Pro terms:**
- `game:GetService()` is the "service pattern" - how we access Roblox services
- `LocalPlayer` only exists in client scripts (it's THIS player)
- `if player then` is called a "nil check" or "safety check"

---

## Step 2: Set Up the Project

### Create the Rojo Configuration

Create `default.project.json` in the `01-hello-world` folder:

```json
{
  "name": "01-hello-world",
  "tree": {
    "$className": "DataModel",
    "ServerScriptService": {
      "$className": "ServerScriptService",
      "HelloWorld": {
        "$path": "src/server/HelloWorld.server.lua"
      }
    },
    "StarterPlayer": {
      "$className": "StarterPlayer",
      "StarterPlayerScripts": {
        "$className": "StarterPlayerScripts",
        "HelloWorld": {
          "$path": "src/client/HelloWorld.client.lua"
        }
      }
    }
  }
}
```

**What this does:**
- Tells Rojo where to put your scripts in Roblox Studio
- Server script goes to `ServerScriptService`
- Client script goes to `StarterPlayer/StarterPlayerScripts`

**Pro term:** This is a "project configuration file" - it maps your file structure to Roblox's structure.

---

## Step 3: Run It!

### Start Rojo Server

In terminal (from the `01-hello-world` folder):

```bash
rojo serve
```

### Connect Roblox Studio

1. Open a new Baseplate in Roblox Studio
2. Plugins tab → Rojo → Connect to localhost:34872
3. You should see your scripts appear in the correct places!

### Test the Server Script

1. Look at the Output window (View → Output, or press F9)
2. You should see:
   ```
   🎮 [SERVER] Hello from the server!
   🎮 [SERVER] This message prints once when the server starts.
   🎮 [SERVER] All players are connected to this one server.
   🎮 [SERVER] Game name: ...
   🎮 [SERVER] Workspace name: Workspace
   ```

**The server script runs immediately when you open the place!**

### Test the Client Script

1. Press Play (F5) to start testing as a player
2. Look at the Output window
3. You should see:
   ```
   👤 [CLIENT] Hello from the client!
   👤 [CLIENT] This message prints once for EACH player who joins.
   👤 [CLIENT] Each player sees their own copy of this message.
   👤 [CLIENT] Your name is: Player1
   👤 [CLIENT] Your User ID is: ...
   ```

**The client script runs when you start playing!**

---

## Step 4: Experiment!

Now that it works, try these challenges:

### Challenge 1: Add More Print Statements

Add your own messages:
```lua
print("My first script is working!")
print("I'm learning Roblox development!")
```

**What you're learning:** Using print() for custom messages.

---

### Challenge 2: Print Math

Try printing calculations:
```lua
print("2 + 2 =", 2 + 2)
print("10 * 5 =", 10 * 5)
print("100 / 4 =", 100 / 4)
```

**What you're learning:** Print can show values and calculations.

---

### Challenge 3: Print Player Count

In the server script:
```lua
local Players = game:GetService("Players")
print("Number of players:", #Players:GetPlayers())
```

**What you're learning:** Accessing services and getting game state.

**Pro term:** `#` is the "length operator" - it counts items in a list.

---

### Challenge 4: Print Every Second

In the server script, add a loop:
```lua
while true do
    wait(1)  -- Wait 1 second
    print("Server is running...")
end
```

**What you're learning:** Loops and timing.

**WARNING:** If you forget `wait()`, Studio will freeze! Always include wait() in infinite loops!

---

## Troubleshooting Guide

### Issue: Script Not Running at All

**Symptoms:**
- No output messages appear
- Script seems to be ignored

**Diagnosis:**
1. Check the script is in the correct location
2. Verify Rojo is connected (green checkmark in Studio)
3. Check Output window is open (F9)
4. Make sure script name ends in `.server.lua` or `.client.lua`

**Solutions:**
- **Server script in wrong place?** Should be in ServerScriptService
- **Client script in wrong place?** Should be in StarterPlayer/StarterPlayerScripts
- **Rojo not connected?** Click the Rojo plugin, then "Connect"
- **Can't find Output?** Press F9, or View → Output

---

### Issue: Output Window Shows Errors

**Common error: "attempt to index nil"**
- Means you're trying to access something that doesn't exist
- Usually `LocalPlayer` on server, or parts that aren't loaded yet
- **Solution:** Always check `if value then` before using it

**Common error: "attempt to call a nil value"**
- Means the function doesn't exist
- Usually because you misspelled it or didn't import a service correctly
- **Solution:** Check spelling exactly, use `game:GetService()` for services

---

### Issue: Output Shows Warnings but No Errors

**Warnings are OK!** They're just notices. Your script still runs.

**However:**
- If you see "Infinite yield possible" - script is waiting forever
- **Solution:** Make sure the part you're waiting for actually exists

---

### Issue: LocalPlayer is Nil (Client Script)

**Problem:**
```lua
-- Client script
local player = game.Players.LocalPlayer
print(player.Name)  -- ERROR: attempt to index nil
```

**Solution:** Always check if player exists first:
```lua
local player = game.Players.LocalPlayer
if player then
    print(player.Name)
else
    print("Player not ready yet!")
end
```

---

## Common Mistakes

### Mistake 1: Wrong Script Type

**Problem:**
- Put a Server Script in StarterPlayerScripts (nothing happens)
- Put a LocalScript in ServerScriptService (nothing happens)

**Solution:**
- **ServerScriptService** → **Script** (server code)
- **StarterPlayerScripts** → **LocalScript** (client code)

---

### Mistake 2: Can't Find Output Window

**Problem:** "I don't see any print messages!"

**Solution:**
- Press F9 to open Output window
- Make sure it says "Output" at the top (not "Command Bar")
- Try printing with a unique message: `print("★★★ TESTING ★★★")`

---

### Mistake 3: Script Doesn't Update After Edits

**Problem:** You edited the code but Studio still runs the old version

**Solution:**
- Make sure Rojo is **connected** (check the plugin)
- If not connected, click "Connect" in the Rojo plugin
- Rojo auto-syncs file changes to Studio in real-time

---

## Extensions & Variations

### Extension 1: Multiple Players

Track multiple players connecting:
```lua
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    print("Player joined:", player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
    print("Player left:", player.Name)
end)
```

---

### Extension 2: Persistent Logging

Save messages to a log file (advanced concept):
```lua
-- Store all messages
local messages = {}

print = function(...)
    local args = {...}
    table.insert(messages, table.concat(args, " "))
end

-- Later: export to file or send to server
```

---

### Extension 3: Conditional Logging

Only print in development mode:
```lua
local DEBUG = true  -- Set to false for production

local function log(...)
    if DEBUG then
        print(...)
    end
end

log("This only prints in DEBUG mode")
```

---

### Variation 1: Using table.concat for Formatted Output

```lua
local function printValues(...)
    local args = {...}
    print(table.concat(args, " | "))  -- Join with pipes
end

printValues("Name", "Age", "Score")  -- Output: Name | Age | Score
```

---

### Variation 2: String Formatting

```lua
-- Using string.format for fancy output
local player = game.Players.LocalPlayer
if player then
    print(string.format("Player %s has ID %d", player.Name, player.UserId))
end
```

---

## Performance Tips

### Tip 1: Don't Print in Loops

**BAD:**
```lua
-- Prints 1000 times per second!
while true do
    print("Running...")
end
```

**GOOD:**
```lua
-- Prints once per second
while true do
    print("Running...")
    task.wait(1)
end
```

**Impact:** Printing to console is slow. Too many prints = lag!

---

### Tip 2: Use Print Only for Debugging

**BAD - Production Code:**
```lua
-- Logs every frame
while true do
    print("Position:", player.Position)
    task.wait()
end
```

**GOOD - Selective Logging:**
```lua
local DEBUG = false  -- Toggle for testing

if DEBUG then
    print("Debug info here")
end
```

**Impact:** Console output is visible to all players in some games. Use debug flags!

---

### Tip 3: Consider Using Warn or Error for Important Messages

```lua
-- Info message
print("Game started")

-- Warning message
warn("Deprecated function used")

-- Error message
error("Critical failure!")
```

**Impact:** Different message types help you scan logs quickly!

---

### Tip 4: Batch Information Display

**BAD - Multiple prints:**
```lua
print("Name:", player.Name)
print("ID:", player.UserId)
print("Age:", player.AccountAge)
```

**GOOD - Single print:**
```lua
print(string.format("Player: %s (ID: %d, Age: %d)", player.Name, player.UserId, player.AccountAge))
```

**Impact:** Fewer print calls = slightly better performance, easier to read!

---

## What You Learned

By completing this example, you now know:

- ✅ How to write a server script (Script)
- ✅ How to write a client script (LocalScript)
- ✅ How to use `print()` for debugging
- ✅ Where to find output (F9 for Output window)
- ✅ How to access services (`game:GetService()`)
- ✅ The difference between server and client execution
- ✅ How to check if something exists before using it (`if player then`)

---

## Professional Insight

**Pro tip:** Professional developers use logging (printing) constantly. Even senior developers with 20 years of experience print values to see what's happening.

**Tools you'll learn later:**
- Debuggers (step through code line by line)
- Breakpoints (pause code at specific lines)
- Stack traces (see call history)

**But print statements?** Used every single day. Never stop using them!

**Pro saying:** "When in doubt, print it out!"

---

## Next Steps

**→ [Example 2: Part Manipulator](../02-part-manipulator/)** - Learn to change parts from code!

Ready to actually change the game world? Let's go!
