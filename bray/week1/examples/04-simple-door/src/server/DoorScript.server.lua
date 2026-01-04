-- Simple Automatic Door System
-- Demonstrates event-driven programming, debouncing, and TweenService

print("🚪 Door System initializing...")

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Get parts (make sure these exist in workspace!)
local door = workspace:WaitForChild("Door")
local sensor = workspace:WaitForChild("Sensor")

-- Configuration
local OPEN_DISTANCE = 8  -- How far to move (studs)
local ANIMATION_TIME = 0.5  -- How long to open/close (seconds)
local STAY_OPEN_TIME = 3  -- How long to stay open (seconds)

print("✅ Door and sensor found")

-- Store original position (closed state)
local closedCFrame = door.CFrame
local openCFrame = closedCFrame * CFrame.new(0, 0, OPEN_DISTANCE)  -- Move backward (away from player)

-- Debounce flag (prevents spam)
local debounce = false

-- Tween info (how the animation looks)
local tweenInfo = TweenInfo.new(
    ANIMATION_TIME,
    Enum.EasingStyle.Quad,  -- Smooth acceleration/deceleration
    Enum.EasingDirection.Out  -- Slow down at end
)

-- Helper function: Open door
local function openDoor()
    print("🚪 Opening door...")
    local tween = TweenService:Create(door, tweenInfo, {CFrame = openCFrame})
    tween:Play()
    return tween
end

-- Helper function: Close door
local function closeDoor()
    print("🚪 Closing door...")
    local tween = TweenService:Create(door, tweenInfo, {CFrame = closedCFrame})
    tween:Play()
    return tween
end

-- Main event handler
sensor.Touched:Connect(function(otherPart)
    -- Check if we're in debounce (door busy)
    if debounce then
        return  -- Door is already operating, ignore this touch
    end

    -- Verify it's a character with a Humanoid
    local character = otherPart.Parent
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return  -- Not a character, ignore (could be a dropped tool, etc.)
    end

    -- Get the player
    local player = Players:GetPlayerFromCharacter(character)

    if not player then
        return  -- Not a player (might be an NPC), ignore
    end

    -- Activate debounce
    debounce = true

    print("🚶", player.Name, "triggered door")

    -- Open door
    local openTween = openDoor()
    openTween.Completed:Wait()  -- Wait for animation to finish

    print("✅ Door fully opened")

    -- Stay open for a bit
    task.wait(STAY_OPEN_TIME)

    -- Close door
    local closeTween = closeDoor()
    closeTween.Completed:Wait()  -- Wait for animation to finish

    print("✅ Door fully closed")

    -- Release debounce (door ready for next player)
    debounce = false
end)

print("🎯 Door system active and waiting for players!")

-- OPTIONAL ENHANCEMENTS (Uncomment to try)

-- Add sound effects
--[[
local openSound = Instance.new("Sound")
openSound.SoundId = "rbxassetid://156286438"  -- Door creak sound
openSound.Parent = door

local closeSound = openSound:Clone()
closeSound.Parent = door

local function openDoor()
    openSound:Play()
    local tween = TweenService:Create(door, tweenInfo, {CFrame = openCFrame})
    tween:Play()
    return tween
end

local function closeDoor()
    closeSound:Play()
    local tween = TweenService:Create(door, tweenInfo, {CFrame = closedCFrame})
    tween:Play()
    return tween
end
]]

-- Add color change when opening
--[[
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
]]

-- Add transparency effect (fading door)
--[[
local function openDoor()
    local tween = TweenService:Create(door, tweenInfo, {
        CFrame = openCFrame,
        Transparency = 0.8  -- Nearly invisible when open
    })
    tween:Play()
    return tween
end

local function closeDoor()
    local tween = TweenService:Create(door, tweenInfo, {
        CFrame = closedCFrame,
        Transparency = 0  -- Solid when closed
    })
    tween:Play()
    return tween
end
]]
