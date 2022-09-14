--eternal#1337 billy es gay wey
repeat task.wait() until game:IsLoaded();


if setfflag then setfflag("OutlineSelection", "true") end


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CoreGui = game:GetService("CoreGui");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local Lighting = game:GetService("Lighting");
local VirtualInputManager = game:GetService("VirtualInputManager");


local Events = ReplicatedStorage:WaitForChild("Events", 1337)


local Player = Players.LocalPlayer;


local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/UILibs/FluxusUI.lua"))()


local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/SimpleHighlightESP.lua"))()


local Window = lib:CreateWindow("Eternal's evade GUI")


local CharPage = Window:NewTab("Player")
local ServerPage = Window:NewTab("Server")
local ESPPage = Window:NewTab("ESP/Camera")


local MainSection = CharPage:AddSection("Character")
local ServerSection = ServerPage:AddSection("Server")
local ESPSection = ESPPage:AddSection("ESP")
local CamSection = ESPPage:AddSection("Camera")


local Highlights_Active = false;
local AI_ESP = false;
local GodMode_Enabled = false;
local No_CamShake = false;


for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do v:Disable() end


function Simple_Create(base, name, trackername, studs)
    local bb = Instance.new('BillboardGui', game.CoreGui)
    bb.Adornee = base
    bb.ExtentsOffset = Vector3.new(0,1,0)
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0,6,0,6)
    bb.StudsOffset = Vector3.new(0,1,0)
    bb.Name = trackername

    local frame = Instance.new('Frame', bb)
    frame.ZIndex = 10
    frame.BackgroundTransparency = 0.3
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

    local txtlbl = Instance.new('TextLabel', bb)
    txtlbl.ZIndex = 10
    txtlbl.BackgroundTransparency = 1
    txtlbl.Position = UDim2.new(0,0,0,-48)
    txtlbl.Size = UDim2.new(1,0,10,0)
    txtlbl.Font = 'ArialBold'
    txtlbl.FontSize = 'Size12'
    txtlbl.Text = name
    txtlbl.TextStrokeTransparency = 0.5
    txtlbl.TextColor3 = Color3.fromRGB(255, 0, 0)

    local txtlblstud = Instance.new('TextLabel', bb)
    txtlblstud.ZIndex = 10
    txtlblstud.BackgroundTransparency = 1
    txtlblstud.Position = UDim2.new(0,0,0,-35)
    txtlblstud.Size = UDim2.new(1,0,10,0)
    txtlblstud.Font = 'ArialBold'
    txtlblstud.FontSize = 'Size12'
    txtlblstud.Text = tostring(studs) .. " Studs"
    txtlblstud.TextStrokeTransparency = 0.5
    txtlblstud.TextColor3 = Color3.new(255,255,255)
end


function ClearESP(espname)
    for _,v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == espname and v:isA('BillboardGui') then
            v:Destroy()
        end
    end
end


MainSection:AddButton("God Mode", "Gives you god mode", function()
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Hum = Character:WaitForChild("Humanoid")
    Hum.Parent = nil;
    Hum.Parent = Character;
end)

MainSection:AddButton("Infinite jump", "Makes you able to jump mid air", function()
    local InfiniteJumpEnabled = true
game:GetService("UserInputService").JumpRequest:connect(function()
	if InfiniteJumpEnabled then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)
end)

MainSection:AddToggle("Loop God Mode", "Keeps god mode on", false, function(bool)
    GodMode_Enabled = bool;

    if bool then 
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Hum = Character:WaitForChild("Humanoid")
        Hum.Parent = nil;
        Hum.Parent = Char;
    end
end)


MainSection:AddButton("Respawn", "Free respawn, no need to pay 15 robux!", function()
    local Reset = Events:FindFirstChild("Reset")
    local Respawn = Events:FindFirstChild("Respawn")

    if Reset and Respawn then
        Reset:FireServer();
        task.wait(2)
        Respawn:FireServer();
    end
end)


MainSection:AddButton("Full Bright", "For users who are scared of the dark :(", function()

    local Light = game:GetService("Lighting")
    
    function dofullbright()
    Light.Ambient = Color3.new(1, 1, 1)
    Light.ColorShift_Bottom = Color3.new(1, 1, 1)
    Light.ColorShift_Top = Color3.new(1, 1, 1)
    end
    
    dofullbright()
    
    Light.LightingChanged:Connect(dofullbright)
end)


ESPSection:AddButton("Player Chams", "Makes other players visible through walls.", function()
    ESP:ClearESP();
    Highlights_Active = true;

    for i, v in ipairs(Players:GetPlayers()) do
        if v ~= Player then
            v.CharacterAdded:Connect(function(Char)
                ESP:AddOutline(Char)
                ESP:AddNameTag(Char)
            end)

            if v.Character then
                ESP:AddOutline(v.Character)
                ESP:AddNameTag(v.Character)
            end
        end
    end
end)


ESPSection:AddToggle("AI ESP", "Adds text ESP to AI to make them easier to see.", false, function(bool)
    AI_ESP = bool;
end)


CamSection:AddToggle("No Camera Shake", "Removes camera shake that is caused by the AI.", false, function(bool)
    No_CamShake = bool;
end)



game:GetService("Players").PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Char)
        if Highlights_Active then
            ESP:AddOutline(Char)
            ESP:AddNameTag(Char)
        end
    end)
end)


Player.CharacterAdded:Connect(function(Char)
    local Hum = Char:WaitForChild("Humanoid", 1337);

    
    if GodMode_Enabled then
        Hum.Parent = nil;
        Hum.Parent = Char;
    end
end)



task.spawn(function()
    while task.wait(0.05) do
        if AI_ESP then
            pcall(function()
                ClearESP("AI_Tracker")
                local GamePlayers = Workspace:WaitForChild("Game", 1337).Players;
                for i,v in pairs(GamePlayers:GetChildren()) do
                    if not game.Players:FindFirstChild(v.Name) then -- Is AI
                        local studs = Player:DistanceFromCharacter(v.PrimaryPart.Position)
                        Simple_Create(v.HumanoidRootPart, v.Name, "AI_Tracker", math.floor(studs + 0.5))
                    end
                end
            end)
        else
            ClearESP("AI_Tracker");
        end
    end
end)


task.spawn(function()
    while task.wait() do
        if No_CamShake then
            Player.PlayerScripts:WaitForChild("CameraShake", 1234).Value = CFrame.new(0,0,0) * CFrame.Angles(0,0,0);
        end
    end
end)
