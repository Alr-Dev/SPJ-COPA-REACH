-- Services
local Workspace = game:GetService('Workspace')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local StarterPlayer = game:GetService('StarterPlayer')
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts
local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')

-- Configuration Folder
local Config = Workspace:WaitForChild("Configuration") -- Ensure the Configuration folder exists

-- Function to Bypass Anti-Cheat and Destroy Exploits
local function bypassAntiCheat()
    if packs.Anti_cheat and packs.WalkSpeed and packs.HopperbinExploit and 
       packs.HumanoidExploit and packs.ServerRemote and packs.RemoteEventExploit and 
       packs.ClientScript then

        print('Bypass Anti-Cheat by SPJ team')

        -- Destroy Exploits and Remotes
        packs.ServerRemote:Destroy()
        print('Destroyed ServerRemote')

        packs.WalkSpeed:Destroy()
        print('Destroyed WalkSpeed')

        packs.HopperbinExploit:Destroy()
        print('Destroyed HopperbinExploit')

        packs.Anti_cheat:Destroy()
        print('Destroyed Anti-Cheat')

        packs.Flying:Destroy()
        print('Destroyed Flying')

        packs.RemoteEventExploit:Destroy()
        print('Destroyed RemoteEventExploit')

        packs.HumanoidExploit:Destroy()
        print('Destroyed HumanoidExploit')

        --**Important:** Do NOT destroy the ClientScript if it's responsible for the UI
        packs.ClientScript:Destroy()
        print('Destroyed ClientScript')
    else
        warn("One or more required packs are missing.")
    end
end


-- Packs Table
local packs = {
    ['Anti_cheat'] = Config:FindFirstChild("AntiExploit"),
    -- Remotes
    ['WalkSpeed'] = ReplicatedStorage:FindFirstChild("Walkspeed"),
    ['HopperbinExploit'] = ReplicatedStorage:FindFirstChild("HopperbinExploit"),
    ['HumanoidExploit'] = ReplicatedStorage:FindFirstChild("HumanoidExploit"),
    ['ServerRemote'] = ReplicatedStorage:FindFirstChild("ServerRemote"),
    ['RemoteEventExploit'] = ReplicatedStorage:FindFirstChild("RemoteEventExploit"),
    ['Flying'] = ReplicatedStorage:FindFirstChild("Flying"),
    -- LocalScript
    ['ClientScript'] = StarterPlayerScripts:FindFirstChild("ClientScript")
}

-- Function to Initialize the UI
local function initializeUI(player)
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdjustLegGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Create Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 250)
    frame.Position = UDim2.new(0.5, -150, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- Helper Function to Create Labels
    local function createLabel(text, position)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 280, 0, 30)
        label.Position = UDim2.new(0, 10, 0, position)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.SourceSans
        label.TextSize = 18
        label.Parent = frame
        return label
    end

    -- Helper Function to Create TextBoxes
    local function createTextBox(placeholder, position)
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0, 260, 0, 30)
        textBox.Position = UDim2.new(0, 10, 0, position)
        textBox.PlaceholderText = placeholder
        textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        textBox.Text = ""
        textBox.ClearTextOnFocus = true
        textBox.Parent = frame
        return textBox
    end

    -- Helper Function to Create Buttons
    local function createButton(text, position)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 280, 0, 30)
        button.Position = UDim2.new(0, 10, 0, position)
        button.Text = text
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.SourceSans
        button.TextSize = 18
        button.Parent = frame
        return button
    end

    -- Create UI Elements
    createLabel("Right Leg Size:", 10)
    local sizeInput = createTextBox("Enter size", 40)

    createLabel("Right Leg Width:", 80)
    local widthInput = createTextBox("Enter width", 110)

    createLabel("Leg Transparency:", 150)
    local transparencyInput = createTextBox("Enter transparency", 180)
    transparencyInput.BackgroundTransparency = 0.5

    local applyButton = createButton("Apply", 220)

    -- Initialize frame visibility
    frame.Visible = true

    -- Function to Update the Right Leg
    local function updateLegSize()
        local character = player.Character or player.CharacterAdded:Wait()
        local rightLeg = character:FindFirstChild("Right Leg") or 
                         character:FindFirstChild("RightLowerLeg") or 
                         character:FindFirstChild("RightFoot")

        if rightLeg then
            local size = tonumber(sizeInput.Text)
            local width = tonumber(widthInput.Text)
            local transparency = tonumber(transparencyInput.Text)

            -- Validate Inputs
            if size and width then
                size = math.clamp(size, 1, MAX_SIZE)
                width = math.clamp(width, 1, MAX_WIDTH)

                -- Update Leg Size
                rightLeg.Size = Vector3.new(size, rightLeg.Size.Y, width)
            else
                warn("Invalid size or width value.")
            end

            -- Update Leg Transparency
            if TR_Enabled then
                if transparency then
                    transparency = math.clamp(transparency, 0, MAX_TRANSPARENCY)
                    rightLeg.Transparency = transparency
                else
                    warn("Invalid transparency value.")
                end
            end
        else
            warn("Right Leg not found in character.")
        end
    end

    -- Function to Toggle GUI Visibility
    local function toggleGuiVisibility()
        frame.Visible = not frame.Visible
    end

    -- Connect Apply Button
    applyButton.MouseButton1Click:Connect(updateLegSize)

    -- Key Press Detection for Toggling GUI (e.g., Press 'Z' to toggle)
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.Z then
            toggleGuiVisibility()
        end
    end)
end

-- Function to Handle Player Added
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        initializeUI(player)
    end)
    -- If character already exists
    if player.Character then
        initializeUI(player)
    end
end

-- Connect Existing Players
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Connect Future Players
Players.PlayerAdded:Connect(onPlayerAdded)
