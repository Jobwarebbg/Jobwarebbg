-- [[ JOBWARE V10 - NEVERLOSE NATIVE EDITION ]] --
-- Height: 96% (Ultra Tall) | Theme: 1:1 Neverlose Dark

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local JobwareLib = {}

-- [[ 1. THEME CONFIGURATION (NEVERLOSE PALETTE) ]] --
local Theme = {
	MainBg      = Color3.fromRGB(6, 6, 8),         -- Pitch Black/Blue tint
	SidebarBg   = Color3.fromRGB(10, 10, 14),      -- Slightly lighter
	SectionBg   = Color3.fromRGB(16, 16, 20),      -- Content Boxes
	ElementBg   = Color3.fromRGB(25, 25, 30),      -- Interactables
	Accent      = Color3.fromRGB(0, 165, 255),     -- Electric Blue
	Text        = Color3.fromRGB(240, 240, 245),   -- White/Grey
	TextDim     = Color3.fromRGB(100, 100, 110),   -- Dark Grey
	Stroke      = Color3.fromRGB(35, 35, 40),      -- Subtle Outlines
	Font        = Enum.Font.GothamBold,            -- Bold Headers
	FontBody    = Enum.Font.GothamMedium           -- Softer Body Text
}

-- [[ 2. UTILITY FUNCTIONS ]] --
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

-- [[ 3. MAIN WINDOW CREATION ]] --
function JobwareLib:CreateWindow(config)
	local WinName = config.Name or "NL"

	-- Cleanup Old UI
	if CoreGui:FindFirstChild("JobwareV10") then CoreGui.JobwareV10:Destroy() end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "JobwareV10"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	-- ScreenGui.IgnoreGuiInset = true -- Optional: Entfernt die Topbar Lücke

	-- [[ MOBILE FLOATING ICON ]] --
	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Name = "Toggle"
	ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
	ToggleBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
	ToggleBtn.BackgroundColor3 = Theme.MainBg
	ToggleBtn.Text = "N"
	ToggleBtn.TextColor3 = Theme.Accent
	ToggleBtn.Font = Enum.Font.GothamBlack
	ToggleBtn.TextSize = 26
	ToggleBtn.Parent = ScreenGui
	AddCorner(ToggleBtn, 8)
	AddStroke(ToggleBtn, Theme.Accent, 1.5)
	MakeDraggable(ToggleBtn, ToggleBtn)

	-- [[ THE MAIN FRAME (ULTRA TALL) ]] --
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	-- 85% Breite, 96% HÖHE (Fast Fullscreen)
	MainFrame.Size = UDim2.new(0.85, 0, 0.96, 0) 
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
	Sidebar.Size = UDim2.new(0.25, 0, 1, 0) -- Schmale Sidebar für modernen Look
	Sidebar.BackgroundColor3 = Theme.SidebarBg
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = MainFrame

	local SidebarLine = Instance.new("Frame")
	SidebarLine.Size = UDim2.new(0, 1, 1, 0)
	SidebarLine.Position = UDim2.new(1, 0, 0, 0)
	SidebarLine.BackgroundColor3 = Theme.Stroke
	SidebarLine.BorderSizePixel = 0
	SidebarLine.Parent = Sidebar

	-- Logo / Name
	local Logo = Instance.new("TextLabel")
	Logo.Text = WinName:upper()
	Logo.Size = UDim2.new(1, 0, 0, 60)
	Logo.BackgroundTransparency = 1
	Logo.TextColor3 = Theme.Accent
	Logo.Font = Enum.Font.GothamBlack
	Logo.TextSize = 18
	Logo.Parent = Sidebar

	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Size = UDim2.new(1, 0, 1, -60)
	TabScroll.Position = UDim2.new(0, 0, 0, 60)
	TabScroll.BackgroundTransparency = 1
	TabScroll.ScrollBarThickness = 0
	TabScroll.Parent = Sidebar

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Padding = UDim.new(0, 5)
	TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabLayout.Parent = TabScroll

	-- [[ CONTENT AREA ]] --
	local Content = Instance.new("Frame")
	Content.Size = UDim2.new(0.75, 0, 1, 0)
	Content.Position = UDim2.new(0.25, 0, 0, 0)
	Content.BackgroundColor3 = Theme.MainBg
	Content.BorderSizePixel = 0
	Content.Parent = MainFrame

	-- Top Gradient Line (Neverlose Style)
	local TopLine = Instance.new("Frame")
	TopLine.Size = UDim2.new(1, 0, 0, 2)
	TopLine.BackgroundColor3 = Theme.Accent
	TopLine.BorderSizePixel = 0
	TopLine.Parent = Content
	
	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Theme.Accent),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
	}
	Gradient.Parent = TopLine

	local PageFolder = Instance.new("Frame")
	PageFolder.Size = UDim2.new(1, 0, 1, -2)
	PageFolder.Position = UDim2.new(0, 0, 0, 2)
	PageFolder.BackgroundTransparency = 1
	PageFolder.Parent = Content

	MakeDraggable(Sidebar, MainFrame)

	local Library = {}
	local Tabs = {}

	-- [[ 4. TABS ]] --
	function Library:CreateTab(name)
		local Tab = {}

		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, 0, 0, 45) -- Volle Breite der Sidebar
		TabBtn.BackgroundColor3 = Theme.SidebarBg
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = name
		TabBtn.TextColor3 = Theme.TextDim
		TabBtn.Font = Theme.FontBody
		TabBtn.TextSize = 14
		TabBtn.Parent = TabScroll

		-- Active Indicator (Der blaue Strich links)
		local Indicator = Instance.new("Frame")
		Indicator.Size = UDim2.new(0, 3, 1, 0)
		Indicator.Position = UDim2.new(0, 0, 0, 0)
		Indicator.BackgroundColor3 = Theme.Accent
		Indicator.BackgroundTransparency = 1 -- Versteckt
		Indicator.BorderSizePixel = 0
		Indicator.Parent = TabBtn

		local Page = Instance.new("ScrollingFrame")
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
		PagePad.PaddingTop = UDim.new(0, 20)
		PagePad.PaddingBottom = UDim.new(0, 20)
		PagePad.Parent = Page

		-- Tab Logic
		TabBtn.MouseButton1Click:Connect(function()
			for _, t in pairs(Tabs) do
				t.Page.Visible = false
				TweenService:Create(t.Btn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim, BackgroundTransparency = 1}):Play()
				TweenService:Create(t.Ind, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			end
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Text, BackgroundTransparency = 0.95}):Play()
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play() -- Leichter blauer Hintergrund
			TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
		end)

		table.insert(Tabs, {Btn = TabBtn, Page = Page, Ind = Indicator})

		-- Activate First
		if #Tabs == 1 then
			Page.Visible = true
			TabBtn.TextColor3 = Theme.Text
			TabBtn.BackgroundColor3 = Theme.Accent
			TabBtn.BackgroundTransparency = 0.95
			Indicator.BackgroundTransparency = 0
		end

		-- [[ 5. SECTIONS ]] --
		function Tab:CreateSection(title)
			local Section = {}

			local SecFrame = Instance.new("Frame")
			SecFrame.Size = UDim2.new(0.96, 0, 0, 0)
			SecFrame.BackgroundColor3 = Theme.SectionBg
			SecFrame.AutomaticSize = Enum.AutomaticSize.Y
			SecFrame.Parent = Page
			AddCorner(SecFrame, 5)
			AddStroke(SecFrame, Theme.Stroke, 1)

			local SecTitle = Instance.new("TextLabel")
			SecTitle.Text = title
			SecTitle.Size = UDim2.new(1, -20, 0, 32)
			SecTitle.Position = UDim2.new(0, 12, 0, 0)
			SecTitle.BackgroundTransparency = 1
			SecTitle.TextColor3 = Theme.Accent
			SecTitle.Font = Theme.Font
			SecTitle.TextSize = 12
			SecTitle.TextXAlignment = Enum.TextXAlignment.Left
			SecTitle.Parent = SecFrame

			local Items = Instance.new("Frame")
			Items.Size = UDim2.new(1, 0, 0, 0)
			Items.Position = UDim2.new(0, 0, 0, 32)
			Items.BackgroundTransparency = 1
			Items.AutomaticSize = Enum.AutomaticSize.Y
			Items.Parent = SecFrame

			local ItemLayout = Instance.new("UIListLayout")
			ItemLayout.Padding = UDim.new(0, 6)
			ItemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			ItemLayout.Parent = Items
			
			local ItemPad = Instance.new("UIPadding")
			ItemPad.PaddingBottom = UDim.new(0, 12)
			ItemPad.Parent = Items

			-- [[ BUTTON ]]
			function Section:AddButton(text, callback)
				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(0.94, 0, 0, 38)
				Button.BackgroundColor3 = Theme.ElementBg
				Button.Text = text
				Button.TextColor3 = Theme.Text
				Button.Font = Theme.FontBody
				Button.TextSize = 13
				Button.Parent = Items
				AddCorner(Button, 4)
				AddStroke(Button, Theme.Stroke, 1)

				Button.MouseButton1Click:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
					wait(0.1)
					TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg}):Play()
					pcall(callback)
				end)
			end

			-- [[ TOGGLE ]]
			function Section:AddToggle(text, default, callback)
				local Toggled = default or false
				local ToggleBtn = Instance.new("TextButton")
				ToggleBtn.Size = UDim2.new(0.94, 0, 0, 38)
				ToggleBtn.BackgroundColor3 = Theme.ElementBg
				ToggleBtn.Text = ""
				ToggleBtn.AutoButtonColor = false
				ToggleBtn.Parent = Items
				AddCorner(ToggleBtn, 4)
				AddStroke(ToggleBtn, Theme.Stroke, 1)

				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Size = UDim2.new(0.7, 0, 1, 0)
				Label.Position = UDim2.new(0.04, 0, 0, 0)
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Theme.Text
				Label.Font = Theme.FontBody
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = ToggleBtn

				-- Rounded Toggle Switch
				local SwitchBg = Instance.new("Frame")
				SwitchBg.Size = UDim2.new(0, 34, 0, 18)
				SwitchBg.Position = UDim2.new(0.96, -34, 0.5, -9)
				SwitchBg.BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(45,45,50)
				SwitchBg.Parent = ToggleBtn
				AddCorner(SwitchBg, 9)

				local Circle = Instance.new("Frame")
				Circle.Size = UDim2.new(0, 14, 0, 14)
				Circle.Position = Toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
				Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Circle.Parent = SwitchBg
				AddCorner(Circle, 7)

				ToggleBtn.MouseButton1Click:Connect(function()
					Toggled = not Toggled
					local col = Toggled and Theme.Accent or Color3.fromRGB(45,45,50)
					local pos = Toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
					
					TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.2), {Position = pos}):Play()
					pcall(callback, Toggled)
				end)
			end
			
			-- [[ SLIDER ]]
			function Section:AddSlider(text, min, max, default, callback)
				local val = default or min
				local SliderFrame = Instance.new("Frame")
				SliderFrame.Size = UDim2.new(0.94, 0, 0, 50)
				SliderFrame.BackgroundColor3 = Theme.ElementBg
				SliderFrame.Parent = Items
				AddCorner(SliderFrame, 4)
				AddStroke(SliderFrame, Theme.Stroke, 1)
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Size = UDim2.new(1, -15, 0, 25)
				Label.Position = UDim2.new(0, 10, 0, 0)
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Theme.Text
				Label.Font = Theme.FontBody
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = SliderFrame
				
				local ValLabel = Instance.new("TextLabel")
				ValLabel.Text = tostring(val)
				ValLabel.Size = UDim2.new(1, -15, 0, 25)
				ValLabel.BackgroundTransparency = 1
				ValLabel.TextColor3 = Theme.Accent
				ValLabel.TextXAlignment = Enum.TextXAlignment.Right
				ValLabel.Font = Theme.FontBody
				ValLabel.TextSize = 13
				ValLabel.Parent = SliderFrame
				
				local Bar = Instance.new("TextButton")
				Bar.Text = ""
				Bar.AutoButtonColor = false
				Bar.Size = UDim2.new(0.92, 0, 0, 4)
				Bar.Position = UDim2.new(0.04, 0, 0.75, 0)
				Bar.BackgroundColor3 = Color3.fromRGB(20,20,25)
				Bar.Parent = SliderFrame
				AddCorner(Bar, 2)
				
				local Fill = Instance.new("Frame")
				Fill.Size = UDim2.new((val-min)/(max-min), 0, 1, 0)
				Fill.BackgroundColor3 = Theme.Accent
				Fill.BorderSizePixel = 0
				Fill.Parent = Bar
				AddCorner(Fill, 2)
				
				local dragging = false
				local function Update(input)
					local s = math.clamp((input.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
					val = math.floor(min + (max-min)*s)
					ValLabel.Text = tostring(val)
					TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(s, 0, 1, 0)}):Play()
					pcall(callback, val)
				end
				
				Bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; Update(i) end end)
				UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
				UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Update(i) end end)
			end

			return Section
		end
		return Tab
	end
	return Library
end

return JobwareLib
