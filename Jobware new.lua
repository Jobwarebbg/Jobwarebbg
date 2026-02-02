-- [[ JOBWARE V8 - MASSIVE MOBILE CONSOLE ]] --
-- Size: 80% Screen Width/Height (Matches Delta Console / Reference Image)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local JobwareLib = {}

-- [[ THEME: DARK CONSOLE ]] --
local Theme = {
	MainBg      = Color3.fromRGB(15, 15, 20),      -- Dark Console Grey
	SidebarBg   = Color3.fromRGB(10, 10, 15),      -- Darker Sidebar
	SectionBg   = Color3.fromRGB(25, 25, 30),      -- Lighter Content Area
	ElementBg   = Color3.fromRGB(35, 35, 40),      -- Button BG
	Accent      = Color3.fromRGB(52, 152, 219),    -- Delta Blue
	Text        = Color3.fromRGB(255, 255, 255),
	TextDim     = Color3.fromRGB(170, 170, 170),
	Stroke      = Color3.fromRGB(50, 50, 60),
	Font        = Enum.Font.GothamBold,
	TextSize    = 16 -- Großer Text für Lesbarkeit
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
	stroke.Thickness = thickness or 1.5
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
	local Name = config.Name or "JOBWARE CONSOLE"
	
	-- Cleanup
	if CoreGui:FindFirstChild("JobwareV8") then CoreGui.JobwareV8:Destroy() end
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "JobwareV8"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	-- [[ 1. FLOATING TOGGLE (Big Icon) ]] --
	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Name = "Toggle"
	ToggleBtn.Size = UDim2.new(0, 60, 0, 60) -- 60px Groß
	ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
	ToggleBtn.BackgroundColor3 = Theme.MainBg
	ToggleBtn.Text = "JW"
	ToggleBtn.TextColor3 = Theme.Accent
	ToggleBtn.Font = Theme.Font
	ToggleBtn.TextSize = 20
	ToggleBtn.Parent = ScreenGui
	AddCorner(ToggleBtn, 12)
	AddStroke(ToggleBtn, Theme.Accent, 2)
	MakeDraggable(ToggleBtn, ToggleBtn)
	
	-- [[ 2. MAIN FRAME (MASSIVE SIZE) ]] --
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	-- HIER IST DIE ÄNDERUNG: 80% Breite, 70% Höhe (Wie Delta Console)
	MainFrame.Size = UDim2.new(0.8, 0, 0.7, 0) 
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Theme.MainBg
	MainFrame.Visible = false
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui
	AddCorner(MainFrame, 10)
	AddStroke(MainFrame, Theme.Stroke, 2)
	
	ToggleBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)
	
	-- [[ SIDEBAR ]] --
	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0.3, 0, 1, 0) -- 30% Breite für Sidebar
	Sidebar.BackgroundColor3 = Theme.SidebarBg
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = MainFrame
	
	-- Title
	local TitleLbl = Instance.new("TextLabel")
	TitleLbl.Text = Name
	TitleLbl.Size = UDim2.new(1, 0, 0, 60) -- 60px Header Höhe
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.TextColor3 = Theme.Accent
	TitleLbl.Font = Enum.Font.GothamBlack
	TitleLbl.TextSize = 20
	TitleLbl.Parent = Sidebar
	
	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Size = UDim2.new(1, 0, 1, -60)
	TabScroll.Position = UDim2.new(0, 0, 0, 60)
	TabScroll.BackgroundTransparency = 1
	TabScroll.ScrollBarThickness = 0
	TabScroll.Parent = Sidebar
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Padding = UDim.new(0, 10)
	TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabLayout.Parent = TabScroll
	
	-- [[ CONTENT ]] --
	local Content = Instance.new("Frame")
	Content.Size = UDim2.new(0.7, 0, 1, 0) -- 70% Rest für Inhalt
	Content.Position = UDim2.new(0.3, 0, 0, 0)
	Content.BackgroundColor3 = Theme.MainBg
	Content.BorderSizePixel = 0
	Content.Parent = MainFrame
	
	local ContentScrollFolder = Instance.new("Frame")
	ContentScrollFolder.Size = UDim2.new(1, 0, 1, 0)
	ContentScrollFolder.BackgroundTransparency = 1
	ContentScrollFolder.Parent = Content
	
	MakeDraggable(Sidebar, MainFrame)

	local Library = {}
	local Tabs = {}
	
	-- [[ TABS ]]
	function Library:CreateTab(name)
		local Tab = {}
		
		-- Tab Button (Gross)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(0.9, 0, 0, 50) -- 50px Hoch
		TabBtn.BackgroundColor3 = Theme.SidebarBg
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = name
		TabBtn.TextColor3 = Theme.TextDim
		TabBtn.Font = Theme.Font
		TabBtn.TextSize = 16
		TabBtn.Parent = TabScroll
		AddCorner(TabBtn, 8)
		
		-- Page
		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 4
		Page.ScrollBarImageColor3 = Theme.Accent
		Page.Parent = ContentScrollFolder
		
		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 15)
		PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Parent = Page
		
		local PagePad = Instance.new("UIPadding")
		PagePad.PaddingTop = UDim.new(0, 20)
		PagePad.PaddingBottom = UDim.new(0, 20)
		PagePad.Parent = Page
		
		TabBtn.MouseButton1Click:Connect(function()
			for _, t in pairs(Tabs) do
				t.Page.Visible = false
				TweenService:Create(t.Btn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim, BackgroundTransparency = 1}):Play()
			end
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Text, BackgroundTransparency = 0}):Play()
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg}):Play()
		end)
		
		table.insert(Tabs, {Btn = TabBtn, Page = Page})
		
		if #Tabs == 1 then
			Page.Visible = true
			TabBtn.TextColor3 = Theme.Text
			TabBtn.BackgroundTransparency = 0
			TabBtn.BackgroundColor3 = Theme.ElementBg
		end
		
		-- [[ SECTIONS ]]
		function Tab:CreateSection(title)
			local Section = {}
			
			local SecFrame = Instance.new("Frame")
			SecFrame.Size = UDim2.new(0.95, 0, 0, 0)
			SecFrame.BackgroundColor3 = Theme.SectionBg
			SecFrame.AutomaticSize = Enum.AutomaticSize.Y
			SecFrame.Parent = Page
			AddCorner(SecFrame, 8)
			
			local SecTitle = Instance.new("TextLabel")
			SecTitle.Text = title
			SecTitle.Size = UDim2.new(1, -20, 0, 35)
			SecTitle.Position = UDim2.new(0, 15, 0, 0)
			SecTitle.BackgroundTransparency = 1
			SecTitle.TextColor3 = Theme.Accent
			SecTitle.Font = Theme.Font
			SecTitle.TextSize = 15
			SecTitle.TextXAlignment = Enum.TextXAlignment.Left
			SecTitle.Parent = SecFrame
			
			local Items = Instance.new("Frame")
			Items.Size = UDim2.new(1, 0, 0, 0)
			Items.Position = UDim2.new(0, 0, 0, 35)
			Items.BackgroundTransparency = 1
			Items.AutomaticSize = Enum.AutomaticSize.Y
			Items.Parent = SecFrame
			
			local ItemLayout = Instance.new("UIListLayout")
			ItemLayout.Padding = UDim.new(0, 10)
			ItemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			ItemLayout.Parent = Items
			
			local ItemPad = Instance.new("UIPadding")
			ItemPad.PaddingBottom = UDim.new(0, 15)
			ItemPad.Parent = Items
			
			-- BUTTON
			function Section:AddButton(text, callback)
				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(0.92, 0, 0, 50) -- 50px Hoch!
				Button.BackgroundColor3 = Theme.ElementBg
				Button.Text = text
				Button.TextColor3 = Theme.Text
				Button.Font = Theme.Font
				Button.TextSize = 15
				Button.Parent = Items
				AddCorner(Button, 6)
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
				ToggleBtn.Size = UDim2.new(0.92, 0, 0, 50) -- 50px Hoch
				ToggleBtn.BackgroundColor3 = Theme.ElementBg
				ToggleBtn.Text = ""
				ToggleBtn.AutoButtonColor = false
				ToggleBtn.Parent = Items
				AddCorner(ToggleBtn, 6)
				AddStroke(ToggleBtn, Theme.Stroke, 1)
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Size = UDim2.new(0.7, 0, 1, 0)
				Label.Position = UDim2.new(0.05, 0, 0, 0)
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Theme.Text
				Label.Font = Theme.Font
				Label.TextSize = 15
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = ToggleBtn
				
				local Status = Instance.new("Frame")
				Status.Size = UDim2.new(0, 24, 0, 24)
				Status.Position = UDim2.new(0.95, -24, 0.5, -12)
				Status.BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(50,50,55)
				Status.Parent = ToggleBtn
				AddCorner(Status, 6)
				
				ToggleBtn.MouseButton1Click:Connect(function()
					Toggled = not Toggled
					local col = Toggled and Theme.Accent or Color3.fromRGB(50,50,55)
					TweenService:Create(Status, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
					pcall(callback, Toggled)
				end)
			end

			-- SLIDER
			function Section:AddSlider(text, min, max, default, callback)
				local val = default or min
				local SliderFrame = Instance.new("Frame")
				SliderFrame.Size = UDim2.new(0.92, 0, 0, 60) -- 60px Hoch
				SliderFrame.BackgroundColor3 = Theme.ElementBg
				SliderFrame.Parent = Items
				AddCorner(SliderFrame, 6)
				AddStroke(SliderFrame, Theme.Stroke, 1)
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Size = UDim2.new(1, -20, 0, 30)
				Label.Position = UDim2.new(0, 10, 0, 0)
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Theme.Text
				Label.Font = Theme.Font
				Label.TextSize = 15
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = SliderFrame
				
				local ValLabel = Instance.new("TextLabel")
				ValLabel.Text = tostring(val)
				ValLabel.Size = UDim2.new(1, -20, 0, 30)
				ValLabel.BackgroundTransparency = 1
				ValLabel.TextColor3 = Theme.Accent
				ValLabel.TextXAlignment = Enum.TextXAlignment.Right
				ValLabel.Font = Theme.Font
				ValLabel.TextSize = 15
				ValLabel.Parent = SliderFrame
				
				local Bar = Instance.new("TextButton")
				Bar.Text = ""
				Bar.AutoButtonColor = false
				Bar.Size = UDim2.new(0.9, 0, 0, 8)
				Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
				Bar.BackgroundColor3 = Color3.fromRGB(20,20,25)
				Bar.Parent = SliderFrame
				AddCorner(Bar, 4)
				
				local Fill = Instance.new("Frame")
				Fill.Size = UDim2.new((val-min)/(max-min), 0, 1, 0)
				Fill.BackgroundColor3 = Theme.Accent
				Fill.BorderSizePixel = 0
				Fill.Parent = Bar
				AddCorner(Fill, 4)
				
				local dragging = false
				local function Update(input)
					local s = math.clamp((input.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
					val = math.floor(min + (max-min)*s)
					ValLabel.Text = tostring(val)
					TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(s, 0, 1, 0)}):Play()
					pcall(callback, val)
				end
				
				Bar.InputBegan:Connect(function(i) 
					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
						dragging = true; Update(i) 
					end 
				end)
				UserInputService.InputEnded:Connect(function(i) 
					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end 
				end)
				UserInputService.InputChanged:Connect(function(i) 
					if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end 
				end)
			end

			return Section
		end
		
		return Tab
	end
	return Library
end

return JobwareLib
