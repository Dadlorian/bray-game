# Lua Basics - The Programming Language

**What pros call it:** "Lua syntax and semantics" or just "Lua fundamentals"

**What it actually means:** The grammar and vocabulary of the Lua programming language - how to write instructions that the computer understands.

**Why Lua:** Roblox uses Lua because it's fast, simple, and designed for embedding in applications. Learning Lua teaches you programming concepts that work in ANY language (JavaScript, Python, C#, etc.).

---

## Table of Contents

1. [Comments](#comments)
2. [Variables](#variables)
3. [Data Types](#data-types)
4. [Operators](#operators)
5. [Conditionals](#conditionals)
6. [Loops](#loops)
7. [Functions](#functions)
8. [Tables](#tables)
9. [Scope](#scope)
10. [Common Patterns](#common-patterns)

---

## Comments

**What pros call it:** "Code comments" or "inline documentation"

**What they are:** Text in your code that the computer ignores - just for humans to read.

### Single-line Comments

```lua
-- This is a comment
print("Hello")  -- This is also a comment (after code)
```

**When to use:** Explain WHY you're doing something, not WHAT you're doing.

```lua
-- ❌ BAD - comment just repeats the code
local speed = 16  -- Set speed to 16

-- ✅ GOOD - comment explains WHY
local speed = 16  -- Default walk speed for Roblox characters
```

---

### Multi-line Comments

```lua
--[[
This is a multi-line comment.
Everything between --[[ and ]] is ignored.
Useful for temporarily disabling code or writing long explanations.
]]

print("This runs")

--[[
print("This doesn't run - it's commented out")
print("Neither does this")
]]
```

**Pro use case:** Commenting out code blocks during debugging.

---

## Variables

**What pros call it:** "Variable declaration" and "assignment"

**What they are:** Named storage for values. Like labeled boxes where you put data.

### Creating Variables

```lua
local name = "Bray"  -- String (text)
local age = 13       -- Number
local isStudent = true  -- Boolean (true/false)
```

**Syntax breakdown:**
- `local` = Creates a local variable (scope-limited, explained later)
- `name` = Variable name (identifier)
- `=` = Assignment operator (puts value in variable)
- `"Bray"` = The value

---

### Variable Naming Rules

**Rules (must follow):**
- Start with letter or underscore: `name`, `_private`, `player1` ✅
- Can contain letters, numbers, underscores: `player1`, `max_health` ✅
- Cannot start with number: `1player` ❌
- Cannot use reserved words: `local`, `if`, `then`, etc. ❌
- Case-sensitive: `Player` ≠ `player` ≠ `PLAYER`

**Conventions (professional style):**
- Use `camelCase` for variables: `maxHealth`, `playerName`, `isAlive`
- Use `PascalCase` for classes: `PlayerManager`, `WeaponSystem`
- Use `SCREAMING_SNAKE_CASE` for constants: `MAX_PLAYERS`, `DEFAULT_SPEED`
- Use descriptive names: `playerHealth` not `ph`

```lua
-- ✅ GOOD - Clear, readable
local playerHealth = 100
local maxPlayers = 10
local isGameActive = false

-- ❌ BAD - Vague, confusing
local ph = 100
local x = 10
local flag = false
```

**Pro insight:** Code is read 10x more than it's written. Spend time on good names!

---

### The `local` Keyword

**Critical:** ALWAYS use `local` when creating variables!

```lua
-- ✅ GOOD - Local variable
local speed = 16

-- ❌ BAD - Global variable (pollutes global scope)
speed = 16
```

**Why it matters:**
- Local variables are faster
- Local variables don't conflict with other scripts
- Global variables cause hard-to-find bugs

**Pro term:** Using `local` creates "lexically scoped variables" (scope explained later).

---

### nil (Nothing)

**What it is:** The absence of a value.

```lua
local something  -- Automatically nil (no value assigned)
print(something)  -- nil

local player = game.Players:FindFirstChild("Bob")
if player == nil then
    print("Player not found")
end

-- Shorter way to check nil
if not player then
    print("Player not found")
end
```

**Pro insight:** `nil` is how Lua represents "nothing" or "doesn't exist". Many bugs come from trying to use nil values!

---

## Data Types

**What pros call it:** "Primitive types" and "value types"

Lua has 8 data types. Here are the most important:

### 1. nil

**What it is:** Nothing, null, absence of value.

```lua
local x  -- nil
local y = nil  -- explicitly nil
```

---

### 2. boolean

**What it is:** True or false.

```lua
local isAlive = true
local isDead = false

-- Boolean expressions
local canJump = player.Health > 0
local isGrounded = character.Humanoid.FloorMaterial ~= Enum.Material.Air
```

**Pro tip:** In conditionals, `nil` and `false` are "falsy" (treated as false). Everything else is "truthy" (treated as true).

```lua
if 0 then
    print("This runs! 0 is truthy")
end

if "" then
    print("This runs! Empty string is truthy")
end

if nil then
    print("This doesn't run - nil is falsy")
end
```

---

### 3. number

**What it is:** Integers and decimals (floats).

```lua
local age = 13              -- Integer
local pi = 3.14159          -- Float
local speed = 16.5          -- Float
local negative = -10        -- Negative
local scientific = 1.5e10   -- Scientific notation (15,000,000,000)
```

**Pro insight:** Lua doesn't distinguish between int and float - all numbers are double-precision floats internally.

---

### 4. string

**What it is:** Text.

```lua
local name = "Bray"
local message = 'Hello, world!'  -- Single or double quotes
local empty = ""
```

**String concatenation (joining):**

```lua
local first = "Hello"
local last = "World"
local full = first .. " " .. last  -- "Hello World"

-- Concatenating with numbers
local score = 100
local text = "Score: " .. score  -- "Score: 100"
-- Lua automatically converts number to string
```

**Pro term:** `..` is called the **concatenation operator**.

---

**String length:**

```lua
local name = "Bray"
print(#name)  -- 4

-- Works with empty strings
print(#"")  -- 0
```

**Pro term:** `#` is called the **length operator**.

---

**String methods:**

```lua
local text = "Hello, World!"

-- Uppercase/Lowercase
print(string.upper(text))  -- "HELLO, WORLD!"
print(string.lower(text))  -- "hello, world!"

-- Substring (portion of string)
print(string.sub(text, 1, 5))  -- "Hello" (characters 1-5)
print(string.sub(text, 8))     -- "World!" (from character 8 to end)

-- Find text
local pos = string.find(text, "World")  -- Returns 8 (position where "World" starts)

-- Replace text
local newText = string.gsub(text, "World", "Bray")  -- "Hello, Bray!"

-- Length (alternative)
print(string.len(text))  -- 13
```

**Modern way (method syntax):**

```lua
local text = "Hello"

-- Instead of: string.upper(text)
-- You can: text:upper()

print(text:upper())  -- "HELLO"
print(text:lower())  -- "hello"
print(text:sub(1, 4))  -- "Hell"
```

**Pro tip:** Both ways work, but method syntax (`:`) is more modern and readable.

---

**Multi-line strings:**

```lua
local longText = [[
This is a multi-line string.
It preserves line breaks.
Useful for big chunks of text.
]]

print(longText)
```

---

**String interpolation (formatting):**

```lua
local name = "Bray"
local age = 13

-- Old way - concatenation
local message = "My name is " .. name .. " and I am " .. age .. " years old."

-- Better way - string.format
local message = string.format("My name is %s and I am %d years old.", name, age)

-- Placeholders:
-- %s = string
-- %d = integer
-- %f = float
-- %.2f = float with 2 decimal places

local pi = 3.14159
print(string.format("Pi: %.2f", pi))  -- "Pi: 3.14"
```

**Pro term:** This is called **string formatting** or **string interpolation**.

---

### 5. function

**What it is:** A reusable block of code (explained in detail later).

```lua
local function greet(name)
    print("Hello, " .. name)
end

greet("Bray")  -- Calls the function
```

---

### 6. table

**What it is:** Lua's Swiss Army knife - can be array, dictionary, object, class, etc. (explained in detail later).

```lua
local colors = {"Red", "Green", "Blue"}  -- Array
local player = {name = "Bray", health = 100}  -- Dictionary
```

---

### 7. userdata

**What it is:** Roblox objects (Instances).

```lua
local part = workspace.Part  -- userdata (a Roblox Instance)
```

**Pro insight:** You can't create userdata in Lua - only Roblox can. Instances, CFrames, Vector3s, etc. are all userdata.

---

### 8. thread

**What it is:** Coroutines (advanced, explained later if needed).

---

### Type Checking

**Get the type of a value:**

```lua
local x = 5
print(type(x))  -- "number"

local name = "Bray"
print(type(name))  -- "string"

local flag = true
print(type(flag))  -- "boolean"

local nothing = nil
print(type(nothing))  -- "nil"

local part = workspace.Part
print(type(part))  -- "userdata"
```

**Pro term:** `type()` is a **reflection function** - it tells you about the code itself.

---

## Operators

**What pros call it:** "Operators and expressions"

### Arithmetic Operators (Math)

```lua
local a = 10
local b = 3

print(a + b)   -- 13 (addition)
print(a - b)   -- 7  (subtraction)
print(a * b)   -- 30 (multiplication)
print(a / b)   -- 3.333... (division)
print(a % b)   -- 1  (modulo - remainder after division)
print(a ^ b)   -- 1000 (exponentiation - 10^3)
print(-a)      -- -10 (negation)
```

**Pro insight:** Modulo (`%`) is super useful for cycles:

```lua
-- Make a number loop 0-9
for i = 0, 20 do
    print(i % 10)  -- 0,1,2,3,4,5,6,7,8,9,0,1,2,3...
end

-- Check if even/odd
if number % 2 == 0 then
    print("Even")
else
    print("Odd")
end
```

---

### Comparison Operators

```lua
local a = 5
local b = 10

print(a == b)   -- false (equal to)
print(a ~= b)   -- true  (not equal to)
print(a < b)    -- true  (less than)
print(a > b)    -- false (greater than)
print(a <= b)   -- true  (less than or equal)
print(a >= b)   -- false (greater than or equal)
```

**Important:** Use `==` for comparison, not `=`!

```lua
-- ❌ WRONG
if x = 5 then  -- ERROR! This is assignment, not comparison

-- ✅ RIGHT
if x == 5 then  -- Comparison
```

---

### Logical Operators

```lua
local a = true
local b = false

print(a and b)  -- false (both must be true)
print(a or b)   -- true  (at least one must be true)
print(not a)    -- false (opposite of a)

-- Short-circuit evaluation
local x = 5
if x > 0 and x < 10 then
    print("x is between 0 and 10")
end

-- Combining conditions
local age = 13
local hasPermission = true
if age >= 13 and hasPermission then
    print("Can play")
end
```

**Pro insight:** `and` and `or` short-circuit:

```lua
-- If first is false, second never runs
local result = false and print("This never prints")

-- If first is true, second never runs
local result = true or print("This never prints")
```

**Practical use - default values:**

```lua
-- If config is nil, use 100
local health = config or 100

-- More explicitly:
local health = config ~= nil and config or 100
```

---

### Operator Precedence (Order of Operations)

Like math, operators have an order:

1. `^` (exponentiation)
2. `not`, `-` (unary negation)
3. `*`, `/`, `%`
4. `+`, `-`
5. `..` (concatenation)
6. `<`, `>`, `<=`, `>=`, `==`, `~=`
7. `and`
8. `or`

**When in doubt, use parentheses!**

```lua
local result = 2 + 3 * 4      -- 14 (multiplication first)
local result = (2 + 3) * 4    -- 20 (parentheses first)

local check = 5 > 3 and 10 < 20   -- true
local check = (5 > 3) and (10 < 20)  -- Same, but clearer
```

---

## Conditionals

**What pros call it:** "Control flow" or "conditional logic"

**What they are:** Making decisions in code - "if this, then that."

### if Statement

```lua
local health = 50

if health > 0 then
    print("Player is alive")
end
```

**Syntax:**
- `if` = keyword
- `health > 0` = condition (boolean expression)
- `then` = keyword (required in Lua!)
- Code block
- `end` = keyword (closes the if)

---

### if-else

```lua
local health = 0

if health > 0 then
    print("Alive")
else
    print("Dead")
end
```

---

### if-elseif-else

```lua
local health = 50

if health > 75 then
    print("Healthy")
elseif health > 25 then
    print("Injured")
elseif health > 0 then
    print("Critical")
else
    print("Dead")
end
```

**Pro tip:** Order matters! First true condition wins.

```lua
local score = 90

-- ❌ BAD - "Good" never triggers
if score > 0 then
    print("You scored")  -- This runs
elseif score > 50 then
    print("Good")  -- Never runs (first condition already true)
elseif score > 75 then
    print("Great")  -- Never runs
end

-- ✅ GOOD - Most specific first
if score > 75 then
    print("Great")
elseif score > 50 then
    print("Good")
elseif score > 0 then
    print("You scored")
end
```

---

### Nested if Statements

```lua
local age = 13
local hasPermission = true

if age >= 13 then
    if hasPermission then
        print("Can play")
    else
        print("Need permission")
    end
else
    print("Too young")
end

-- Better: combine with 'and'
if age >= 13 and hasPermission then
    print("Can play")
elseif age >= 13 then
    print("Need permission")
else
    print("Too young")
end
```

**Pro tip:** Avoid deep nesting - it gets hard to read. Combine conditions or use functions.

---

### Truthy and Falsy

In Lua, `nil` and `false` are **falsy**. Everything else is **truthy**.

```lua
if 0 then print("Truthy") end           -- Runs! (0 is truthy)
if "" then print("Truthy") end          -- Runs! (empty string is truthy)
if nil then print("Truthy") end         -- Doesn't run (nil is falsy)
if false then print("Truthy") end       -- Doesn't run (false is falsy)

-- Practical use
local player = game.Players:FindFirstChild("Bob")
if player then
    -- Player exists (truthy)
    print(player.Name)
else
    -- Player is nil (falsy)
    print("Not found")
end
```

---

## Loops

**What pros call it:** "Iteration" or "looping constructs"

**What they are:** Repeating code multiple times.

### while Loop

**Runs while condition is true:**

```lua
local count = 1

while count <= 5 do
    print(count)
    count = count + 1
end
-- Prints: 1, 2, 3, 4, 5
```

**Critical:** Make sure the condition eventually becomes false, or you get an infinite loop!

```lua
-- ❌ INFINITE LOOP - freezes Studio
while true do
    print("Forever!")
end

-- ✅ INFINITE LOOP - Safe (has wait)
while true do
    print("Safe forever")
    wait(1)  -- Yields (pauses) for 1 second
end
```

**Pro term:** `wait()` is called a **yield function** - it pauses execution and lets other code run.

---

### repeat-until Loop

**Runs at least once, then checks condition:**

```lua
local count = 1

repeat
    print(count)
    count = count + 1
until count > 5
-- Prints: 1, 2, 3, 4, 5
```

**Difference from while:**
- `while` checks condition BEFORE running
- `repeat-until` checks condition AFTER running (guaranteed to run at least once)

**Pro use case:** Rare in practice - `while` and `for` are more common.

---

### for Loop (Numeric)

**Runs a specific number of times:**

```lua
for i = 1, 5 do
    print(i)
end
-- Prints: 1, 2, 3, 4, 5
```

**Syntax:**
```lua
for variable = start, finish, step do
    -- code
end
```

**Examples:**

```lua
-- Count up by 1 (default step)
for i = 1, 10 do
    print(i)
end

-- Count down
for i = 10, 1, -1 do
    print(i)
end

-- Count by 2
for i = 0, 10, 2 do
    print(i)  -- 0, 2, 4, 6, 8, 10
end

-- Start at 0
for i = 0, 4 do
    print(i)  -- 0, 1, 2, 3, 4
end
```

**Pro tip:** The loop variable (`i`) is automatically local to the loop:

```lua
for i = 1, 5 do
    print(i)
end
print(i)  -- nil (i doesn't exist outside loop)
```

---

### for Loop (Generic - Iterating Tables)

**Iterates over table elements:**

```lua
local colors = {"Red", "Green", "Blue"}

for index, value in ipairs(colors) do
    print(index, value)
end
-- Prints:
-- 1 Red
-- 2 Green
-- 3 Blue
```

**For dictionaries:**

```lua
local player = {
    name = "Bray",
    health = 100,
    level = 5
}

for key, value in pairs(player) do
    print(key, value)
end
-- Prints (order not guaranteed):
-- name Bray
-- health 100
-- level 5
```

**Differences:**
- `ipairs()` = Array iteration (stops at first nil)
- `pairs()` = Dictionary iteration (all key-value pairs)

**Pro insight:** `ipairs` is faster for arrays, `pairs` works for any table.

---

### Breaking Out of Loops

**break - Exit loop immediately:**

```lua
for i = 1, 10 do
    if i == 5 then
        break  -- Exit loop
    end
    print(i)
end
-- Prints: 1, 2, 3, 4 (stops at 5)
```

**continue doesn't exist in Lua!**

```lua
-- ❌ This doesn't work (Lua has no continue)
for i = 1, 10 do
    if i % 2 == 0 then
        continue  -- ERROR!
    end
    print(i)
end

-- ✅ Workaround - use if to skip
for i = 1, 10 do
    if i % 2 == 1 then  -- Only run for odd numbers
        print(i)
    end
end
```

---

## Functions

**What pros call it:** "Function definition and invocation" or "procedures"

**What they are:** Reusable blocks of code with a name.

### Basic Function

```lua
local function greet()
    print("Hello!")
end

greet()  -- Calls the function
```

**Syntax:**
- `local function` = Keywords (creates local function)
- `greet` = Function name
- `()` = Parameters (empty here)
- Code block
- `end` = Closes function

---

### Functions with Parameters

```lua
local function greet(name)
    print("Hello, " .. name .. "!")
end

greet("Bray")    -- Hello, Bray!
greet("World")   -- Hello, World!
```

**Multiple parameters:**

```lua
local function add(a, b)
    print(a + b)
end

add(5, 3)  -- 8
add(10, 20)  -- 30
```

**Pro term:** Parameters are also called "arguments" or "formal parameters."

---

### Return Values

**Functions can send values back:**

```lua
local function add(a, b)
    return a + b
end

local result = add(5, 3)
print(result)  -- 8

-- Use directly in expressions
print(add(10, 20))  -- 30

-- Multiple return values
local function getPlayerInfo()
    return "Bray", 13, 100  -- name, age, health
end

local name, age, health = getPlayerInfo()
print(name, age, health)  -- Bray 13 100
```

**Pro insight:** Lua functions can return multiple values (uncommon in most languages)!

---

### Early Return

```lua
local function divide(a, b)
    if b == 0 then
        return nil  -- Can't divide by zero
    end
    return a / b
end

print(divide(10, 2))  -- 5
print(divide(10, 0))  -- nil
```

**Pro pattern:** Check for errors early and return, then handle the main logic.

```lua
-- ❌ Nested conditions
local function processPlayer(player)
    if player then
        if player.Character then
            if player.Character.Humanoid then
                player.Character.Humanoid.Health = 100
            end
        end
    end
end

-- ✅ Guard clauses (early returns)
local function processPlayer(player)
    if not player then return end
    if not player.Character then return end
    if not player.Character.Humanoid then return end

    player.Character.Humanoid.Health = 100
end
```

**Pro term:** Early returns are called **guard clauses** - they guard against bad input.

---

### Default Parameters

Lua doesn't have native default parameters, but you can simulate them:

```lua
local function greet(name)
    name = name or "Guest"  -- If name is nil, use "Guest"
    print("Hello, " .. name)
end

greet("Bray")  -- Hello, Bray
greet()        -- Hello, Guest
```

---

### Variable Parameters

**Functions can accept any number of arguments:**

```lua
local function sum(...)
    local args = {...}  -- Pack into table
    local total = 0
    for i, value in ipairs(args) do
        total = total + value
    end
    return total
end

print(sum(1, 2, 3))        -- 6
print(sum(10, 20, 30, 40)) -- 100
```

**Pro term:** `...` is called **varargs** (variable arguments).

---

### Anonymous Functions

**Functions without names:**

```lua
-- Assigned to variable
local greet = function(name)
    print("Hello, " .. name)
end

greet("Bray")

-- Used directly (common for events)
part.Touched:Connect(function(otherPart)
    print("Touched:", otherPart.Name)
end)
```

**Pro term:** Anonymous functions are also called **lambda functions** or **closures**.

---

### Function Scope and Closures

**Functions can access variables from outer scope:**

```lua
local function makeCounter()
    local count = 0  -- Local to makeCounter

    return function()
        count = count + 1
        return count
    end
end

local counter1 = makeCounter()
print(counter1())  -- 1
print(counter1())  -- 2
print(counter1())  -- 3

local counter2 = makeCounter()
print(counter2())  -- 1 (separate counter)
```

**Pro term:** This is called a **closure** - the inner function "closes over" the outer function's variables.

**Pro insight:** Closures are powerful but confusing at first. They're used for encapsulation and creating private state.

---

## Tables

**What pros call it:** "Tables", "dictionaries", "arrays", "hash maps" (depending on use)

**What they are:** Lua's only data structure - incredibly versatile.

### Arrays (Indexed Tables)

**List of values, accessed by number:**

```lua
local colors = {"Red", "Green", "Blue"}

print(colors[1])  -- "Red" (Lua arrays start at 1, not 0!)
print(colors[2])  -- "Green"
print(colors[3])  -- "Blue"

-- Length
print(#colors)  -- 3
```

**Important:** Lua arrays start at index 1, not 0 (unlike most languages)!

---

**Adding elements:**

```lua
local fruits = {"Apple", "Banana"}

table.insert(fruits, "Orange")  -- Add to end
print(fruits[3])  -- "Orange"

table.insert(fruits, 1, "Grape")  -- Insert at position 1
print(fruits[1])  -- "Grape"
```

**Removing elements:**

```lua
local fruits = {"Apple", "Banana", "Orange"}

table.remove(fruits, 2)  -- Remove "Banana"
print(fruits[2])  -- "Orange" (shifted down)

local last = table.remove(fruits)  -- Remove last element
print(last)  -- "Orange"
```

---

**Iterating arrays:**

```lua
local colors = {"Red", "Green", "Blue"}

-- Method 1: ipairs
for i, color in ipairs(colors) do
    print(i, color)
end

-- Method 2: numeric for (if you just need values)
for i = 1, #colors do
    print(colors[i])
end
```

---

### Dictionaries (Associative Tables)

**Key-value pairs:**

```lua
local player = {
    name = "Bray",
    health = 100,
    level = 5
}

print(player.name)    -- "Bray"
print(player.health)  -- 100

-- Alternative syntax
print(player["name"])  -- "Bray"
```

**Adding/modifying:**

```lua
player.score = 1000  -- Add new key
player.health = 50   -- Modify existing key

print(player.score)  -- 1000
```

**Removing:**

```lua
player.score = nil  -- Remove key
print(player.score)  -- nil
```

---

**Iterating dictionaries:**

```lua
local player = {name = "Bray", health = 100, level = 5}

for key, value in pairs(player) do
    print(key, value)
end
-- Prints (order not guaranteed):
-- name Bray
-- health 100
-- level 5
```

**Pro insight:** Dictionary order is NOT guaranteed. Don't rely on it!

---

### Mixed Tables

**Tables can be both array and dictionary:**

```lua
local data = {
    "First",     -- [1]
    "Second",    -- [2]
    name = "Bray",
    age = 13
}

print(data[1])      -- "First"
print(data[2])      -- "Second"
print(data.name)    -- "Bray"
print(data.age)     -- 13
```

**Pro warning:** Mixing can be confusing. Best to use either array OR dictionary, not both.

---

### Nested Tables

**Tables inside tables:**

```lua
local game = {
    players = {
        {name = "Bray", score = 100},
        {name = "Alice", score = 200},
        {name = "Bob", score = 150}
    },
    settings = {
        maxPlayers = 10,
        gameMode = "FFA"
    }
}

print(game.players[1].name)   -- "Bray"
print(game.players[2].score)  -- 200
print(game.settings.maxPlayers)  -- 10
```

**Pro insight:** This is how you represent complex data structures (JSON-like data).

---

### Table Methods

```lua
local t = {"A", "B", "C"}

-- Insert
table.insert(t, "D")        -- Add to end
table.insert(t, 1, "Z")     -- Insert at position 1

-- Remove
table.remove(t)             -- Remove last
table.remove(t, 2)          -- Remove at position 2

-- Concatenate (join into string)
local str = table.concat(t, ", ")  -- "Z, A, B, C"

-- Sort
local numbers = {5, 2, 8, 1, 9}
table.sort(numbers)
-- numbers is now {1, 2, 5, 8, 9}

-- Sort with custom comparator
table.sort(numbers, function(a, b)
    return a > b  -- Sort descending
end)
-- numbers is now {9, 8, 5, 2, 1}
```

---

### Table References (Important!)

**Tables are reference types, not value types:**

```lua
local t1 = {1, 2, 3}
local t2 = t1  -- t2 points to SAME table as t1

t2[1] = 999

print(t1[1])  -- 999 (changed!)
print(t2[1])  -- 999

-- They're the same table
print(t1 == t2)  -- true
```

**To copy a table:**

```lua
-- Shallow copy (only top level)
local function shallowCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end

local t1 = {1, 2, 3}
local t2 = shallowCopy(t1)
t2[1] = 999
print(t1[1])  -- 1 (not changed)
```

**Pro insight:** This is a common source of bugs! Understanding references is critical.

---

## Scope

**What pros call it:** "Lexical scope" or "variable scope"

**What it means:** Where in your code a variable is accessible.

### Global Scope

**Variables without `local`:**

```lua
myGlobal = "Everyone can see this"

-- In another script, this works:
print(myGlobal)  -- "Everyone can see this"
```

**❌ AVOID GLOBALS!** They cause bugs and conflicts.

---

### Local Scope

**Variables with `local`:**

```lua
local myLocal = "Only this script can see this"

-- In another script:
print(myLocal)  -- nil (doesn't exist)
```

---

### Block Scope

**Variables inside blocks:**

```lua
if true then
    local x = 10
    print(x)  -- 10
end
print(x)  -- nil (x doesn't exist outside the if block)

for i = 1, 5 do
    local y = i * 2
    print(y)  -- Works here
end
print(y)  -- nil (y doesn't exist outside the loop)
```

**Pro insight:** Always use the narrowest scope possible. If a variable is only needed in a loop, declare it in the loop.

---

### Function Scope

```lua
local function myFunction()
    local x = 10
    print(x)  -- 10
end

myFunction()
print(x)  -- nil (x only exists inside the function)
```

---

### Shadowing

**Inner scope can "shadow" (hide) outer scope:**

```lua
local x = 10

if true then
    local x = 20  -- Different variable!
    print(x)  -- 20
end

print(x)  -- 10
```

**Pro warning:** Shadowing can be confusing. Use different names when possible.

---

## Common Patterns

### The Module Pattern

**Creating reusable code libraries:**

```lua
-- In ReplicatedStorage.MyLibrary (ModuleScript)
local MyLibrary = {}

function MyLibrary.greet(name)
    print("Hello, " .. name)
end

function MyLibrary.add(a, b)
    return a + b
end

return MyLibrary

-- In another script
local MyLibrary = require(game.ReplicatedStorage.MyLibrary)
MyLibrary.greet("Bray")  -- Hello, Bray
local sum = MyLibrary.add(5, 3)  -- 8
```

**Pro term:** This is the **module pattern** - standard way to organize code in Roblox.

---

### The Object Pattern

**Creating objects with methods:**

```lua
local Player = {}
Player.__index = Player

function Player.new(name, health)
    local self = setmetatable({}, Player)
    self.name = name
    self.health = health
    return self
end

function Player:takeDamage(amount)
    self.health = self.health - amount
    print(self.name .. " took " .. amount .. " damage!")
end

-- Usage
local player1 = Player.new("Bray", 100)
player1:takeDamage(25)  -- Bray took 25 damage!
print(player1.health)   -- 75
```

**Pro term:** This is **object-oriented programming** (OOP) in Lua.

---

### The Singleton Pattern

**One global instance:**

```lua
-- In ReplicatedStorage.GameManager (ModuleScript)
local GameManager = {
    score = 0,
    isGameActive = false
}

function GameManager.startGame()
    GameManager.isGameActive = true
    print("Game started!")
end

function GameManager.addScore(points)
    GameManager.score = GameManager.score + points
end

return GameManager

-- Anywhere in your game
local GameManager = require(game.ReplicatedStorage.GameManager)
GameManager.startGame()
GameManager.addScore(100)
```

**Pro term:** **Singleton** - only one instance exists globally.

---

### The Factory Pattern

**Creating multiple objects:**

```lua
local function createEnemy(name, health, damage)
    return {
        name = name,
        health = health,
        damage = damage,
        attack = function(self, target)
            print(self.name .. " attacks " .. target .. " for " .. self.damage .. " damage!")
        end
    }
end

local zombie = createEnemy("Zombie", 50, 10)
local skeleton = createEnemy("Skeleton", 30, 15)

zombie:attack("Player")  -- Zombie attacks Player for 10 damage!
```

**Pro term:** **Factory function** - function that creates objects.

---

## Advanced Techniques

### Technique 1: Metatables and Metamethods

**What they are:** Special behaviors for tables (advanced object programming).

```lua
-- Create a table with special behavior
local Vector = {}
Vector.__index = Vector

-- Constructor
function Vector.new(x, y)
    return setmetatable({x = x, y = y}, Vector)
end

-- Metamethod: Addition
function Vector.__add(v1, v2)
    return Vector.new(v1.x + v2.x, v1.y + v2.y)
end

-- Metamethod: String representation
function Vector.__tostring(v)
    return string.format("Vector(%d, %d)", v.x, v.y)
end

-- Usage
local v1 = Vector.new(3, 4)
local v2 = Vector.new(1, 2)
local v3 = v1 + v2  -- Calls __add metamethod

print(v3)  -- Vector(4, 6)
```

**Common metamethods:**
- `__add`, `__sub`, `__mul`, `__div` - Arithmetic
- `__eq`, `__lt`, `__le` - Comparison
- `__tostring` - Convert to string
- `__index`, `__newindex` - Property access

---

### Technique 2: Coroutines and Async Programming

**What they are:** Functions that can be paused and resumed.

```lua
-- Create a coroutine (lightweight thread)
local function countToFive()
    for i = 1, 5 do
        print("Count:", i)
        coroutine.yield()  -- Pause here
    end
end

local co = coroutine.create(countToFive)

-- Resume one step at a time
coroutine.resume(co)  -- Prints: Count: 1
coroutine.resume(co)  -- Prints: Count: 2
coroutine.resume(co)  -- Prints: Count: 3
-- ...

-- Practical use: Better than deep nesting
-- ❌ BAD - Nested callbacks (callback hell)
function doTask(callback)
    wait(1)
    callback()
end

doTask(function()
    doTask(function()
        doTask(function()
            print("Done!")
        end)
    end)
end)

-- ✅ GOOD - Use coroutine
local function doTasks()
    wait(1)
    wait(1)
    wait(1)
    print("Done!")
end

local co = coroutine.create(doTasks)
coroutine.resume(co)
```

---

### Technique 3: Module Patterns for Code Organization

**Pattern 1: Singleton Module**

```lua
-- In ReplicatedStorage.GameConfig (ModuleScript)
local GameConfig = {
    MAX_PLAYERS = 10,
    DEFAULT_HEALTH = 100,
    SPAWN_DELAY = 2,
    DIFFICULTY = "Normal"
}

function GameConfig.setDifficulty(newDifficulty)
    GameConfig.DIFFICULTY = newDifficulty
end

return GameConfig

-- Usage anywhere
local GameConfig = require(game.ReplicatedStorage.GameConfig)
print(GameConfig.MAX_PLAYERS)  -- 10
```

**Pattern 2: Class Module**

```lua
-- In ReplicatedStorage.Player (ModuleScript)
local Player = {}
Player.__index = Player

function Player.new(name, health)
    return setmetatable({
        name = name,
        health = health,
        level = 1
    }, Player)
end

function Player:takeDamage(amount)
    self.health = math.max(0, self.health - amount)
end

function Player:levelUp()
    self.level = self.level + 1
    self.health = self.health + 50
end

return Player

-- Usage anywhere
local Player = require(game.ReplicatedStorage.Player)
local player = Player.new("Bray", 100)
player:takeDamage(25)
player:levelUp()
```

---

### Technique 4: Error Handling with pcall and xpcall

**What they do:** Safely call functions and catch errors.

```lua
-- pcall = Protected call (catches errors)
local function riskyOperation()
    error("Something went wrong!")
end

local success, result = pcall(riskyOperation)
if success then
    print("Success:", result)
else
    print("Error caught:", result)
end

-- Practical example: Safely process player data
local function loadPlayerData(playerId)
    -- This might fail if data doesn't exist
    local data = game.DataStoreService:FindFirstChild(playerId)
    return data
end

local success, playerData = pcall(loadPlayerData, "Player123")
if not success then
    print("Failed to load player data:", playerData)
    -- Provide default data instead
    playerData = {coins = 0, level = 1}
end
```

---

## Performance Considerations

### Memory Optimization

**Problem:** Careless code wastes memory.

**Solution: Avoid creating unnecessary objects**

```lua
-- ❌ BAD - Creates new tables every frame
local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(function()
    local position = {}
    position.x = 10
    position.y = 20
    -- 60 new tables per second = memory leak!
end)

-- ✅ GOOD - Reuse table
local position = {x = 0, y = 0}
RunService.Heartbeat:Connect(function()
    position.x = 10
    position.y = 20
    -- Same table, reused
end)

-- ✅ ALSO GOOD - Use Vector3 (optimized Roblox type)
local position = Vector3.new(0, 0, 0)
RunService.Heartbeat:Connect(function()
    position = Vector3.new(10, 20, 0)  -- Efficient
end)
```

---

### Table Performance

**Problem:** Looking up items in tables is slow if not done right.

```lua
-- ❌ SLOW - Linear search (O(n))
local items = {"Sword", "Shield", "Potion", "Bow", "Helmet"}

local function findItem(itemName)
    for i, item in ipairs(items) do
        if item == itemName then
            return true
        end
    end
    return false
end

findItem("Sword")  -- Searches 1 item: O(1)
findItem("Helmet")  -- Searches 5 items: O(n)

-- ✅ FAST - Hash table lookup (O(1))
local items = {
    Sword = true,
    Shield = true,
    Potion = true,
    Bow = true,
    Helmet = true
}

local function hasItem(itemName)
    return items[itemName] or false
end

hasItem("Sword")  -- Always O(1) - instant lookup!
hasItem("Helmet")  -- Always O(1) - same speed!
```

---

### String Concatenation Performance

**Problem:** String concatenation creates new strings every time (expensive).

```lua
-- ❌ SLOW - Creates 3 new strings
local str = "Hello"
str = str .. " "
str = str .. "World"

-- ❌ VERY SLOW - Creates many strings in loop
local result = ""
for i = 1, 1000 do
    result = result .. "x"  -- Creates new string each iteration!
end

-- ✅ FAST - Build string at once
local str = "Hello" .. " " .. "World"

-- ✅ VERY FAST - Use table.concat
local parts = {}
for i = 1, 1000 do
    table.insert(parts, "x")
end
local result = table.concat(parts)  -- Much faster!

-- ✅ ALSO FAST - Use string.format
local str = string.format("%s %s", "Hello", "World")
```

---

### Function Call Performance

**Problem:** Function calls have overhead. Calling too many times = slow.

```lua
-- ❌ SLOW - Many function calls
local function isEven(n) return n % 2 == 0 end

local count = 0
for i = 1, 1000000 do
    if isEven(i) then
        count = count + 1
    end
end

-- ✅ FAST - Inline logic
local count = 0
for i = 1, 1000000 do
    if i % 2 == 0 then
        count = count + 1
    end
end

-- ✅ BEST - Use vectorized operations (if available)
-- Process multiple items at once instead of one by one
```

---

## Quick Reference Guide

**Handy Lua cheat sheet for quick lookup:**

### Variables & Types
```lua
local x = 10               -- number
local name = "Bray"        -- string
local active = true        -- boolean
local nothing = nil        -- nil
local colors = {"Red"}     -- table (array)
local player = {}          -- table (dictionary)
```

### Operators Quick Table
| Operator | Use | Example |
|----------|-----|---------|
| `+` `-` `*` `/` `%` `^` | Math | `10 + 5`, `10 % 3` |
| `==` `~=` `<` `>` `<=` `>=` | Compare | `x == 5`, `x ~= 10` |
| `and` `or` `not` | Logic | `x and y`, `not z` |
| `..` | Concatenate | `"Hello" .. " World"` |

### Control Flow Patterns
```lua
-- If statement
if condition then
    -- code
elseif other then
    -- code
else
    -- code
end

-- For loop (numeric)
for i = 1, 10 do
    -- code (i goes 1,2,3...10)
end

-- For loop (table iteration)
for key, value in pairs(table) do
    -- code
end

-- While loop
while condition do
    -- code
end
```

### Functions Quick Forms
```lua
-- Simple function
local function add(a, b)
    return a + b
end

-- Anonymous function
local greet = function(name)
    print("Hello, " .. name)
end

-- With varargs
local function printAll(...)
    local args = {...}
    for i, v in ipairs(args) do
        print(v)
    end
end
```

---

## Hands-On Exercises

**Complete these exercises to master Lua fundamentals:**

### Exercise 1: Variables and Types (10 min)
```lua
-- Create the following variables and print their types:
-- 1. A variable named 'playerName' with value "Bray"
-- 2. A variable named 'playerHealth' with value 100
-- 3. A variable named 'isAlive' with value true
-- 4. Print each variable and its type using type()

-- Solutions shown below (try first!)
local playerName = "Bray"
local playerHealth = 100
local isAlive = true

print(playerName, type(playerName))
print(playerHealth, type(playerHealth))
print(isAlive, type(isAlive))
```

### Exercise 2: String Manipulation (15 min)
```lua
-- 1. Create a function that takes a first name and last name
--    and returns "FirstName LastName"
local function fullName(first, last)
    return first .. " " .. last
end

-- 2. Test it
print(fullName("Bray", "Tutor"))  -- Should print: Bray Tutor

-- 3. Create a function that makes a string UPPERCASE
local function makeUppercase(str)
    return string.upper(str)
end

-- 4. Create a function that counts vowels in a string
local function countVowels(str)
    local count = 0
    for i = 1, #str do
        local char = string.sub(str, i, i):lower()
        if char == "a" or char == "e" or char == "i" or char == "o" or char == "u" then
            count = count + 1
        end
    end
    return count
end

print(countVowels("Hello World"))  -- Should be 3
```

### Exercise 3: Tables and Loops (20 min)
```lua
-- 1. Create a table of 5 numbers
local numbers = {10, 20, 30, 40, 50}

-- 2. Write a function to find the maximum value
local function findMax(list)
    local max = list[1]
    for i = 2, #list do
        if list[i] > max then
            max = list[i]
        end
    end
    return max
end

print("Max:", findMax(numbers))  -- Should be 50

-- 3. Write a function to sum all numbers
local function sum(list)
    local total = 0
    for i, value in ipairs(list) do
        total = total + value
    end
    return total
end

print("Sum:", sum(numbers))  -- Should be 150

-- 4. Create a table of player data
local players = {
    {name = "Alice", score = 100},
    {name = "Bob", score = 85},
    {name = "Charlie", score = 120}
}

-- 5. Find the player with highest score
local function topPlayer(playerList)
    local top = playerList[1]
    for i = 2, #playerList do
        if playerList[i].score > top.score then
            top = playerList[i]
        end
    end
    return top
end

local winner = topPlayer(players)
print("Winner:", winner.name, "Score:", winner.score)
```

### Exercise 4: Conditionals Logic (15 min)
```lua
-- 1. Grade calculator
local function getGrade(score)
    if score >= 90 then
        return "A"
    elseif score >= 80 then
        return "B"
    elseif score >= 70 then
        return "C"
    elseif score >= 60 then
        return "D"
    else
        return "F"
    end
end

print(getGrade(95))  -- A
print(getGrade(75))  -- C

-- 2. Validate player data
local function isValidPlayer(player)
    if not player then
        return false, "Player is nil"
    end

    if not player.name or player.name == "" then
        return false, "Invalid name"
    end

    if not player.health or player.health <= 0 then
        return false, "Invalid health"
    end

    return true, "Valid player"
end

local testPlayer = {name = "Alice", health = 100}
local valid, msg = isValidPlayer(testPlayer)
print(valid, msg)
```

### Exercise 5: Functions and Scope (20 min)
```lua
-- 1. Create a counter factory
local function makeCounter()
    local count = 0

    return function()
        count = count + 1
        return count
    end
end

local counter = makeCounter()
print(counter())  -- 1
print(counter())  -- 2
print(counter())  -- 3

-- 2. Calculator with memory
local function createCalculator()
    local result = 0

    return {
        add = function(num)
            result = result + num
            return result
        end,
        subtract = function(num)
            result = result - num
            return result
        end,
        getResult = function()
            return result
        end,
        reset = function()
            result = 0
        end
    }
end

local calc = createCalculator()
print(calc.add(10))        -- 10
print(calc.add(5))         -- 15
print(calc.subtract(3))    -- 12
print(calc.getResult())    -- 12
```

### Exercise 6: Data Structure Challenge (30 min)
```lua
-- Create a simple game inventory system

local Inventory = {}

-- Add item to inventory
local function addItem(inventory, itemName, quantity)
    if inventory[itemName] then
        inventory[itemName] = inventory[itemName] + quantity
    else
        inventory[itemName] = quantity
    end
end

-- Remove item from inventory
local function removeItem(inventory, itemName, quantity)
    if inventory[itemName] and inventory[itemName] >= quantity then
        inventory[itemName] = inventory[itemName] - quantity
        if inventory[itemName] == 0 then
            inventory[itemName] = nil
        end
        return true
    end
    return false
end

-- Print inventory
local function printInventory(inventory)
    print("=== Inventory ===")
    for itemName, quantity in pairs(inventory) do
        print(string.format("  %s: %d", itemName, quantity))
    end
end

-- Test it!
local myInventory = {}
addItem(myInventory, "Sword", 1)
addItem(myInventory, "Potion", 5)
addItem(myInventory, "Potion", 3)
printInventory(myInventory)

removeItem(myInventory, "Potion", 2)
printInventory(myInventory)
```

---

## Debugging Lua Code

**Techniques for finding and fixing bugs:**

### Technique 1: Print Debugging
```lua
-- Add prints to see what's happening
local function processData(data)
    print("Input:", data)

    local result = data * 2
    print("After doubling:", result)

    result = result + 10
    print("After adding 10:", result)

    return result
end

processData(5)
```

### Technique 2: Type Checking
```lua
-- Check types when debugging
local function divide(a, b)
    print("Type of a:", type(a), "Value:", a)
    print("Type of b:", type(b), "Value:", b)

    if b == 0 then
        print("ERROR: Division by zero!")
        return nil
    end

    return a / b
end
```

### Technique 3: Assertion Checking
```lua
-- Use assert to catch mistakes early
local function setHealth(character, health)
    assert(character ~= nil, "Character cannot be nil")
    assert(type(health) == "number", "Health must be a number")
    assert(health >= 0, "Health cannot be negative")

    character.health = health
end
```

### Common Bugs and Fixes

| Bug | Cause | Fix |
|-----|-------|-----|
| `attempt to index nil` | Using something that doesn't exist | Check with `if x then` first |
| Infinite loop freezes game | Missing `wait()` in loop | Always add `wait()` to loops |
| Table size always 0 | Using `{}` instead of populated table | Initialize table with values |
| Wrong variable value | Using global instead of local | Always use `local` |
| Function not found | Typo in function name | Check spelling and capitalization |

---

## Testing Your Understanding

Before moving on, make sure you can:

1. Create and use variables with proper naming
2. Understand all data types (nil, boolean, number, string, table)
3. Use arithmetic, comparison, and logical operators
4. Write if-elseif-else statements
5. Write while, repeat-until, and for loops
6. Create functions with parameters and return values
7. Create and manipulate arrays and dictionaries
8. Understand scope (global, local, block, function)
9. Explain the difference between value and reference types

**Challenge exercises:**

```lua
-- 1. Write a function that takes a table of numbers and returns the average
local function average(numbers)
    local sum = 0
    for i, num in ipairs(numbers) do
        sum = sum + num
    end
    return sum / #numbers
end

-- 2. Write a function that takes a string and returns it reversed
local function reverseString(str)
    local result = ""
    for i = #str, 1, -1 do
        result = result .. string.sub(str, i, i)
    end
    return result
end

-- 3. Create a table of 3 players, each with name and score. Print the player with the highest score.
local players = {
    {name = "Alice", score = 100},
    {name = "Bob", score = 85},
    {name = "Charlie", score = 120}
}

local topScore = 0
local topPlayer = nil
for i, player in ipairs(players) do
    if player.score > topScore then
        topScore = player.score
        topPlayer = player.name
    end
end
print("Top player:", topPlayer, "Score:", topScore)

-- 4. Write a loop that prints the Fibonacci sequence up to 100
local a, b = 1, 1
while a <= 100 do
    print(a)
    a, b = b, a + b
end
```

---

## Next Steps

Now that you know Lua:

- **Read:** [How Roblox Works](./how-roblox-works.md) - Apply Lua to Roblox
- **Read:** [Client-Server Model](./client-server-model.md) - Networking concepts
- **Build:** [Examples 1-5](../README.md#example-projects) - Apply everything!

**Pro tip:** Lua is just a tool. The real learning happens when you BUILD things. Don't just read - code! Type out the examples, modify them, break them, fix them. That's how you learn.

**Remember:** Every professional developer was once where you are now. The difference between a beginner and a pro is just time and practice. Keep coding! 🚀
