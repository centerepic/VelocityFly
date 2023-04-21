local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local VelocityFly = {}

function VelocityFly:CFrameToOrientation(cf)
	local x, y, z = cf:ToOrientation()
	return Vector3.new(math.deg(x), math.deg(y), math.deg(z))
end

VelocityFly.Speed = 5
VelocityFly.Enabled = false
VelocityFly.TargetCFrame = CFrame.new(0,0,0)
VelocityFly.HeartbeatConnection = nil

function VelocityFly:Toggle(State)
    self.Enabled = State
    if State == true then
        VelocityFly.TargetCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        LocalPlayer.Character.Humanoid.PlatformStand = true
    else
        VelocityFly.HeartbeatConnection:Disconnect()
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

VelocityFly.HeartbeatConnection = RunService.Heartbeat:Connect(function()
    if VelocityFly.Enabled == true then
        local MovementInputDetected = false

        for _, KeyObject in pairs(UserInputService:GetKeysPressed()) do
            if KeyObject.KeyCode == Enum.KeyCode.W then
                MovementInputDetected = true
                VelocityFly.TargetCFrame = VelocityFly.TargetCFrame + Camera.CFrame.LookVector.Unit
            end
            if KeyObject.KeyCode == Enum.KeyCode.D then
                MovementInputDetected = true
                VelocityFly.TargetCFrame = VelocityFly.TargetCFrame + Camera.CFrame.LookVector:Cross(Vector3.new(0, 1, 0)).Unit
            end
            if KeyObject.KeyCode == Enum.KeyCode.A then
                MovementInputDetected = true
                VelocityFly.TargetCFrame = VelocityFly.TargetCFrame + Camera.CFrame.LookVector:Cross(Vector3.new(0, -1, 0)).Unit
            end
            if KeyObject.KeyCode == Enum.KeyCode.S then
                MovementInputDetected = true
                VelocityFly.TargetCFrame = VelocityFly.TargetCFrame + (Camera.CFrame.LookVector.Unit * - 1)
            end
        end

        if not MovementInputDetected then
            VelocityFly.TargetCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 1.3 * (workspace.Gravity / 196.1999969482422), 0)
        end

        LocalPlayer.Character.HumanoidRootPart.Velocity = VelocityFly.TargetCFrame.Position - LocalPlayer.Character.HumanoidRootPart.Position
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.p) * Camera.CFrame.Rotation
    end
end)

return VelocityFly