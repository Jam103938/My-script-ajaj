local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

local Player = game:GetService("Players").LocalPlayer
local Backpack = Player:WaitForChild("Backpack")
local EquipEvent = game:GetService("ReplicatedStorage").packages.Net:WaitForChild("RE/Backpack/Equip")

local IsRunning = false

local function autoEquipRod()
    while IsRunning do
        for _, item in ipairs(Backpack:GetChildren()) do
            if item.Name:find("Rod") then
                EquipEvent:FireServer(item)
                break
            end
        end
        task.wait(0.4)
    end
end

Tabs.Main:AddToggle("AutoEquipRodToggle", {
    Title = "Auto Equip Rod",
    Default = false,
    Callback = function(state)
        IsRunning = state
        if IsRunning then
            task.spawn(autoEquipRod)
        end
    end
})

local AutoCast = false

local function autoCast()
    while AutoCast do
        local LocalCharacter = game:GetService("Players").LocalPlayer.Character
        local Tool = LocalCharacter:FindFirstChildOfClass("Tool")

        if Tool and Tool:FindFirstChild("events") and Tool.events:FindFirstChild("cast") then
            local Random = math.random(90, 99)
            Tool.events.cast:FireServer(Random)
        else
            AutoCast = false
            break
        end

        task.wait(0.4)
    end
end

Tabs.Main:AddToggle("AutoCastToggle", {
    Title = "Auto Cast",
    Default = false,
    Callback = function(state)
        AutoCast = state
        if state then
            task.spawn(autoCast)
        end
    end
})

local AutoFish = false

local function autoShake()
    while AutoFish do
        local PlayerGUI = Player:WaitForChild("PlayerGui")
        local shakeUI = PlayerGUI:FindFirstChild("shakeui")

        if shakeUI and shakeUI.Enabled then
            local safezone = shakeUI:FindFirstChild("safezone")
            if safezone then
                local button = safezone:FindFirstChild("button")

                local GuiService = game:GetService("GuiService")
                local VirtualInputManager = game:GetService("VirtualInputManager")
                GuiService.SelectedObject = button
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end

        task.wait(0.05)
    end
end

local originalAutoShake = autoShake

if hookfunction then
    autoShake = hookfunction(autoShake, function(...)
        return originalAutoShake(...)
    end)
elseif getgenv and type(getgenv) == "function" then
    getgenv().autoShake = function(...)
        return originalAutoShake(...)
    end
end

Tabs.Main:AddToggle("AutoFishToggle", {
    Title = "Auto Fish",
    Default = false,
    Callback = function(state)
        AutoFish = state
        if AutoFish then
            task.spawn(autoShake)
        end
    end
})

local AutoReel = false

local function autoReel()
    while AutoReel do
        local args = {
            [1] = 100,
            [2] = true
        }

        game:GetService("ReplicatedStorage").events.reelfinished:FireServer(unpack(args))
        task.wait(0.5)
    end
end

Tabs.Main:AddToggle("AutoReelToggle", {
    Title = "Auto Reel",
    Default = false,
    Callback = function(state)
        AutoReel = state
        if AutoReel then
            task.spawn(autoReel)
        end
    end
})
