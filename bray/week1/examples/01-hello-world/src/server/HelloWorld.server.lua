-- This is a server script! It runs on the server.
-- The server is the computer that hosts the game for everyone.

print("🎮 [SERVER] Hello from the server!")
print("🎮 [SERVER] This message prints once when the server starts.")
print("🎮 [SERVER] All players are connected to this one server.")

-- Let's print some info about the game
print("🎮 [SERVER] Game name:", game.Name)
print("🎮 [SERVER] Workspace name:", workspace.Name)

-- Count how many players are in the game
local Players = game:GetService("Players")
print("🎮 [SERVER] Number of players:", #Players:GetPlayers())

-- Print a message every 10 seconds to show the server is running
task.spawn(function()
    while true do
        task.wait(10)
        print("🎮 [SERVER] Server is running... (" .. #Players:GetPlayers() .. " players online)")
    end
end)
