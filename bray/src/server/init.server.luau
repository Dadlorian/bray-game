-- This script runs on the server as soon as the game starts.
-- It's a great place to set up the initial state of your world.

-- Let's find the Baseplate in the game. All the visible parts of your game world
-- live inside a container called "Workspace".
local baseplate = game.Workspace:FindFirstChild("Baseplate")

-- It's good practice to check if the part actually exists before
-- we try to do things with it. This prevents errors!
if baseplate then
	-- We found it! Let's print a message to the Output window in Roblox Studio.
	print("Found the Baseplate! Customizing it now...")

	-- Now, let's change its properties.
	baseplate.Color = Color3.fromRGB(255, 0, 100) -- A bright magenta color
	baseplate.Material = Enum.Material.Neon      -- Make it glow!
	baseplate.Size = Vector3.new(1024, 2, 1024)   -- Make it bigger!

	print("Baseplate customization complete! Press Play to see it.")
else
	-- If we couldn't find it, we'll print a warning.
	-- This is helpful for debugging later on.
	warn("Oops! Could not find a part named 'Baseplate' in the Workspace.")
end
