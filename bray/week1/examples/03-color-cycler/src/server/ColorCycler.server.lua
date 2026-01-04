-- Color Cycler - Demonstrates loops, timing, and color manipulation
-- Choose one of the examples below by uncommenting it

print("🌈 Color Cycler starting...")

local part = workspace:WaitForChild("ColorPart")

-- Seed random number generator for true randomness
math.randomseed(tick())

print("✅ Part found:", part.Name)

-- =============================================================================
-- EXAMPLE A: Rainbow Cycle (Predefined Colors)
-- Uncomment to use
-- =============================================================================

--[[
local colors = {
    Color3.fromRGB(255, 0, 0),    -- Red
    Color3.fromRGB(255, 127, 0),  -- Orange
    Color3.fromRGB(255, 255, 0),  -- Yellow
    Color3.fromRGB(0, 255, 0),    -- Green
    Color3.fromRGB(0, 0, 255),    -- Blue
    Color3.fromRGB(75, 0, 130),   -- Indigo
    Color3.fromRGB(148, 0, 211),  -- Violet
}

print("🌈 Starting rainbow cycle (7 colors, 0.5s each)")

while true do
    for i, color in ipairs(colors) do
        part.Color = color
        print("Color", i, "of", #colors)
        task.wait(0.5)
    end

    print("🔄 Restarting rainbow cycle...")
end
]]

-- =============================================================================
-- EXAMPLE B: Random Colors
-- Uncomment to use
-- =============================================================================

--[[
print("🎲 Changing to random color every second")

while true do
    local r = math.random(0, 255)
    local g = math.random(0, 255)
    local b = math.random(0, 255)

    part.Color = Color3.fromRGB(r, g, b)

    print(string.format("Color: R=%d, G=%d, B=%d", r, g, b))

    task.wait(1)
end
]]

-- =============================================================================
-- EXAMPLE C: Smooth Color Transition (Lerp)
-- Uncomment to use
-- =============================================================================

--[[
local colorA = Color3.fromRGB(255, 0, 0)    -- Red
local colorB = Color3.fromRGB(0, 0, 255)    -- Blue

print("✨ Smoothly transitioning between red and blue")

while true do
    -- Fade from A to B
    for alpha = 0, 1, 0.01 do
        part.Color = colorA:Lerp(colorB, alpha)
        task.wait(0.02)
    end

    -- Fade from B to A
    for alpha = 0, 1, 0.01 do
        part.Color = colorB:Lerp(colorA, alpha)
        task.wait(0.02)
    end

    print("🔄 Restarting smooth transition...")
end
]]

-- =============================================================================
-- EXAMPLE D: Smooth Rainbow (Best of Both) - DEFAULT
-- This is enabled by default!
-- =============================================================================

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

print("🌈✨ Smoothly cycling through rainbow colors")

while true do
    for i = 1, #colors do
        local colorA = colors[i]
        local colorB = colors[i % #colors + 1]  -- Next color (wraps around)

        -- Smooth transition from current to next
        for alpha = 0, 1, 1/steps do
            part.Color = colorA:Lerp(colorB, alpha)
            task.wait(transitionSpeed)
        end
    end

    print("🔄 Rainbow cycle complete, restarting...")
end

-- =============================================================================
-- BONUS CHALLENGES (Uncomment to try)
-- =============================================================================

-- Traffic Light Challenge
--[[
while true do
    -- Red light
    part.Color = Color3.fromRGB(255, 0, 0)
    print("🔴 RED - Stop!")
    task.wait(3)

    -- Yellow light
    part.Color = Color3.fromRGB(255, 255, 0)
    print("🟡 YELLOW - Caution!")
    task.wait(1)

    -- Green light
    part.Color = Color3.fromRGB(0, 255, 0)
    print("🟢 GREEN - Go!")
    task.wait(3)
end
]]

-- HSV Rainbow Cycle (Smooth Spectrum)
--[[
local hue = 0

print("🌈 HSV rainbow cycle starting...")

while true do
    part.Color = Color3.fromHSV(hue, 1, 1)

    hue = hue + 0.005
    if hue > 1 then
        hue = 0
    end

    task.wait(0.03)
end
]]

-- Pulsing Neon Effect
--[[
local baseColor = Color3.fromRGB(0, 255, 255)  -- Cyan

print("💓 Pulsing neon effect starting...")

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
]]
