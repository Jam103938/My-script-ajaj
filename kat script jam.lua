local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Kat Script", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Section = Tab:AddSection({
	Name = "Main script"
})

local aimbotEnabled = false
local wallCheckEnabled = false
local aimAtPart = "HumanoidRootPart"
local teamCheckEnabled = false
local headSizeEnabled = false

-- Functions
local function getClosestTarget()
    local Cam = workspace.CurrentCamera
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local localRoot = character:WaitForChild("HumanoidRootPart")
    local nearestTarget = nil
    local shortestDistance = math.huge

    local function checkTarget(target)
        if target and target:IsA("Model") and target:FindFirstChild("Humanoid") and target:FindFirstChild(aimAtPart) then
            local targetRoot = target[aimAtPart]
            local distance = (targetRoot.Position - localRoot.Position).Magnitude

            if distance < shortestDistance then
                if wallCheckEnabled then
                    local rayDirection = (targetRoot.Position - Cam.CFrame.Position).Unit * 1000
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                    local raycastResult = workspace:Raycast(Cam.CFrame.Position, rayDirection, raycastParams)

                    if raycastResult and raycastResult.Instance:IsDescendantOf(target) then
                        shortestDistance = distance
                        nearestTarget = target
                    end
                else
                    shortestDistance = distance
                    nearestTarget = target
                end
            end
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and (not teamCheckEnabled or player.Team ~= localPlayer.Team) then
            checkTarget(player.Character)
        end
    end

    if targetNPCs then
        for _, npc in pairs(workspace:GetDescendants()) do
            checkTarget(npc)
        end
    end

    return nearestTarget
end

local function lookAt(targetPosition)
    local Cam = workspace.CurrentCamera
    if targetPosition then
        Cam.CFrame = CFrame.new(Cam.CFrame.Position, targetPosition)
    end
end

local function aimAtTarget()
    local runService = game:GetService("RunService")
    local connection
    connection = runService.RenderStepped:Connect(function()
        if not aimbotEnabled then
            connection:Disconnect()
            return
        end

        local closestTarget = getClosestTarget()
        if closestTarget and closestTarget:FindFirstChild(aimAtPart) then
            local targetRoot = closestTarget[aimAtPart]

            while aimbotEnabled and closestTarget and closestTarget:FindFirstChild(aimAtPart) and closestTarget.Humanoid.Health > 0 do
                lookAt(targetRoot.Position)
                local rayDirection = (targetRoot.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {character}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                local raycastResult = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, rayDirection, raycastParams)

                if not raycastResult or not raycastResult.Instance:IsDescendantOf(closestTarget) then
                    break
                end

                runService.RenderStepped:Wait()
            end
        end
    end)
end

local function resizeHeads()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer

    local function resizeHead(model)
        local head = model:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            head.Size = Vector3.new(10, 10, 10)
            head.CanCollide = false
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            resizeHead(player.Character)
        end
    end

    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Head") then
            resizeHead(npc)
        end
    end
end


Tab:AddButton({
	Name = "Button!",
	Callback = function()
    local Camera = game:GetService("Workspace").CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = game:GetService("Players").LocalPlayer

local function GetClosestPlayer()
   local ClosestPlayer = nil
   local FarthestDistance = math.huge

   for i, v in pairs(Players.GetPlayers(Players)) do
       if v ~= LocalPlayer and v.Character and v.Character.FindFirstChild(v.Character, "HumanoidRootPart") then
           local DistanceFromPlayer = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude

           if DistanceFromPlayer < FarthestDistance then
               FarthestDistance = DistanceFromPlayer
               ClosestPlayer = v
           end
       end
   end

   if ClosestPlayer then
       return ClosestPlayer
   end
end

local GameMetaTable = getrawmetatable(game)
local OldGameMetaTableNamecall = GameMetaTable.__namecall
setreadonly(GameMetaTable, false)

GameMetaTable.__namecall = newcclosure(function(object, ...)
   local NamecallMethod = getnamecallmethod()
   local Arguments = {...}

   if tostring(NamecallMethod) == "FindPartOnRayWithIgnoreList" then
       local ClosestPlayer = GetClosestPlayer()
       
       if ClosestPlayer and ClosestPlayer.Character then
           Arguments[1] = Ray.new(Camera.CFrame.Position, (ClosestPlayer.Character.Head.Position - Camera.CFrame.Position).Unit * (Camera.CFrame.Position - ClosestPlayer.Character.Head.Position).Magnitude)
       end
   end

   return OldGameMetaTableNamecall(object, unpack(Arguments))
end)

setreadonly(GameMetaTable, true)
end)
end    
})


Tab:AddButton({
	Name = "Button!",
	Callback = function()
   aimbotEnabled = Value
		if aimbotEnabled then
			aimAtTarget()
			end
		end    
})


Tab:AddButton({
	Name = "Button!",
	Callback = function()
   wallCheckEnabled = Value
end    
})



Tab:AddButton({
	Name = "Button!",
	Callback = function()
    getgenv().Walkspeed = value
    pcall(function()
        game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = value
    end)
end    
})




Tab:AddButton({
	Name = "Button!",
	Callback = function()
    getgenv().loopW = state
    game:GetService("RunService").Heartbeat:Connect(function()
        if loopW == true then
            pcall(function()
                game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = Walkspeed
            end)
        end
    end)
end    
})

Tab:AddButton({
	Name = "Button!",
	Callback = function()
	_G.HeadSize = value
_G.Disabled = true
 
game:GetService('RunService').RenderStepped:connect(function()
if _G.Disabled then
for i,v in next, game:GetService('Players'):GetPlayers() do
if v.Name ~= game:GetService('Players').LocalPlayer.Name then
pcall(function()
v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
v.Character.HumanoidRootPart.Transparency = 0.7
v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
v.Character.HumanoidRootPart.Material = "Neon"
v.Character.HumanoidRootPart.CanCollide = false
end)
end
end
end
end)
end    
})




local Tab = Window:MakeTab({
	Name = "Tab 1",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "esp"
})


getgenv().esp = false
getgenv().teamcheck = false
getgenv().Color = Color3.fromRGB(255, 0, 0)

Tab:AddButton({
	Name = "Button!",
	Callback = function()
getgenv().esp = Value
		spawn(function()
		while wait() do
		    if not getgenv().esp then
		          for i,v in pairs(game.Players:GetChildren()) do
		              if v.Character and v.Character:FindFirstChild("Highlight") then
		                  local Highlight = v.Character:FindFirstChild("Highlight")
		                  Highlight.Enabled = false
    		      end
		      end 
		      else
		          for i,v in pairs(game.Players:GetChildren()) do
		             if getgenv().teamcheck == true then
		               if v.Character and v ~= game.Players.LocalPlayer and v.TeamColor ~= game.Players.LocalPlayer.TeamColor then
    		                 if v.Character:FindFirstChild("Highlight") then
    		                 local Highlight = v.Character:FindFirstChild("Highlight") 
    		                 Highlight.Enabled = true
    		                 Highlight.FillColor = getgenv().Color
    		                 Highlight.Adornee = v.Character
    		                 else
    		                 local Highlight = Instance.new("Highlight",v.Character)
    		                 Highlight.Enabled = true
    		                 Highlight.FillColor = getgenv().Color
    		                 Highlight.Adornee = v.Character
    		              end       
    		           end  
		                if v.TeamColor == game.Players.LocalPlayer.TeamColor then
    		              if v.Character and v.Character:FindFirstChild("Highlight") then
    		                  local Highlight = v.Character:FindFirstChild("Highlight")
        		              Highlight.Enabled = false
        		          end    
    		            end 
    		          else
    		              if v.Character and v ~= game.Players.LocalPlayer then
    		                 if v.Character:FindFirstChild("Highlight") then
    		                 local Highlight = v.Character:FindFirstChild("Highlight") 
    		                 Highlight.Enabled = true
    		                 Highlight.FillColor = getgenv().Color
    		                 Highlight.Adornee = v.Character
    		                 else
    		                 local Highlight = Instance.new("Highlight",v.Character)
    		                 Highlight.Enabled = true
    		                 Highlight.FillColor = getgenv().Color
    		                 Highlight.Adornee = v.Character
    		              end       
    		           end    
		            end       
		      end    
		    end  
		end    
		end)
		end    
})

local Tab = Window:MakeTab({
	Name = "Gun",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Gun mod"
})

local g_mod = false
Tab:AddButton({
	Name = "Button!",
	Callback = function(bool)
  g_mod = bool
end)

while wait(1) do
	if g_mod == true then
		for i, v in next, getgc(true) do
			if type(v) == "table" then
				if rawget(v, "LoadedAmmo") then
					v.LoadedAmmo = 10000000000
					v.RecoilFactor = 0
					v.Spread = 0
				end
				if rawget(v, "ReloadTime") then
					v.ReloadTime = 0
					v.EquipTime = 0
					v.LoadCapacity = 10000000000
				end
			end
		end
	end
end
end    
})