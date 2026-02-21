
-- LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- UI SETUP (breiter)
--------------------------------------------------

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5,-250,0.5,-150)
mainFrame.BackgroundColor3 = Color3.fromRGB(10,10,50)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Rounded Corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,16)
corner.Parent = mainFrame

-- Glühender Rand (Outer Glow)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0,180,255)
stroke.Thickness = 2
stroke.Parent = mainFrame

--------------------------------------------------
-- DRAG SYSTEM
--------------------------------------------------

local dragging = false
local dragInput
local mousePos
local framePos

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		mainFrame.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end
end)

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "Modern Panel"
title.TextColor3 = Color3.fromRGB(200,200,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

--------------------------------------------------
-- CLOSE BUTTON (X)
--------------------------------------------------

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,35,0,35)
closeButton.Position = UDim2.new(1,-40,0,5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(30,30,80)
closeButton.TextColor3 = Color3.fromRGB(255,100,100)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1,0)
closeCorner.Parent = closeButton

closeButton.MouseEnter:Connect(function()
	closeButton.BackgroundColor3 = Color3.fromRGB(50,50,100)
end)
closeButton.MouseLeave:Connect(function()
	closeButton.BackgroundColor3 = Color3.fromRGB(30,30,80)
end)

closeButton.MouseButton1Click:Connect(function()
	mainFrame:TweenSize(
		UDim2.new(0,0,0,0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.2,
		true,
		function()
			screenGui:Destroy()
		end
	)
end)

--------------------------------------------------
-- MINIMIZE BUTTON (-)
--------------------------------------------------

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0,35,0,35)
minimizeButton.Position = UDim2.new(1,-80,0,5)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(30,30,80)
minimizeButton.TextColor3 = Color3.fromRGB(150,200,255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 24
minimizeButton.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1,0)
minCorner.Parent = minimizeButton

minimizeButton.MouseEnter:Connect(function()
	minimizeButton.BackgroundColor3 = Color3.fromRGB(50,50,100)
end)
minimizeButton.MouseLeave:Connect(function()
	minimizeButton.BackgroundColor3 = Color3.fromRGB(30,30,80)
end)

--------------------------------------------------
-- CONTENT CONTAINER
--------------------------------------------------

local container = Instance.new("Frame")
container.Position = UDim2.new(0,15,0,60)
container.Size = UDim2.new(1,-30,1,-70)
container.BackgroundTransparency = 1
container.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,12)
layout.Parent = container

--------------------------------------------------
-- MINIMIZE LOGIC
--------------------------------------------------

local isMinimized = false
local savedSize = mainFrame.Size

local function toggleMinimize()
	if not isMinimized then
		isMinimized = true
		mainFrame:TweenSize(UDim2.new(savedSize.X.Scale, savedSize.X.Offset, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		container.Visible = false
	else
		isMinimized = false
		mainFrame:TweenSize(savedSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		container.Visible = true
	end
end

minimizeButton.MouseButton1Click:Connect(toggleMinimize)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		toggleMinimize()
	end
end)

--------------------------------------------------
-- SCHNEEFLOCKEN / PUNKTE (reduziert)
--------------------------------------------------

local particleFolder = Instance.new("Folder")
particleFolder.Name = "Particles"
particleFolder.Parent = mainFrame

local function spawnParticle()
	local dot = Instance.new("Frame")
	local size = math.random(3,7)
	dot.Size = UDim2.new(0,size,0,size)
	dot.Position = UDim2.new(math.random(),0,0,0)
	dot.BackgroundColor3 = Color3.fromRGB(0,180,255)
	dot.BorderSizePixel = 0
	dot.AnchorPoint = Vector2.new(0.5,0)
	dot.BackgroundTransparency = 0
	dot.Parent = particleFolder

	local tween = TweenService:Create(dot, TweenInfo.new(math.random(2,5), Enum.EasingStyle.Linear), {Position = UDim2.new(dot.Position.X.Scale,0,1,0), BackgroundTransparency = 1})
	tween:Play()
	tween.Completed:Connect(function()
		dot:Destroy()
	end)
end

spawn(function()
	while true do
		for i=1,4 do
			spawnParticle()
		end
		wait(0.1)
	end
end)

--------------------------------------------------
-- FPS DISPLAY (transparent)
--------------------------------------------------

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0,90,0,25)
fpsLabel.Position = UDim2.new(0,10,0,10)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(0,180,255)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 16
fpsLabel.Text = "FPS: 0"
fpsLabel.Parent = mainFrame

-- FPS Berechnung
local frameCount = 0
local updateInterval = 0.1
local lastTime = tick()

RunService.RenderStepped:Connect(function()
	frameCount = frameCount + 1
	local now = tick()
	if now - lastTime >= updateInterval then
		fpsLabel.Text = "FPS: "..math.floor(frameCount / (now - lastTime))
		frameCount = 0
		lastTime = now
	end
end)

--------------------------------------------------
-- PREMIUM PLAYER HIGHLIGHT SYSTEM
--------------------------------------------------

local highlightEnabled = false
local highlights = {}

--------------------------------------------------
-- CREATE HIGHLIGHT
--------------------------------------------------

local function createHighlight(player)
	if player == LocalPlayer then return end
	if not player.Character then return end
	if highlights[player] then return end

	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(0, 180, 255)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 1
	highlight.Parent = player.Character

	-- Smooth Fade In
	TweenService:Create(highlight, TweenInfo.new(0.3), {
		FillTransparency = 0.5,
		OutlineTransparency = 0
	}):Play()

	highlights[player] = highlight
end

local function removeHighlight(player)
	if highlights[player] then
		TweenService:Create(highlights[player], TweenInfo.new(0.2), {
			FillTransparency = 1,
			OutlineTransparency = 1
		}):Play()

		task.delay(0.2, function()
			if highlights[player] then
				highlights[player]:Destroy()
				highlights[player] = nil
			end
		end)
	end
end

local function enableHighlights()
	for _, player in pairs(Players:GetPlayers()) do
		createHighlight(player)
	end
end

local function disableHighlights()
	for player, _ in pairs(highlights) do
		removeHighlight(player)
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		if highlightEnabled then
			createHighlight(player)
		end
	end)
end)

--------------------------------------------------
-- MODERN TOGGLE SWITCH DESIGN
--------------------------------------------------

local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(1, 0, 0, 50)
toggleFrame.BackgroundColor3 = Color3.fromRGB(20,20,70)
toggleFrame.Parent = container

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0,12)
toggleCorner.Parent = toggleFrame

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(0,180,255)
toggleStroke.Parent = toggleFrame

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(0.7,0,1,0)
toggleLabel.Position = UDim2.new(0.05,0,0,0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "Player Highlight"
toggleLabel.Font = Enum.Font.GothamBold
toggleLabel.TextSize = 16
toggleLabel.TextColor3 = Color3.fromRGB(200,200,255)
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.Parent = toggleFrame

local switch = Instance.new("Frame")
switch.Size = UDim2.new(0,60,0,28)
switch.Position = UDim2.new(0.85,-30,0.5,-14)
switch.BackgroundColor3 = Color3.fromRGB(40,40,90)
switch.Parent = toggleFrame

local switchCorner = Instance.new("UICorner")
switchCorner.CornerRadius = UDim.new(1,0)
switchCorner.Parent = switch

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0,24,0,24)
knob.Position = UDim2.new(0,2,0.5,-12)
knob.BackgroundColor3 = Color3.fromRGB(200,200,255)
knob.Parent = switch

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1,0)
knobCorner.Parent = knob

--------------------------------------------------
-- TOGGLE FUNCTION
--------------------------------------------------

local function updateToggle()
	if highlightEnabled then
		enableHighlights()

		TweenService:Create(knob, TweenInfo.new(0.25), {
			Position = UDim2.new(1,-26,0.5,-12)
		}):Play()

		TweenService:Create(switch, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(0,200,120)
		}):Play()

		toggleStroke.Color = Color3.fromRGB(0,255,150)
	else
		disableHighlights()

		TweenService:Create(knob, TweenInfo.new(0.25), {
			Position = UDim2.new(0,2,0.5,-12)
		}):Play()

		TweenService:Create(switch, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(40,40,90)
		}):Play()

		toggleStroke.Color = Color3.fromRGB(0,180,255)
	end
end

toggleFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		highlightEnabled = not highlightEnabled
		updateToggle()
	end
end)

--------------------------------------------------
-- TRACER SYSTEM (ROT)
--------------------------------------------------

local tracerEnabled = false
local tracers = {}

local function createTracer(player)
	if player == LocalPlayer then return end
	if not player.Character then return end
	if not player.Character:FindFirstChild("HumanoidRootPart") then return end
	if tracers[player] then return end

	local beam = Instance.new("Beam")

	local att0 = Instance.new("Attachment")
	local att1 = Instance.new("Attachment")

	att0.Parent = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	att1.Parent = player.Character.HumanoidRootPart

	beam.Attachment0 = att0
	beam.Attachment1 = att1

	beam.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
	beam.Width0 = 0.1
	beam.Width1 = 0.1
	beam.FaceCamera = true
	beam.Parent = LocalPlayer.Character

	tracers[player] = {
		beam = beam,
		att0 = att0,
		att1 = att1
	}
end

local function removeTracer(player)
	if tracers[player] then
		tracers[player].beam:Destroy()
		tracers[player].att0:Destroy()
		tracers[player].att1:Destroy()
		tracers[player] = nil
	end
end

local function enableTracers()
	for _, player in pairs(Players:GetPlayers()) do
		createTracer(player)
	end
end

local function disableTracers()
	for player, _ in pairs(tracers) do
		removeTracer(player)
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		if tracerEnabled then
			createTracer(player)
		end
	end)
end)

--------------------------------------------------
-- TRACER TOGGLE UI (GLEICHER STYLE)
--------------------------------------------------

local tracerFrame = Instance.new("Frame")
tracerFrame.Size = UDim2.new(1, 0, 0, 50)
tracerFrame.BackgroundColor3 = Color3.fromRGB(20,20,70)
tracerFrame.Parent = container

local tracerCorner = Instance.new("UICorner")
tracerCorner.CornerRadius = UDim.new(0,12)
tracerCorner.Parent = tracerFrame

local tracerStroke = Instance.new("UIStroke")
tracerStroke.Color = Color3.fromRGB(0,180,255)
tracerStroke.Parent = tracerFrame

local tracerLabel = Instance.new("TextLabel")
tracerLabel.Size = UDim2.new(0.7,0,1,0)
tracerLabel.Position = UDim2.new(0.05,0,0,0)
tracerLabel.BackgroundTransparency = 1
tracerLabel.Text = "Player Tracer"
tracerLabel.Font = Enum.Font.GothamBold
tracerLabel.TextSize = 16
tracerLabel.TextColor3 = Color3.fromRGB(200,200,255)
tracerLabel.TextXAlignment = Enum.TextXAlignment.Left
tracerLabel.Parent = tracerFrame

local tracerSwitch = Instance.new("Frame")
tracerSwitch.Size = UDim2.new(0,60,0,28)
tracerSwitch.Position = UDim2.new(0.85,-30,0.5,-14)
tracerSwitch.BackgroundColor3 = Color3.fromRGB(40,40,90)
tracerSwitch.Parent = tracerFrame

local tracerSwitchCorner = Instance.new("UICorner")
tracerSwitchCorner.CornerRadius = UDim.new(1,0)
tracerSwitchCorner.Parent = tracerSwitch

local tracerKnob = Instance.new("Frame")
tracerKnob.Size = UDim2.new(0,24,0,24)
tracerKnob.Position = UDim2.new(0,2,0.5,-12)
tracerKnob.BackgroundColor3 = Color3.fromRGB(200,200,255)
tracerKnob.Parent = tracerSwitch

local tracerKnobCorner = Instance.new("UICorner")
tracerKnobCorner.CornerRadius = UDim.new(1,0)
tracerKnobCorner.Parent = tracerKnob

--------------------------------------------------
-- TRACER TOGGLE LOGIC
--------------------------------------------------

local function updateTracerToggle()
	if tracerEnabled then
		enableTracers()

		TweenService:Create(tracerKnob, TweenInfo.new(0.25), {
			Position = UDim2.new(1,-26,0.5,-12)
		}):Play()

		TweenService:Create(tracerSwitch, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(200,0,0)
		}):Play()

		tracerStroke.Color = Color3.fromRGB(255,0,0)
	else
		disableTracers()

		TweenService:Create(tracerKnob, TweenInfo.new(0.25), {
			Position = UDim2.new(0,2,0.5,-12)
		}):Play()

		TweenService:Create(tracerSwitch, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(40,40,90)
		}):Play()

		tracerStroke.Color = Color3.fromRGB(0,180,255)
	end
end

tracerFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		tracerEnabled = not tracerEnabled
		updateTracerToggle()
	end
end)


-- LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- UI SETUP (breiter)
--------------------------------------------------

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5,-250,0.5,-150)
mainFrame.BackgroundColor3 = Color3.fromRGB(10,10,50)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Rounded Corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,16)
corner.Parent = mainFrame

-- Glühender Rand (Outer Glow)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0,180,255)
stroke.Thickness = 2
stroke.Parent = mainFrame

--------------------------------------------------
-- DRAG SYSTEM
--------------------------------------------------

local dragging = false
local dragInput
local mousePos
local framePos

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		mainFrame.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end
end)

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "Modern Panel"
title.TextColor3 = Color3.fromRGB(200,200,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

--------------------------------------------------
-- CLOSE BUTTON (X)
--------------------------------------------------

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,35,0,35)
closeButton.Position = UDim2.new(1,-40,0,5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(30,30,80)
closeButton.TextColor3 = Color3.fromRGB(255,100,100)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1,0)
closeCorner.Parent = closeButton

closeButton.MouseEnter:Connect(function()
	closeButton.BackgroundColor3 = Color3.fromRGB(50,50,100)
end)
closeButton.MouseLeave:Connect(function()
	closeButton.BackgroundColor3 = Color3.fromRGB(30,30,80)
end)

closeButton.MouseButton1Click:Connect(function()
	mainFrame:TweenSize(
		UDim2.new(0,0,0,0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.2,
		true,
		function()
			screenGui:Destroy()
		end
	)
end)

--------------------------------------------------
-- MINIMIZE BUTTON (-)
--------------------------------------------------

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0,35,0,35)
minimizeButton.Position = UDim2.new(1,-80,0,5)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(30,30,80)
minimizeButton.TextColor3 = Color3.fromRGB(150,200,255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 24
minimizeButton.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1,0)
minCorner.Parent = minimizeButton

minimizeButton.MouseEnter:Connect(function()
	minimizeButton.BackgroundColor3 = Color3.fromRGB(50,50,100)
end)
minimizeButton.MouseLeave:Connect(function()
	minimizeButton.BackgroundColor3 = Color3.fromRGB(30,30,80)
end)

--------------------------------------------------
-- CONTENT CONTAINER
--------------------------------------------------

local container = Instance.new("Frame")
container.Position = UDim2.new(0,15,0,60)
container.Size = UDim2.new(1,-30,1,-70)
container.BackgroundTransparency = 1
container.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,12)
layout.Parent = container

--------------------------------------------------
-- MINIMIZE LOGIC
--------------------------------------------------

local isMinimized = false
local savedSize = mainFrame.Size

local function toggleMinimize()
	if not isMinimized then
		isMinimized = true
		mainFrame:TweenSize(UDim2.new(savedSize.X.Scale, savedSize.X.Offset, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		container.Visible = false
	else
		isMinimized = false
		mainFrame:TweenSize(savedSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		container.Visible = true
	end
end

minimizeButton.MouseButton1Click:Connect(toggleMinimize)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		toggleMinimize()
	end
end)

--------------------------------------------------
-- SCHNEEFLOCKEN / PUNKTE (reduziert)
--------------------------------------------------

local particleFolder = Instance.new("Folder")
particleFolder.Name = "Particles"
particleFolder.Parent = mainFrame

local function spawnParticle()
	local dot = Instance.new("Frame")
	local size = math.random(3,7)
	dot.Size = UDim2.new(0,size,0,size)
	dot.Position = UDim2.new(math.random(),0,0,0)
	dot.BackgroundColor3 = Color3.fromRGB(0,180,255)
	dot.BorderSizePixel = 0
	dot.AnchorPoint = Vector2.new(0.5,0)
	dot.BackgroundTransparency = 0
	dot.Parent = particleFolder

	local tween = TweenService:Create(dot, TweenInfo.new(math.random(2,5), Enum.EasingStyle.Linear), {Position = UDim2.new(dot.Position.X.Scale,0,1,0), BackgroundTransparency = 1})
	tween:Play()
	tween.Completed:Connect(function()
		dot:Destroy()
	end)
end

spawn(function()
	while true do
		for i=1,4 do
			spawnParticle()
		end
		wait(0.1)
	end
end)

--------------------------------------------------
-- FPS DISPLAY (transparent)
--------------------------------------------------

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0,90,0,25)
fpsLabel.Position = UDim2.new(0,10,0,10)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(0,180,255)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 16
fpsLabel.Text = "FPS: 0"
fpsLabel.Parent = mainFrame

-- FPS Berechnung
local frameCount = 0
local updateInterval = 0.1
local lastTime = tick()

RunService.RenderStepped:Connect(function()
	frameCount = frameCount + 1
	local now = tick()
	if now - lastTime >= updateInterval then
		fpsLabel.Text = "FPS: "..math.floor(frameCount / (now - lastTime))
		frameCount = 0
		lastTime = now
	end
end)

--------------------------------------------------
-- PREMIUM PLAYER HIGHLIGHT SYSTEM
--------------------------------------------------

local highlightEnabled = false
local highlights = {}

--------------------------------------------------
-- CREATE HIGHLIGHT
--------------------------------------------------

local function createHighlight(player)
	if player == LocalPlayer then return end
	if not player.Character then return end
	if highlights[player] then return end

	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(0, 180, 255)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 1
	highlight.Parent = player.Character

	-- Smooth Fade In
	TweenService:Create(highlight, TweenInfo.new(0.3), {
		FillTransparency = 0.5,
		OutlineTransparency = 0
	}):Play()

	highlights[player] = highlight
end	OutlineTransparency = 1
		}):Play()

		task.delay(0.2, function()
			if highlights[player] then
				highlights[player]:Destroy()
				highlights[player] = nil
			end
		end)
	end
end

local function enableHighlights()
	for _, player in pairs(Players:GetPlayers()) do
		createHighlight(player)
	end
end

local function disableHighlights()
	for player, _ in pairs(highlights) do
		removeHighlight(player)
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		if highlightEnabled then
			createHighlight(player)
		end
	end)
end)

--------------------------------------------------
-- MODERN TOGGLE SWITCH DESIGN
--------------------------------------------------

local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(1, 0, 0, 50)
toggleFrame.BackgroundColor3 = Color3.fromRGB(20,20,70)
toggleFrame.Parent = container

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0,12)
toggleCorner.Parent = toggleFrame

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(0,180,255)
toggleStroke.Parent = toggleFrame

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(0.7,0,1,0)
toggleLabel.Position = UDim2.new(0.05,0,0,0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "Player Highlight"
toggleLabel.Font = Enum.Font.GothamBold
toggleLabel.TextSize = 16
toggleLabel.TextColor3 = Color3.fromRGB(200,200,255)
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.Parent = toggleFrame

local switch = Instance.new("Frame")
switch.Size = UDim2.new(0,60,0,28)
switch.Position = UDim2.new(0.85,-30,0.5,-14)
switch.BackgroundColor3 = Color3.fromRGB(40,40,90)
switch.Parent = toggleFrame

local switchCorner = Instance.new("UICorner")
switchCorner.CornerRadius = UDim.new(1,0)
switchCorner.Parent = switch

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0,24,0,24)
knob.Position = UDim2.new(0,2,0.5,-12)
knob.BackgroundColor3 = Color3.fromRGB(200,200,255)
knob.Parent = switch

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1,0)
knobCorner.Parent = knob

--------------------------------------------------
-- TOGGLE FUNCTION
--------------------------------------------------

local function updateToggle()
	if highlightEnabled then
		enableHighlights()

		TweenService:Create(knob, TweenInfo.new(0.25), {
			Position = UDim2.new(1,-26,0.5,-12)
		}):Play()

		TweenService:Create(switch, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(0,200,120)
		}):Play()

		toggleStroke.Color = Color3.fromRGB(0,255,150)
	else
		disableHighlights()

		TweenService:Create(knob, TweenInfo.new(0.25), {
			Position = UDim2.new(0,2,0.5,-12)
		}):Play()

		TweenService:Create(switch, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(40,40,90)
		}):Play()

		toggleStroke.Color = Color3.fromRGB(0,180,255)
	end
end

toggleFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		highlightEnabled = not highlightEnabled
		updateToggle()
	end
end)

--------------------------------------------------
-- TRACER SYSTEM (ROT)
--------------------------------------------------

local tracerEnabled = false
local tracers = {}

local function createTracer(player)
	if player == LocalPlayer then return end
	if not player.Character then return end
	if not player.Character:FindFirstChild("HumanoidRootPart") then return end
	if tracers[player] then return end

	local beam = Instance.new("Beam")

	local att0 = Instance.new("Attachment")
	local att1 = Instance.new("Attachment")

	att0.Parent = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	att1.Parent = player.Character.HumanoidRootPart

	beam.Attachment0 = att0
	beam.Attachment1 = att1

	beam.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
	beam.Width0 = 0.1
	beam.Width1 = 0.1
	beam.FaceCamera = true
	beam.Parent = LocalPlayer.Character

	tracers[player] = {
		beam = beam,
		att0 = att0,
		att1 = att1
	}
end

local function removeTracer(player)
	if tracers[player] then
		tracers[player].beam:Destroy()
		tracers[player].att0:Destroy()
		tracers[player].att1:Destroy()
		tracers[player] = nil
	end
end

local function enableTracers()
	for _, player in pairs(Players:GetPlayers()) do
		createTracer(player)
	end
end

local function disableTracers()
	for player, _ in pairs(tracers) do
		removeTracer(player)
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		if tracerEnabled then
			createTracer(player)
		end
	end)
end)

--------------------------------------------------
-- TRACER TOGGLE UI (GLEICHER STYLE)
--------------------------------------------------

local tracerFrame = Instance.new("Frame")
tracerFrame.Size = UDim2.new(1, 0, 0, 50)
tracerFrame.BackgroundColor3 = Color3.fromRGB(20,20,70)
tracerFrame.Parent = container

local tracerCorner = Instance.new("UICorner")
tracerCorner.CornerRadius = UDim.new(0,12)
tracerCorner.Parent = tracerFrame

local tracerStroke = Instance.new("UIStroke")
tracerStroke.Color = Color3.fromRGB(0,180,255)
tracerStroke.Parent = tracerFrame

local tracerLabel = Instance.new("TextLabel")
tracerLabel.Size = UDim2.new(0.7,0,1,0)
tracerLabel.Position = UDim2.new(0.05,0,0,0)
tracerLabel.BackgroundTransparency = 1
tracerLabel.Text = "Player Tracer"
tracerLabel.Font = Enum.Font.GothamBold
tracerLabel.TextSize = 16
tracerLabel.TextColor3 = Color3.fromRGB(200,200,255)
tracerLabel.TextXAlignment = Enum.TextXAlignment.Left
tracerLabel.Parent = tracerFrame

local tracerSwitch = Instance.new("Frame")
tracerSwitch.Size = UDim2.new(0,60,0,28)
tracerSwitch.Position = UDim2.new(0.85,-30,0.5,-14)
tracerSwitch.BackgroundColor3 = Color3.fromRGB(40,40,90)
tracerSwitch.Parent = tracerFrame

local tracerSwitchCorner = Instance.new("UICorner")
tracerSwitchCorner.CornerRadius = UDim.new(1,0)
tracerSwitchCorner.Parent = tracerSwitch

local tracerKnob = Instance.new("Frame")
tracerKnob.Size = UDim2.new(0,24,0,24)
tracerKnob.Position = UDim2.new(0,2,0.5,-12)
tracerKnob.BackgroundColor3 = Color3.fromRGB(200,200,255)
tracerKnob.Parent = tracerSwitch

local tracerKnobCorner = Instance.new("UICorner")
tracerKnobCorner.CornerRadius = UDim.new(1,0)
tracerKnobCorner.Parent = tracerKnob

--------------------------------------------------
-- TRACER TOGGLE LOGIC
--------------------------------------------------

local function updateTracerToggle()
	if tracerEnabled then
		enableTracers()

		TweenService:Create(tracerKnob, TweenInfo.new(0.25), {
			Position = UDim2.new(1,-26,0.5,-12)
		}):Play()

		TweenService:Create(tracerSwitch, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(200,0,0)
		}):Play()

		tracerStroke.Color = Color3.fromRGB(255,0,0)
	else
		disableTracers()

		TweenService:Create(tracerKnob, TweenInfo.new(0.25), {
			Position = UDim2.new(0,2,0.5,-12)
		}):Play()

		TweenService:Create(tracerSwitch, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(40,40,90)
		}):Play()

		tracerStroke.Color = Color3.fromRGB(0,180,255)
	end
end

tracerFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		tracerEnabled = not tracerEnabled
		updateTracerToggle()
	end
end)

local function removeHighlight(player)
	if highlights[player] then
		TweenService:Create(highlights[player], TweenInfo.new(0.2), {
			FillTransparency = 1,
		
