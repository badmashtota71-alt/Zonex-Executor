-- Zonex Executor v4.1 (Fully Restored & Fixed)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Sidebar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FloatingIcon = Instance.new("TextButton")

-- Tabs
local HomeTab = Instance.new("Frame")
local EditorTab = Instance.new("Frame")
local HubTab = Instance.new("ScrollingFrame")
local BloxTab = Instance.new("ScrollingFrame")

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

-- FUNCTION TO SWITCH TABS
local function ShowTab(tabToShow)
    HomeTab.Visible = false
    EditorTab.Visible = false
    HubTab.Visible = false
    BloxTab.Visible = false
    tabToShow.Visible = true
end

-- Setup Tab Containers
local tabs = {HomeTab, EditorTab, HubTab, BloxTab}
for _, tab in pairs(tabs) do
    tab.Parent = MainFrame
    tab.Size = UDim2.new(1, -140, 1, -20)
    tab.Position = UDim2.new(0, 130, 0, 10)
    tab.BackgroundTransparency = 1
    tab.Visible = false
    if tab:IsA("ScrollingFrame") then
        tab.CanvasSize = UDim2.new(0,0,2,0)
        tab.ScrollBarThickness = 2
        local layout = Instance.new("UIListLayout", tab)
        layout.Padding = UDim.new(0,5)
    end
end

-- Home Tab
local WelcomeText = Instance.new("TextLabel", HomeTab)
WelcomeText.Size = UDim2.new(1,0,1,0)
WelcomeText.Text = "ZONEX v4.1\n\nStatus: Keyless\nSelect a tab to begin."
WelcomeText.TextColor3 = Color3.fromRGB(200, 200, 200)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Font = Enum.Font.Gotham

-- Editor Tab
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
ExecBtn.MouseButton1Click:Connect(function() loadstring(TextBox.Text)() end)

-- Hub Tab Content
local function addHubScript(name, code)
    local btn = Instance.new("TextButton", HubTab)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() loadstring(game:HttpGet(code))() end)
end
addHubScript("Infinite Yield", "https://githubusercontent.com")

-- Blox Fruits Tab Logic
local function addToggle(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. ": OFF"
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        btn.TextColor3 = enabled and Color3.fromRGB(0, 255, 180) or Color3.fromRGB(255, 255, 255)
        callback(enabled)
    end)
end

local farming = false
addToggle("Farm npc and players (8 Studs Above)", BloxTab, function(state)
    farming = state
    task.spawn(function()
        while farming do
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local targetPos, dist = nil, math.huge
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent and v.Parent ~= char then
                        local hrp = v.Parent:FindFirstChild("HumanoidRootPart")
                        if hrp and v.Health > 0 then
                            local h = math.floor(v.Health)
                            if not (string.find(v.Parent.Name, "Dummy") and (h == 90 or h == 91 or h == 92)) then
                                local m = (hrp.Position - char.HumanoidRootPart.Position).Magnitude
                                if m < dist then dist = m targetPos = hrp.Position end
                            end
                        end
                    end
                end
                if targetPos then char.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 8, 0)) end
            end
            task.wait(0.03)
        end
    end)
end)

-- Sidebar Navigation
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

createNav("HOME", UDim2.new(0.05, 0, 0.2, 0), function() ShowTab(HomeTab) end)
createNav("EDITOR", UDim2.new(0.05, 0, 0.35, 0), function() ShowTab(EditorTab) end)
createNav("HUB", UDim2.new(0.05, 0, 0.5, 0), function() ShowTab(HubTab) end)
createNav("BLOX FRUITS", UDim2.new(0.05, 0, 0.65, 0), function() ShowTab(BloxTab) end)
createNav("CLOSE", UDim2.new(0.05, 0, 0.85, 0), function() MainFrame.Visible = false FloatingIcon.Visible = true end)

-- Floating Icon
FloatingIcon.Parent = ScreenGui
FloatingIcon.Position = UDim2.new(0, 20, 0.5, 0)
FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
FloatingIcon.Text = "Z"
FloatingIcon.TextColor3 = Color3.fromRGB(0, 255, 180)
FloatingIcon.Font = Enum.Font.GothamBold
FloatingIcon.Visible = false
Instance.new("UICorner", FloatingIcon).CornerRadius = UDim.new(1, 0)
FloatingIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true FloatingIcon.Visible = false end)

ShowTab(HomeTab)

