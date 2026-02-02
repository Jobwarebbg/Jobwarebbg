-- [[ JOBWARE V6 - PANDAZ SIZE HYBRID ]] --
-- Style: Neverlose Theme | Size: PandazWare++ (Wider & Higher)

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local JobwareLib = {}

-- [[ THEME: NEVERLOSE ]] --
local Theme = {
	MainBg      = Color3.fromRGB(12, 12, 16),      -- Deep Dark (Neverlose Background)
	SidebarBg   = Color3.fromRGB(18, 18, 22),      -- Sidebar Contrast
	SectionBg   = Color3.fromRGB(24, 24, 28),      -- Content Boxes
	ElementBg   = Color3.fromRGB(32, 32, 38),      -- Button Backgrounds
	Accent      = Color3.fromRGB(0, 165, 255),     -- Neverlose Blue
	Text        = Color3.fromRGB(255, 255, 255),   -- White
	TextDim     = Color3.fromRGB(145, 145, 155),   -- Dimmed Gray
	Stroke      = Color3.fromRGB(45, 45, 50),      -- Borders/Outlines
	Font        = Enum.Font.GothamBold             -- Bold Tech Font
}

-- [[ UTILITIES ]] --
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

-- [[ LIBRARY START ]] --
function JobwareLib:CreateWindow(config)
	local Name = config.Name or "Jobware"
	
	-- Cleanup
	if CoreGui:FindFirstChild("JobwareV6") then CoreGui.JobwareV6:Destroy() end
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "JobwareV6"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	-- [[ 1. MOBILE TOGGLE (Floating Logo) ]]
	local OpenBtn = Instance.new("TextButton")
	OpenBtn.Name = "MobileToggle"
	OpenBtn.Size = UDim2.new(0, 50, 0, 50)
	OpenBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
	OpenBtn.BackgroundColor3 = Theme.MainBg
	OpenBtn.Text = "J"
	OpenBtn.TextColor3 = Theme.Accent
	OpenBtn.Font = Theme.Font
	OpenBtn.TextSize = 24
	OpenBtn.Parent = ScreenGui
	AddCorner(OpenBtn, 12) -- Pandaz Style Soft Square
	AddStroke(OpenBtn, Theme.Accent, 2)
	MakeDraggable(OpenBtn, OpenBtn)
	
	-- Pulse Animation
	spawn(function()
		while OpenBtn.Parent do
			TweenService:Create(OpenBtn, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation = 0, BackgroundColor3 = Theme.SidebarBg}):Play()
			wait(1.5)
		end
	end)

	-- [[ 2. MAIN FRAME (Pandaz Size + Bigger) ]]
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	-- Pandaz ist oft kleiner. Wir machen es hier breiter (0.65) und höher (0.6)
	MainFrame.Size = UDim2.new(0.65, 0, 0.6, 0) 
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Theme.MainBg
	MainFrame.Visible = false
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui
	AddCorner(MainFrame, 8)
	AddStroke(MainFrame, Theme.Stroke, 1.5)
	
	-- Toggle Logic
	OpenBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)
	
	-- [[ SIDEBAR ]]
	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0.28, 0, 1, 0)
	Sidebar.BackgroundColor3 = Theme.SidebarBg
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = MainFrame
	
	-- Title Area
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = Name
	TitleLabel.Size = UDim2.new(1, 0, 0, 45)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextColor3 = Theme.Accent
	TitleLabel.Font = Theme.Font
	TitleLabel.TextSize = 18
	TitleLabel.Parent = Sidebar
	MakeDraggable(Sidebar, MainFrame) -- Drag via Sidebar
	
	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Size = UDim2.new(1, 0, 1, -45)
	TabContainer.Position = UDim2.new(0, 0, 0, 45)
	TabContainer.BackgroundTransparency = 1
	TabContainer.ScrollBarThickness = 0
	TabContainer.Parent = Sidebar
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Padding = UDim.new(0, 5)
	TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabLayout.Parent = TabContainer
	
	-- [[ CONTENT AREA ]]
	local Content = Instance.new("Frame")
	Content.Size = UDim2.new(0.72, 0, 1, 0)
	Content.Position = UDim2.new(0.28, 0, 0, 0)
	Content.BackgroundColor3 = Theme.MainBg
	Content.BorderSizePixel = 0
	Content.Parent = MainFrame
	
	-- Top Stripe (Neverlose Detail)
	local AccentLine = Instance.new("Frame")
	AccentLine.Size = UDim2.new(1, 0, 0, 2)
	AccentLine.BackgroundColor3 = Theme.Accent
	AccentLine.BorderSizePixel = 0
	AccentLine.Parent = Content
	
	-- Content Container
	local PagesFolder = Instance.new("Frame")
	PagesFolder.Size = UDim2.new(1, 0, 1, -2)
	PagesFolder.Position = UDim2.new(0, 0, 0, 2)
	PagesFolder.BackgroundTransparency = 1
	PagesFolder.Parent = Content

	local Tabs = {}
	
	local Library = {}
	
	-- [[ CREATE TAB ]] --
	function Library:CreateTab(name, icon)
		local Tab = {}
		
		-- Tab Button
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(0.9, 0, 0, 40)
		TabBtn.BackgroundColor3 = Theme.MainBg
		TabBtn.BackgroundTransparency = 1 -- Transparent inactive
		TabBtn.Text = name
		TabBtn.TextColor3 = Theme.TextDim
		TabBtn.Font = Theme.Font
		TabBtn.TextSize = 14
		TabBtn.Parent = TabContainer
		AddCorner(TabBtn, 6)
		
		-- Page Frame
		local Page = Instance.new("ScrollingFrame")
		Page.Name = name.."_Page"
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = Theme.Accent
		Page.Parent = PagesFolder
		
		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 12)
		PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Parent = Page
		
		local PagePad = Instance.new("UIPadding")
		PagePad.PaddingTop = UDim.new(0, 15)
		PagePad.PaddingBottom = UDim.new(0, 15)
		PagePad.Parent = Page
		
		-- Switching Logic
		TabBtn.MouseButton1Click:Connect(function()
			for _, t in pairs(Tabs) do
				t.Page.Visible = false
				TweenService:Create(t.Btn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim, BackgroundTransparency = 1}):Play()
			end
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Text, BackgroundTransparency = 0}):Play() -- Active Background
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SectionBg}):Play()
		end)
		
		table.insert(Tabs, {Btn = TabBtn, Page = Page})
		
		-- Activate first tab
		if #Tabs == 1 then
			Page.Visible = true
			TabBtn.TextColor3 = Theme.Text
			TabBtn.BackgroundTransparency = 0
			TabBtn.BackgroundColor3 = Theme.SectionBg
		end
		
		-- [[ SECTIONS ]] --
		function Tab:CreateSection(title)
			local Section = {}
			
			-- Section Frame
			local SecFrame = Instance.new("Frame")
			SecFrame.Size = UDim2.new(0.94, 0, 0, 0) -- Wide
			SecFrame.BackgroundColor3 = Theme.SectionBg
			SecFrame.AutomaticSize = Enum.AutomaticSize.Y
			SecFrame.Parent = Page
			AddCorner(SecFrame, 6)
			AddStroke(SecFrame, Theme.Stroke, 1)
			
			-- Title
			local SecTitle = Instance.new("TextLabel")
			SecTitle.Text = title
			SecTitle.Size = UDim2.new(1, -20, 0, 30)
			SecTitle.Position = UDim2.new(0, 12, 0, 0)
			SecTitle.BackgroundTransparency = 1
			SecTitle.TextColor3 = Theme.Accent
			SecTitle.Font = Theme.Font
			SecTitle.TextSize = 13
			SecTitle.TextXAlignment = Enum.TextXAlignment.Left
			SecTitle.Parent = SecFrame
			
			local ContentContainer = Instance.new("Frame")
			ContentContainer.Size = UDim2.new(1, 0, 0, 0)
			ContentContainer.Position = UDim2.new(0, 0, 0, 30)
			ContentContainer.AutomaticSize = Enum.AutomaticSize.Y
			ContentContainer.BackgroundTransparency = 1
			ContentContainer.Parent = SecFrame
			
			local SecLayout = Instance.new("UIListLayout")
			SecLayout.Padding = UDim.new(0, 8)
			SecLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			SecLayout.Parent = ContentContainer
			
			local SecPad = Instance.new("UIPadding")
			SecPad.PaddingBottom = UDim.new(0, 12)
			SecPad.Parent = ContentContainer
			
			-- [[ ELEMENTS ]] --
			
			-- TOGGLE
			function Section:AddToggle(text, default, callback)
				local Toggled = default or false
				
				local ToggleBtn = Instance.new("TextButton")
				ToggleBtn.Size = UDim2.new(0.92, 0, 0, 38)
				ToggleBtn.BackgroundColor3 = Theme.ElementBg
				ToggleBtn.Text = ""
				ToggleBtn.AutoButtonColor = false
				ToggleBtn.Parent = ContentContainer
				AddCorner(ToggleBtn, 5)
				AddStroke(ToggleBtn, Theme.Stroke, 1)
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Size = UDim2.new(0.7, 0, 1, 0)
				Label.Position = UDim2.new(0.05, 0, 0, 0)
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Theme.Text
				Label.Font = Theme.Font
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = ToggleBtn
				
				-- Neverlose Style Square Check
				local CheckFrame = Instance.new("Frame")
				CheckFrame.Size = UDim2.new(0, 20, 0, 20)
				CheckFrame.Position = UDim2.new(0.95, -20, 0.5, -10)
				CheckFrame.BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(45,45,50)
				CheckFrame.Parent = ToggleBtn
				AddCorner(CheckFrame, 4)
				
				ToggleBtn.MouseButton1Click:Connect(function()
					Toggled = not Toggled
					local targetColor = Toggled and Theme.Accent or Color3.fromRGB(45,45,50)
					TweenService:Create(CheckFrame, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
					pcall(callback, Toggled)
				end)
			end
			
			-- BUTTON
			function Section:AddButton(text, callback)
				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(0.92, 0, 0, 38)
				Button.BackgroundColor3 = Theme.ElementBg
				Button.Text = text
				Button.TextColor3 = Theme.Text
				Button.Font = Theme.Font
				Button.TextSize = 13
				Button.Parent = ContentContainer
				AddCorner(Button, 5)
				AddStroke(Button, Theme.Stroke, 1)
				
				Button.MouseButton1Click:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
					wait(0.1)
					TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg}):Play()
					pcall(callback)
				end)
			end
			
			-- SLIDER
			function Section:AddSlider(text, min, max, default, callback)
				local Value = default or min
				local SliderFrame = Instance.new("Frame")
				SliderFrame.Size = UDim2.new(0.92, 0, 0, 50)
				SliderFrame.BackgroundColor3 = Theme.ElementBg
				SliderFrame.Parent = ContentContainer
				AddCorner(SliderFrame, 5)
				AddStroke(SliderFrame, Theme.Stroke, 1)
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Size = UDim2.new(1, -10, 0, 25)
				Label.Position = UDim2.new(0, 10, 0, 0)
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Theme.Text
				Label.Font = Theme.Font
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = SliderFrame
				
				local ValLabel = Instance.new("TextLabel")
				ValLabel.Text = tostring(Value)
				ValLabel.Size = UDim2.new(1, -10, 0, 25)
				ValLabel.BackgroundTransparency = 1
				ValLabel.TextColor3 = Theme.Accent
				ValLabel.TextXAlignment = Enum.TextXAlignment.Right
				ValLabel.Font = Theme.Font
				ValLabel.TextSize = 13
				ValLabel.Parent = SliderFrame
				
				local Bar = Instance.new("TextButton")
				Bar.Size = UDim2.new(0.9, 0, 0, 6)
				Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
				Bar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
				Bar.Text = ""
				Bar.AutoButtonColor = false
				Bar.Parent = SliderFrame
				AddCorner(Bar, 3)
				
				local Fill = Instance.new("Frame")
				Fill.Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
				Fill.BackgroundColor3 = Theme.Accent
				Fill.BorderSizePixel = 0
				Fill.Parent = Bar
				AddCorner(Fill, 3)
				
				local dragging = false
				local function Update(input)
					local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
					Value = math.floor(min + (max - min) * percent)
					ValLabel.Text = tostring(Value)
					TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
					pcall(callback, Value)
				end
				
				Bar.InputBegan:Connect(function(inp) 
					if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
						dragging = true; Update(inp)
					end
				end)
				UserInputService.InputEnded:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
				end)
				UserInputService.InputChanged:Connect(function(inp)
					if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then Update(inp) end
				end)
			end

			return Section
		end
		
		return Tab
	end
	
	-- Notification Function (Placeholder)
	function Library:Notify(config)
		-- Simple console print for now, or add real notifications
		print("[NOTIFY]: " .. (config.Title or "") .. " - " .. (config.Message or ""))
	end

	return Library
end

return JobwareLib
