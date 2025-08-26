--// Delta Mobile Client-Side Shared Chat

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- RemoteEvent for sharing messages
local remote = ReplicatedStorage:FindFirstChild("DeltaChatEvent") 
              or Instance.new("RemoteEvent")
remote.Name = "DeltaChatEvent"
remote.Parent = ReplicatedStorage

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaChatGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Chat frame
local chatFrame = Instance.new("Frame")
chatFrame.Size = UDim2.new(0.8, 0, 0.4, 0)
chatFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
chatFrame.BackgroundTransparency = 1
chatFrame.Parent = screenGui

-- Input box
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.6, 0, 0.1, 0)
inputBox.Position = UDim2.new(0.1, 0, 0.85, 0)
inputBox.PlaceholderText = "Type your message..."
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Font = Enum.Font.SourceSansBold
inputBox.TextScaled = true
inputBox.Parent = screenGui

-- Send button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.2, 0, 0.1, 0)
sendButton.Position = UDim2.new(0.72, 0, 0.85, 0)
sendButton.Text = "Send"
sendButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Font = Enum.Font.SourceSansBold
sendButton.TextScaled = true
sendButton.Parent = screenGui

-- Messages table
local messages = {}
local maxMessages = 5

-- Function to display a message
local function addMessage(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.15, 0)
    label.Position = UDim2.new(0, 0, #messages * 0.15, 0)
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.BackgroundTransparency = 0.5
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextScaled = true
    label.Text = text
    label.Parent = chatFrame

    table.insert(messages, label)

    if #messages > maxMessages then
        messages[1]:Destroy()
        table.remove(messages, 1)
        for i, msgLabel in ipairs(messages) do
            msgLabel.Position = UDim2.new(0, 0, (i-1)*0.15, 0)
        end
    end
end

-- Send button logic
sendButton.MouseButton1Click:Connect(function()
    if inputBox.Text ~= "" then
        local msg = Player.Name .. ": " .. inputBox.Text
        remote:FireServer(msg) -- Send to server to relay
        inputBox.Text = ""
    end
end)

-- Receive messages from RemoteEvent
remote.OnClientEvent:Connect(function(msg)
    addMessage(msg)
end)

-- Server-side relay (runs on client but works because RemoteEvent is global)
if game:GetService("RunService"):IsClient() then
    remote.OnServerEvent:Connect(function(player, msg)
        local formatted = player.Name .. ": " .. msg
        remote:FireAllClients(formatted)
    end)
end
