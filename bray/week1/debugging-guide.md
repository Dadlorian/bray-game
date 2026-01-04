# Debugging Guide for Fundamentals

**Purpose:** Master debugging techniques for core Lua and Roblox fundamentals. Understanding how to debug basic concepts is essential before tackling complex systems.

---

## Table of Contents

1. [Core Language Debugging](#core-language-debugging)
2. [Variable and Type Debugging](#variable-and-type-debugging)
3. [Table and Data Structure Issues](#table-and-data-structure-issues)
4. [Function Debugging](#function-debugging)
5. [Loop Debugging](#loop-debugging)
6. [Event System Debugging](#event-system-debugging)
7. [Common Fundamental Errors](#common-fundamental-errors)
8. [Systematic Problem-Solving](#systematic-problem-solving)

---

## Core Language Debugging

### Understanding Nil References

The most common fundamental error is nil reference. When a variable is nil but treated as if it contains a value:

```lua
-- ❌ WRONG: Assumes variable exists
local myVariable
print(myVariable.Property)  -- ERROR: attempt to index nil

-- ✅ CORRECT: Check before accessing
local myVariable
if myVariable then
    print(myVariable.Property)
else
    print("myVariable is nil!")
end
```

**Debugging Strategy:** Always print before accessing:

```lua
local myVariable = workspace:FindFirstChild("MissingPart")
print("myVariable type:", typeof(myVariable))  -- Will show "Instance" or "nil"
print("myVariable value:", myVariable)         -- Will show object or "nil"

if myVariable then
    print("Safe to access properties!")
else
    warn("Variable is nil - object doesn't exist!")
end
```

### String Concatenation Errors

A common mistake with strings and numbers:

```lua
-- ❌ WRONG: Can't concatenate string with number directly
local count = 5
print("Items: " .. count)  -- Works
print("Count is more than " .. 10)  -- ERROR if not careful

-- ✅ CORRECT: Use tostring()
local count = 5
local limit = 10
print("Count: " .. tostring(count) .. " / " .. tostring(limit))

-- ✅ BETTER: Use string.format()
print(string.format("Count: %d / %d", count, limit))
```

**Debugging Technique:** Add type checking before concatenation:

```lua
local function safeConcat(a, b)
    print("Type of a:", type(a), "| Type of b:", type(b))
    return tostring(a) .. tostring(b)
end

safeConcat(5, 10)     -- Works: "510"
safeConcat("hello", 5)  -- Works: "hello5"
```

### Boolean Logic Debugging

Incorrect boolean conditions are subtle bugs:

```lua
-- ❌ WRONG: Confusing not operator
local isEnabled = true
if not isEnabled = true then  -- Syntax error!
    print("This is confusing")
end

-- ✅ CORRECT: Use proper syntax
local isEnabled = true
if not isEnabled then
    print("isEnabled is false")
end

-- ✅ BETTER: Make boolean intent clear
local isEnabled = true
if isEnabled then
    print("Enabled")
else
    print("Disabled")
end
```

**Debugging print statements for boolean logic:**

```lua
local function debugBoolean(condition, label)
    label = label or "condition"
    local conditionStr = tostring(condition)
    local notStr = tostring(not condition)

    print(string.format("[BOOL] %s = %s | not %s = %s",
        label, conditionStr, label, notStr))
end

local isReady = false
debugBoolean(isReady, "isReady")
-- Output: [BOOL] isReady = false | not isReady = true
```

---

## Variable and Type Debugging

### Type Checking and Validation

Lua is dynamically typed, causing silent type mismatches:

```lua
-- ❌ WRONG: No type validation
function multiplyValue(x, y)
    return x * y  -- Crashes if x or y is string!
end

multiplyValue(5, 10)      -- Works
multiplyValue("5", "10")  -- ERROR: attempt to perform arithmetic

-- ✅ CORRECT: Validate types
function multiplyValue(x, y)
    if type(x) ~= "number" then
        error(string.format("x must be number, got %s", type(x)))
    end
    if type(y) ~= "number" then
        error(string.format("y must be number, got %s", type(y)))
    end

    return x * y
end

-- ✅ WITH DEBUG OUTPUT
function multiplyValueDebug(x, y)
    print("multiplyValue called with:")
    print("  x =", x, "| type:", type(x))
    print("  y =", y, "| type:", type(y))

    if type(x) ~= "number" or type(y) ~= "number" then
        return nil
    end

    local result = x * y
    print("  result =", result)
    return result
end
```

### Variable Scope Issues

Scope confusion causes "undefined variable" errors:

```lua
-- ❌ WRONG: Scope confusion
local myVariable = 5

function printVariable()
    print(myVariable)  -- Can access (closure)
end

function changeVariable()
    myVariable = 10  -- Changes global scope variable
end

-- ✅ CORRECT: Understand scope
local myVariable = 5

function printVariable()
    print("Outer variable:", myVariable)
end

function changeVariableLocal()
    local myVariable = 10  -- Creates NEW local variable
    print("Inner variable:", myVariable)  -- Prints 10
end

printVariable()          -- Prints 5
changeVariableLocal()    -- Prints 10
printVariable()          -- Still prints 5
```

**Debugging scope issues:**

```lua
local function debugScope()
    local localVar = "local"

    print("Before function definition:")
    print("  localVar:", localVar)

    local function innerFunction()
        print("Inside inner function:")
        print("  localVar:", localVar)  -- Can see outer variable
    end

    innerFunction()

    print("After inner function:")
    print("  localVar:", localVar)
end

debugScope()
```

---

## Table and Data Structure Issues

### Table Access Errors

Tables are error-prone when accessed with wrong keys:

```lua
-- ❌ WRONG: Case-sensitive key mismatch
local player = {
    Name = "Bray",
    Health = 100
}

print(player.name)   -- nil! Should be player.Name
print(player.health) -- nil! Should be player.Health

-- ✅ CORRECT: Exact key matching
print(player.Name)    -- "Bray"
print(player.Health)  -- 100

-- ✅ WITH DEBUG OUTPUT
local function debugTableAccess(table, key)
    print(string.format("Accessing table[%s]", key))

    local value = table[key]
    if value then
        print(string.format("  Found: %s = %s", key, tostring(value)))
    else
        print(string.format("  NOT FOUND: Key '%s' doesn't exist", key))
        print("  Available keys:")
        for k, v in pairs(table) do
            print(string.format("    - %s = %s", k, tostring(v)))
        end
    end

    return value
end

local player = {Name = "Bray", Health = 100}
debugTableAccess(player, "Name")
debugTableAccess(player, "name")
```

### Table Modification Errors

Modifying tables while iterating causes problems:

```lua
-- ❌ WRONG: Modifying while iterating
local items = {1, 2, 3, 4, 5}

for i, item in ipairs(items) do
    if item == 3 then
        table.remove(items, i)  -- Skips items!
    end
    print("Item:", item)
end

-- ✅ CORRECT: Collect first, modify second
local items = {1, 2, 3, 4, 5}
local toRemove = {}

for i, item in ipairs(items) do
    if item == 3 then
        table.insert(toRemove, i)
    end
    print("Item:", item)
end

for i = #toRemove, 1, -1 do  -- Remove in reverse!
    table.remove(items, toRemove[i])
end
```

### Nested Table Debugging

Debugging deeply nested tables requires careful inspection:

```lua
local player = {
    stats = {
        health = 100,
        mana = 50
    },
    inventory = {
        "sword",
        "shield"
    }
}

-- ❌ WRONG: Doesn't check intermediate tables
print(player.stats.health)  -- Works
print(player.missing.value) -- ERROR: attempt to index nil

-- ✅ CORRECT: Check each level
if player and player.stats then
    print(player.stats.health)
else
    print("Stats not found!")
end

-- ✅ DEBUGGING FUNCTION
local function getNestedValue(table, path)
    print("Getting path:", path)

    local current = table
    local keys = {}

    for key in path:gmatch("[^%.]+") do
        table.insert(keys, key)
    end

    for i, key in ipairs(keys) do
        print(string.rep("  ", i) .. "Checking key:", key)

        if type(current) == "table" then
            current = current[key]
            if current then
                print(string.rep("  ", i) .. "Found:", current)
            else
                print(string.rep("  ", i) .. "NOT FOUND!")
                return nil
            end
        else
            print(string.rep("  ", i) .. "Current is not a table!")
            return nil
        end
    end

    return current
end

getNestedValue(player, "stats.health")
getNestedValue(player, "stats.mana.max")
```

---

## Function Debugging

### Function Argument Issues

Wrong number or type of arguments is a common error:

```lua
-- ❌ WRONG: No argument validation
function divide(a, b)
    return a / b  -- Crashes if b is 0 or nil!
end

divide(10, 2)      -- Works: 5
divide(10)         -- ERROR: attempt to perform arithmetic on nil
divide(10, 0)      -- ERROR: attempt to divide by zero

-- ✅ CORRECT: Validate arguments
function divide(a, b)
    if type(a) ~= "number" then
        error("First argument must be number")
    end
    if type(b) ~= "number" then
        error("Second argument must be number")
    end
    if b == 0 then
        error("Cannot divide by zero")
    end

    return a / b
end

-- ✅ WITH DEBUGGING
function divideDebug(a, b)
    print("divide called with", #({a, b}), "arguments")
    print("  a =", a, "type:", type(a))
    print("  b =", b, "type:", type(b))

    if not a or not b then
        print("ERROR: Missing arguments!")
        return nil
    end

    if b == 0 then
        print("ERROR: Division by zero!")
        return nil
    end

    local result = a / b
    print("  result =", result)
    return result
end
```

### Return Value Debugging

Functions that return multiple values or no values can confuse:

```lua
-- ❌ WRONG: Doesn't check for multiple returns
local function getPlayerStats(playerName)
    -- Sometimes returns two values, sometimes one!
    if playerName == "Bray" then
        return 100, 50  -- health, mana
    else
        return nil
    end
end

local health, mana = getPlayerStats("Bray")
print(health, mana)  -- 100, 50

local health, mana = getPlayerStats("Unknown")
print(health, mana)  -- nil, nil

-- ✅ CORRECT: Clear return pattern
local function getPlayerStatsSafe(playerName)
    if playerName == "Bray" then
        return {health = 100, mana = 50}
    else
        return {health = 0, mana = 0}
    end
end

local stats = getPlayerStatsSafe("Bray")
print("Health:", stats.health, "Mana:", stats.mana)

-- ✅ DEBUGGING RETURNS
local function getPlayerStatsDebug(playerName)
    print("Getting stats for:", playerName)

    local stats
    if playerName == "Bray" then
        stats = {health = 100, mana = 50}
    else
        stats = nil
    end

    if stats then
        print("Stats found: health =", stats.health, "| mana =", stats.mana)
    else
        print("Stats not found!")
    end

    return stats
end
```

---

## Loop Debugging

### Infinite Loop Prevention

Infinite loops without yield freeze the game:

```lua
-- ❌ WRONG: Infinite loop, no yield
while true do
    print("Running")
    -- No wait = freezes entire game!
end

-- ✅ CORRECT: Add yield
while true do
    print("Running")
    task.wait()  -- Yield to next frame
end

-- ✅ WITH ITERATION LIMIT FOR DEBUGGING
local maxIterations = 100
local iterations = 0

while iterations < maxIterations do
    print("Iteration:", iterations)
    iterations = iterations + 1
    task.wait(0.1)
end

print("Loop completed:", iterations, "iterations")
```

### Loop Condition Issues

Off-by-one errors and wrong conditions cause bugs:

```lua
-- ❌ WRONG: Off-by-one errors
local count = 0
while count < 5 do
    print(count)  -- Prints 0, 1, 2, 3, 4 (5 times)
    count = count + 1
end

-- ❌ WRONG: Infinite loop with wrong condition
local count = 0
while count >= 0 do
    count = count + 1  -- Always true!
end

-- ✅ CORRECT: Debug condition
local count = 0
while count < 5 do
    print("Iteration", count, "| condition (count < 5):", count < 5)
    count = count + 1
end
```

### Loop Performance Debugging

Slow loops reveal inefficiency:

```lua
-- ❌ WRONG: Expensive operation in loop
local result = 0
for i = 1, 10000 do
    local expensive = math.sqrt(i)  -- Recalculates every iteration
    result = result + expensive
end

-- ✅ CORRECT: Calculate once if possible
local result = 0
local sqrtFunc = math.sqrt  -- Cache function
for i = 1, 10000 do
    result = result + sqrtFunc(i)
end

-- ✅ DEBUGGING LOOP PERFORMANCE
local startTime = os.clock()
local iterations = 0

local loopStart = os.clock()
while os.clock() - loopStart < 0.1 do
    iterations = iterations + 1
    -- Do work
end

local totalTime = os.clock() - startTime
print(string.format("Completed %d iterations in %.3f seconds", iterations, totalTime))
```

---

## Event System Debugging

### Event Connection Issues

Events that don't fire indicate connection problems:

```lua
-- ❌ WRONG: Event not connected
local part = workspace.Part

-- Event created but nothing listening!
part.Touched

-- ✅ CORRECT: Connect to event
local part = workspace.Part
local connection = part.Touched:Connect(function(otherPart)
    print("Touched by:", otherPart.Name)
end)

-- ✅ DEBUGGING EVENT
local function debugEventConnection(event, eventName)
    print("Connecting to:", eventName)

    local fired = false
    local connection = event:Connect(function(...)
        fired = true
        print("EVENT FIRED:", eventName)
        print("  Arguments:", ...)
    end)

    print("Connected to", eventName)

    task.wait(5)

    if not fired then
        warn("EVENT DID NOT FIRE:", eventName)
    end

    connection:Disconnect()
end

local part = workspace:FindFirstChild("Part")
if part then
    debugEventConnection(part.Touched, "Part.Touched")
end
```

### Event Disconnection Issues

Forgetting to disconnect events causes memory leaks:

```lua
-- ❌ WRONG: Never disconnects
local part = workspace.Part
part.Touched:Connect(function(other)
    print("Touched!")
    -- No disconnect = keeps firing forever!
end)

-- ✅ CORRECT: Manage connections
local part = workspace.Part
local connection

function setupTouchEvent()
    if connection then
        connection:Disconnect()
    end

    connection = part.Touched:Connect(function(other)
        print("Touched!")
    end)
end

function cleanupTouchEvent()
    if connection then
        connection:Disconnect()
        print("Event disconnected")
    end
end

-- Usage
setupTouchEvent()
-- Later...
cleanupTouchEvent()
```

---

## Common Fundamental Errors

### "attempt to index nil with [key]"

The most common Lua error:

```lua
-- Cause: Accessing property of nil
local value = workspace:FindFirstChild("NonExistent")
print(value.Property)  -- ERROR!

-- Solution: Check before access
if value then
    print(value.Property)
else
    print("Value is nil!")
end
```

### "attempt to call a nil value"

Calling something that isn't a function:

```lua
-- Cause: Function doesn't exist
local myFunc = nil
myFunc()  -- ERROR!

-- Solution: Check if function exists
if type(myFunc) == "function" then
    myFunc()
else
    print("myFunc is not a function!")
end
```

### "infinite yield possible on 'X:WaitForChild(Y)'"

Waiting for something that never appears:

```lua
-- Cause: Object name wrong or doesn't exist
local part = workspace:WaitForChild("WrongName")  -- Waits forever

-- Solution: Add timeout
local part = workspace:WaitForChild("Part", 5)
if part then
    print("Part found!")
else
    print("Part not found after 5 seconds!")
end
```

---

## Systematic Problem-Solving

### The Debug Workflow

When code doesn't work:

1. **Add print statements** at key points
2. **Check output window** for errors
3. **Verify types** match expectations
4. **Test in isolation** with simple values
5. **Narrow down** the exact problematic line
6. **Fix and verify**

```lua
local function debugWorkflow()
    print("[1] Starting function")

    local value = workspace:FindFirstChild("MyPart")
    print("[2] Found part:", value)

    if not value then
        print("[ERROR] Part doesn't exist!")
        return
    end

    print("[3] Part exists, accessing property")
    print("[4] Part position:", value.Position)

    print("[5] Done")
end

debugWorkflow()
```

### Creating Minimal Reproductions

Isolate problems to smallest code snippet:

```lua
-- Full code: 50 lines, hard to debug

-- Minimal reproduction: 5 lines, easy to debug
local x = nil
local y = x + 5  -- ERROR: attempt to perform arithmetic on nil

-- Now I can fix it:
local x = 0
local y = x + 5  -- Works
```

---

## Professional Debugging Checklist

- [ ] Added print statement showing entry to function
- [ ] Printed variable values before using them
- [ ] Checked Output window for error messages
- [ ] Verified variable types match expectations
- [ ] Checked for nil values before accessing properties
- [ ] Verified loop conditions and yield statements
- [ ] Tested with simple input values
- [ ] Removed debug code once fixed

---

**Pro Tip:** Save debugging code in commented blocks during development. You'll need it again for the next bug!

**Remember:** Debugging fundamentals well saves time on complex systems later. Master these patterns now.

---

*Last Updated: 2025-11-19*
*Word Count: 1450*
