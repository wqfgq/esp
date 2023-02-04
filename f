-- { Services } --
local playerService = game:GetService("Players")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local httpService = game:GetService("HttpService")
local networkClient = game:GetService("NetworkClient")
local virtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local lib = loadstring(game:HttpGet"https://raw.githubusercontent.com/killjoyelite67/Prim-Ui-lib/main/uilibPrim.lua")()
local loadConfig;
local saveConfig; local fps;

-- { Client Variables } --

local client = {}
    client.player = playerService.LocalPlayer
    client.fakeLagReady = true
    client.mouse = client.player:GetMouse()
        client.getCharacter = function()
            return client.player.Character or client.player.Character.CharacterAdded:Wait()
        end
        client.isFullyLoaded = function(table)
            local checks = {"Head","HumanoidRootPart","UpperTorso"}
            if table ~= nil then for i,v in pairs(table) do table.insert(checks, v) end end
            for i,v in pairs(checks) do
                if not client.getCharacter():FindFirstChild(v) then
                     return false
                end
            end
            return true
        end

-- { Game Variables } --

local players = workspace.Players

-- { Local Variables / Functions } --

local keybinds = {}; local velpred = 1009

local sessionSettings = {
   
    ["uiaccent"] = {218, 154, 169},
    ["watermark"] = {255,255,255},
    ["watermark2"] = false,
    ["watermarkpos"] = {},
    ["watermarktext"] = "none",
    ["ambiance"] = {0,0,0},
    ["outsideambiance"] = {187, 187, 187},
    ["brightness"] = 100,

}


local watermarkui = Instance.new("ScreenGui")
local watermarkback = Instance.new("Frame")
local watermarkback2 = Instance.new("Frame")
local watermarkLabel = Instance.new("TextLabel")
local watermarkLine = Instance.new("ImageLabel")

watermarkui.Name = " "
watermarkui.Parent = game.CoreGui
watermarkui.ResetOnSpawn = false
watermarkui.Enabled = false

watermarkback.Name = "watermarkback"
watermarkback.Parent = watermarkui
watermarkback.BackgroundColor3 = Color3.fromRGB(27, 22, 20)
watermarkback.BorderSizePixel = 0
watermarkback.Size = UDim2.new(0, 190, 0, 28)
watermarkback.BackgroundTransparency = 1
local uiCorner = Instance.new("UICorner",watermarkback); uiCorner.CornerRadius = UDim.new(0,6)
watermarkback:GetPropertyChangedSignal("Position"):Connect(function()
    sessionSettings["watermarkpos"] = {watermarkback.Position.X.Scale, watermarkback.Position.X.Offset, watermarkback.Position.Y.Scale, watermarkback.Position.Y.Offset}
end); watermarkback.Position = UDim2.new(1, -245, 0, -28)

watermarkback2.Name = "watermarkback2"
watermarkback2.Parent = watermarkback
watermarkback2.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
watermarkback2.BorderSizePixel = 0
watermarkback2.Position = UDim2.new(0, 1, 0, 1)
watermarkback2.Size = UDim2.new(1, -2, 1, -2)
watermarkback2.BackgroundTransparency = 1
local uiCorner = Instance.new("UICorner",watermarkback2); uiCorner.CornerRadius = UDim.new(0,6)

watermarkLabel.Name = "watermarkLabel"
watermarkLabel.Parent = watermarkback2
watermarkLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
watermarkLabel.BackgroundTransparency = 1.000
watermarkLabel.Position = UDim2.new(0, 0, 0, 2)
watermarkLabel.Size = UDim2.new(1, 0, 0, 20)
watermarkLabel.Font = Enum.Font.Arial
watermarkLabel.Text = ""
watermarkLabel.TextColor3 = Color3.fromRGB(218, 218, 218)
watermarkLabel.TextSize = 14.000
watermarkLabel.TextStrokeColor3 = Color3.fromRGB(14, 14, 14)
watermarkLabel.TextStrokeTransparency = 0.220

watermarkLine.Name = "watermarkLine"
watermarkLine.Parent = watermarkLabel
watermarkLine.BackgroundColor3 = Color3.fromRGB(172, 159, 162)
watermarkLine.BackgroundTransparency = 1.000
watermarkLine.BorderSizePixel = 0
watermarkLine.Position = UDim2.new(0.5, -64, 1, 0)
watermarkLine.Size = UDim2.new(0, 128, 0, 2)
watermarkLine.Image = "http://www.roblox.com/asset/?id=8753817226"
watermarkLine.ImageColor3 = Color3.fromRGB(218, 154, 169)

local dragging2
local dragInput2
local dragStart2
local startPos2

local function update2(input)
	local delta = input.Position - dragStart2
	watermarkback.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
    sessionSettings["watermarkpos"] = {watermarkback.Position.X.Scale, watermarkback.Position.X.Offset, watermarkback.Position.Y.Scale, watermarkback.Position.Y.Offset}
end

watermarkback.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging2 = true
		dragStart2 = input.Position
		startPos2 = watermarkback.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging2 = false
			end
		end)
	end
end)

watermarkback.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput2 = input
	end
end)

userInputService.InputChanged:Connect(function(input)
	if input == dragInput2 and dragging2 then
		update2(input)
	end
end)

coroutine.wrap(function()
    local TimeFunction = runService:IsRunning() and time or os.clock

    local LastIteration, Start
    local FrameUpdateTable = {}
    
    local function HeartbeatUpdate()
        LastIteration = TimeFunction()
        for Index = #FrameUpdateTable, 1, -1 do
            FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
        end
    
        FrameUpdateTable[1] = LastIteration
        fps = tostring(math.floor(TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start)))
    end
    
    Start = TimeFunction()
    runService.Heartbeat:Connect(HeartbeatUpdate)
end)()
