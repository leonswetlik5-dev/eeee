local Players = game:GetService("Players")

local function addESP(character)
	if character:FindFirstChild("PlayerHighlight") then return end
	
	local highlight = Instance.new("Highlight")
	highlight.Name = "PlayerHighlight"
	highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Box Farbe
	highlight.FillTransparency = 0.5 -- Innen leicht durchsichtig
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Randfarbe
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Durch Wände sichtbar
	
	highlight.Parent = character
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		addESP(character)
	end)

	if player.Character then
		addESP(player.Character)
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
