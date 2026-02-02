-- [[ JOBWARE V7 - TITAN EDITION ]] --
-- Based on analysis of PandazWare but BIGGER and in Neverlose Style.

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local JobwareLib = {}

-- [[ THEME: NEVERLOSE (DARK & BLUE) ]] --
local Theme = {
	MainBg      = Color3.fromRGB(11, 11, 14),      -- Fast Schwarz (Neverlose Main)
	SidebarBg   = Color3.fromRGB(16, 16, 20),      -- Sidebar etwas heller
	SectionBg   = Color3.fromRGB(22, 22, 28),      -- Content Boxen
	ElementBg   = Color3.fromRGB(30, 30, 36),      -- Buttons/Inputs
	Accent      = Color3.fromRGB(66, 165, 245),    -- Strahlendes Hellblau
	Text        = Color3.fromRGB(245, 245, 245),   -- Weiß
	TextDim     = Color3.fromRGB(140, 140, 150),   -- Grau
	Stroke      = Color3.fromRGB(45, 45, 55),      -- Ränder
	Font        = Enum.Font.GothamBold,
	TextSize    = 14
}

-- [[ HILFSFUNKTIONEN ]] --
local function AddCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = instance
	return corner
end

local function AddStroke(instance, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Theme.Stroke
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = instance
	return stroke
end

local function MakeDraggable(trigger, object)
	local dragging, dragInput, dragStart, startPos
	trigger.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	trigger.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- [[ MAIN WINDOW ]] --
function JobwareLib:CreateWindow(config)
	local ConfigName = config.Name or "Jobware"
	
	-- Reset
	if CoreGui:FindFirstChild("JobwareV7") then CoreGui.JobwareV7:Destroy() end
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "JobwareV7"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	-- [[ MOBILE TOGGLE (NEVERLOSE LOGO STYLE) ]] --
	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Name = "Toggle"
	ToggleBtn.Size = UDim2.new(0, 55, 0, 55) -- Groß genug für Daumen
	ToggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
	ToggleBtn.BackgroundColor3 = Theme.MainBg
	ToggleBtn.Text = "NL" -- Neverlose Kürzel Style
	ToggleBtn.TextColor3 = Theme.Accent
	ToggleBtn.Font = Enum.Font.GothamBlack
	ToggleBtn.TextSize = 22
	ToggleBtn.Parent = ScreenGui
	AddCorner(ToggleBtn, 10) -- Soft Round
	AddStroke(ToggleBtn, Theme.Accent, 2)
	MakeDraggable(ToggleBtn, ToggleBtn)
	
	-- [[ MAIN FRAME (BIGGER THAN PANDAZ) ]] --
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	-- Pandaz ist oft kleiner. Hier: 70% Breite, 65% Höhe.
	MainFrame.Size = UDim2.new(0.70, 0, 0.65, 0) 
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Theme.MainBg
	MainFrame.Visible = false -- Startet versteckt
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui
	AddCorner(MainFrame, 6)
	AddStroke(MainFrame, Theme.Stroke, 1.5)
	
	-- Toggle Logic
	ToggleBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)
	
	-- [[ SIDEBAR ]] --
	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0.28, 0, 1, 0) -- 28% für Sidebar
	Sidebar.BackgroundColor3 = Theme.SidebarBg
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = MainFrame
	
	-- Logo Area
	local LogoLabel = Instance.new("TextLabel")
	LogoLabel.Text = ConfigName:upper()
	LogoLabel.Size = UDim2.new(1, 0, 0, 50)
	LogoLabel.BackgroundTransparency = 1
	LogoLabel.TextColor3 = Theme.Accent
	LogoLabel.Font = Enum.Font.GothamBlack
	LogoLabel.TextSize = 18
	LogoLabel.Parent = Sidebar
	
	-- Tab Container
	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Size = UDim2.new(1, 0, 1, -50)
	TabScroll.Position = UDim2.new(0, 0, 0, 50)
	TabScroll.BackgroundTransparency = 1
	TabScroll.ScrollBarThickness = 0
	TabScroll.Parent = Sidebar
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Padding = UDim.new(0, 8)
	TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabLayout.Parent = TabScroll
	
	-- [[ CONTENT AREA ]] --
	local Content = Instance.new("Frame")
	Content.Size = UDim2.new(0.72, 0, 1, 0) -- Restlicher Platz
	Content.Position = UDim2.new(0.28, 0, 0, 0)
	Content.BackgroundColor3 = Theme.MainBg
	Content.BorderSizePixel = 0
	Content.Parent = MainFrame
	
	-- Top Accent Line
	local TopLine = Instance.new("Frame")
	TopLine.Size = UDim2.new(1, 0, 0, 2)
	TopLine.BackgroundColor3 = Theme.Accent
	TopLine.BorderSizePixel = 0
	TopLine.Parent = Content
	
	-- Page Container
	local PageFolder = Instance.new("Frame")
	PageFolder.Size = UDim2.new(1, 0, 1, -2)
	PageFolder.Position = UDim2.new(0, 0, 0, 2)
	PageFolder.BackgroundTransparency = 1
	PageFolder.Parent = Content
	
	MakeDraggable(Sidebar, MainFrame) -- Man kann das Menü an der Sidebar ziehen

	local Library = {}
	local Tabs = {}

	-- [[ TAB CREATION ]] --
	function Library:CreateTab(name)
		local Tab = {}
		
		-- Tab Button
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(0.9, 0, 0, 42) -- Gute Höhe
		TabBtn.BackgroundColor3 = Theme.SidebarBg
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = name
		TabBtn.TextColor3 = Theme.TextDim
		TabBtn.Font = Theme.Font
		TabBtn.TextSize = 14
		TabBtn.Parent = TabScroll
		AddCorner(TabBtn, 6)
		
		-- Page
		local Page = Instance.new("ScrollingFrame")
		Page.Name = name.."_Page"
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 3
		Page.ScrollBarImageColor3 = Theme.Accent
		Page.Parent = PageFolder
		
		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 12)
		PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Parent = Page
		
		local PagePad = Instance.new("UIPadding")
		PagePad.PaddingTop = UDim.new(0, 15)
		PagePad.PaddingBottom = UDim.new(0, 15)
		PagePad.Parent = Page
		
		-- Activation Logic
		TabBtn.MouseButton1Click:Connect(function()
			for _, t in pairs(Tabs) do
				t.Page.Visible = false
				TweenService:Create(t.Btn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim, BackgroundTransparency = 1}):Play()
			end
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Text, BackgroundTransparency = 0}):Play()
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SectionBg}):Play()
		end)
		
		table.insert(Tabs, {Btn = TabBtn, Page = Page})
		
		-- First Tab Active
		if #Tabs == 1 then
			Page.Visible = true
			TabBtn.TextColor3 = Theme.Text
			TabBtn.BackgroundTransparency = 0
			TabBtn.BackgroundColor3 = Theme.SectionBg
		end
		
		-- [[ SECTION CREATION ]] --
		function Tab:CreateSection(title)
			local Section = {}
			
			local SecFrame = Instance.new("Frame")
			SecFrame.Size = UDim2.new(0.96, 0, 0, 0) -- Fast volle Breite
			SecFrame.BackgroundColor3 = Theme.SectionBg
			SecFrame.AutomaticSize = Enum.AutomaticSize.Y
			SecFrame.Parent = Page
			AddCorner(SecFrame, 5)
			AddStroke(SecFrame, Theme.Stroke, 1)
			
			local SecTitle = Instance.new("TextLabel")
			SecTitle.Text = title
			SecTitle.Size = UDim2.new(1, -20, 0, 32)
			SecTitle.Position = UDim2.new(0, 10, 0, 0)
			SecTitle.BackgroundTransparency = 1
			SecTitle.TextColor3 = Theme.Accent
			SecTitle.Font = Theme.Font
			SecTitle.TextSize = 13
			SecTitle.TextXAlignment = Enum.TextXAlignment.Left
			SecTitle.Parent = SecFrame
			
			local ItemContainer = Instance.new("Frame")
			ItemContainer.Size = UDim2.new(1, 0, 0, 0)
			ItemContainer.Position = UDim2.new(0, 0, 0, 32)
			ItemContainer.BackgroundTransparency = 1
			ItemContainer.AutomaticSize = Enum.AutomaticSize.Y
			ItemContainer.Parent = SecFrame
			
			local ItemLayout = Instance.new("UIListLayout")
			ItemLayout.Padding = UDim.new(0, 8)
			ItemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			ItemLayout.Parent = ItemContainer
			
			local ItemPad = Instance.new("UIPadding")
			ItemPad.PaddingBottom = UDim.new(0, 10)
			ItemPad.Parent = ItemContainer
			
			-- [[ TOGGLE ]]
			function Section:AddToggle(text, default, callback)
				local Toggled = default or false
				local ToggleBtn = Instance.new("TextButton")
				ToggleBtn.Size = UDim2.new(0.94, 0, 0, 42) -- 42px Hoch (Tippfreundlich)
				ToggleBtn.BackgroundColor3 = Theme.ElementBg
				ToggleBtn.Text = ""
				ToggleBtn.AutoButtonColor = false
				ToggleBtn.Parent = ItemContainer
				AddCorner(ToggleBtn, 5)
				AddStroke(ToggleBtn, Theme.Stroke, 1)
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Size = UDim2.new(0.8, 0, 1, 0)
				Label.Position = UDim2.new(0.04, 0, 0, 0)
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Theme.Text
				Label.Font = Theme.Font
				Label.TextSize = 14
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = ToggleBtn
				
				local CheckBox = Instance.new("Frame")
				CheckBox.Size = UDim2.new(0, 22, 0, 22)
				CheckBox.Position = UDim2.new(0.96, -22, 0.5, -11)
				CheckBox.BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(40,40,45)
				CheckBox.Parent = ToggleBtn
				AddCorner(CheckBox, 4)
				
				ToggleBtn.MouseButton1Click:Connect(function()
					Toggled = not Toggled
					local goal = Toggled and Theme.Accent or Color3.fromRGB(40,40,45)
					TweenService:Create(CheckBox, TweenInfo.new(0.15), {BackgroundColor3 = goal}):Play()
					pcall(callback, Toggled)
				end)
			end
			
			-- [[ BUTTON ]]
			function Section:AddButton(text, callback)
				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(0.94, 0, 0, 42)
				Button.BackgroundColor3 = Theme.ElementBg
				Button.Text = text
				Button.TextColor3 = Theme.Text
				Button.Font = Theme.Font
				Button.TextSize = 14
				Button.Parent = ItemContainer
				AddCorner(Button, 5)
				AddStroke(Button, Theme.Stroke, 1)
				
				Button.MouseButton1Click:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
					wait(0.1)
					TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg}):Play()
					pcall(callback)
				end)
			end
			
			-- [[ SLIDER ]]
			function Section:AddSlider(text, min, max, default, callback)
				local Value = default or min
				local SliderFrame = Instance.new("Frame")
				SliderFrame.Size = UDim2.new(0.94, 0, 0, 55) -- 55px Hoch
				SliderFrame.BackgroundColor3 = Theme.ElementBg
				SliderFrame.Parent = ItemContainer
				AddCorner(SliderFrame, 5)
				AddStroke(SliderFrame, Theme.Stroke, 1)
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Size = UDim2.new(1, -15, 0, 25)
				Label.Position = UDim2.new(0, 10, 0, 2)
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Theme.Text
				Label.Font = Theme.Font
				Label.TextSize = 14
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = SliderFrame
				
				local ValLabel = Instance.new("TextLabel")
				ValLabel.Text = tostring(Value)
				ValLabel.Size = UDim2.new(1, -15, 0, 25)
				ValLabel.Position = UDim2.new(0, 0, 0, 2)
				ValLabel.BackgroundTransparency = 1
				ValLabel.TextColor3 = Theme.Accent
				ValLabel.Font = Theme.Font
				ValLabel.TextSize = 14
				ValLabel.TextXAlignment = Enum.TextXAlignment.Right
				ValLabel.Parent = SliderFrame
				
				local Bar = Instance.new("TextButton")
				Bar.Text = ""
				Bar.AutoButtonColor = false
				Bar.Size = UDim2.new(0.92, 0, 0, 6)
				Bar.Position = UDim2.new(0.04, 0, 0.7, 0)
				Bar.BackgroundColor3 = Color3.fromRGB(20,20,25)
				Bar.Parent = SliderFrame
				AddCorner(Bar, 3)
				
				local Fill = Instance.new("Frame")
				Fill.Size = UDim2.new((Value - min)/(max - min), 0, 1, 0)
				Fill.BackgroundColor3 = Theme.Accent
				Fill.BorderSizePixel = 0
				Fill.Parent = Bar
				AddCorner(Fill, 3)
				
				local dragging = false
				local function Update(input)
					local scale = math.clamp((input.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
					Value = math.floor(min + (max-min)*scale)
					ValLabel.Text = tostring(Value)
					TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(scale, 0, 1, 0)}):Play()
					pcall(callback, Value)
				end
				
				Bar.InputBegan:Connect(function(i) 
					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
						dragging = true; Update(i) 
					end 
				end)
				UserInputService.InputEnded:Connect(function(i) 
					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
						dragging = false 
					end 
				end)
				UserInputService.InputChanged:Connect(function(i) 
					if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
						Update(i) 
					end 
				end)
			end

			return Section
		end
		
		return Tab
	end
	
	return Library
end

return JobwareLib
