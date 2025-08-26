-- Delta BABFT Teleport-to-End Script (Client-Side Only)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Detect your boat (assumes your boat has a PrimaryPart set)
local boat = workspace:FindFirstChild(Player.Name.."Boat") or Character:WaitForChild("HumanoidRootPart")

-- Find the end part
local finish = workspace:FindFirstChild("Finish") -- or adjust path to the final stage part
if not finish then
    warn("Finish part not found! Make sure the script points to the correct final stage.")
    return
end

-- Teleport loop
local speed = 2 -- adjust speed (higher = faster teleport)
RunService.RenderStepped:Connect(function()
    if boat and finish then
        local currentCFrame = boat.CFrame
        local targetCFrame = finish.CFrame + Vector3.new(0,5,0) -- slightly above finish
        boat.CFrame = currentCFrame:Lerp(targetCFrame, 0.1 * speed)
    end
end)
