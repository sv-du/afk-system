-- Define Services & Variables
local PlayersService = game:GetService("Players")
local afkedPlayers = {}

-- Configuration
local afkCommand = "!afk" -- Command place the user to the afk zone
local unAFKCommand = "!unafk" -- Command to remove the user from the afk zone
local isPVPGame = false -- Switch to toggle if your game is a PVP-like game so that people can't do !afk on 1 health
local maxHealth = 100 -- Change this value to change the max health that the player gets after they do !unafk. Roblox's default health goes to 100, but if your game changes that, change it on here


-- Functions
function startsWith(str, start)
	return str:sub(1, #start) == start
end

-- Main Code
PlayersService.PlayerAdded:Connect(function(plr)
	plr.Chatted:Connect(function(msg)
		if startsWith(msg, afkCommand) then
			if isPVPGame == true then
				if plr.Character.Humanoid.Health == plr.Character.Humanoid.MaxHealth then
				else
					return
				end
			end
			if table.find(afkedPlayers, plr.Name) then
				return
			end
			plr.Character:MoveTo(game.Workspace["AFK Place"].Spawn.Position)
			plr.Character.Humanoid.MaxHealth = math.huge
			plr.Character.Humanoid.Health = plr.Character.Humanoid.MaxHealth
			table.insert(afkedPlayers, plr.Name)
			return
		end
		if startsWith(msg, unAFKCommand) then
			if not table.find(afkedPlayers, plr.Name) then
				return
			end
			table.remove(afkedPlayers, table.find(afkedPlayers, plr.Name))
			plr.Character.Humanoid.MaxHealth = maxHealth
			plr.Character.Humanoid.Health = 0
		end
	end)
	
	plr.CharacterAdded:Connect(function()
		if table.find(afkedPlayers, plr.Name) then
			wait()
			plr.Character:MoveTo(game.Workspace["AFK Place"].Spawn.Position)
			plr.Character.Humanoid.MaxHealth = math.huge
			plr.Character.Humanoid.Health = plr.Character.Humanoid.MaxHealth
		end
	end)
end)