-- Delta Script-Sided Chat (Client-only)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Shared table for everyone running the script
if not _G.DeltaChatShared then
    _G.DeltaChatShared = {}
end
local sharedMessages = _G.DeltaChatShared

-- Messages displayed locally
local messages = {}
local maxMessages = 5

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaChatGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local chatFrame = Instance.new("Frame")
chatFrame.Size = UDim2.new(0.8, 0, 0.4, 0)
chatFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
chatFrame.BackgroundTransparency = 1
chatFrame.Parent = screenGui

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.6,0,0.1,0)
inputBox.Position = UDim2.new(0.1,0,0.85,0)
inputBox.PlaceholderText = "Type your message..."
inputBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
inputBox.TextColor3 = Color3.fromRGB(255,255,255)
inputBox.Font = Enum.Font.SourceSansBold
inputBox.TextScaled = true
inputBox.Parent = screenGui

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.2,0,0.1,0)
sendButton.Position = UDim2.new(0.72,0,0.85,0)
sendButton.Text = "Send"
sendButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
sendButton.TextColor3 = Color3.fromRGB(255,255,255)
sendButton.Font = Enum.Font.SourceSansBold
sendButton.TextScaled = true
sendButton.Parent = screenGui

-- Function to display a message locally
local function addMessage(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0.15,0)
    label.Position = UDim2.new(0,0,#messages*0.15,0)
    label.BackgroundColor3 = Color3.fromRGB(0,0,0)
    label.BackgroundTransparency = 0.5
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.SourceSans
    label.TextScaled = true
    label.Text = text
    label.Parent = chatFrame

    table.insert(messages,label)

    if #messages > maxMessages then
        messages[1]:Destroy()
        table.remove(messages,1)
        for i,label in ipairs(messages) do
            label.Position = UDim2.new(0,0,(i-1)*0.15,0)
        end
    end
end

-- Send button logic
sendButton.MouseButton1Click:Connect(function()
    if inputBox.Text ~= "" then
        local msg = Player.Name .. ": " .. inputBox.Text
        table.insert(sharedMessages,{text = msg})
        inputBox.Text = ""
    end
end)

-- Update chat from shared table
game:GetService("RunService").RenderStepped:Connect(function()
    for _, msg in ipairs(sharedMessages) do
        if not msg._displayed then
            addMessage(msg.text)
            msg._displayed = true
        end
    end
end)
