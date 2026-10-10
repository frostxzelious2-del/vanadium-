-- VanadiumGUI v2.0 (LocalScript)
-- Put in StarterPlayerScripts or StarterGui of YOUR private game.
-- Tabs: Home, Player, Aiming, Visuals, List, Misc, Settings

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Clean up a previous copy if the script is run twice
do
	local old = playerGui:FindFirstChild("VanadiumGUI")
	if old then old:Destroy() end
	for _, name in ipairs({"VanadiumSpin", "VanadiumAim"}) do
		pcall(function() RunService:UnbindFromRenderStep(name) end)
	end
end

local unloaded = false
local connections = {}
local function connect(signal, fn)
	local c = signal:Connect(fn)
	table.insert(connections, c)
	return c
end

local Colors = {
	Background = Color3.fromRGB(13, 13, 16),
	Secondary = Color3.fromRGB(21, 21, 25),
	Tertiary = Color3.fromRGB(32, 32, 38),
	Accent = Color3.fromRGB(245, 150, 205),
	AccentDark = Color3.fromRGB(170, 95, 140),
	Text = Color3.fromRGB(232, 232, 238),
	TextDark = Color3.fromRGB(135, 135, 148),
	Stroke = Color3.fromRGB(42, 42, 50),
}

local WINDOW_W, WINDOW_H = 640, 460
local TAB_NAMES = {"Home", "Player", "Aiming", "Visuals", "List", "Misc", "Settings"}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VanadiumGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ==================== LOADING SCREEN ====================
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
loadingFrame.BorderSizePixel = 0
loadingFrame.ZIndex = 10
loadingFrame.Parent = screenGui

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0, 50)
loadingText.Position = UDim2.new(0, 0, 0.5, -44)
loadingText.BackgroundTransparency = 1
loadingText.Text = "VANADIUM"
loadingText.TextColor3 = Colors.Accent
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 30
loadingText.ZIndex = 11
loadingText.Parent = loadingFrame

local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(0, 240, 0, 3)
loadingBarBg.Position = UDim2.new(0.5, -120, 0.5, 14)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.ZIndex = 11
loadingBarBg.Parent = loadingFrame
Instance.new("UICorner", loadingBarBg).CornerRadius = UDim.new(1, 0)

local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.BackgroundColor3 = Colors.Accent
loadingBar.BorderSizePixel = 0
loadingBar.ZIndex = 12
loadingBar.Parent = loadingBarBg
Instance.new("UICorner", loadingBar).CornerRadius = UDim.new(1, 0)

-- ==================== MAIN WINDOW (CanvasGroup = whole window can fade) ====================
local main = Instance.new("CanvasGroup")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Size = UDim2.new(0, WINDOW_W, 0, WINDOW_H)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = Colors.Background
main.BorderSizePixel = 0
main.GroupTransparency = 1
main.Visible = false
main.Parent = screenGui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Colors.Stroke
mainStroke.Thickness = 1
mainStroke.Parent = main

local uiScale = Instance.new("UIScale")
uiScale.Scale = 0.92
uiScale.Parent = main

local accentLine = Instance.new("Frame")
accentLine.Name = "AccentLine"
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.BackgroundColor3 = Colors.Accent
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 3
accentLine.Parent = main

local accentGrad = Instance.new("UIGradient")
accentGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 80, 255)),
	ColorSequenceKeypoint.new(0.5, Colors.Accent),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 80, 255)),
})
accentGrad.Parent = accentLine

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundColor3 = Colors.Secondary
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Vanadium"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = titleBar

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Colors.Accent),
})
titleGrad.Rotation = 0
titleGrad.Parent = title

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
closeBtn.BackgroundColor3 = Colors.Tertiary
closeBtn.AutoButtonColor = false
closeBtn.Text = "×"
closeBtn.TextColor3 = Colors.Text
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(200, 70, 90)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Colors.Tertiary}):Play()
end)

-- ==================== OPEN / CLOSE WITH SMOOTH FADE ====================
local menuOpen = false
local menuToken = 0

local function setMenu(open)
	menuOpen = open
	menuToken += 1
	local token = menuToken

	if open then
		main.Visible = true
		TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
		TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
	else
		local t = TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 1})
		TweenService:Create(uiScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.93}):Play()
		t.Completed:Connect(function()
			if token == menuToken then
				main.Visible = false
			end
		end)
		t:Play()
	end
end

-- ==================== TABS ====================
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 34)
tabBar.Position = UDim2.new(0, 0, 0, 44)
tabBar.BackgroundColor3 = Colors.Secondary
tabBar.BorderSizePixel = 0
tabBar.Parent = main

local tabDivider = Instance.new("Frame")
tabDivider.Size = UDim2.new(1, 0, 0, 1)
tabDivider.Position = UDim2.new(0, 0, 1, -1)
tabDivider.BackgroundColor3 = Colors.Stroke
tabDivider.BorderSizePixel = 0
tabDivider.Parent = tabBar

local TAB_SCALE = 1 / #TAB_NAMES

local tabIndicator = Instance.new("Frame")
tabIndicator.Size = UDim2.new(TAB_SCALE, -24, 0, 2)
tabIndicator.Position = UDim2.new(0, 12, 1, -2)
tabIndicator.BackgroundColor3 = Colors.Accent
tabIndicator.BorderSizePixel = 0
tabIndicator.ZIndex = 2
tabIndicator.Parent = tabBar
Instance.new("UICorner", tabIndicator).CornerRadius = UDim.new(1, 0)

local tabs = {}
local tabCount = 0

local function makeColumn(parent, position, size)
	local col = Instance.new("ScrollingFrame")
	col.Size = size
	col.Position = position
	col.BackgroundTransparency = 1
	col.BorderSizePixel = 0
	col.ScrollBarThickness = 3
	col.ScrollBarImageColor3 = Colors.Accent
	col.CanvasSize = UDim2.new(0, 0, 0, 0)
	col.AutomaticCanvasSize = Enum.AutomaticSize.Y
	col.ScrollingDirection = Enum.ScrollingDirection.Y
	col.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 10)
	layout.Parent = col

	local pad = Instance.new("UIPadding")
	pad.PaddingRight = UDim.new(0, 6)
	pad.PaddingBottom = UDim.new(0, 4)
	pad.Parent = col

	return col
end

-- Each page = a container with a Left and a Right scrolling column
local function makePage(twoColumns)
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1, -24, 1, -92)
	page.Position = UDim2.new(0, 12, 0, 86)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = main

	local left, right
	if twoColumns then
		left = makeColumn(page, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, -5, 1, 0))
		right = makeColumn(page, UDim2.new(0.5, 5, 0, 0), UDim2.new(0.5, -5, 1, 0))
	else
		left = makeColumn(page, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0))
	end
	return page, left, right
end

local function switchTab(name)
	for tabName, t in pairs(tabs) do
		local active = (tabName == name)
		t.page.Visible = active
		TweenService:Create(t.button, TweenInfo.new(0.15), {
			TextColor3 = active and Colors.Accent or Colors.TextDark
		}):Play()
		if active then
			TweenService:Create(tabIndicator, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(TAB_SCALE * (t.index - 1), 12, 1, -2)
			}):Play()
		end
	end
end

local function addTab(name, twoColumns)
	tabCount += 1
	local index = tabCount

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(TAB_SCALE, 0, 1, 0)
	btn.Position = UDim2.new(TAB_SCALE * (index - 1), 0, 0, 0)
	btn.BackgroundTransparency = 1
	btn.Text = name
	btn.TextColor3 = Colors.TextDark
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.Parent = tabBar

	local page, left, right = makePage(twoColumns)
	tabs[name] = {button = btn, page = page, index = index}

	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)

	return left, right
end

local homeL, homeR = addTab("Home", true)
local playerL, playerR = addTab("Player", true)
local aimL, aimR = addTab("Aiming", true)
local visL, visR = addTab("Visuals", true)
local listL = addTab("List", false)
local miscL, miscR = addTab("Misc", true)
local setL, setR = addTab("Settings", true)

-- ==================== NOTIFICATIONS ====================
local notifyEnabled = true
local suppressNotify = false

local toastHolder = Instance.new("Frame")
toastHolder.Size = UDim2.new(0, 220, 1, -20)
toastHolder.Position = UDim2.new(1, -230, 0, 0)
toastHolder.BackgroundTransparency = 1
toastHolder.ZIndex = 20
toastHolder.Parent = screenGui

local toastLayout = Instance.new("UIListLayout")
toastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
toastLayout.Padding = UDim.new(0, 6)
toastLayout.SortOrder = Enum.SortOrder.LayoutOrder
toastLayout.Parent = toastHolder

local function notify(text)
	if not notifyEnabled or suppressNotify or unloaded then return end

	local toast = Instance.new("CanvasGroup")
	toast.Size = UDim2.new(1, 0, 0, 32)
	toast.BackgroundColor3 = Colors.Secondary
	toast.BorderSizePixel = 0
	toast.GroupTransparency = 1
	toast.ZIndex = 21
	toast.Parent = toastHolder
	Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)

	local ts = Instance.new("UIStroke")
	ts.Color = Colors.Stroke
	ts.Parent = toast

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 3, 1, 0)
	bar.BackgroundColor3 = Colors.Accent
	bar.BorderSizePixel = 0
	bar.Parent = toast

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -16, 1, 0)
	lbl.Position = UDim2.new(0, 14, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Colors.Text
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = toast

	TweenService:Create(toast, TweenInfo.new(0.2), {GroupTransparency = 0}):Play()
	task.delay(2, function()
		if not toast.Parent then return end
		local t = TweenService:Create(toast, TweenInfo.new(0.25), {GroupTransparency = 1})
		t.Completed:Connect(function() toast:Destroy() end)
		t:Play()
	end)
end

-- ==================== UI HELPERS ====================
local orderCount = {}
local function nextOrder(parent)
	orderCount[parent] = (orderCount[parent] or 0) + 1
	return orderCount[parent]
end

local cardScroller = {}

-- A card = a rounded section box with a title, like the reference layout
local function createCard(column, text)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 0)
	card.AutomaticSize = Enum.AutomaticSize.Y
	card.BackgroundColor3 = Colors.Secondary
	card.BorderSizePixel = 0
	card.LayoutOrder = nextOrder(column)
	card.Parent = column
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

	local cs = Instance.new("UIStroke")
	cs.Color = Colors.Stroke
	cs.Thickness = 1
	cs.Parent = card

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
	layout.Parent = card

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 10)
	pad.PaddingBottom = UDim.new(0, 12)
	pad.PaddingLeft = UDim.new(0, 12)
	pad.PaddingRight = UDim.new(0, 12)
	pad.Parent = card

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 16)
	label.BackgroundTransparency = 1
	label.Text = string.upper(text)
	label.TextColor3 = Colors.Accent
	label.Font = Enum.Font.GothamBold
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.LayoutOrder = nextOrder(card)
	label.Parent = card

	cardScroller[card] = column
	return card
end

local function createLabel(parent, text, color, size)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or Colors.TextDark
	label.Font = Enum.Font.Gotham
	label.TextSize = size or 13
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.LayoutOrder = nextOrder(parent)
	label.Parent = parent
	return label
end

local function createButton(parent, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.BackgroundColor3 = Colors.Tertiary
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Colors.Text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.LayoutOrder = nextOrder(parent)
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Colors.AccentDark}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Colors.Tertiary}):Play()
	end)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function createToggle(parent, text, callback, defaultState)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 24)
	row.BackgroundTransparency = 1
	row.LayoutOrder = nextOrder(parent)
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -50, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Colors.Text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = row

	local switch = Instance.new("TextButton")
	switch.Size = UDim2.new(0, 38, 0, 20)
	switch.Position = UDim2.new(1, -38, 0.5, -10)
	switch.BackgroundColor3 = Colors.Tertiary
	switch.Text = ""
	switch.AutoButtonColor = false
	switch.Parent = row
	Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(0, 3, 0.5, -7)
	knob.BackgroundColor3 = Colors.Text
	knob.BorderSizePixel = 0
	knob.Parent = switch
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local state = false

	local function set(newState, silent)
		state = newState
		TweenService:Create(switch, TweenInfo.new(0.18), {
			BackgroundColor3 = state and Colors.Accent or Colors.Tertiary
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
			Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
			BackgroundColor3 = state and Color3.new(1, 1, 1) or Colors.Text
		}):Play()
		if not silent then
			callback(state)
			notify(text .. (state and "  ON" or "  OFF"))
		end
	end

	switch.MouseButton1Click:Connect(function()
		set(not state)
	end)

	if defaultState then
		set(true, true) -- visual only, the caller's variable already holds the default
	end

	return {
		Set = set,
		Get = function() return state end,
	}
end

local function createSlider(parent, text, minVal, maxVal, defaultVal, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 40)
	row.BackgroundTransparency = 1
	row.LayoutOrder = nextOrder(parent)
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.55, 0, 0, 16)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Colors.Text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Parent = row

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0.45, 0, 0, 16)
	valueLabel.Position = UDim2.new(0.55, 0, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = defaultVal .. " / " .. maxVal
	valueLabel.TextColor3 = Colors.Accent
	valueLabel.Font = Enum.Font.GothamMedium
	valueLabel.TextSize = 12
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = row

	-- Larger invisible hit area so the slider is easy to grab
	local hit = Instance.new("TextButton")
	hit.Size = UDim2.new(1, 0, 0, 20)
	hit.Position = UDim2.new(0, 0, 0, 20)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.AutoButtonColor = false
	hit.Parent = row

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, 0, 0, 8)
	track.Position = UDim2.new(0, 0, 0.5, -4)
	track.BackgroundColor3 = Colors.Tertiary
	track.BorderSizePixel = 0
	track.Parent = hit
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
	fill.BackgroundColor3 = Colors.Accent
	fill.BorderSizePixel = 0
	fill.Parent = track
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 12, 0, 12)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(1, 0, 0.5, 0)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.BorderSizePixel = 0
	knob.Parent = fill
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local sliding = false
	local scroller = cardScroller[parent]

	local function updateFromInput(input)
		local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local value = math.floor(minVal + rel * (maxVal - minVal) + 0.5)
		fill.Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
		valueLabel.Text = value .. " / " .. maxVal
		callback(value)
	end

	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			sliding = true
			if scroller then scroller.ScrollingEnabled = false end
			updateFromInput(input)
		end
	end)

	connect(UserInputService.InputChanged, function(input)
		if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromInput(input)
		end
	end)

	connect(UserInputService.InputEnded, function(input)
		if sliding and (input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch) then
			sliding = false
			if scroller then scroller.ScrollingEnabled = true end
		end
	end)
end

local function createDropdown(parent, text, options, default, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 0)
	holder.AutomaticSize = Enum.AutomaticSize.Y
	holder.BackgroundTransparency = 1
	holder.LayoutOrder = nextOrder(parent)
	holder.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)
	layout.Parent = holder

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 16)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Colors.Text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.LayoutOrder = 1
	label.Parent = holder

	local header = Instance.new("TextButton")
	header.Size = UDim2.new(1, 0, 0, 30)
	header.BackgroundColor3 = Colors.Tertiary
	header.BorderSizePixel = 0
	header.AutoButtonColor = false
	header.Text = ""
	header.LayoutOrder = 2
	header.Parent = holder
	Instance.new("UICorner", header).CornerRadius = UDim.new(0, 7)

	local current = Instance.new("TextLabel")
	current.Size = UDim2.new(1, -36, 1, 0)
	current.Position = UDim2.new(0, 10, 0, 0)
	current.BackgroundTransparency = 1
	current.Text = default
	current.TextColor3 = Colors.Text
	current.Font = Enum.Font.GothamMedium
	current.TextSize = 13
	current.TextXAlignment = Enum.TextXAlignment.Left
	current.Parent = header

	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 24, 1, 0)
	arrow.Position = UDim2.new(1, -28, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▾"
	arrow.TextColor3 = Colors.Accent
	arrow.Font = Enum.Font.GothamBold
	arrow.TextSize = 14
	arrow.Parent = header

	local list = Instance.new("Frame")
	list.Size = UDim2.new(1, 0, 0, 0)
	list.AutomaticSize = Enum.AutomaticSize.Y
	list.BackgroundColor3 = Colors.Tertiary
	list.BorderSizePixel = 0
	list.Visible = false
	list.LayoutOrder = 3
	list.Parent = holder
	Instance.new("UICorner", list).CornerRadius = UDim.new(0, 7)

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = list

	local open = false
	local function setOpen(v)
		open = v
		list.Visible = v
		arrow.Text = v and "▴" or "▾"
	end

	for i, option in ipairs(options) do
		local ob = Instance.new("TextButton")
		ob.Size = UDim2.new(1, 0, 0, 26)
		ob.BackgroundTransparency = 1
		ob.Text = option
		ob.TextColor3 = option == default and Colors.Accent or Colors.TextDark
		ob.Font = Enum.Font.Gotham
		ob.TextSize = 13
		ob.LayoutOrder = i
		ob.Parent = list

		ob.MouseButton1Click:Connect(function()
			current.Text = option
			for _, child in ipairs(list:GetChildren()) do
				if child:IsA("TextButton") then
					child.TextColor3 = child.Text == option and Colors.Accent or Colors.TextDark
				end
			end
			setOpen(false)
			callback(option)
		end)
	end

	header.MouseButton1Click:Connect(function()
		setOpen(not open)
	end)
end

-- ==================== SHARED HELPERS ====================
local function getCharacterParts()
	local char = player.Character
	if not char then return nil, nil end
	return char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
end

-- Used for flight movement (handles keyboard, gamepad and mobile thumbstick)
local controls
task.spawn(function()
	pcall(function()
		local module = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10)
		controls = require(module):GetControls()
	end)
end)

local featureToggles = {} -- everything "Turn Off All Features" should reset

-- ==================== FLY ====================
local flySpeed = 50
local flying = false
local spinning = false -- declared early so fly can see it
local flyConn, bodyVelocity, bodyGyro

local function stopFly()
	flying = false
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end

	local _, hum = getCharacterParts()
	if hum then hum.PlatformStand = false end
end

local function getFlyDirection()
	local cam = workspace.CurrentCamera
	local look, right = cam.CFrame.LookVector, cam.CFrame.RightVector
	local dir = Vector3.zero

	local gotMove = false
	if controls then
		local ok, mv = pcall(function() return controls:GetMoveVector() end)
		if ok and typeof(mv) == "Vector3" then
			dir += right * mv.X + look * -mv.Z
			gotMove = true
		end
	end
	if not gotMove then
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += look end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= look end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += right end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= right end
	end

	-- Up: Space / E    Down: Left Shift / Left Ctrl / Q
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then
		dir += Vector3.yAxis
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
		or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
		or UserInputService:IsKeyDown(Enum.KeyCode.Q) then
		dir -= Vector3.yAxis
	end

	return dir
end

local function startFly()
	local root, hum = getCharacterParts()
	if not root or not hum then return false end

	stopFly()
	flying = true
	hum.PlatformStand = true

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = root

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	bodyGyro.P = 9e4
	bodyGyro.CFrame = root.CFrame
	bodyGyro.Parent = root

	flyConn = RunService.RenderStepped:Connect(function()
		local r = getCharacterParts()
		if not r or not bodyVelocity or not bodyGyro then return end

		local dir = getFlyDirection()
		bodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero

		-- Let the spinbot control rotation if it's on
		if spinning then
			bodyGyro.MaxTorque = Vector3.zero
		else
			bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
			local cam = workspace.CurrentCamera
			bodyGyro.CFrame = CFrame.lookAt(r.Position, r.Position + cam.CFrame.LookVector)
		end
	end)

	return true
end

-- ==================== SPINBOT ====================
-- We keep our own angle and force the character's rotation to it after everything
-- else (camera, shift lock, humanoid) has run, so it works while moving too.
local spinSpeed = 40 -- slider 1-200, degrees per second = value * 10
local spinAngle = 0
local spinBound = false
local spinHeartbeat

local function applySpin()
	local root, hum = getCharacterParts()
	if not root or not hum or hum.Health <= 0 or hum.Sit then return end
	hum.AutoRotate = false
	root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, spinAngle, 0)
	root.AssemblyAngularVelocity = Vector3.zero
end

local function stopSpin()
	spinning = false
	if spinBound then
		pcall(function() RunService:UnbindFromRenderStep("VanadiumSpin") end)
		spinBound = false
	end
	if spinHeartbeat then spinHeartbeat:Disconnect() spinHeartbeat = nil end

	local _, hum = getCharacterParts()
	if hum then
		hum.AutoRotate = UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter
	end
end

local function startSpin()
	stopSpin()
	spinning = true

	RunService:BindToRenderStep("VanadiumSpin", Enum.RenderPriority.Last.Value, function(dt)
		spinAngle = (spinAngle + math.rad(spinSpeed * 10) * dt) % (math.pi * 2)
		applySpin()
	end)
	spinBound = true

	spinHeartbeat = RunService.Heartbeat:Connect(applySpin)
end

-- ==================== WALK SPEED ====================
local speedValue = 50
local speedOn = false
local speedConn
local origWalkSpeed = 16

local function setSpeedEnabled(on)
	if on == speedOn then return end
	speedOn = on
	local _, hum = getCharacterParts()

	if on then
		if hum then origWalkSpeed = hum.WalkSpeed end
		speedConn = RunService.Heartbeat:Connect(function()
			local _, h = getCharacterParts()
			if h and h.WalkSpeed ~= speedValue then
				h.WalkSpeed = speedValue
			end
		end)
	else
		if speedConn then speedConn:Disconnect() speedConn = nil end
		if hum then hum.WalkSpeed = origWalkSpeed end
	end
end

-- ==================== INFINITE JUMP ====================
local infJump = false
connect(UserInputService.JumpRequest, function()
	if infJump then
		local _, hum = getCharacterParts()
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- ==================== AIMING ====================
local aimEnabled = false
local aimHold = true
local aimHead = true
local aimTeamCheck = true
local aimWallCheck = false
local aimShowFOV = true
local aimFOV = 150
local aimSmooth = 5

local fovCircle = Instance.new("Frame")
fovCircle.Name = "AimFOV"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Size = UDim2.fromOffset(aimFOV * 2, aimFOV * 2)
fovCircle.Visible = false
fovCircle.ZIndex = 0
fovCircle.Parent = screenGui
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Colors.Accent
fovStroke.Thickness = 1.5
fovStroke.Parent = fovCircle

local function getAimTarget()
	local cam = workspace.CurrentCamera
	if not cam then return nil end

	local mousePos = UserInputService:GetMouseLocation()
	local best, bestDist = nil, aimFOV

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {player.Character}

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local char = p.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local part = char and (aimHead and char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
			local sameTeam = aimTeamCheck and p.Team ~= nil and p.Team == player.Team

			if part and hum and hum.Health > 0 and not sameTeam then
				local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
				if onScreen then
					local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
					if dist < bestDist then
						local visible = true
						if aimWallCheck then
							local origin = cam.CFrame.Position
							local result = workspace:Raycast(origin, part.Position - origin, params)
							visible = result == nil or result.Instance:IsDescendantOf(char)
						end
						if visible then
							best, bestDist = part, dist
						end
					end
				end
			end
		end
	end

	return best
end

RunService:BindToRenderStep("VanadiumAim", Enum.RenderPriority.Camera.Value + 1, function(dt)
	local mouse = UserInputService:GetMouseLocation()
	fovCircle.Visible = aimEnabled and aimShowFOV
	fovCircle.Position = UDim2.fromOffset(mouse.X, mouse.Y)
	fovCircle.Size = UDim2.fromOffset(aimFOV * 2, aimFOV * 2)

	if not aimEnabled then return end
	if aimHold and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

	local target = getAimTarget()
	if target then
		local cam = workspace.CurrentCamera
		local goal = CFrame.lookAt(cam.CFrame.Position, target.Position)
		local alpha = 1 - (1 - 1 / aimSmooth) ^ (dt * 60)
		cam.CFrame = cam.CFrame:Lerp(goal, alpha)
	end
end)

-- ==================== VISUALS ====================
local espChams, espNames, espHealth, espDistance = false, false, false, false
local fullbright = false
local origLighting
local customFov = false
local fovValue = 70
local origFov = 70

local function updateESP()
	local myRoot = getCharacterParts()

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local char = p.Character
			if char then
				local head = char:FindFirstChild("Head")
				local root = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")

				-- Chams
				local hl = char:FindFirstChild("VanadiumChams")
				if espChams then
					if not hl then
						hl = Instance.new("Highlight")
						hl.Name = "VanadiumChams"
						hl.FillColor = Colors.Accent
						hl.OutlineColor = Color3.new(1, 1, 1)
						hl.FillTransparency = 0.6
						hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						hl.Parent = char
					end
				elseif hl then
					hl:Destroy()
				end

				-- Name / health / distance tag
				local tag = char:FindFirstChild("VanadiumTag")
				if (espNames or espHealth or espDistance) and head then
					if not tag then
						tag = Instance.new("BillboardGui")
						tag.Name = "VanadiumTag"
						tag.Size = UDim2.fromOffset(220, 24)
						tag.StudsOffset = Vector3.new(0, 2.6, 0)
						tag.AlwaysOnTop = true
						tag.Adornee = head

						local label = Instance.new("TextLabel")
						label.Name = "Label"
						label.Size = UDim2.new(1, 0, 1, 0)
						label.BackgroundTransparency = 1
						label.TextColor3 = Color3.new(1, 1, 1)
						label.TextStrokeTransparency = 0.4
						label.Font = Enum.Font.GothamBold
						label.TextSize = 13
						label.Parent = tag

						tag.Parent = char
					end

					local parts = {}
					if espNames then table.insert(parts, p.DisplayName) end
					if espHealth and hum then table.insert(parts, "HP " .. math.floor(hum.Health)) end
					if espDistance and myRoot and root then
						table.insert(parts, math.floor((root.Position - myRoot.Position).Magnitude) .. "m")
					end

					local label = tag:FindFirstChild("Label")
					if label then label.Text = table.concat(parts, " | ") end
				elseif tag then
					tag:Destroy()
				end
			end
		end
	end

	if fullbright then
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 1e5
		Lighting.GlobalShadows = false
		Lighting.Ambient = Color3.fromRGB(178, 178, 178)
		Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
	end
end

local function setFullbright(on)
	if on == fullbright then return end
	fullbright = on
	if on then
		origLighting = {
			Brightness = Lighting.Brightness,
			ClockTime = Lighting.ClockTime,
			FogEnd = Lighting.FogEnd,
			GlobalShadows = Lighting.GlobalShadows,
			Ambient = Lighting.Ambient,
			OutdoorAmbient = Lighting.OutdoorAmbient,
		}
		updateESP()
	elseif origLighting then
		for prop, value in pairs(origLighting) do
			Lighting[prop] = value
		end
	end
end

task.spawn(function()
	while not unloaded do
		updateESP()
		task.wait(0.15)
	end
end)

connect(RunService.RenderStepped, function()
	if customFov and workspace.CurrentCamera then
		workspace.CurrentCamera.FieldOfView = fovValue
	end
end)

-- ==================== PLAYER LIST ====================
local listRows = {}
local leaving = {}

local listCard = createCard(listL, "Players")
local listHeader = createLabel(listCard, "Players in server: 0", Colors.Text, 14)

local function buildRow(p)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 32)
	frame.BackgroundColor3 = Colors.Tertiary
	frame.BorderSizePixel = 0
	frame.Parent = listCard
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.55, -12, 1, 0)
	nameLabel.Position = UDim2.new(0, 12, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = p.DisplayName .. (p == player and "  (You)" or "")
	nameLabel.TextColor3 = p == player and Colors.Accent or Colors.Text
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextSize = 13
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.Parent = frame

	local userLabel = Instance.new("TextLabel")
	userLabel.Size = UDim2.new(0.45, -12, 1, 0)
	userLabel.Position = UDim2.new(0.55, 0, 0, 0)
	userLabel.BackgroundTransparency = 1
	userLabel.Text = "@" .. p.Name
	userLabel.TextColor3 = Colors.TextDark
	userLabel.Font = Enum.Font.Gotham
	userLabel.TextSize = 12
	userLabel.TextXAlignment = Enum.TextXAlignment.Right
	userLabel.TextTruncate = Enum.TextTruncate.AtEnd
	userLabel.Parent = frame

	return frame
end

local function refreshList()
	local all = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if not leaving[p] then table.insert(all, p) end
	end
	table.sort(all, function(a, b)
		return a.DisplayName:lower() < b.DisplayName:lower()
	end)

	local present = {}
	for i, p in ipairs(all) do
		present[p] = true
		local frame = listRows[p]
		if not frame then
			frame = buildRow(p)
			listRows[p] = frame
		end
		frame.LayoutOrder = i + 10
	end

	for p, frame in pairs(listRows) do
		if not present[p] then
			frame:Destroy()
			listRows[p] = nil
		end
	end

	listHeader.Text = "Players in server: " .. #all
end

connect(Players.PlayerAdded, refreshList)
connect(Players.PlayerRemoving, function(p)
	leaving[p] = true
	refreshList()
end)

task.spawn(function()
	while not unloaded do
		refreshList()
		task.wait(0.5)
	end
end)

-- ==================== HOME PAGE ====================
local welcomeCard = createCard(homeL, "Welcome")
createLabel(welcomeCard, player.DisplayName, Colors.Text, 18)
createLabel(welcomeCard, "Right Ctrl - show / hide menu\nDrag the window by the top bar, resize from the bottom-right corner.")

local statusCard = createCard(homeR, "Status")
local fpsLabel = createLabel(statusCard, "FPS: --", Colors.Text, 14)
local pingLabel = createLabel(statusCard, "Ping: --", Colors.Text, 14)
local playersLabel = createLabel(statusCard, "Players: --", Colors.Text, 14)

local fps = 60
connect(RunService.RenderStepped, function(dt)
	fps = fps * 0.9 + (1 / math.max(dt, 1e-4)) * 0.1
end)

task.spawn(function()
	while not unloaded do
		fpsLabel.Text = "FPS: " .. math.floor(fps + 0.5)
		local ok, ping = pcall(function() return player:GetNetworkPing() * 1000 end)
		pingLabel.Text = "Ping: " .. (ok and (math.floor(ping + 0.5) .. " ms") or "--")
		playersLabel.Text = "Players: " .. #Players:GetPlayers()
		task.wait(0.5)
	end
end)

local tipsCard = createCard(homeL, "Quick Keys")
createLabel(tipsCard,
	"F - toggle fly\n" ..
	"Space / E - fly up\n" ..
	"Shift / Ctrl / Q - fly down\n" ..
	"Right Click (hold) - aim assist")

-- ==================== PLAYER PAGE ====================
local flightCard = createCard(playerL, "Flight")

local flyToggle
flyToggle = createToggle(flightCard, "Fly  (hotkey: F)", function(on)
	if on then
		if not startFly() then
			task.defer(function() flyToggle.Set(false, true) end)
		end
	else
		stopFly()
	end
end)
table.insert(featureToggles, flyToggle)

createSlider(flightCard, "Fly Speed", 1, 500, flySpeed, function(v)
	flySpeed = v
end)

local spinCard = createCard(playerR, "Spinbot")

local spinToggle = createToggle(spinCard, "Spinbot", function(on)
	if on then startSpin() else stopSpin() end
end)
table.insert(featureToggles, spinToggle)

createSlider(spinCard, "Spin Speed", 1, 200, spinSpeed, function(v)
	spinSpeed = v
end)

local moveCard = createCard(playerL, "Movement")

local speedToggle = createToggle(moveCard, "Walk Speed", function(on)
	setSpeedEnabled(on)
end)
table.insert(featureToggles, speedToggle)

createSlider(moveCard, "Walk Speed Value", 1, 200, speedValue, function(v)
	speedValue = v
end)

local miscPlayerCard = createCard(playerR, "Extras")
local jumpToggle = createToggle(miscPlayerCard, "Infinite Jump", function(on)
	infJump = on
end)
table.insert(featureToggles, jumpToggle)

-- Fly resets on respawn (spin and speed keep working on the new character)
connect(player.CharacterAdded, function()
	if flying then
		stopFly()
		flyToggle.Set(false, true)
	end
end)

-- ==================== AIMING PAGE ====================
local aimCard = createCard(aimL, "Aim Assist")

local aimToggle = createToggle(aimCard, "Enabled", function(on)
	aimEnabled = on
end)
table.insert(featureToggles, aimToggle)

createDropdown(aimCard, "Aim Mode", {"Hold Right Click", "Always On"}, "Hold Right Click", function(v)
	aimHold = (v == "Hold Right Click")
end)

createDropdown(aimCard, "Hit Part", {"Head", "Body"}, "Head", function(v)
	aimHead = (v == "Head")
end)

local checksCard = createCard(aimR, "Checks")

createToggle(checksCard, "Team Check", function(on)
	aimTeamCheck = on
end, true)

createToggle(checksCard, "Wall Check", function(on)
	aimWallCheck = on
end, false)

local fovCard = createCard(aimR, "Aim FOV")

createToggle(fovCard, "Show FOV Circle", function(on)
	aimShowFOV = on
end, true)

createSlider(fovCard, "Size", 20, 500, aimFOV, function(v)
	aimFOV = v
end)

local smoothCard = createCard(aimL, "Smoothness")

createSlider(smoothCard, "Smoothness (1 = instant)", 1, 100, aimSmooth, function(v)
	aimSmooth = v
end)

-- ==================== VISUALS PAGE ====================
local espCard = createCard(visL, "Player ESP")

local chamsToggle = createToggle(espCard, "Chams", function(on) espChams = on end)
local namesToggle = createToggle(espCard, "Names", function(on) espNames = on end)
local healthToggle = createToggle(espCard, "Health", function(on) espHealth = on end)
local distanceToggle = createToggle(espCard, "Distance", function(on) espDistance = on end)
for _, t in ipairs({chamsToggle, namesToggle, healthToggle, distanceToggle}) do
	table.insert(featureToggles, t)
end

local worldCard = createCard(visR, "World")

local fullbrightToggle = createToggle(worldCard, "Fullbright", function(on)
	setFullbright(on)
end)
table.insert(featureToggles, fullbrightToggle)

local camCard = createCard(visR, "Camera")

local fovToggle = createToggle(camCard, "Custom Camera FOV", function(on)
	if on then
		local cam = workspace.CurrentCamera
		if cam then origFov = cam.FieldOfView end
		customFov = true
	else
		customFov = false
		local cam = workspace.CurrentCamera
		if cam then cam.FieldOfView = origFov end
	end
end)
table.insert(featureToggles, fovToggle)

createSlider(camCard, "Camera FOV", 30, 120, fovValue, function(v)
	fovValue = v
end)

-- ==================== MISC PAGE ====================
local creditsCard = createCard(miscL, "Credits")
createLabel(creditsCard, "creator - soqef", Colors.Text, 16)
createLabel(creditsCard, "(CREDITS TO MATCHA <3)", Colors.Accent, 13)
createLabel(creditsCard, "Vanadium v2.0\nMade for a private game with friends - for fun only.")

local keysCard = createCard(miscR, "Keybinds")
createLabel(keysCard,
	"Right Ctrl - show / hide menu\n" ..
	"F - toggle fly\n" ..
	"Space / E - fly up\n" ..
	"Left Shift / Left Ctrl / Q - fly down\n" ..
	"Right Click (hold) - aim assist")

-- ==================== SETTINGS PAGE ====================
local function turnOffAll()
	suppressNotify = true
	for _, t in ipairs(featureToggles) do
		if t.Get() then t.Set(false) end
	end
	suppressNotify = false
end

local function unload()
	unloaded = true
	turnOffAll()
	updateESP() -- removes chams and tags now that every flag is off

	pcall(function() RunService:UnbindFromRenderStep("VanadiumAim") end)
	pcall(function() RunService:UnbindFromRenderStep("VanadiumSpin") end)
	for _, c in ipairs(connections) do
		c:Disconnect()
	end
	screenGui:Destroy()
end

local actionsCard = createCard(setL, "Actions")
createButton(actionsCard, "Turn Off All Features", function()
	turnOffAll()
	notify("All features turned off")
end)
createButton(actionsCard, "Unload GUI", unload)

local interfaceCard = createCard(setR, "Interface")
createToggle(interfaceCard, "Notifications", function(on)
	notifyEnabled = on
end, true)

-- ==================== CLOSE / TOGGLE ====================
closeBtn.MouseButton1Click:Connect(function()
	setMenu(false)
end)

connect(UserInputService.InputBegan, function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.RightControl then
		setMenu(not menuOpen)
	elseif input.KeyCode == Enum.KeyCode.F then
		flyToggle.Set(not flyToggle.Get())
	end
end)

-- ==================== DRAGGING ====================
local dragging = false
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

connect(UserInputService.InputChanged, function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- ==================== RESIZING ====================
local resizeHandle = Instance.new("Frame")
resizeHandle.Size = UDim2.new(0, 14, 0, 14)
resizeHandle.Position = UDim2.new(1, -16, 1, -16)
resizeHandle.BackgroundColor3 = Colors.Tertiary
resizeHandle.BorderSizePixel = 0
resizeHandle.ZIndex = 5
resizeHandle.Parent = main
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 4)

local resizing = false
local resizeStart
local startSize
local resizeStartPos

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = true
		resizeStart = input.Position
		startSize = main.Size
		resizeStartPos = main.Position
	end
end)

resizeHandle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = false
	end
end)

connect(UserInputService.InputChanged, function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - resizeStart
		local newX = math.clamp(startSize.X.Offset + delta.X, WINDOW_W, 1000)
		local newY = math.clamp(startSize.Y.Offset + delta.Y, 340, 760)
		main.Size = UDim2.new(0, newX, 0, newY)
		-- window is center-anchored, so shift it by half the growth to keep the corner under the cursor
		main.Position = UDim2.new(
			resizeStartPos.X.Scale, resizeStartPos.X.Offset + (newX - startSize.X.Offset) / 2,
			resizeStartPos.Y.Scale, resizeStartPos.Y.Offset + (newY - startSize.Y.Offset) / 2
		)
	end
end)

-- ==================== START ====================
switchTab("Home")

task.spawn(function()
	local tween = TweenService:Create(loadingBar, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 1, 0)
	})
	tween:Play()
	tween.Completed:Wait()
	task.wait(0.2)

	TweenService:Create(loadingFrame, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
	TweenService:Create(loadingText, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
	TweenService:Create(loadingBarBg, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
	TweenService:Create(loadingBar, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
	task.wait(0.4)

	loadingFrame:Destroy()
	setMenu(true)
end)
