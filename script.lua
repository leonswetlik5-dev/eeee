-- LocalScript

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- UI
--------------------------------------------------

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Text = "kaka"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local container = Instance.new("Frame")
container.Size = UDim2.new(1,-10,1,-40)
container.Position = UDim2.new(0,5,0,35)
container.BackgroundTransparency = 1
container.Parent = mainFrame

--------------------------------------------------
-- ESP SYSTEM
--------------------------------------------------

local espEnabled = false
local selectedColor = Color3.fromRGB(255,0,0)

local function addHighlight(character)
	if character:FindFirstChild("PlayerHighlight") then
		character.PlayerHighlight.FillColor = selectedColor
		return
	end
	
	local highlight = Instance.new("Highlight")
	highlight.Name = "PlayerHighlight"
	highlight.FillColor = selectedColor
	highlight.OutlineColor = Color3.fromRGB(255,255,255)
	highlight.FillTransparency = 0.4
	highlight.Parent = character
end

local function removeHighlight(character)
	local h = character:FindFirstChild("PlayerHighlight")
	if h then
		h:Destroy()
	end
end

local function refreshHighlights()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			addHighlight(player.Character)
		end
	end
end

local function enableESP()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			if player.Character then
				addHighlight(player.Character)
			end
			
			player.CharacterAdded:Connect(function(character)
				if espEnabled then
					addHighlight(character)
				end
			end)
		end
	end
end

local function disableESP()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			removeHighlight(player.Character)
		end
	end
end

--------------------------------------------------
-- Toggle Button
--------------------------------------------------

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1,0,0,35)
toggleButton.Text = "Player ESP: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextSize = 16
toggleButton.Parent = container

--------------------------------------------------
-- Farb-Container (erst versteckt)
--------------------------------------------------

local colorFrame = Instance.new("Frame")
colorFrame.Size = UDim2.new(1,0,0,40)
colorFrame.Position = UDim2.new(0,0,0,45)
colorFrame.BackgroundTransparency = 1
colorFrame.Visible = false -- 👈 VERSTECKT
colorFrame.Parent = container

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.Padding = UDim.new(0,8)
layout.Parent = colorFrame

local function createColorButton(color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,30,0,30)
	btn.BackgroundColor3 = color
	btn.Text = ""
	btn.BorderSizePixel = 0
	btn.Parent = colorFrame
	
	btn.MouseButton1Click:Connect(function()
		selectedColor = color
		if espEnabled then
			refreshHighlights()
		end
	end)
end

-- Farben
createColorButton(Color3.fromRGB(255,0,0))
createColorButton(Color3.fromRGB(0,255,0))
createColorButton(Color3.fromRGB(0,0,255))
createColorButton(Color3.fromRGB(255,0,255))
createColorButton(Color3.fromRGB(255,255,0))

--------------------------------------------------
-- Toggle Funktion
--------------------------------------------------

toggleButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	
	if espEnabled then
		toggleButton.Text = "Player ESP: ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(40,120,40)
		colorFrame.Visible = true -- 👈 Farben anzeigen
		enableESP()
	else
		toggleButton.Text = "Player ESP: OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
		colorFrame.Visible = false -- 👈 Farben verstecken
		disableESP()
	end
end)

--------------------------------------------------
-- NAME TAG SYSTEM
--------------------------------------------------

local nameTagsEnabled = false

local function addNameTag(character, player)
	if character:FindFirstChild("NameTagGui") then return end
	
	local head = character:FindFirstChild("Head")
	if not head then return end
	
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "NameTagGui"
	billboard.Size = UDim2.new(0,100,0,20)
	billboard.StudsOffset = Vector3.new(0,2.5,0)
	billboard.AlwaysOnTop = true
	billboard.Parent = character
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = player.Name
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.TextStrokeTransparency = 0
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.Parent = billboard
end

local function removeNameTag(character)
	local tag = character:FindFirstChild("NameTagGui")
	if tag then
		tag:Destroy()
	end
end

local function enableNameTags()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			if player.Character then
				addNameTag(player.Character, player)
			end
			
			player.CharacterAdded:Connect(function(character)
				if nameTagsEnabled then
					addNameTag(character, player)
				end
			end)
		end
	end
end

local function disableNameTags()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			removeNameTag(player.Character)
		end
	end
end

--------------------------------------------------
-- NAME TAG TOGGLE BUTTON (neue Kategorie)
--------------------------------------------------

local nameToggle = Instance.new("TextButton")
nameToggle.Size = UDim2.new(1,0,0,35)
nameToggle.Position = UDim2.new(0,0,0,100) -- unter ESP
nameToggle.Text = "Name Tags: OFF"
nameToggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
nameToggle.TextColor3 = Color3.new(1,1,1)
nameToggle.Font = Enum.Font.Gotham
nameToggle.TextSize = 16
nameToggle.Parent = container

nameToggle.MouseButton1Click:Connect(function()
	nameTagsEnabled = not nameTagsEnabled
	
	if nameTagsEnabled then
		nameToggle.Text = "Name Tags: ON"
		nameToggle.BackgroundColor3 = Color3.fromRGB(40,120,40)
		enableNameTags()
	else
		nameToggle.Text = "Name Tags: OFF"
		nameToggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
		disableNameTags()
	end
end)
