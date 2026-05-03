-- Zonex Executor v4.1 (Final Stable Pro Suite)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- 1. CLEANUP OLD UI
if lp.PlayerGui:FindFirstChild("ZonexMainGui") then lp.PlayerGui.ZonexMainGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
ScreenGui.Name = "ZonexMainGui"
ScreenGui.ResetOnSpawn = false

-- 2. FLOATING RE-OPEN ICON (CAREFLY INTEGRATED)
local FloatingIcon = Instance.new("TextButton", ScreenGui)
FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
FloatingIcon.Position = UDim2.new(0, 20, 0.5, 0)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
FloatingIcon.Text = "Z"; FloatingIcon.TextColor3 = Color3.fromRGB(0, 255, 180)
FloatingIcon.Font = Enum.Font.GothamBold; FloatingIcon.Visible = false
FloatingIcon.Draggable = true
Instance.new("UICorner", FloatingIcon).CornerRadius = UDim.new(1, 0)

-- 3. MAIN UI FRAME (DEEP DARK THEME)
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

-- 4. TABS SETUP
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

-- 5. EDITOR FUNCTIONALITY (FIXED)
local TextBox = Instance.new("TextBox", EditorTab)
TextBox.Size = UDim2.new(1, 0, 0, 200); TextBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TextBox.Text = "-- Paste Script Here"; TextBox.MultiLine = true; TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.Code; TextBox.ClearTextOnFocus = false; TextBox.TextXAlignment = "Left"; TextBox.TextYAlignment = "Top"
Instance.new("UICorner", TextBox)

local ExecBtn = Instance.new("TextButton", EditorTab)
ExecBtn.Size = UDim2.new(1, 0, 0, 40); ExecBtn.Position = UDim2.new(0, 0, 0, 210)
ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 180); ExecBtn.Text = "EXECUTE"; Instance.new("UICorner", ExecBtn)
ExecBtn.MouseButton1Click:Connect(function() loadstring(TextBox.Text)() end)

-- 6. TOGGLE HELPER
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

-- 6a. MAXIMUM SPEED GLIDE FARM (7 STUDS UP)
local farming = false
addToggle("Farm nearest players (Fast Glide)", function(s)
    farming = s
    task.spawn(function()
        while farming do
            pcall(function()
                local char = lp.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local target, dist = nil, math.huge
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent and v.Parent ~= char and v.Health > 0 then
                        local thp = v.Parent:FindFirstChild("HumanoidRootPart")
                        if thp and not (v.Parent.Name:find("Dummy") and v.Health >= 90) then
                            local m = (thp.Position - hrp.Position).Magnitude
                            if m < dist then dist = m; target = thp end
                        end
                    end
                end
                
                if target then
                    -- Noclip Bypass logic
                    for _,part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                    local goalPos = target.Position + Vector3.new(0, 7, 0)
                    local direction = (goalPos - hrp.Position)
                    -- Fast 5.0 step increment
                    if direction.Magnitude > 0.5 then
                        hrp.CFrame = hrp.CFrame + (direction.Unit * math.min(direction.Magnitude, 5.0))
                        hrp.CFrame = CFrame.new(hrp.Position, target.Position)
                    else
                        hrp.CFrame = CFrame.new(goalPos, target.Position)
                    end
                    hrp.Velocity = Vector3.new(0,0,0)
                end
            end)
            task.wait(0.01)
        end
    end)
end)

-- 6b. GOD MODE + ANTI-RAGDOLL (YOUR SCRIPT + FIX)
addToggle("Infinite Health (God Mode)", function(s)
    _G.InfHealth = s
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if s and hum then
        hum.Health = hum.MaxHealth
        hum:SetAttribute("CanTakeDamage", false)
        -- Prevents ragdolling/falling over when hit
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        
        task.spawn(function()
            while _G.InfHealth do
                if hum then hum.Health = hum.MaxHealth end
                task.wait()
            end
        end)
    else
        pcall(function()
            hum:SetAttribute("CanTakeDamage", true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        end)
    end
end)

-- 6c. FLY MODE (STABLE)
addToggle("Fly Mode", function(s)
    _G.Flying = s
    task.spawn(function()
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        while _G.Flying do
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                bv.Parent = lp.Character.HumanoidRootPart
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
            end
            task.wait(0.01)
        end
        bv:Destroy()
    end)
end)

-- 7. NAVIGATION
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
createNav("CLOSE", UDim2.new(0.05,0,0.85,0), function() 
    MainFrame.Visible = false; FloatingIcon.Visible = true 
end, true)

FloatingIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true; FloatingIcon.Visible = false
end)

ShowTab(HomeTab)

