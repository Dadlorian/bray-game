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

    -- Wait for character to load
    if player.Character or player.CharacterAdded:Wait() then
        print("👤 [CLIENT] Your character has loaded!")
    end
else
    print("👤 [CLIENT] Player not loaded yet!")
end
