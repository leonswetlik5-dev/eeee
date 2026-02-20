-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")

-- Function to add highlight to a character
local function addHighlight(character)
	if character:FindFirstChild("PlayerHighlight") then return end
	
	local highlight = Instance.new("Highlight")
	highlight.Name = "PlayerHighlight"
	highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red fill
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 0
	highlight.Parent = character
end

-- Function to handle player
local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		addHighlight(character)
	end)
	
	-- If character already exists
	if player.Character then
		addHighlight(player.Character)
	end
end

-- Apply to existing players
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

-- Apply to new players
Players.PlayerAdded:Connect(onPlayerAdded)
