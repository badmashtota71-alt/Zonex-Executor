-- Zonex Executor v4.1 (Fixed Tabs & Logic)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Sidebar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FloatingIcon = Instance.new("TextButton")

-- Tabs
local HomeTab = Instance.new("Frame")
local EditorTab = Instance.new("Frame")
local HubTab = Instance.new("ScrollingFrame")

-- Setup UI Base
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "ZonexMain"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Instance.new("UICorner", Sidebar)

Title.Parent = Sidebar
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "ZONEX"
Title.TextColor3 = Color3.fromRGB(0, 255, 180)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24

-- FUNCTION TO SWITCH TABS (This was missing!)
local function ShowTab(tabToShow)
    HomeTab.Visible = false
    EditorTab.Visible = false
    HubTab.Visible = false
    
    tabToShow.Visible = true
end

-- Home Tab Setup
HomeTab.Parent = MainFrame
HomeTab.Size = UDim2.new(1, -140, 1, -20)
HomeTab.Position = UDim2.new(0, 130, 0, 10)
HomeTab.BackgroundTransparency = 1
local WelcomeText = Instance.new("TextLabel", HomeTab)
WelcomeText.Size = UDim2.new(1,0,1,0)
WelcomeText.Text = "ZONEX v4.1\n\nStatus: Keyless\nSelect a tab to begin."
WelcomeText.TextColor3 = Color3.fromRGB(200, 200, 200)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Font = Enum.Font.Gotham

-- Editor Tab Setup
EditorTab.Parent = MainFrame
EditorTab.Size = HomeTab.Size
EditorTab.Position = HomeTab.Position
EditorTab.BackgroundTransparency = 1

local TextBox = Instance.new("TextBox", EditorTab)
TextBox.Size = UDim2.new(1, 0, 0, 200)
TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TextBox.Text = "-- Paste Script Here"
TextBox.MultiLine = true
TextBox.ClearTextOnFocus = false
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.Code
TextBox.TextXAlignment = "Left"
TextBox.TextYAlignment = "Top"
Instance.new("UICorner", TextBox)

local ExecBtn = Instance.new("TextButton", EditorTab)
ExecBtn.Size = UDim2.new(1, 0, 0, 40)
ExecBtn.Position = UDim2.new(0, 0, 0, 210)
ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
ExecBtn.Text = "EXECUTE"
ExecBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ExecBtn)

-- Hub Tab Setup
HubTab.Parent = MainFrame
HubTab.Size = HomeTab.Size
HubTab.Position = HomeTab.Position
HubTab.BackgroundTransparency = 1
HubTab.CanvasSize = UDim2.new(0,0,2,0)
HubTab.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", HubTab)
layout.Padding = UDim.new(0,5)

local function addHubScript(name, code)
    local btn = Instance.new("TextButton", HubTab)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() 
        loadstring(game:HttpGet(code))() 
    end)
end

-- Built-in Scripts (Actual Working Links)
addHubScript("Infinite Yield", "https://githubusercontent.com")
addHubScript("SimpleSpy", "https://githubusercontent.com")

-- Floating Icon Setup
FloatingIcon.Parent = ScreenGui
FloatingIcon.Position = UDim2.new(0, 20, 0.5, 0)
FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
FloatingIcon.Text = "Z"
FloatingIcon.TextColor3 = Color3.fromRGB(0, 255, 180)
FloatingIcon.Font = Enum.Font.GothamBold
FloatingIcon.TextSize = 30
FloatingIcon.Visible = false
FloatingIcon.Draggable = true
Instance.new("UICorner", FloatingIcon).CornerRadius = UDim.new(1, 0)

-- Sidebar Button Generator
local function createNav(name, pos, func)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(func)
end

-- TAB BUTTON CLICKS
createNav("HOME", UDim2.new(0.05, 0, 0.25, 0), function() ShowTab(HomeTab) end)
createNav("EDITOR", UDim2.new(0.05, 0, 0.4, 0), function() ShowTab(EditorTab) end)
createNav("HUB", UDim2.new(0.05, 0, 0.55, 0), function() ShowTab(HubTab) end)
createNav("CLOSE", UDim2.new(0.05, 0, 0.85, 0), function() MainFrame.Visible = false FloatingIcon.Visible = true end)

-- BUTTON LOGIC
FloatingIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true FloatingIcon.Visible = false end)
ExecBtn.MouseButton1Click:Connect(function() loadstring(TextBox.Text)() end)

-- Initialize
ShowTab(HomeTab)

