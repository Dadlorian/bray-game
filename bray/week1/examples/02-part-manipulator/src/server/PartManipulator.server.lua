-- Part Manipulator - Demonstrates property manipulation
-- This script finds a part and changes its properties step by step

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
print("  Material:", part.Material.Name)
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

task.wait(1)
print("✅ Part manipulation complete!")
print("💡 Try the challenges in the README to learn more!")

-- BONUS: Uncomment one of these to see continuous animations!

-- Rainbow cycle (uncomment to enable)
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

print("🌈 Starting rainbow cycle...")
while true do
    for i, color in ipairs(colors) do
        part.Color = color
        task.wait(0.5)
    end
end
]]

-- Grow and shrink pulse (uncomment to enable)
--[[
print("💓 Starting pulse animation...")
while true do
    -- Grow
    for size = 4, 10, 0.5 do
        part.Size = Vector3.new(size, size, size)
        task.wait(0.05)
    end

    -- Shrink
    for size = 10, 4, -0.5 do
        part.Size = Vector3.new(size, size, size)
        task.wait(0.05)
    end
end
]]

-- Orbit animation (uncomment to enable)
--[[
local angle = 0
local radius = 15
local height = 10

print("🌍 Starting orbit animation...")
while true do
    local x = math.cos(angle) * radius
    local z = math.sin(angle) * radius
    part.Position = Vector3.new(x, height, z)

    angle = angle + 0.05
    task.wait(0.03)
end
]]
