# Client-Server Architecture

**What pros call it:** "Client-Server Architecture" or "Client-Server Model"

**What it actually means:**
Think of it like playing a board game with friends. Everyone has their own view of the game (that's the **client** - what you see on YOUR screen). But there's one person who's the "game master" who tracks the real rules, prevents cheating, and decides what actually happened (that's the **server** - the computer that runs the game for everyone).

---

## Why We Say It This Way

When developers say "that runs on the client" they mean "each player's computer handles that."

When they say "that runs on the server" they mean "the main game computer handles that."

---

## Real Developer Talk

- ❌ Don't say: "My computer does the jumping"
- ✅ Do say: "Jump animation runs client-side"
- ✅ Do say: "The server validates the jump height"

---

## The Pattern

```
Client (Your Computer)          Server (Game Computer)
     |                                  |
     |  "Hey, I pressed jump!"          |
     |--------------------------------->|
     |                                  | (Checks: Is this player allowed to jump?)
     |                                  | (Checks: Are they on the ground?)
     |  "Approved, jump 50 studs"       |
     |<---------------------------------|
     | (Shows jump animation)           |
```

---

## Why It Matters

If you put score tracking on the client, hackers can change their score.

If you put it on the server, only the server can change it - that's secure.

You'll hear pros say **"never trust the client"** - this is why.

---

## In Roblox Terms

### Client-Side (LocalScript)

**Where it runs:** `StarterPlayer/StarterPlayerScripts` or `StarterGui`

**What it's for:**
- UI updates (showing health bars, ammo counters)
- Visual effects (particles, animations that only you see)
- Input detection (mouse clicks, keyboard presses)
- Camera manipulation
- Sound (for just this player)

**Example:**
```lua
-- LocalScript in StarterPlayerScripts
local player = game.Players.LocalPlayer

-- This runs on YOUR computer only
player.Character.Humanoid.WalkSpeed = 100  -- ❌ Exploiters can do this!
```

**Pros:**
- ✅ Super fast (no network delay)
- ✅ Responsive UI and controls
- ✅ Can run code even if server is laggy

**Cons:**
- ❌ Can be hacked/exploited
- ❌ Changes only visible to that one player
- ❌ Can't affect other players

---

### Server-Side (Script)

**Where it runs:** `ServerScriptService` or `Workspace` (in anchored parts)

**What it's for:**
- Score tracking
- Inventory management
- Damage dealing
- Game state (round timers, who's winning, etc.)
- Spawning objects that all players can see
- Validating actions (did they really earn that coin?)

**Example:**
```lua
-- Script in ServerScriptService
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    -- This runs on the SERVER for ALL players
    player.Character.Humanoid.WalkSpeed = 16  -- ✅ Secure, server decides
end)
```

**Pros:**
- ✅ Secure (players can't hack it)
- ✅ Authoritative (server's version is the truth)
- ✅ Affects all players

**Cons:**
- ❌ Slower (network delay for remote events)
- ❌ More complex (need to communicate with clients)

---

## The Golden Rule: Never Trust the Client

**Bad example (client can cheat):**

```lua
-- ❌ LocalScript - Exploiter can change this!
local coins = 100
coins = coins + 1000000  -- Hacker gives themselves coins
```

**Good example (server validates):**

```lua
-- Client (LocalScript)
local replicatedStorage = game:GetService("ReplicatedStorage")
local addCoinEvent = replicatedStorage.AddCoinEvent

-- Client asks server to add coins
addCoinEvent:FireServer()  -- Just asks, doesn't directly add

-- Server (Script in ServerScriptService)
local replicatedStorage = game:GetService("ReplicatedStorage")
local addCoinEvent = replicatedStorage.AddCoinEvent

addCoinEvent.OnServerEvent:Connect(function(player)
    -- Server checks: Did they really collect a coin?
    -- Server adds the coin (secure!)
    player.leaderstats.Coins.Value = player.leaderstats.Coins.Value + 1
end)
```

---

## Decision Tree: Client or Server?

Ask yourself:

### "Can a hacker abuse this if they change it?"

**YES** → Server-side
**NO** → Can be client-side

### Examples:

| Action | Client or Server? | Why? |
|--------|-------------------|------|
| Show ammo count on screen | Client | Just UI, doesn't affect gameplay |
| Decrease ammo when shooting | Server | Exploiter could give infinite ammo |
| Play shooting sound | Client | Just audio, doesn't hurt anyone |
| Deal damage to enemy | Server | Exploiter could one-shot everyone |
| Animate weapon recoil | Client | Visual only, just looks cool |
| Check if player can afford item | Server | Exploiter could buy anything for free |
| Move camera when aiming | Client | Just their view, doesn't affect others |
| Give player an item | Server | Exploiter could spawn any item |

---

## Replication (How Server Shares to Clients)

**What pros call it:** "Replication" or "Network replication"

**What it means:** When the server changes something, Roblox automatically sends that change to all clients.

**Example:**
```lua
-- Server Script
workspace.Part.Color = Color3.new(1, 0, 0)  -- Server changes part to red
```

**What happens:**
1. Server changes the part's color in its version
2. Roblox automatically sends this change to ALL clients
3. All players see the part turn red

**This is replication!** Server's changes automatically replicate to clients.

**Pro term:** We say "the part's color replicates to clients."

---

## What Replicates vs. What Doesn't

### Replicates (Server → Clients)

- Part properties (Color, Size, Position, etc.)
- Player stats (leaderstats)
- Objects created/destroyed by server
- Character movements (physics)

### Doesn't Replicate (Client only)

- LocalScript variables
- Camera changes
- UI (ScreenGuis in PlayerGui)
- Client-only sound
- Particles created client-side

**Important:** If you change something in a LocalScript, only YOU see it. Other players don't.

---

## Communication: Remote Events

**What pros call it:** "Remote Events" or "Client-server communication"

**What it means:** Clients and servers send messages to each other.

**Pattern:**
```
Client wants to do something
    ↓
Client fires RemoteEvent to server
    ↓
Server receives the event
    ↓
Server validates (is this allowed?)
    ↓
Server performs the action
    ↓
Change replicates to all clients
```

**Example:**
```lua
-- ReplicatedStorage: Create RemoteEvent named "BuyItemEvent"

-- Client (LocalScript)
local replicatedStorage = game:GetService("ReplicatedStorage")
local buyItemEvent = replicatedStorage.BuyItemEvent

-- Player clicks "Buy" button
buyItemEvent:FireServer("Sword", 100)  -- Asks server to buy Sword for 100 coins

-- Server (Script)
local replicatedStorage = game:GetService("ReplicatedStorage")
local buyItemEvent = replicatedStorage.BuyItemEvent

buyItemEvent.OnServerEvent:Connect(function(player, itemName, cost)
    -- Server checks: Does player have enough coins?
    if player.leaderstats.Coins.Value >= cost then
        -- Give item
        player.leaderstats.Coins.Value -= cost
        -- ... create item in player's inventory
    else
        -- Not enough coins, reject
        warn(player.Name .. " tried to buy " .. itemName .. " but doesn't have enough coins")
    end
end)
```

**Key points:**
- Client **asks** server to do something
- Server **validates** the request
- Server **performs** the action
- Exploiter can't cheat because server decides everything

---

## Try This Exercise

Next time you play any online game (Fortnite, Minecraft, Roblox games), ask yourself:

**"Is this client-side or server-side?"**

Examples:
- Your character's walking animation? **Client** (your computer animates it smoothly)
- Taking damage from an enemy? **Server** (server calculates damage to prevent cheating)
- Your crosshair/reticle? **Client** (just UI on your screen)
- Picking up a coin? **Server decides if you really picked it up**, but **client shows the animation**
- Opening a menu? **Client** (just UI)
- Buying an item from shop? **Server** (validates you have money, gives item)

---

## Common Mistakes

### Mistake 1: Putting Everything on Server

```lua
-- ❌ BAD - UI should be client-side!
-- Server Script trying to update player's UI
player.PlayerGui.ScreenGui.TextLabel.Text = "Hello!"  -- Works but WRONG!
```

**Why it's bad:** Server is doing work that clients should do. Wastes server resources!

**Fix:** Use client scripts for UI.

---

### Mistake 2: Putting Important Logic on Client

```lua
-- ❌ BAD - Client decides damage (exploitable!)
-- LocalScript
local damage = 1000000  -- Hacker sets to huge number
enemy.Humanoid.Health -= damage
```

**Why it's bad:** Exploiter can deal infinite damage!

**Fix:** Server validates and applies damage.

---

### Mistake 3: Forgetting to Validate

```lua
-- ❌ BAD - Server trusts client blindly!
-- Server Script
giveCoinsEvent.OnServerEvent:Connect(function(player, amount)
    player.leaderstats.Coins.Value += amount  -- Exploiter can pass huge number!
end)
```

**Why it's bad:** Exploiter can give themselves infinite coins!

**Fix:**
```lua
-- ✅ GOOD - Server validates
giveCoinsEvent.OnServerEvent:Connect(function(player)
    -- Server decides the amount (client can't control it)
    local amount = 10  -- Fixed amount, safe!
    player.leaderstats.Coins.Value += amount
end)
```

---

## Professional Insight

**Pro saying:** "The server is the source of truth."

**What it means:** When client and server disagree, server wins. Always.

**Example scenario:**
1. Client thinks player has 100 health (laggy connection, info is old)
2. Server knows player has 0 health (they died 2 seconds ago)
3. Server kicks player out of game
4. Client's version doesn't matter - server's version is the truth

**This is how all online games work!** Fortnite, Minecraft, Call of Duty - same pattern.

---

## Advanced Techniques

### Technique 1: Client-Side Prediction with Server Reconciliation

When network latency is high, games become unresponsive if clients wait for server approval. Professionals use **client-side prediction**:

**How it works:**
1. Client predicts action immediately (moves character)
2. Client sends request to server
3. Server validates and applies action
4. If server disagrees, client corrects to match server

**Example - Movement with prediction:**

```lua
-- CLIENT (LocalScript)
local character = script.Parent
local position = character:GetPivot()

-- Player presses forward - predict movement
local userInput = game:GetService("UserInputService")
local moveSpeed = 16

if userInput:IsKeyDown(Enum.KeyCode.W) then
    -- Predict on client (smooth, responsive)
    position = position * CFrame.new(0, 0, -moveSpeed * deltaTime)
    character:MoveTo(position.Position)

    -- Tell server what we did
    game.ReplicatedStorage.MoveEvent:FireServer(position)
end

-- SERVER (Script)
local moveEvent = game.ReplicatedStorage.MoveEvent

moveEvent.OnServerEvent:Connect(function(player, clientPosition)
    -- Validate position is reasonable
    local character = player.Character
    local serverPosition = character:GetPivot().Position

    -- Check if client moved too far (exploit detection)
    local distance = (clientPosition.Position - serverPosition).Magnitude
    if distance > 100 then  -- Max 100 studs per frame = suspicious
        warn("Exploit detected:", player.Name)
        return
    end

    -- Approve the move
    character:MoveTo(clientPosition.Position)
end)
```

**Why it matters:** Feels responsive to players, but server still validates (secure).

---

### Technique 2: Request-Response Pattern

For complex actions, use RemoteFunctions instead of RemoteEvents:

```lua
-- SERVER (Script in ServerScriptService)
local BuyItemFunction = game.ReplicatedStorage.BuyItemFunction

BuyItemFunction.OnServerInvoke = function(player, itemName)
    -- Server validates purchase
    local price = {
        Sword = 100,
        Shield = 150
    }

    if not price[itemName] then
        return false, "Item not found"
    end

    if player.leaderstats.Coins.Value < price[itemName] then
        return false, "Not enough coins"
    end

    -- Grant item
    player.leaderstats.Coins.Value -= price[itemName]
    giveItemToPlayer(player, itemName)

    return true, "Purchase successful"
end

-- CLIENT (LocalScript)
local BuyItemFunction = game.ReplicatedStorage.BuyItemFunction

-- Call server and WAIT for response
local success, message = BuyItemFunction:InvokeServer("Sword")

if success then
    print("Bought item!", message)
else
    print("Purchase failed:", message)
end
```

**When to use:**
- When client needs to know if action succeeded
- When server needs to return data to client
- When you need request-response pattern

---

### Technique 3: Rate Limiting and Debouncing

Prevent exploiters from spam-clicking:

```lua
-- CLIENT (LocalScript)
local lastClickTime = 0
local COOLDOWN = 0.5  -- Can click every 0.5 seconds

local function onAttackButtonPressed()
    local currentTime = tick()

    if currentTime - lastClickTime < COOLDOWN then
        return  -- Too soon, ignore
    end

    lastClickTime = currentTime
    game.ReplicatedStorage.AttackEvent:FireServer()
end

-- SERVER (Script)
local AttackEvent = game.ReplicatedStorage.AttackEvent
local playerCooldowns = {}

AttackEvent.OnServerEvent:Connect(function(player)
    local playerId = player.UserId
    local currentTime = tick()
    local lastAttackTime = playerCooldowns[playerId] or 0

    -- Server enforces cooldown (client check is just UX)
    if currentTime - lastAttackTime < 0.5 then
        warn("Attack spam detected:", player.Name)
        return
    end

    playerCooldowns[playerId] = currentTime

    -- Process attack
    dealDamage(player)
end)
```

**Why double check:** Client check = responsive UI. Server check = security against cheaters.

---

## Performance Considerations

### Network Performance

**Problem:** Sending too much data over network = slow, laggy game.

**Solutions:**

```lua
-- ❌ BAD - Sends position 60 times per second for all players
local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(function()
    game.ReplicatedStorage.PlayerPositionEvent:FireServer(character.Position)
end)

-- ✅ GOOD - Send position only when it changes significantly
local lastSentPosition = character:GetPivot().Position
local POSITION_THRESHOLD = 0.5  -- Only send if moved 0.5+ studs

RunService.Heartbeat:Connect(function()
    local currentPosition = character:GetPivot().Position
    local distance = (currentPosition - lastSentPosition).Magnitude

    if distance > POSITION_THRESHOLD then
        lastSentPosition = currentPosition
        game.ReplicatedStorage.PlayerPositionEvent:FireServer(currentPosition)
    end
end)
```

### Memory Performance

```lua
-- ❌ BAD - Creates memory leak
while true do
    local part = Instance.new("Part")
    part.Parent = workspace
    wait(1)
    -- Part never destroyed!
end

-- ✅ GOOD - Clean up properly
for i = 1, 10 do
    local part = Instance.new("Part")
    part.Parent = workspace
    wait(1)
    part:Destroy()  -- Clean up immediately
end

-- ✅ ALSO GOOD - Reuse instead of recreate
local part = Instance.new("Part")
part.Parent = workspace
for i = 1, 10 do
    part.Position = part.Position + Vector3.new(0, 0, 5)
    wait(1)
end
part:Destroy()
```

### Server Load Performance

```lua
-- ❌ BAD - Server processes every mouse move (thousands per minute)
mouse.Move:Connect(function()
    -- Expensive calculation
    calculateDamageForEveryEnemy()
end)

-- ✅ GOOD - Throttle expensive operations
local lastCalculation = tick()
local CALCULATION_INTERVAL = 0.1  -- Only calculate 10 times per second

mouse.Move:Connect(function()
    if tick() - lastCalculation > CALCULATION_INTERVAL then
        calculateDamageForEveryEnemy()
        lastCalculation = tick()
    end
end)
```

---

## Best Practices Checklist

Before shipping your game, verify:

```lua
-- ❌ WRONG - Data on client
local coins = 1000000
game.ReplicatedStorage.BuyCoinEvent:FireServer(coins)

-- ✅ RIGHT - Data on server
game.ReplicatedStorage.BuyCoinEvent:FireServer()  -- Client just asks
-- Server decides amount

-- ❌ WRONG - Trust client
if costInCoins <= playerCoins then  -- Client deciding!
    giveItem()
end

-- ✅ RIGHT - Server validates
game.ReplicatedStorage.BuyItemEvent:FireServer(itemName)
-- Server checks: Does player have coins? Server decides.

-- ❌ WRONG - No validation
local damageEvent = ...
damageEvent.OnServerEvent:Connect(function(player, damage)
    applyDamage(damage)  -- What if it's 9999999?
end)

-- ✅ RIGHT - Validate before applying
damageEvent.OnServerEvent:Connect(function(player, targetId)
    local baseDamage = 25
    -- Server decides damage amount
    applyDamage(baseDamage * player.Character.PowerLevel)
end)
```

---

## Real-World Applications

This pattern isn't just Roblox - it's EVERYWHERE:

**Web Development:**
- Your browser (client) sends login request
- Server validates username/password
- Server decides if you can log in
- Never trust the client!

**Banking Apps:**
- App (client) shows your balance
- But the REAL balance is on the bank's server
- You can't hack the app to add money (client can't change server)

**Social Media:**
- Your phone (client) shows posts
- But the posts are stored on Facebook's server
- You can't hack your phone to delete someone else's post (server decides who can delete what)

**Same exact pattern!** Learn it once, use it forever.

---

## Quick Reference Guide

### Script Placement Cheat Sheet

| Location | Script Type | Who Can See | When Runs | Best For |
|----------|-------------|-------------|-----------|----------|
| **ServerScriptService** | Script | Server only | At game start | Game logic, scoring, validation |
| **Workspace (part)** | Script | Server only | When part loads | Object behavior |
| **StarterPlayerScripts** | LocalScript | Each player | When player joins | Player input, UI |
| **StarterCharacterScripts** | LocalScript | Each player | When char spawns | Character behavior |
| **StarterGui** | LocalScript | Each player | When player joins | UI interaction |
| **ReplicatedStorage** | ModuleScript | Both | When required | Shared code |
| **ReplicatedStorage** | RemoteEvent | Both | When fired | Communication |

### Client vs Server Decision Flowchart

```
Does this affect gameplay security?
├─ YES → Use SERVER (Script)
└─ NO  → Can be CLIENT (LocalScript)

Can a hacker abuse this?
├─ YES → Use SERVER
└─ NO  → Probably CLIENT

Does this need to happen the same way for ALL players?
├─ YES → Use SERVER
└─ NO  → Probably CLIENT

Does this affect game state/scoring?
├─ YES → Use SERVER
└─ NO  → Probably CLIENT

Examples:
✓ Damage dealing → SERVER (exploiter could one-shot everyone)
✓ Show ammo count → CLIENT (just UI for that player)
✓ Award coins → SERVER (exploiter could give themselves infinite coins)
✓ Play sound effect → CLIENT (just audio for that player)
✓ Teleport player → SERVER (exploiter could teleport anywhere)
✓ Update camera → CLIENT (just their view)
```

---

## Hands-On Exercises

### Exercise 1: Identifying Code Location (10 min)

**For each scenario, decide: Server Script, LocalScript, or RemoteEvent?**

1. **Displaying the player's current health on the screen**
   - Answer: LocalScript (in StarterGui)
   - Why: Just UI for that player, doesn't affect gameplay

2. **Subtracting health when a player takes damage**
   - Answer: Server Script (in ServerScriptService)
   - Why: Affects game state, prevent exploiting

3. **Playing a sound effect when a tool is equipped**
   - Answer: LocalScript (in the tool or StarterCharacterScripts)
   - Why: Just audio, doesn't affect gameplay

4. **Checking if a player can afford to buy an item**
   - Answer: Server Script + RemoteEvent
   - Why: Server validates the purchase to prevent cheating

5. **Showing a particle effect when a magic spell fires**
   - Answer: LocalScript (or server broadcasts via RemoteEvent for other players to see)
   - Why: Visual effect only

6. **Subtracting money when a player buys something**
   - Answer: Server Script
   - Why: Affects player resources, must be secure

---

### Exercise 2: RemoteEvent Communication (20 min)

**Create a secure coin collection system:**

```lua
-- SETUP: Create a RemoteEvent in ReplicatedStorage named "CoinCollected"

-- SERVER SCRIPT (ServerScriptService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local coinEvent = ReplicatedStorage:WaitForChild("CoinCollected")

-- Player leaderstats setup (handle in another script)
Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats
end)

-- When client reports collecting a coin, server validates and awards it
coinEvent.OnServerEvent:Connect(function(player)
    -- Server decides the reward (client can't control this!)
    local coinReward = 10

    -- Server directly modifies the player's coins
    player.leaderstats.Coins.Value = player.leaderstats.Coins.Value + coinReward

    print(player.Name, "collected coins! Total:", player.leaderstats.Coins.Value)
end)

-- CLIENT SCRIPT (in the coin part)
local coin = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local coinEvent = ReplicatedStorage:WaitForChild("CoinCollected")

local debounce = false

coin.Touched:Connect(function(otherPart)
    if debounce then return end
    debounce = true

    -- Try to collect (server will validate)
    local humanoid = otherPart.Parent:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Tell server we touched a coin
        coinEvent:FireServer()

        -- Optional: Show visual effect for player
        coin.Transparency = 0.5
    end

    task.wait(1)
    debounce = false
end)
```

**Key points:**
- Client asks server to collect coin
- Server validates and awards coins
- Exploiter can't give themselves coins (server controls amount)

---

### Exercise 3: Replication Example (15 min)

**See replication in action:**

```lua
-- SERVER SCRIPT: Changes something, watch it replicate to clients
local part = workspace:WaitForChild("Part")

while true do
    -- Change color on server
    part.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))

    -- Wait 1 second
    task.wait(1)

    -- ALL clients automatically see this color change!
    -- Roblox handles the replication for us
end

-- CLIENT SCRIPT: Just watches the part
local part = workspace:WaitForChild("Part")

print("Part color on client:", part.Color)  -- Automatically updated!

part.Color_InstanceColorChanged:Connect(function()
    print("Client sees new color!")
end)
```

**What's happening:**
1. Server changes part color
2. Roblox automatically sends this change to all clients
3. All clients see the same color
4. No RemoteEvent needed! Replication is automatic.

---

### Exercise 4: Security Vulnerability (20 min)

**Identify the security problems:**

```lua
-- ❌ INSECURE CLIENT SCRIPT
local replicatedStorage = game:GetService("ReplicatedStorage")
local giveCoinsEvent = replicatedStorage.GiveCoinsEvent

-- Client decides how many coins to give themselves!
local cheatAmount = 1000000
giveCoinsEvent:FireServer(cheatAmount)  -- Exploiter passes huge number!

-- ❌ INSECURE SERVER SCRIPT
local giveCoinsEvent = replicatedStorage.GiveCoinsEvent

giveCoinsEvent.OnServerEvent:Connect(function(player, amount)
    -- Server blindly trusts what client sent!
    player.leaderstats.Coins.Value = player.leaderstats.Coins.Value + amount
    -- Exploiter just gave themselves 1 million coins!
end)

-- ✅ SECURE VERSION
-- CLIENT SCRIPT: Just requests, doesn't control amount
local giveCoinsEvent = replicatedStorage.GiveCoinsEvent
giveCoinsEvent:FireServer()  -- No parameters!

-- ✅ SECURE SERVER SCRIPT
local giveCoinsEvent = replicatedStorage.GiveCoinsEvent

giveCoinsEvent.OnServerEvent:Connect(function(player)
    -- Server decides the reward amount (client can't control it)
    local coinReward = 10

    -- Validation: Is this player allowed to earn coins?
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.leaderstats.Coins.Value = player.leaderstats.Coins.Value + coinReward
        print("Player earned coins!")
    end
end)
```

---

## Common Mistakes and Fixes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Using LocalScript in ServerScriptService | Script doesn't run | Use Script instead |
| Trusting client about values | Exploiters cheat | Server validates everything |
| Not checking player exists | Can error if player leaves | Check `if player then` |
| Forgetting RemoteEvent in ReplicatedStorage | Client can't find it | Put event in ReplicatedStorage |
| Both client and server modify same property | Conflicts and errors | Only server modifies game state |

---

## Real-World Applications

### Example 1: Damage System

```lua
-- CLIENT: Show damage indicator (visual only)
-- Server: Calculate and apply actual damage

-- SERVER
local damageEvent = ReplicatedStorage.DealDamageEvent

damageEvent.OnServerEvent:Connect(function(player, targetCharacter)
    -- Validate: Did player really attack?
    if not canAttack(player) then
        return  -- Reject invalid attack
    end

    -- Server calculates damage (not the client!)
    local baseDamage = 25
    local multiplier = player.Character:FindFirstChild("Humanoid") and 1.0 or 0.5
    local actualDamage = baseDamage * multiplier

    -- Apply damage
    targetCharacter.Humanoid.Health = targetCharacter.Humanoid.Health - actualDamage
end)
```

### Example 2: Inventory System

```lua
-- CLIENT: Shows inventory UI
-- SERVER: Actually removes/adds items

-- SERVER
local takeItemEvent = ReplicatedStorage.TakeItemEvent

takeItemEvent.OnServerEvent:Connect(function(player, itemName)
    -- Server checks inventory
    if player.Inventory:FindFirstChild(itemName) then
        player.Inventory[itemName]:Destroy()
        print("Item removed")
    else
        print("Item not found!")
    end
end)
```

### Example 3: Shop System

```lua
-- CLIENT: Shows shop UI
-- SERVER: Validates purchase and awards item

-- SERVER
local buyItemEvent = ReplicatedStorage.BuyItemEvent

buyItemEvent.OnServerEvent:Connect(function(player, itemName)
    -- Server decides item price (not client!)
    local prices = {
        Sword = 100,
        Shield = 150,
        Potion = 50
    }

    local price = prices[itemName]

    if not price then
        warn("Invalid item:", itemName)
        return
    end

    -- Check if player can afford
    if player.leaderstats.Coins.Value >= price then
        player.leaderstats.Coins.Value = player.leaderstats.Coins.Value - price
        giveItemToPlayer(player, itemName)
        print(player.Name, "bought", itemName)
    else
        print(player.Name, "can't afford", itemName)
    end
end)
```

---

## Quiz Yourself

Before moving on, make sure you can answer:

1. What's the difference between a Script and a LocalScript?
   - Script runs on server (affects all players), LocalScript runs on each client (affects only that player)

2. Why do we say "never trust the client"?
   - Because clients can be exploited. Players can modify code/values on their computer. Only server validation is secure.

3. If I want to show a player's health bar, should that be client or server code?
   - Client (LocalScript in StarterGui). It's just UI for that player, doesn't affect gameplay.

4. If I want to subtract health when hit, should that be client or server code?
   - Server (Script in ServerScriptService). It affects gameplay and must be secure against exploiters.

5. What is replication?
   - Automatic synchronization. When the server changes something (like part color), Roblox automatically sends that change to all clients so they see the same thing.

6. What's a RemoteEvent used for?
   - Communication between client and server. Client fires it to ask the server to do something, server validates and performs the action.

---

## Next Steps

Now that you understand client-server architecture:

- **Read:** [Lua Basics](./lua-basics.md) - Learn the programming language
- **Read:** [How Roblox Works](./how-roblox-works.md) - Understand the game engine
- **Build:** [Examples 1-5](../README.md#example-projects) - Apply what you learned

**Remember:** This concept is CRITICAL. Every online game uses this pattern. Master it here, and you'll understand how games work everywhere!
