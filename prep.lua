Workspace = game:GetService("Workspace")
ReplicatedStorage = game:GetService("ReplicatedStorage")
LocalPlayer = game:GetService("Players").LocalPlayer

RemoteKey = -ReplicatedStorage.Remote.ReqPasskey:InvokeServer()
GameScriptEnv = getsenv(LocalPlayer.PlayerScripts.CL_MAIN_GameScript)
oldAlert = GameScriptEnv.newAlert
GameScriptEnv.newAlert = function(...)
	if checkcaller() then
		oldAlert(...)
	end
end
Alert = function(...) -- Custom Fe2 Rainbow Alert Function
	GameScriptEnv.newAlert(tostring(...), nil, nil, "rainbow")
end
Alert("Waiting for \"ingame\" GameState..")
CurrentGameState = ""
ReplicatedStorage.Remote.UpdateGameState.OnClientEvent:Connect(function(newGameState) -- Detect GameState
	CurrentGameState = newGameState
end)
repeat wait() until CurrentGameState == "ingame"
Alert("GameState ingame detected! Waiting for game..")
ReplicatedStorage.Remote.StartClientMapTimer.OnClientEvent:wait()
task.wait(1)
Map = Workspace.Multiplayer:WaitForChild("Map"):Clone()
Map.Parent = workspace -- Bypass Map Deletion

local AnchorPart = Map:FindFirstChild("Part", true)
local SpawnOffset
for i,v in pairs(Map:GetChildren()) do
	if v.ClassName == "Part" then
		local X, Y, Z = v.Size.X, v.Size.Y, v.Size.Z
		if (Y > 0 and Y <= 1) and (X < 16.99 and X > 15.00) and (Z < 16.99 and Z > 15.00) then
			print(v.Name, X, Y , Z)
			SpawnOffset = (v.CFrame * CFrame.new(0, 2.6, 0)) * AnchorPart.CFrame:Inverse()
		end
	end
end
Alert("Spawn Offset calculated. Preparing player and client..")
local SpawnLocation = SpawnOffset * AnchorPart.CFrame

UpdateGameState = GameScriptEnv.updGameState
GameScriptEnv.updGameState = function(...)
	repeat wait(1) until GameScriptEnv.updGameState == UpdateGameState
	return UpdateGameState(...)
end -- Lock GameState
LocalPlayer.Character.Humanoid.Health = 0 -- Kill Player
LocalPlayer.CharacterAdded:Wait() -- Wait For Respawn
Alert("Client ready!")
Humanoid, HumanoidRootPart = LocalPlayer.Character:WaitForChild("Humanoid"), LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local GodMode
function Reset() -- Return to no tas system
	GameScriptEnv.updGameState = UpdateGameState
	Humanoid.Health = 0
	getgenv().BlockRemotes = false
end
GodMode = Humanoid.Changed:Connect(function()
	Humanoid.Health = 100
end)
-- Beginning of Client-Side Anticheat Bypass
Alert("Attempting to bypass Client-Side Anticheat..")
local function DisableAntiGrav(Character)
	local AntiGrav = Character:WaitForChild("CL_AntiGrav")
	AntiGrav.Disabled = true
	AntiGrav:Destroy()
end
DisableAntiGrav(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(DisableAntiGrav)
function ReplicatedStorage.Remote.ReqCharVars.OnClientInvoke(...)
	return wait(9e6)
end
function ReplicatedStorage.Remote.FetchPos.OnClientInvoke(...)
	return wait(9e6)
end
for i,v in pairs(getnilinstances()) do
	if v.Name == "CL_AntiExploit" then
		v.Disabled = true
		v:Destroy()
	end
end
local old
old = hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	if getgenv().BlockRemotes and (method == "FireServer" or method == "InvokeServer") or method == "Kick" then
		return
	end
	return old(self, ...)
end)
Alert("Bypassed Client-Side Anticheat without errors!")
-- End of Client-side Anticheat Bypass

HumanoidRootPart.CFrame = SpawnLocation

-- Beginning of Playback Tools Stuff
