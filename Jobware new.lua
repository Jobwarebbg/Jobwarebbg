-- [[ JOBWARE V14 - FIXED DROPDOWNS & COMPLETE ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local JobwareLib = {}

-- [[ THEME ]] --
local Theme = {
	MainBg      = Color3.fromRGB(6, 6, 8),
	SidebarBg   = Color3.fromRGB(11, 11, 15),
	SectionBg   = Color3.fromRGB(18, 18, 22),
	ElementBg   = Color3.fromRGB(28, 28, 32),
	Accent      = Color3.fromRGB(60, 140, 255),
	Text        = Color3.fromRGB(235, 235, 235),
	TextDim     = Color3.fromRGB(120, 120, 130),
	Stroke      = Color3.fromRGB(35, 35, 40),
	Font        = Enum.Font.GothamBold,
	FontItem    = Enum.Font.GothamMedium,
	TextSize    = 11
}

-- [[ UTILS ]] --
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

-- [[ MAIN LIB ]] --
function JobwareLib:CreateWindow(config)
	local WinName = "Jobware"
	
	if CoreGui:FindFirstChild("JobwareV14") then CoreGui.JobwareV14:Destroy() end
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "JobwareV14"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	-- JOKER TOGGLE
	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Name = "JokerToggle"
	ToggleBtn.Size = UDim2.new(0, 35, 0, 35)
	ToggleBtn.Position = UDim2.new(0.5, 0, 0.05, 0)
	ToggleBtn.AnchorPoint = Vector2.new(0.5, 0)
	ToggleBtn.BackgroundColor3 = Theme.MainBg
	ToggleBtn.Text = "🃏"
	ToggleBtn.TextColor3 = Theme.Text
	ToggleBtn.TextSize = 20
	ToggleBtn.Parent = ScreenGui
	AddCorner(ToggleBtn, 8)
	AddStroke(ToggleBtn, Theme.Accent, 1.5)
	MakeDraggable(ToggleBtn, ToggleBtn)

	-- WATERMARK
	local InfoBar = Instance.new("Frame")
	InfoBar.Name = "Watermark"
	InfoBar.Size = UDim2.new(0, 200, 0, 26)
	InfoBar.Position = UDim2.new(0.98, 0, 0.05, 0)
	InfoBar.AnchorPoint = Vector2.new(1, 0)
	InfoBar.BackgroundColor3 = Theme.MainBg
	InfoBar.Parent = ScreenGui
	AddCorner(InfoBar, 4)
	AddStroke(InfoBar, Theme.Stroke, 1)
	
	local InfoText = Instance.new("TextLabel")
	InfoText.Size = UDim2.new(1, -10, 1, 0)
	InfoText.Position = UDim2.new(0, 5, 0, 0)
	InfoText.BackgroundTransparency = 1
	InfoText.TextColor3 = Theme.Text
	InfoText.Font = Theme.FontItem
	InfoText.TextSize = 11
	InfoText.TextXAlignment = Enum.TextXAlignment.Right
	InfoText.Parent = InfoBar

	local GameName = "Game"
	task.spawn(function()
		local s, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
		if s and info then GameName = info.Name end
	end)

	RunService.RenderStepped:Connect(function(dt)
		InfoText.Text = "Jobware | " .. GameName .. " | FPS: " .. math.floor(1/dt)
		InfoBar.Size = UDim2.new(0, InfoText.TextBounds.X + 20, 0, 26)
	end)

	-- MAIN FRAME
	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0.85, 0, 0.92, 0)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Theme.MainBg
	MainFrame.Visible = false
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui
	AddCorner(MainFrame, 4)
	AddStroke(MainFrame, Theme.Stroke, 1)
	
	ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0.24, 0, 1, 0)
	Sidebar.BackgroundColor3 = Theme.SidebarBg
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = MainFrame
	
	local SidebarLine = Instance.new("Frame")
	SidebarLine.Size = UDim2.new(0, 1, 1, 0)
	SidebarLine.Position = UDim2.new(1, 0, 0, 0)
	SidebarLine.BackgroundColor3 = Theme.Stroke
	SidebarLine.BorderSizePixel = 0
	SidebarLine.Parent = Sidebar
	
	local Logo = Instance.new("TextLabel")
	Logo.Text = WinName
	Logo.Size = UDim2.new(1, 0, 0, 40)
	Logo.BackgroundTransparency = 1
	Logo.TextColor3 = Theme.Accent
	Logo.Font = Enum.Font.GothamBlack
	Logo.TextSize = 14
	Logo.Parent = Sidebar
	
	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Size = UDim2.new(1, 0, 1, -40)
	TabScroll.Position = UDim2.new(0, 0, 0, 40)
	TabScroll.BackgroundTransparency = 1
	TabScroll.ScrollBarThickness = 0
	TabScroll.Parent = Sidebar
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Padding = UDim.new(0, 2)
	TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabLayout.Parent = TabScroll
	
	local Content = Instance.new("Frame")
	Content.Size = UDim2.new(0.76, 0, 1, 0)
	Content.Position = UDim2.new(0.24, 0, 0, 0)
	Content.BackgroundColor3 = Theme.MainBg
	Content.BorderSizePixel = 0
	Content.Parent = MainFrame
	
	local TopLine = Instance.new("Frame")
	TopLine.Size = UDim2.new(1, 0, 0, 1)
	TopLine.BackgroundColor3 = Theme.Accent
	TopLine.BorderSizePixel = 0
	TopLine.Parent = Content
	
	local PageFolder = Instance.new("Frame")
	PageFolder.Size = UDim2.new(1, 0, 1, -1)
	PageFolder.Position = UDim2.new(0, 0, 0, 1)
	PageFolder.BackgroundTransparency = 1
	PageFolder.Parent = Content
	
	MakeDraggable(Sidebar, MainFrame)
	
	local Library = {}
	local Tabs = {}
	
	function Library:CreateTab(name)
		local Tab = {}
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, 0, 0, 32)
		TabBtn.BackgroundColor3 = Theme.SidebarBg
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = name
		TabBtn.TextColor3 = Theme.TextDim
		TabBtn.Font = Theme.FontItem
		TabBtn.TextSize = 11
		TabBtn.Parent = TabScroll
		
		local Ind = Instance.new("Frame")
		Ind.Size = UDim2.new(0, 2, 1, 0)
		Ind.BackgroundColor3 = Theme.Accent
		Ind.BackgroundTransparency = 1
		Ind.BorderSizePixel = 0
		Ind.Parent = TabBtn
		
		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = Theme.Accent
		Page.Parent = PageFolder
		
		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 6)
		PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Parent = Page
		
		local PagePad = Instance.new("UIPadding")
		PagePad.PaddingTop = UDim.new(0, 10)
		PagePad.PaddingBottom = UDim.new(0, 10)
		PagePad.Parent = Page
		
		TabBtn.MouseButton1Click:Connect(function()
			for _, t in pairs(Tabs) do
				t.Page.Visible = false
				TweenService:Create(t.Btn, TweenInfo.new(0.15), {TextColor3 = Theme.TextDim, BackgroundTransparency = 1}):Play()
				t.Ind.BackgroundTransparency = 1
			end
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.15), {TextColor3 = Theme.Text, BackgroundTransparency = 0.95}):Play()
			TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Accent}):Play()
			Ind.BackgroundTransparency = 0
		end)
		
		table.insert(Tabs, {Btn = TabBtn, Page = Page, Ind = Ind})
		
		if #Tabs == 1 then
			Page.Visible = true
			TabBtn.TextColor3 = Theme.Text
			TabBtn.BackgroundColor3 = Theme.Accent
			TabBtn.BackgroundTransparency = 0.95
			Ind.BackgroundTransparency = 0
		end
		
		function Tab:CreateSection(title)
			local Section = {}
			local SecFrame = Instance.new("Frame")
			SecFrame.Size = UDim2.new(0.96, 0, 0, 0)
			SecFrame.BackgroundColor3 = Theme.SectionBg
			SecFrame.AutomaticSize = Enum.AutomaticSize.Y
			SecFrame.Parent = Page
			AddCorner(SecFrame, 3)
			AddStroke(SecFrame, Theme.Stroke, 1)
			
			local SecTitle = Instance.new("TextLabel")
			SecTitle.Text = title
			SecTitle.Size = UDim2.new(1, -10, 0, 24)
			SecTitle.Position = UDim2.new(0, 8, 0, 0)
			SecTitle.BackgroundTransparency = 1
			SecTitle.TextColor3 = Theme.Accent
			SecTitle.Font = Theme.Font
			SecTitle.TextSize = 11
			SecTitle.TextXAlignment = Enum.TextXAlignment.Left
			SecTitle.Parent = SecFrame
			
			local Items = Instance.new("Frame")
			Items.Size = UDim2.new(1, 0, 0, 0)
			Items.Position = UDim2.new(0, 0, 0, 24)
			Items.BackgroundTransparency = 1
			Items.AutomaticSize = Enum.AutomaticSize.Y
			Items.Parent = SecFrame
			
			local ItemLayout = Instance.new("UIListLayout")
			ItemLayout.Padding = UDim.new(0, 4)
			ItemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			ItemLayout.Parent = Items
			
			local ItemPad = Instance.new("UIPadding")
			ItemPad.PaddingBottom = UDim.new(0, 8)
			ItemPad.Parent = Items
			
			-- BUTTON
			function Section:AddButton(text, callback)
				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(0.96, 0, 0, 28)
				Button.BackgroundColor3 = Theme.ElementBg
				Button.Text = text
				Button.TextColor3 = Theme.Text
				Button.Font = Theme.FontItem
				Button.TextSize = 11
				Button.Parent = Items
				AddCorner(Button, 3)
				AddStroke(Button, Theme.Stroke, 1)
				
				Button.MouseButton1Click:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
					wait(0.1)
					TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg}):Play()
					pcall(callback)
				end)
			end
			
			-- TOGGLE
			function Section:AddToggle(text, default, callback)
				local Toggled = default or false
				local ToggleBtn = Instance.new("TextButton")
				ToggleBtn.Size = UDim2.new(0.96, 0, 0, 28)
				ToggleBtn.BackgroundColor3 = Theme.ElementBg
				ToggleBtn.Text = ""
				ToggleBtn.AutoButtonColor = false
				ToggleBtn.Parent = Items
				AddCorner(ToggleBtn, 3)
				AddStroke(ToggleBtn, Theme.Stroke, 1)
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Size = UDim2.new(0.8, 0, 1, 0)
				Label.Position = UDim2.new(0.04, 0, 0, 0)
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Theme.Text
				Label.Font = Theme.FontItem
				Label.TextSize = 11
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = ToggleBtn
				
				local Box = Instance.new("Frame")
				Box.Size = UDim2.new(0, 14, 0, 14)
				Box.Position = UDim2.new(0.96, -14, 0.5, -7)
				Box.BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(35,35,40)
				Box.Parent = ToggleBtn
				AddCorner(Box, 2)
				
				ToggleBtn.MouseButton1Click:Connect(function()
					Toggled = not Toggled
					local col = Toggled and Theme.Accent or Color3.fromRGB(35,35,40)
					TweenService:Create(Box, TweenInfo.new(0.1), {BackgroundColor3 = col}):Play()
					pcall(callback, Toggled)
				end)
			end
			
			-- SLIDER
			function Section:AddSlider(text, min, max, default, callback)
				local val = default or min
				local SliderFrame = Instance.new("Frame")
				SliderFrame.Size = UDim2.new(0.96, 0, 0, 38)
				SliderFrame.BackgroundColor3 = Theme.ElementBg
				SliderFrame.Parent = Items
				AddCorner(SliderFrame, 3)
				AddStroke(SliderFrame, Theme.Stroke, 1)
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Size = UDim2.new(1, -10, 0, 20)
				Label.Position = UDim2.new(0, 6, 0, 0)
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Theme.Text
				Label.Font = Theme.FontItem
				Label.TextSize = 11
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = SliderFrame
				
				local ValLabel = Instance.new("TextLabel")
				ValLabel.Text = tostring(val)
				ValLabel.Size = UDim2.new(1, -10, 0, 20)
				ValLabel.Position = UDim2.new(0, -6, 0, 0)
				ValLabel.BackgroundTransparency = 1
				ValLabel.TextColor3 = Theme.Accent
				ValLabel.TextXAlignment = Enum.TextXAlignment.Right
				ValLabel.Font = Theme.FontItem
				ValLabel.TextSize = 11
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
			
			-- DROPDOWN (FIXED)
			function Section:AddDropdown(text, list, default, callback)
				local open = false
				local selected = default or list[1]
				
				local Container = Instance.new("Frame")
				Container.Size = UDim2.new(0.96, 0, 0, 32) -- Standard Höhe
				Container.BackgroundColor3 = Theme.ElementBg
				Container.Parent = Items
				Container.ClipsDescendants = true -- Wichtig für Animation
				AddCorner(Container, 3)
				AddStroke(Container, Theme.Stroke, 1)
				
				local TopBtn = Instance.new("TextButton")
				TopBtn.Size = UDim2.new(1, 0, 0, 32)
				TopBtn.BackgroundTransparency = 1
				TopBtn.Text = ""
				TopBtn.Parent = Container
				
				local Label = Instance.new("TextLabel")
				Label.Text = text .. ": " .. selected
				Label.Size = UDim2.new(1, -25, 0, 32)
				Label.Position = UDim2.new(0, 8, 0, 0)
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Theme.Text
				Label.Font = Theme.FontItem
				Label.TextSize = 11
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = TopBtn
				
				local Arrow = Instance.new("TextLabel")
				Arrow.Text = "▼"
				Arrow.Size = UDim2.new(0, 20, 0, 32)
				Arrow.Position = UDim2.new(1, -20, 0, 0)
				Arrow.BackgroundTransparency = 1
				Arrow.TextColor3 = Theme.TextDim
				Arrow.TextSize = 10
				Arrow.Parent = TopBtn
				
				local List = Instance.new("Frame")
				List.Size = UDim2.new(1, 0, 0, 0)
				List.Position = UDim2.new(0, 0, 0, 32)
				List.BackgroundTransparency = 1
				List.Parent = Container
				
				local ListLayout = Instance.new("UIListLayout")
				ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ListLayout.Parent = List
				
				local function RefreshList()
					for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
					for _, item in pairs(list) do
						local ItemBtn = Instance.new("TextButton")
						ItemBtn.Size = UDim2.new(1, 0, 0, 24)
						ItemBtn.BackgroundColor3 = (item == selected) and Theme.Accent or Theme.ElementBg
						ItemBtn.BackgroundTransparency = (item == selected) and 0.8 or 1
						ItemBtn.Text = item
						ItemBtn.TextColor3 = Theme.Text
						ItemBtn.Font = Theme.FontItem
						ItemBtn.TextSize = 11
						ItemBtn.Parent = List
						
						ItemBtn.MouseButton1Click:Connect(function()
							selected = item
							Label.Text = text .. ": " .. selected
							open = false
							TweenService:Create(Container, TweenInfo.new(0.2), {Size = UDim2.new(0.96, 0, 0, 32)}):Play()
							Arrow.Rotation = 0
							pcall(callback, item)
						end)
					end
				end
				
				TopBtn.MouseButton1Click:Connect(function()
					open = not open
					RefreshList()
					local targetHeight = open and (32 + (#list * 24)) or 32
					TweenService:Create(Container, TweenInfo.new(0.2), {Size = UDim2.new(0.96, 0, 0, targetHeight)}):Play()
					Arrow.Rotation = open and 180 or 0
				end)
			end
			
			return Section
		end
		return Tab
	end
	return Library
end

return JobwareLib
