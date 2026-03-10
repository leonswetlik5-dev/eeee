local uiOpen = true
local scriptClosed = false
-- ANTI DOUBLE OPEN FIX
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local function ClearAllESP()

		scriptClosed = true

    -- NAME ESP
    for _,v in pairs(tags) do
        v:Remove()
    end
    tags = {}

    -- SKELETON ESP
    for _,lines in pairs(skeletons) do
        for _,line in pairs(lines) do
            line:Remove()
        end
    end
    skeletons = {}

    -- DISTANCE ESP
    for _,v in pairs(distanceTags) do
        v:Remove()
    end
    distanceTags = {}

    -- HEALTHBAR ESP
    for _,data in pairs(healthbars) do
        data.outline:Remove()
        data.bar:Remove()
    end
    healthbars = {}

    -- BOX ESP
    for _,box in pairs(boxes) do
        box:Remove()
    end
    boxes = {}

    -- TRACERS
    for _,line in pairs(tracers) do
        line:Remove()
    end
    tracers = {}

	for _,v in pairs(tags) do pcall(function() v.Visible = false end) end
for _,v in pairs(distanceTags) do pcall(function() v.Visible = false end) end

end

if LocalPlayer.PlayerGui:FindFirstChild("ModernPanelUI") then
    LocalPlayer.PlayerGui:FindFirstChild("ModernPanelUI"):Destroy()
end

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local blur = Lighting:FindFirstChild("MenuBlur")

if not blur then
    blur = Instance.new("BlurEffect")
    blur.Name = "MenuBlur"
    blur.Size = 0
    blur.Parent = Lighting
end

--------------------------------------------------
-- UI SETUP
--------------------------------------------------

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernPanelUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 265)
mainFrame.Position = UDim2.new(1, -555, 0, 54) -- FIXED: Kein Minus vor 54
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
TweenService:Create(
    blur,
    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = 30}
):Play()

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80,80,80)
stroke.Thickness = 2
stroke.Parent = mainFrame

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "MONO WARE"
title.TextColor3 = Color3.fromRGB(220,220,220)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

--------------------------------------------------
-- DRAG SYSTEM (TOPBAR ONLY)
--------------------------------------------------

local dragging = false
local dragInput
local mousePos
local framePos

title.InputBegan:Connect(function(input)

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

title.InputChanged:Connect(function(input)

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
-- CLOSE BUTTON (FULL SCRIPT CLOSE)
--------------------------------------------------

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,35,0,35)
closeButton.Position = UDim2.new(1,-40,0,5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
closeButton.TextColor3 = Color3.fromRGB(255,100,100)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

Instance.new("UICorner", closeButton).CornerRadius = UDim.new(1,0)

closeButton.MouseButton1Click:Connect(function()

    uiOpen = false

    -- ESP zuerst komplett entfernen
    pcall(function()
        ClearAllESP()
    end)

    -- 1 Frame warten damit Drawing wirklich gelöscht wird
    RunService.RenderStepped:Wait()

    -- Script stoppen
    scriptClosed = true

    --------------------------------------------------
    -- PLAYER RESET
    --------------------------------------------------

    pcall(function()

        local char = LocalPlayer.Character
        if char then

            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end

            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(0,0,0)
            end

        end

        walkSpeedEnabled = false
        flyEnabled = false
        walkSpeed = 16
        flySpeed = 1

    end)

    --------------------------------------------------
    -- BLUR ENTFERNEN
    --------------------------------------------------

    pcall(function()
        local blurEffect = game:GetService("Lighting"):FindFirstChild("MenuBlur")
        if blurEffect then
            blurEffect:Destroy()
        end
    end)

    --------------------------------------------------
    -- LOGO ENTFERNEN
    --------------------------------------------------

    pcall(function()
        local logo = LocalPlayer.PlayerGui:FindFirstChild("MWLogoOverlay")
        if logo then
            logo:Destroy()
        end
    end)

    --------------------------------------------------
    -- UI LÖSCHEN
    --------------------------------------------------

    pcall(function()
        if LocalPlayer.PlayerGui:FindFirstChild("ModernPanelUI") then
            LocalPlayer.PlayerGui.ModernPanelUI:Destroy()
        end
    end)

end)
--------------------------------------------------
-- FPS DISPLAY
--------------------------------------------------

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0,90,0,25)
fpsLabel.Position = UDim2.new(0,10,0,10)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(220,220,220)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 16
fpsLabel.Text = "FPS: 0"
fpsLabel.Parent = mainFrame

local fps = 0
local last = tick()

RunService.RenderStepped:Connect(function(dt)

    if scriptClosed then return end

    fps = 1/dt

    if tick() - last > 0.5 then
        fpsLabel.Text = "FPS: "..math.floor(fps)
        last = tick()
    end
end)
--------------------------------------------------
-- KILL BUTTON (TOPBAR)
--------------------------------------------------

local killTopButton = Instance.new("TextButton")
killTopButton.Size = UDim2.new(0,70,0,25)
killTopButton.Position = UDim2.new(0.5,-160,0,10)

killTopButton.BackgroundTransparency = 1
killTopButton.AutoButtonColor = false -- verhindert Hover Hintergrund

killTopButton.Text = "KILL"
killTopButton.TextColor3 = Color3.fromRGB(220,220,220)
killTopButton.Font = Enum.Font.GothamBold
killTopButton.TextSize = 16
killTopButton.Parent = mainFrame

Instance.new("UICorner", killTopButton).CornerRadius = UDim.new(0,6)

local warningText = Instance.new("TextLabel")
warningText.Size = UDim2.new(1,0,0.2,0) -- ganze Bildschirmbreite
warningText.Position = UDim2.new(0,0,0.4,0)
warningText.BackgroundTransparency = 1
warningText.Text = "⚠ CLOSE SCRIPT / KICK OUT OF THE GAME ⚠"
warningText.TextColor3 = Color3.fromRGB(255,0,0)
warningText.Font = Enum.Font.GothamBold
warningText.TextScaled = true
warningText.Visible = false
warningText.Parent = screenGui

killTopButton.MouseEnter:Connect(function()
    killTopButton.TextColor3 = Color3.fromRGB(255,80,80)
    warningText.Visible = true
end)

killTopButton.MouseLeave:Connect(function()
    killTopButton.TextColor3 = Color3.fromRGB(220,220,220)
    warningText.Visible = false
end)

killTopButton.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer:Kick("Mono Ware Closed")
end)

local hidden = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        
        hidden = not hidden
        mainFrame.Visible = not hidden
        mainFrame.Active = not hidden
        uiOpen = not hidden

        -- LOGO MIT AUSBLENDEN
        local logo = LocalPlayer.PlayerGui:FindFirstChild("MWLogoOverlay")
        if logo then
            logo.Enabled = not hidden
        end

        if hidden then
            TweenService:Create(
                blur,
                TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = 0}
            ):Play()
        else
            TweenService:Create(
                blur,
                TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = 30}
            ):Play()
        end

    end
end)

--------------------------------------------------
-- LOCAL CLOCK SYSTEM
--------------------------------------------------

local clockLabel = Instance.new("TextLabel")
clockLabel.Size = UDim2.new(0,120,0,25)
clockLabel.Position = UDim2.new(1,-180,0,11)
clockLabel.BackgroundTransparency = 100
clockLabel.TextColor3 = Color3.fromRGB(220,220,220)
clockLabel.Font = Enum.Font.GothamBold
clockLabel.TextSize = 16
clockLabel.Text = "00:00"
clockLabel.Parent = mainFrame

task.spawn(function()
    while not scriptClosed do
        local time = os.date("*t")

        local hour = string.format("%02d", time.hour)
        local min = string.format("%02d", time.min)

        clockLabel.Text = hour..":"..min.." Uhr"

        task.wait(1)
    end
end)

--------------------------------------------------
-- CONTENT FRAME (FIXED: Nur einmal erstellen)
--------------------------------------------------

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 55)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

--------------------------------------------------
-- TAB SYSTEM (KORRIGIERTE VERSION)
--------------------------------------------------

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(0, 130, 1, 0)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = contentFrame

local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -140, 1, 0)
pagesContainer.Position = UDim2.new(0, 140, 0, 0)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = contentFrame

local tabs = {}
local currentTab = nil

local function createTab(name, order)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(0, 0, 0, (order-1) * 40)
    button.BackgroundColor3 = Color3.fromRGB(30,30,30)
    button.BackgroundTransparency = 0.35
    button.TextColor3 = Color3.fromRGB(220,220,220)
    button.Text = name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.BorderSizePixel = 0
    button.Parent = tabContainer
    
    Instance.new("UICorner", button).CornerRadius = UDim.new(0,12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50,50,50)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = button
    
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = pagesContainer
    
    tabs[name] = {Button = button, Page = page}

    button.MouseButton1Click:Connect(function()
        for _, tabData in pairs(tabs) do
            tabData.Page.Visible = false
            tabData.Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
            tabData.Button.BackgroundTransparency = 0.35
        end
        
        page.Visible = true
        button.BackgroundColor3 = Color3.fromRGB(15,15,15)
        button.BackgroundTransparency = 0
        currentTab = name
    end)
    
    return page
end

-- Tabs erstellen (Main Tab entfernt da du Combat als Standard willst)
local combatPage = createTab("Combat", 1)
--------------------------------------------------
-- COMBAT SCROLL SYSTEM
--------------------------------------------------

local combatScroll = Instance.new("ScrollingFrame")
combatScroll.Size = UDim2.new(1,0,1,0)
combatScroll.CanvasSize = UDim2.new(0,0,0,600)
combatScroll.ScrollBarThickness = 4
combatScroll.BackgroundTransparency = 1
combatScroll.Parent = combatPage

local combatLayout = Instance.new("UIListLayout")
combatLayout.Padding = UDim.new(0,10)
combatLayout.SortOrder = Enum.SortOrder.LayoutOrder
combatLayout.Parent = combatScroll

local visualsPage = createTab("Visuals", 2)
--------------------------------------------------
-- VISUALS SCROLL SYSTEM
--------------------------------------------------

local visualsScroll = Instance.new("ScrollingFrame")
visualsScroll.Size = UDim2.new(1,0,1,0)
visualsScroll.CanvasSize = UDim2.new(0,0,0,400)
visualsScroll.ScrollBarThickness = 4
visualsScroll.BackgroundTransparency = 1
visualsScroll.Parent = visualsPage

local visualsLayout = Instance.new("UIListLayout")
visualsLayout.Padding = UDim.new(0,10)
visualsLayout.SortOrder = Enum.SortOrder.LayoutOrder
visualsLayout.Parent = visualsScroll

visualsScroll.CanvasSize = UDim2.new(0,0,0,600)
local playerModsPage = createTab("Player", 3)
--------------------------------------------------
-- PLAYER SCROLL SYSTEM
--------------------------------------------------

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1,0,1,0)
playerScroll.CanvasSize = UDim2.new(0,0,0,600)
playerScroll.ScrollBarThickness = 4
playerScroll.BackgroundTransparency = 1
playerScroll.Parent = playerModsPage

local playerLayout = Instance.new("UIListLayout")
playerLayout.Padding = UDim.new(0,10)
playerLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerLayout.Parent = playerScroll

--------------------------------------------------
-- PLAYER TAB SYSTEM
--------------------------------------------------

local walkSpeedEnabled = false
local walkSpeed = 16

local flyEnabled = false
local flySpeed = 1
local slideBoostEnabled = false
local slideBoostPower = 0
local infinityJumpEnabled = false

--------------------------------------------------
-- WALK SPEED
--------------------------------------------------

local walkToggle = Instance.new("TextButton")
walkToggle.Size = UDim2.new(1,-20,0,40)
walkToggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
walkToggle.Text = "WalkSpeed [ OFF ]"
walkToggle.TextColor3 = Color3.fromRGB(220,220,220)
walkToggle.Font = Enum.Font.GothamBold
walkToggle.TextSize = 16
walkToggle.Parent = playerScroll
walkToggle.LayoutOrder = 1

Instance.new("UICorner",walkToggle).CornerRadius = UDim.new(0,12)

local walkFrame = Instance.new("Frame")
walkFrame.Size = UDim2.new(1,-20,0,0)
walkFrame.BackgroundTransparency = 1
walkFrame.ClipsDescendants = true
walkFrame.Parent = playerScroll
walkFrame.LayoutOrder = 2

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1,0,0,20)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = Color3.fromRGB(220,220,220)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 16
speedLabel.Parent = walkFrame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(1,0,0,6)
sliderBar.Position = UDim2.new(0,0,0,25)
sliderBar.BackgroundColor3 = Color3.fromRGB(45,45,45)
sliderBar.Parent = walkFrame
Instance.new("UICorner",sliderBar).CornerRadius = UDim.new(1,0)

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0,16,0,16)
sliderKnob.Position = UDim2.new(0,0,0,20)
sliderKnob.BackgroundColor3 = Color3.fromRGB(0,170,255)
sliderKnob.Parent = walkFrame
Instance.new("UICorner",sliderKnob).CornerRadius = UDim.new(1,0)

local walkDragging = false

sliderKnob.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        walkDragging = true
    end
end)

sliderKnob.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        walkDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(i)

    if walkDragging and i.UserInputType == Enum.UserInputType.MouseMovement then

        local mouse = UserInputService:GetMouseLocation().X
        local pos = sliderBar.AbsolutePosition.X
        local size = sliderBar.AbsoluteSize.X

        local percent = math.clamp((mouse-pos)/size,0,1)

        sliderKnob.Position = UDim2.new(percent,-8,0,20)

        walkSpeed = math.floor(16 + percent * 184)

        speedLabel.Text = "Speed: "..walkSpeed

    end

end)

walkToggle.MouseButton1Click:Connect(function()

    walkSpeedEnabled = not walkSpeedEnabled

    if walkSpeedEnabled then

        walkToggle.Text = "WalkSpeed [ ON ]"
        walkToggle.BackgroundColor3 = Color3.fromRGB(20,60,20)

        TweenService:Create(
            walkFrame,
            TweenInfo.new(0.25),
            {Size = UDim2.new(1,-20,0,50)}
        ):Play()

    else

        walkToggle.Text = "WalkSpeed [ OFF ]"
        walkToggle.BackgroundColor3 = Color3.fromRGB(30,30,30)

        TweenService:Create(
            walkFrame,
            TweenInfo.new(0.25),
            {Size = UDim2.new(1,-20,0,0)}
        ):Play()

        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end
        end

    end

end)

RunService.RenderStepped:Connect(function()

    if scriptClosed then return end

    if walkSpeedEnabled then

        local char = LocalPlayer.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        hum.WalkSpeed = walkSpeed

    end

end)

--------------------------------------------------
-- FLY
--------------------------------------------------

local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(1,-20,0,40)
flyToggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
flyToggle.Text = "Fly [ OFF ]"
flyToggle.TextColor3 = Color3.fromRGB(220,220,220)
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 16
flyToggle.Parent = playerScroll
flyToggle.LayoutOrder = 3
Instance.new("UICorner",flyToggle).CornerRadius = UDim.new(0,12)

local flyFrame = Instance.new("Frame")
flyFrame.Size = UDim2.new(1,-20,0,0)
flyFrame.BackgroundTransparency = 1
flyFrame.ClipsDescendants = true
flyFrame.Parent = playerScroll
flyFrame.LayoutOrder = 4

local flyLabel = Instance.new("TextLabel")
flyLabel.Size = UDim2.new(1,0,0,20)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "FlySpeed: 2"
flyLabel.TextColor3 = Color3.fromRGB(220,220,220)
flyLabel.Font = Enum.Font.GothamBold
flyLabel.TextSize = 16
flyLabel.Parent = flyFrame

local flySlider = Instance.new("Frame")
flySlider.Size = UDim2.new(1,0,0,6)
flySlider.Position = UDim2.new(0,0,0,25)
flySlider.BackgroundColor3 = Color3.fromRGB(45,45,45)
flySlider.Parent = flyFrame
Instance.new("UICorner",flySlider).CornerRadius = UDim.new(1,0)

local flyKnob = Instance.new("Frame")
flyKnob.Size = UDim2.new(0,16,0,16)
flyKnob.Position = UDim2.new(0,0,0,20)
flyKnob.BackgroundColor3 = Color3.fromRGB(0,170,255)
flyKnob.Parent = flyFrame
Instance.new("UICorner",flyKnob).CornerRadius = UDim.new(1,0)

local flyDrag = false

flyKnob.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        flyDrag = true
    end
end)

flyKnob.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        flyDrag = false
    end
end)

UserInputService.InputChanged:Connect(function(i)

    if flyDrag and i.UserInputType == Enum.UserInputType.MouseMovement then

        local mouse = UserInputService:GetMouseLocation().X
        local pos = flySlider.AbsolutePosition.X
        local size = flySlider.AbsoluteSize.X

        local percent = math.clamp((mouse-pos)/size,0,1)

        flyKnob.Position = UDim2.new(percent,-8,0,20)

        flySpeed = math.floor(1 + percent * 9)

        flyLabel.Text = "FlySpeed: "..flySpeed

    end

end)

flyToggle.MouseButton1Click:Connect(function()

    flyEnabled = not flyEnabled

    if flyEnabled then

        flyToggle.Text = "Fly [ ON ]"
        flyToggle.BackgroundColor3 = Color3.fromRGB(20,60,20)

        TweenService:Create(
            flyFrame,
            TweenInfo.new(0.25),
            {Size = UDim2.new(1,-20,0,50)}
        ):Play()

    else

        flyToggle.Text = "Fly [ OFF ]"
        flyToggle.BackgroundColor3 = Color3.fromRGB(30,30,30)

        TweenService:Create(
            flyFrame,
            TweenInfo.new(0.25),
            {Size = UDim2.new(1,-20,0,0)}
        ):Play()

    end

end)

RunService.RenderStepped:Connect(function()

    if scriptClosed then return end

    if flyEnabled then

        local char = LocalPlayer.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local cam = workspace.CurrentCamera
        local move = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move += cam.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move -= cam.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move -= cam.CFrame.RightVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move += cam.CFrame.RightVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move += Vector3.new(0,1,0)
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            move -= Vector3.new(0,1,0)
        end

        root.Velocity = move * flySpeed * 25

    end

end)

--------------------------------------------------
-- SLIDE BOOST
--------------------------------------------------

local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

local slideBoostEnabled = false
local slideBoostPower = 0

-- Toggle Button
local slideToggle = Instance.new("TextButton")
slideToggle.Size = UDim2.new(1,-20,0,40)
slideToggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
slideToggle.Text = "Slide Boost [ OFF ]"
slideToggle.TextColor3 = Color3.fromRGB(220,220,220)
slideToggle.Font = Enum.Font.GothamBold
slideToggle.TextSize = 16
slideToggle.Parent = playerScroll
slideToggle.LayoutOrder = 5
Instance.new("UICorner",slideToggle).CornerRadius = UDim.new(0,12)

-- Slider Frame
local slideFrame = Instance.new("Frame")
slideFrame.Size = UDim2.new(1,-20,0,0)
slideFrame.BackgroundTransparency = 1
slideFrame.ClipsDescendants = true
slideFrame.Parent = playerScroll
slideFrame.LayoutOrder = 6

-- Label
local slideLabel = Instance.new("TextLabel")
slideLabel.Size = UDim2.new(1,0,0,20)
slideLabel.BackgroundTransparency = 1
slideLabel.Text = "Boost: 0"
slideLabel.TextColor3 = Color3.fromRGB(220,220,220)
slideLabel.Font = Enum.Font.GothamBold
slideLabel.TextSize = 16
slideLabel.Parent = slideFrame

-- Slider Bar
local slideSlider = Instance.new("Frame")
slideSlider.Size = UDim2.new(1,0,0,6)
slideSlider.Position = UDim2.new(0,0,0,25)
slideSlider.BackgroundColor3 = Color3.fromRGB(45,45,45)
slideSlider.Parent = slideFrame
Instance.new("UICorner",slideSlider).CornerRadius = UDim.new(1,0)

-- Slider Knob
local slideKnob = Instance.new("Frame")
slideKnob.Size = UDim2.new(0,16,0,16)
slideKnob.Position = UDim2.new(0,0,0,20)
slideKnob.BackgroundColor3 = Color3.fromRGB(0,170,255)
slideKnob.Parent = slideFrame
Instance.new("UICorner",slideKnob).CornerRadius = UDim.new(1,0)

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

slideToggle.MouseButton1Click:Connect(function()
    slideBoostEnabled = not slideBoostEnabled

    if slideBoostEnabled then
        slideToggle.Text = "Slide Boost [ ON ]"
        slideToggle.BackgroundColor3 = Color3.fromRGB(20,60,20) -- Grün

        -- Slide Slider einblenden
        slideFrame:TweenSize(
            UDim2.new(1,-20,0,50),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.25,
            true
        )

        -- WICHTIG: LayoutOrder setzen
        slideFrame.LayoutOrder = slideToggle.LayoutOrder + 1  -- Slider direkt unter Slide Boost
        infJumpToggle.LayoutOrder = slideFrame.LayoutOrder + 1  -- Infinity Jump danach

    else
        slideToggle.Text = "Slide Boost [ OFF ]"
        slideToggle.BackgroundColor3 = Color3.fromRGB(30,30,30) -- Grau

        -- Slider ausblenden
        slideFrame:TweenSize(
            UDim2.new(1,-20,0,0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.25,
            true
        )

        -- Slider unsichtbar → Infinity Jump rückt wieder nach oben
        slideFrame.LayoutOrder = 0
        infJumpToggle.LayoutOrder = slideToggle.LayoutOrder + 1
    end
end)

--------------------------------------------------
-- SLIDER
--------------------------------------------------

local dragging = false

slideKnob.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
end
end)

slideKnob.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = false
end
end)

UIS.InputChanged:Connect(function(input)

if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

local pos = (input.Position.X - slideSlider.AbsolutePosition.X) / slideSlider.AbsoluteSize.X
pos = math.clamp(pos,0,1)

slideKnob.Position = UDim2.new(pos,-8,0,20)

slideBoostPower = math.floor(pos * 100)
slideLabel.Text = "Boost: "..slideBoostPower

end
end)

--------------------------------------------------
-- SLIDE BOOST SYSTEM
--------------------------------------------------

UIS.InputBegan:Connect(function(input,gpe)

if gpe then return end
if input.KeyCode ~= Enum.KeyCode.LeftControl then return end
if not slideBoostEnabled then return end

local char = player.Character
if not char then return end

local hrp = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")

if not hrp or not hum then return end

-- Nur wenn am Boden
if hum.FloorMaterial == Enum.Material.Air then
return
end

local boost = slideBoostPower * 2

local vel = Instance.new("BodyVelocity")
vel.MaxForce = Vector3.new(1,0,1) * 50000
vel.Velocity = hrp.CFrame.LookVector * boost
vel.Parent = hrp

game.Debris:AddItem(vel,0.2)

end)

--------------------------------------------------
-- INFINITY JUMP
--------------------------------------------------

local infJumpToggle = Instance.new("TextButton")
infJumpToggle.Size = UDim2.new(1,-20,0,40)
infJumpToggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
infJumpToggle.Text = "Infinity Jump [ OFF ]"
infJumpToggle.TextColor3 = Color3.fromRGB(220,220,220)
infJumpToggle.Font = Enum.Font.GothamBold
infJumpToggle.TextSize = 16
infJumpToggle.Parent = playerScroll
infJumpToggle.LayoutOrder = 7

Instance.new("UICorner",infJumpToggle).CornerRadius = UDim.new(0,12)

infJumpToggle.MouseButton1Click:Connect(function()

    infinityJumpEnabled = not infinityJumpEnabled

    if infinityJumpEnabled then
        infJumpToggle.Text = "Infinity Jump [ ON ]"
        infJumpToggle.BackgroundColor3 = Color3.fromRGB(20,60,20)
    else
        infJumpToggle.Text = "Infinity Jump [ OFF ]"
        infJumpToggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
    end

end)

local settingsPage = createTab("Settings", 4)
--------------------------------------------------
-- SETTINGS SCROLL SYSTEM
--------------------------------------------------

local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1,0,1,0)
settingsScroll.CanvasSize = UDim2.new(0,0,0,1200)
settingsScroll.ScrollBarThickness = 4
settingsScroll.BackgroundTransparency = 1
settingsScroll.Parent = settingsPage

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.Padding = UDim.new(0,10)
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsLayout.Parent = settingsScroll


--------------------------------------------------
-- SKY SYSTEM (ALLE SKIES MIT IDs)
--------------------------------------------------

local skyDropdown = Instance.new("TextButton")
skyDropdown.Size = UDim2.new(1,-20,0,40)
skyDropdown.BackgroundColor3 = Color3.fromRGB(30,30,30)
skyDropdown.TextColor3 = Color3.fromRGB(220,220,220)
skyDropdown.Font = Enum.Font.GothamBold
skyDropdown.TextSize = 16
skyDropdown.Text = "Select Sky"
skyDropdown.LayoutOrder = 2
skyDropdown.Parent = settingsScroll
Instance.new("UICorner", skyDropdown).CornerRadius = UDim.new(0,12)

-- Alle Skies (mit funktionierenden IDs)
local skies = {

{name="Aurora", id="159454299"},
{name="Beautifaul", id="570557514"},
{name="Blue", id="7018684000"},
{name="Chill Gray", id="271042516"},
{name="Chill Pink", id="271042556"},
{name="Chroma Key", id="271042556"},
{name="Cyan", id="570557620"},
{name="Emo", id="6285719338"},
{name="Goodnight", id="159454296"},
{name="Light Blue", id="7018684000"},
{name="Light Pink", id="271042556"},
{name="Moonlight", id="159454288"},
{name="Neon Sky", id="570557514"},
{name="Neon Sky 2", id="570557620"},
{name="Night Orange Overcast", id="6285719338"},
{name="Pandora", id="271042516"},
{name="Pink Sunrise", id="271042556"},
{name="Red", id="6285719338"},
{name="Spooky", id="6285719338"},
{name="Universe", id="159454299"},
{name="Space Blue", id="7018684000"}

}

-- Dropdown
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1,-20,0,0)
dropdownFrame.BackgroundTransparency = 1
dropdownFrame.ClipsDescendants = true
dropdownFrame.LayoutOrder = 3
dropdownFrame.Parent = settingsScroll

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = dropdownFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,5)

local dropdownOpen = false

skyDropdown.MouseButton1Click:Connect(function()

    dropdownOpen = not dropdownOpen

    dropdownFrame:TweenSize(
        UDim2.new(1,-20,0, dropdownOpen and (#skies*35) or 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.25,
        true
    )

end)

for _, sky in ipairs(skies) do

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = sky.name
    btn.Parent = dropdownFrame

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(function()

        skyDropdown.Text = sky.name

        if Lighting:FindFirstChild("CustomSky") then
            Lighting.CustomSky:Destroy()
        end

        local newSky = Instance.new("Sky")
        newSky.Name = "CustomSky"

        local id = "rbxassetid://"..sky.id

        newSky.SkyboxBk = id
        newSky.SkyboxDn = id
        newSky.SkyboxFt = id
        newSky.SkyboxLf = id
        newSky.SkyboxRt = id
        newSky.SkyboxUp = id

        newSky.Parent = Lighting

    end)

end
--------------------------------------------------
-- FPS BOOST SYSTEM (mit Wiederherstellung)
--------------------------------------------------

local fpsBoost = false

local fpsButton = Instance.new("TextButton")
fpsButton.Size = UDim2.new(1,-20,0,40)
fpsButton.Position = UDim2.new(0,10,0,10)
fpsButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
fpsButton.Text = "FPS BOOST [ OFF ]"
fpsButton.TextColor3 = Color3.fromRGB(220,220,220)
fpsButton.Font = Enum.Font.GothamBold
fpsButton.TextSize = 16
fpsButton.Parent = settingsScroll

Instance.new("UICorner",fpsButton).CornerRadius = UDim.new(0,12)

-- Werte speichern, die wir ändern
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

local originalSettings = {
    GlobalShadows = Lighting.GlobalShadows,
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    QualityLevel = settings().Rendering.QualityLevel,
    PostEffects = {}
}

-- PostEffects speichern
for _,v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        originalSettings.PostEffects[v] = v.Enabled
    end
end

-- Decals speichern
local originalDecals = {}
for _,v in ipairs(workspace:GetDescendants()) do
    if v:IsA("Decal") then
        originalDecals[v] = v.Transparency
    end
end

fpsButton.MouseButton1Click:Connect(function()
    fpsBoost = not fpsBoost

    if fpsBoost then
        fpsButton.Text = "FPS BOOST [ ON ]"
        fpsButton.BackgroundColor3 = Color3.fromRGB(20,60,20)

        -- Lighting reduzieren
        Lighting.GlobalShadows = false
        Lighting.Brightness = 1
        Lighting.FogEnd = 9e9
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0

        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        -- Effekte aus
        for _,v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") then
                v.Enabled = false
            end
        end

        -- Decals aus
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Decal") then
                v.Transparency = 1
            end
        end

    else
        fpsButton.Text = "FPS BOOST [ OFF ]"
        fpsButton.BackgroundColor3 = Color3.fromRGB(30,30,30)

        -- Originalwerte wiederherstellen
        Lighting.GlobalShadows = originalSettings.GlobalShadows
        Lighting.Brightness = originalSettings.Brightness
        Lighting.FogEnd = originalSettings.FogEnd
        Lighting.EnvironmentDiffuseScale = originalSettings.EnvironmentDiffuseScale
        Lighting.EnvironmentSpecularScale = originalSettings.EnvironmentSpecularScale
        settings().Rendering.QualityLevel = originalSettings.QualityLevel

        -- PostEffects wiederherstellen
        for effect,enabled in pairs(originalSettings.PostEffects) do
            if effect.Parent then -- nur falls Effect noch existiert
                effect.Enabled = enabled
            end
        end

        -- Decals wiederherstellen
        for decal,trans in pairs(originalDecals) do
            if decal.Parent then
                decal.Transparency = trans
            end
        end
    end
end)
--------------------------------------------------
-- NAME ESP SYSTEM
--------------------------------------------------

local MAX_DISTANCE = 200
local nameEspEnabled = false
local tags = {}

local function createTag(player)

    if scriptClosed then return end
    if player == LocalPlayer then return end

    local text = Drawing.new("Text")
    text.Size = 16
    text.Center = true
    text.Outline = true
    text.Color = Color3.fromRGB(255,255,255)
    text.Visible = false

    tags[player] = text

end

local function removeTag(player)

    if tags[player] then
        tags[player]:Remove()
        tags[player] = nil
    end

end

for _,p in pairs(Players:GetPlayers()) do
    createTag(p)
end

Players.PlayerAdded:Connect(createTag)
Players.PlayerRemoving:Connect(removeTag)

RunService.RenderStepped:Connect(function()

    if scriptClosed then return end

    if not nameEspEnabled then
        for _,v in pairs(tags) do
            v.Visible = false
        end
        return
    end

    local char = LocalPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for player,text in pairs(tags) do

        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and char:FindFirstChild("Head")

        if humanoid and humanoid.Health > 0 and head then

            local distance = (head.Position - root.Position).Magnitude

            if distance <= MAX_DISTANCE then

                local pos,visible = workspace.CurrentCamera:WorldToViewportPoint(head.Position + Vector3.new(0,2.5,0))

                if visible then
                    text.Position = Vector2.new(pos.X,pos.Y)
                    text.Text = player.DisplayName
                    text.Visible = true
                else
                    text.Visible = false
                end

            else
                text.Visible = false
            end

        else
            text.Visible = false
        end
    end
end)

-- Standardmäßig Combat öffnen
tabs["Combat"].Page.Visible = true
tabs["Combat"].Button.BackgroundColor3 = Color3.fromRGB(15,15,15)
tabs["Combat"].Button.BackgroundTransparency = 0

--------------------------------------------------
-- ACCOUNT FRAME (unterhalb der Tabs)
--------------------------------------------------
local accountFrame = Instance.new("Frame")
accountFrame.Size = UDim2.new(0, 250, 0, 35)
accountFrame.Position = UDim2.new(0, 10, 0, 170) -- Position angepasst für 4 Tabs
accountFrame.BackgroundTransparency = 1
accountFrame.Parent = contentFrame

-- Weißer Rahmen um Avatar
local avatarBorder = Instance.new("Frame")
avatarBorder.Size = UDim2.new(0, 32, 0, 32)
avatarBorder.BackgroundTransparency = 1
avatarBorder.BorderSizePixel = 0
avatarBorder.Parent = accountFrame

local uiStroke2 = Instance.new("UIStroke") -- Anderer Name um Konflikt zu vermeiden
uiStroke2.Color = Color3.fromRGB(255, 255, 255)
uiStroke2.Thickness = 2
uiStroke2.Parent = avatarBorder

Instance.new("UICorner", avatarBorder).CornerRadius = UDim.new(1,0)

-- Avatarbild
local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 30, 0, 30)
avatar.Position = UDim2.new(0, 1, 0, 1)
avatar.BackgroundTransparency = 1
avatar.Parent = avatarBorder
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0)

-- Thumbnail vom LocalPlayer (asynchron laden)
task.spawn(function()
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size48x48
    local content, isReady = game.Players:GetUserThumbnailAsync(LocalPlayer.UserId, thumbType, thumbSize)
    if content then
        avatar.Image = content
    end
end)

-- Grüner Online-Punkt
local onlineDot = Instance.new("Frame")
onlineDot.Size = UDim2.new(0, 8, 0, 8)
onlineDot.Position = UDim2.new(1, -10, 1, -10)
onlineDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
onlineDot.BorderSizePixel = 0
onlineDot.Parent = avatarBorder
Instance.new("UICorner", onlineDot).CornerRadius = UDim.new(1,0)

-- Pulsierender Effekt für grünen Punkt
local pulseTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local pulseTween = TweenService:Create(onlineDot, pulseTweenInfo, {BackgroundTransparency = 0.3})
pulseTween:Play()

-- Anzeige-Name neben Avatar
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 150, 1, 0)
nameLabel.Position = UDim2.new(0, 38, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = LocalPlayer.DisplayName or LocalPlayer.Name -- Fallback auf Name wenn DisplayName nicht existiert
nameLabel.TextColor3 = Color3.fromRGB(220,220,220)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 14
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
nameLabel.Parent = accountFrame

--------------------------------------------------
-- ZENTRIERTES DURCHSICHTIGES WASSERZEICHEN (SICHTBAR)
--------------------------------------------------

local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0, 300, 0, 30)
watermark.AnchorPoint = Vector2.new(0.5, 0.5)
watermark.Position = UDim2.new(0.5, 0, 0.5, 0)
watermark.BackgroundTransparency = 1
watermark.Text = "Scripted by Leon"
watermark.Font = Enum.Font.GothamBold
watermark.TextScaled = true
watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
watermark.TextTransparency = 0.75
watermark.TextStrokeTransparency = 1
watermark.ZIndex = 10
watermark.Parent = mainFrame

--------------------------------------------------
-- SOUND BEIM ÖFFNEN (OPTIONAL - kann Performance beeinflussen)
--------------------------------------------------

-- Optionaler Sound - kommentiere aus wenn nicht gewünscht
--[[
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://137559443496067"
sound.Volume = 10
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
]]

--------------------------------------------------
-- LOGO IN DER MITTE DES BILDSCHIRMS (DURCHSICHTIG)
--------------------------------------------------


-- Neues ScreenGui für das Logo
local logoGui = Instance.new("ScreenGui")
logoGui.Name = "MWLogoOverlay"
logoGui.ResetOnSpawn = false
logoGui.DisplayOrder = 1000 -- über allem anderen
logoGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ImageLabel für das Logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 300, 0, 150) -- Größe anpassen nach Bedarf
logo.Position = UDim2.new(0.5, 0, 0.5, 0) -- immer zentriert
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://130567061539775"
logo.ImageTransparency = 0.90
logo.ImageColor3 = Color3.fromRGB(255,255,255)
logo.Parent = logoGui

-- Optional: Logo ein-/ausblenden mit Rechts-Shift
local visible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        visible = not visible
        logoGui.Enabled = visible
    end
end)

--------------------------------------------------
-- VISUALS TOGGLES
--------------------------------------------------

local function createToggle(text, positionY)

    local enabled = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(1,-20,0,40)
button.LayoutOrder = positionY
button.BackgroundColor3 = Color3.fromRGB(30,30,30)
    button.TextColor3 = Color3.fromRGB(220,220,220)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.Text = text.." [ OFF ]"
    button.Parent = visualsScroll

    Instance.new("UICorner", button).CornerRadius = UDim.new(0,12)

    button.MouseButton1Click:Connect(function()

        enabled = not enabled

        if enabled then
            button.Text = text.." [ ON ]"
            button.BackgroundColor3 = Color3.fromRGB(20,60,20)
        else
            button.Text = text.." [ OFF ]"
            button.BackgroundColor3 = Color3.fromRGB(30,30,30)
        end

    end)

    return function()
        return enabled
    end
end

local nameEspToggle = createToggle("Name ESP",1)
local distanceEspToggle = createToggle("Distance ESP",2)
local boxEspToggle = createToggle("Box ESP",3)
local healthbarToggle = createToggle("Healthbar ESP",4)
local skeletonEspToggle = createToggle("Skeleton ESP",5)
local tracerToggle = createToggle("Tracer ESP",7)
local spinToggle = createToggle("Spin",9)
--------------------------------------------------
-- SKELETON COLOR PICKER
--------------------------------------------------

local colorPicker = Instance.new("Frame")
colorPicker.Size = UDim2.new(1,-20,0,45)
colorPicker.BackgroundColor3 = Color3.fromRGB(25,25,25)
colorPicker.Visible = false
colorPicker.LayoutOrder = 6
colorPicker.Parent = visualsScroll

Instance.new("UICorner", colorPicker).CornerRadius = UDim.new(0,10)

local pickerLayout = Instance.new("UIListLayout")
pickerLayout.FillDirection = Enum.FillDirection.Horizontal
pickerLayout.Padding = UDim.new(0,6)
pickerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pickerLayout.Parent = colorPicker

local colors = {
    Color3.fromRGB(255,0,0),
    Color3.fromRGB(0,255,0),
    Color3.fromRGB(0,120,255),
    Color3.fromRGB(255,255,0),
    Color3.fromRGB(170,0,255),
    Color3.fromRGB(255,255,255)
}

for _,color in pairs(colors) do

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,35,0,35)
    btn.BackgroundColor3 = color
    btn.Text = ""
    btn.Parent = colorPicker
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(function()
        skeletonColor = color
    end)

end

RunService.RenderStepped:Connect(function()
    nameEspEnabled = nameEspToggle()
end)

--------------------------------------------------
-- TRACER COLOR PICKER
--------------------------------------------------

local tracerColorPicker = Instance.new("Frame")
tracerColorPicker.Size = UDim2.new(1,-20,0,45)
tracerColorPicker.BackgroundColor3 = Color3.fromRGB(25,25,25)
tracerColorPicker.Visible = false
tracerColorPicker.LayoutOrder = 8
tracerColorPicker.Parent = visualsScroll

Instance.new("UICorner", tracerColorPicker).CornerRadius = UDim.new(0,10)

local tracerLayout = Instance.new("UIListLayout")
tracerLayout.FillDirection = Enum.FillDirection.Horizontal
tracerLayout.Padding = UDim.new(0,6)
tracerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tracerLayout.Parent = tracerColorPicker

local tracerColors = {
    Color3.fromRGB(255,0,0),
    Color3.fromRGB(0,255,0),
    Color3.fromRGB(0,120,255),
    Color3.fromRGB(255,255,0),
    Color3.fromRGB(255,0,255),
    Color3.fromRGB(255,255,255)
}

for _,color in pairs(tracerColors) do

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,35,0,35)
    btn.BackgroundColor3 = color
    btn.Text = ""
    btn.Parent = tracerColorPicker

    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(function()
        tracerColor = color
    end)

end

--------------------------------------------------
-- SKELETON ESP SYSTEM
--------------------------------------------------

local Camera = workspace.CurrentCamera
local skeletons = {}
local skeletonEspEnabled = false
skeletonColor = Color3.fromRGB(0,255,0)

local bones = {
    {"Head","UpperTorso"},
    {"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},
    {"LeftUpperArm","LeftLowerArm"},
    {"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},
    {"RightUpperArm","RightLowerArm"},
    {"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},
    {"LeftUpperLeg","LeftLowerLeg"},
    {"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},
    {"RightUpperLeg","RightLowerLeg"},
    {"RightLowerLeg","RightFoot"}
}

local function createLine()
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Visible = false
    return line
end

local function createSkeleton(player)

    if scriptClosed then return end
    if player == LocalPlayer then return end

    local lines = {}

    for i = 1,#bones do
        lines[i] = createLine()
    end

    skeletons[player] = lines

end

local function removeSkeleton(player)

    if skeletons[player] then
        for _,line in pairs(skeletons[player]) do
            line:Remove()
        end
        skeletons[player] = nil
    end

end

for _,player in pairs(Players:GetPlayers()) do
    createSkeleton(player)
end

Players.PlayerAdded:Connect(createSkeleton)
Players.PlayerRemoving:Connect(removeSkeleton)

RunService.RenderStepped:Connect(function()

 skeletonEspEnabled = skeletonEspToggle()
 colorPicker.Visible = skeletonEspEnabled

    for player,lines in pairs(skeletons) do

        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")

        if skeletonEspEnabled and char and humanoid and humanoid.Health > 0 then

            for i,bone in pairs(bones) do

                local p1 = char:FindFirstChild(bone[1])
                local p2 = char:FindFirstChild(bone[2])

                if p1 and p2 then

                    local pos1,vis1 = Camera:WorldToViewportPoint(p1.Position)
                    local pos2,vis2 = Camera:WorldToViewportPoint(p2.Position)

                    if vis1 and vis2 then
                        lines[i].From = Vector2.new(pos1.X,pos1.Y)
                        lines[i].To = Vector2.new(pos2.X,pos2.Y)
                        lines[i].Color = skeletonColor
                        lines[i].Visible = true
                    else
                        lines[i].Visible = false
                    end

                else
                    lines[i].Visible = false
                end
            end

        else

            for _,line in pairs(lines) do
                line.Visible = false
            end

        end
    end
end)


--------------------------------------------------
-- SPIN SCRIPT
--------------------------------------------------

local spinSpeed = 25

RunService.RenderStepped:Connect(function()

    if scriptClosed then return end

    if spinToggle() then

        local char = LocalPlayer.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)

    end

end)

--------------------------------------------------
-- DISTANCE ESP SYSTEM
--------------------------------------------------

local distanceTags = {}
local distanceEspEnabled = false

local function createDistance(player)

    if scriptClosed then return end
    if player == LocalPlayer then return end

    local text = Drawing.new("Text")
    text.Size = 12
    text.Center = true
    text.Outline = true
    text.Color = Color3.fromRGB(255,255,255)
    text.Visible = false

   distanceTags[player] = text

end

local function removeDistance(player)

    if distanceTags[player] then
        distanceTags[player]:Remove()
        distanceTags[player] = nil
    end

end

for _,p in pairs(Players:GetPlayers()) do
    createDistance(p)
end

Players.PlayerAdded:Connect(createDistance)
Players.PlayerRemoving:Connect(removeDistance)

RunService.RenderStepped:Connect(function()

    if scriptClosed then return end

    distanceEspEnabled = distanceEspToggle()

    local char = LocalPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for player,text in pairs(distanceTags) do

        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and char:FindFirstChild("Head")

        if distanceEspEnabled and humanoid and humanoid.Health > 0 and head then

            local distance = (head.Position - root.Position).Magnitude

            if distance <= MAX_DISTANCE then

                local pos,visible = Camera:WorldToViewportPoint(head.Position - Vector3.new(0,4.5,0))

                if visible then
                    text.Position = Vector2.new(pos.X,pos.Y)
                    text.Text = math.floor(distance).."m"
                    text.Visible = true
                else
                    text.Visible = false
                end

            else
                text.Visible = false
            end

        else
            text.Visible = false
        end
    end
end)

--------------------------------------------------
-- ADVANCED HEALTHBAR ESP
--------------------------------------------------

local healthbars = {}

local function createHealthbar(player)

    if player == LocalPlayer then return end

    local outline = Drawing.new("Square")
    outline.Filled = false
    outline.Thickness = 1
    outline.Color = Color3.fromRGB(0,0,0)
    outline.Visible = false

    local bar = Drawing.new("Square")
    bar.Filled = true
    bar.Thickness = 1
    bar.Visible = false

    healthbars[player] = {
        outline = outline,
        bar = bar
    }

end

local function removeHealthbar(player)

    if healthbars[player] then
        healthbars[player].outline:Remove()
        healthbars[player].bar:Remove()
        healthbars[player] = nil
    end

end

for _,p in pairs(Players:GetPlayers()) do
    createHealthbar(p)
end

Players.PlayerAdded:Connect(createHealthbar)
Players.PlayerRemoving:Connect(removeHealthbar)

RunService.RenderStepped:Connect(function()

    if scriptClosed then return end

    local enabled = healthbarToggle()

    for player,data in pairs(healthbars) do

        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if enabled and humanoid and humanoid.Health > 0 and root then

            local pos,visible = Camera:WorldToViewportPoint(root.Position)

            if visible then

                local distance = (Camera.CFrame.Position - root.Position).Magnitude

                if distance <= MAX_DISTANCE then

                    local scale = 1 / distance * 100
                    local height = 42 * scale

                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local healthHeight = height * healthPercent

                    local x = pos.X - 17 * scale
                    local y = pos.Y - height/2

                    data.outline.Size = Vector2.new(4,height)
                    data.outline.Position = Vector2.new(x,y)
                    data.outline.Visible = true

                    data.bar.Size = Vector2.new(2,healthHeight)
                    data.bar.Position = Vector2.new(x+1,y + (height-healthHeight))

                    local r = 255 - (255 * healthPercent)
                    local g = 255 * healthPercent

                    data.bar.Color = Color3.fromRGB(r,g,0)
                    data.bar.Visible = true

                else
                    data.outline.Visible = false
                    data.bar.Visible = false
                end

            else
                data.outline.Visible = false
                data.bar.Visible = false
            end

        else
            data.outline.Visible = false
            data.bar.Visible = false
        end
    end
end)

--------------------------------------------------
-- BOX ESP SYSTEM
--------------------------------------------------

local boxes = {}

local function createBox(player)

    if player == LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Color = Color3.fromRGB(255,255,255)
    box.Visible = false

    boxes[player] = box

end

local function removeBox(player)

    if boxes[player] then
        boxes[player]:Remove()
        boxes[player] = nil
    end

end

for _,p in pairs(Players:GetPlayers()) do
    createBox(p)
end

Players.PlayerAdded:Connect(createBox)
Players.PlayerRemoving:Connect(removeBox)

RunService.RenderStepped:Connect(function()

    if scriptClosed then return end

    local enabled = boxEspToggle()
    for player,box in pairs(boxes) do

        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if enabled and humanoid and humanoid.Health > 0 and root then

            local pos,visible = Camera:WorldToViewportPoint(root.Position)

            if visible then

                local distance = (Camera.CFrame.Position - root.Position).Magnitude

                if distance <= MAX_DISTANCE then

                    local scale = 1 / distance * 100

                    local width = 28 * scale
                    local height = 44 * scale

                    box.Size = Vector2.new(width,height)
                    box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                    box.Visible = true

                else
                    box.Visible = false
                end

            else
                box.Visible = false
            end

        else
            box.Visible = false
        end
    end
end)

--------------------------------------------------
-- REMOVE PLAYER NAME TAGS
--------------------------------------------------


local function removeName(player)

    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
    end

    player.CharacterAdded:Connect(function(char)
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end)

end

-- für alle aktuellen Spieler
for _,player in pairs(Players:GetPlayers()) do
    removeName(player)
end

-- für neue Spieler
Players.PlayerAdded:Connect(removeName)

--------------------------------------------------
-- TRACER ESP
--------------------------------------------------

local tracers = {}
local tracerEspEnabled = false
tracerColor = Color3.fromRGB(255,0,0)
Players.PlayerRemoving:Connect(function(player)
    if tracers[player] then
        tracers[player]:Remove()
        tracers[player] = nil
    end
end)

--------------------------------------------------
-- TRACER SYSTEM
--------------------------------------------------

RunService.RenderStepped:Connect(function()

    if scriptClosed then return end

    tracerEspEnabled = tracerToggle()
    tracerColorPicker.Visible = tracerEspEnabled

    if not tracerEspEnabled then
        for _,line in pairs(tracers) do
            line.Visible = false
        end
        return
    end

    local camera = Camera

    for _,player in pairs(Players:GetPlayers()) do

        if player ~= LocalPlayer then

            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")

            if root and humanoid and humanoid.Health > 0 then

                local pos,visible = camera:WorldToViewportPoint(root.Position)

                if visible then

                    if not tracers[player] then
                        local line = Drawing.new("Line")
                        line.Thickness = 2
                        line.Transparency = 1
                        tracers[player] = line
                    end

                    local line = tracers[player]

                    line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y - 10)
                    line.To = Vector2.new(pos.X,pos.Y)
                    line.Color = tracerColor
                    line.Visible = true

                elseif tracers[player] then
                    tracers[player].Visible = false
                end

            elseif tracers[player] then
                tracers[player].Visible = false
            end

        end
    end

end)
--------------------------------------------------
-- INFINITY JUMP SYSTEM (NO HOLD)
--------------------------------------------------

local jumpCooldown = false

UserInputService.JumpRequest:Connect(function()

    if scriptClosed then return end
    if not infinityJumpEnabled then return end
    if jumpCooldown then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    jumpCooldown = true

    hum:ChangeState(Enum.HumanoidStateType.Jumping)

    -- verhindert halten der Taste
    task.wait(0.15)
    jumpCooldown = false

end)

--------------------------------------------------
-- SLIDE BOOST SYSTEM
--------------------------------------------------

UserInputService.InputBegan:Connect(function(input,gameProcessed)

	if gameProcessed then return end
	if scriptClosed then return end
	if not slideBoostEnabled then return end

	if input.KeyCode == Enum.KeyCode.LeftControl then

		local char = LocalPlayer.Character
		if not char then return end

		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")

		if not root or not hum then return end

		-- nur wenn Spieler am Boden ist
		if hum.FloorMaterial ~= Enum.Material.Air then

			local cam = workspace.CurrentCamera
			local direction = cam.CFrame.LookVector

			root.Velocity += direction * slideBoostPower

		end

	end

end)
