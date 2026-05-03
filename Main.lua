-- Zonex Executor v4.1 (Clean God Mode + High-Speed Suite)
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- CLEANUP
if lp.PlayerGui:FindFirstChild("ZonexMainGui") then lp.PlayerGui.ZonexMainGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
ScreenGui.Name = "ZonexMainGui"
ScreenGui.ResetOnSpawn = false

-- FLOATING ICON
local FloatingIcon = Instance.new("TextButton", ScreenGui)
FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
FloatingIcon.Position = UDim2.new(0, 20, 0.5, 0)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
FloatingIcon.Text = "Z"; FloatingIcon.TextColor3 = Color3.fromRGB(0, 255, 180)
FloatingIcon.Font = Enum.Font.GothamBold; FloatingIcon.Visible = false
FloatingIcon.Draggable = true; Instance.new("UICorner", FloatingIcon).CornerRadius = UDim.new(1, 0)

-- MAIN UI
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
Sidebar.Size = UDim2.new(0, 120, 1, 0); Instance.new("UICorner", Sidebar)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 50); Logo.Text = "ZONEX"
Logo.TextColor3 = Color3.fromRGB(0, 255, 180); Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 26; Logo.BackgroundTransparency = 1

-- TABS Setup
local HomeTab = Instance.new("Frame", MainFrame)
local EditorTab = Instance.new("Frame", MainFrame)
local BloxTab = Instance.new("ScrollingFrame", MainFrame)

local function SetupTab(tab)
    tab.Size = UDim2.new(1, -140, 1, -20); tab.Position = UDim2.new(0, 130, 0, 10)
    tab.BackgroundTransparency = 1; tab.Visible = false
    if tab:IsA("ScrollingFrame") then
        tab.CanvasSize = UDim2.new(0,0,2,0)
        Instance.new("UIListLayout", tab).Padding = UDim.new(0,5)
    end
end
SetupTab(HomeTab); SetupTab(EditorTab); SetupTab(BloxTab)

local function ShowTab(t)
    HomeTab.Visible = false; EditorTab.Visible = false; BloxTab.Visible = false
    t.Visible = true
end

-- EDITOR (Fixed)
local TextBox = Instance.new("TextBox", EditorTab)
TextBox.Size = UDim2.new(1, 0, 0, 200); TextBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TextBox.Text = "-- Paste Script Here"; TextBox.MultiLine = true; TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.Code; TextBox.ClearTextOnFocus = false; TextBox.TextXAlignment = "Left"; TextBox.TextYAlignment = "Top"
Instance.new("UICorner", TextBox)

local ExecBtn = Instance.new("TextButton", EditorTab)
ExecBtn.Size = UDim2.new(1, 0, 0, 40); ExecBtn.Position = UDim2.new(0, 0, 0, 210)
ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 180); ExecBtn.Text = "EXECUTE"; Instance.new("UICorner", ExecBtn)
ExecBtn.MouseButton1Click:Connect(function() loadstring(TextBox.Text)() end)

-- TOGGLE HELPER
local function addToggle(name, callback)
    local btn = Instance.new("TextButton", BloxTab)
    btn.Size = UDim2.new(1, 0, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = name .. ": OFF"
    btn.Font = Enum.Font.Gotham; Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 180) or Color3.fromRGB(255, 255, 255)
        callback(state)
    end)
end

-- 1. FARM (7 STUDS)
local farming = false
addToggle("Safe Farm (7 Studs Above)", function(s)
    farming = s
    task.spawn(function()
        while farming do
            pcall(function()
                local target, dist = nil, math.huge
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent and v.Parent ~= lp.Character and v.Health > 0 then
                        local hrp = v.Parent:FindFirstChild("HumanoidRootPart")
                        if hrp and not (v.Parent.Name:find("Dummy") and v.Health >= 90) then
                            local m = (hrp.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                            if m < dist then dist = m; target = hrp end
                        end
                    end
                end
                if target then
                    lp.Character.HumanoidRootPart.CFrame = CFrame.new(target.Position + Vector3.new(0, 7, 0), target.Position)
                    lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                end
            end)
            task.wait(0.03)
        end
    end)
end)

-- 2. IMPROVED GOD MODE (REMOVED STUCK PART)
local UserInput = Instance.new("TextBox", BloxTab)
UserInput.Size = UDim2.new(1, 0, 0, 30); UserInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
UserInput.PlaceholderText = "Username (Empty = You)"; UserInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", UserInput)

addToggle("Infinite Health (Target)", function(s)
    _G.GodState = s
    local targetName = UserInput.Text
    local targetPlayer = (targetName == "" and lp) or Players:FindFirstChild(targetName)
    
    if targetPlayer and targetPlayer.Character then
        local hum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Removed PlatformStand = true to prevent getting stuck
            hum:SetAttribute("CanTakeDamage", not s)
            
            task.spawn(function()
                while _G.GodState do
                    if hum then 
                        hum.Health = hum.MaxHealth 
                        -- Prevents "died" state even if server lags
                        if hum.Health <= 0 then hum.Health = 1 end 
                    end
                    task.wait()
                end
            end)
        end
    end
end)

-- 3. FLY
addToggle("Fly Mode", function(s)
    _G.Flying = s
    task.spawn(function()
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        while _G.Flying do
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                bv.Parent = lp.Character.HumanoidRootPart
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 80
            end
            task.wait(0.01)
        end
        bv:Destroy()
    end)
end)

-- NAV
local function createNav(n, p, f, isClose)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = p
    b.BackgroundColor3 = isClose and Color3.fromRGB(15, 15, 20) or Color3.fromRGB(20, 20, 25)
    b.Text = n; b.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(f)
end

createNav("HOME", UDim2.new(0.05,0,0.2,0), function() ShowTab(HomeTab) end)
createNav("EDITOR", UDim2.new(0.05,0,0.35,0), function() ShowTab(EditorTab) end)
createNav("BLOX FRUITS", UDim2.new(0.05,0,0.5,0), function() ShowTab(BloxTab) end)
createNav("CLOSE", UDim2.new(0.05,0,0.85,0), function() MainFrame.Visible = false; FloatingIcon.Visible = true end, true)

FloatingIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true; FloatingIcon.Visible = false
end)

ShowTab(HomeTab)
