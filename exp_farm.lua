if getgenv().jaydevs then
    return
end
getgenv().jaydevs = true

local jay = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua", true))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = jay:CreateWindow({
    Title = "Jay Hub | " .. game:GetService("MarketplaceService"):GetProductInfo(126884695634066).Name,
    SubTitle = "by Jay Devs",
    TabWidth = 150,
    Size = UDim2.fromOffset(480, 320),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.Insert
})

local ClickButton = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UICorner_2 = Instance.new("UICorner")

ClickButton.Name = "ClickButton"
ClickButton.Parent = game.CoreGui
ClickButton.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ClickButton
MainFrame.AnchorPoint = Vector2.new(1, 0)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(1, -60, 0, 10)
MainFrame.Size = UDim2.new(0, 45, 0, 45)

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

UICorner_2.CornerRadius = UDim.new(0, 10)
UICorner_2.Parent = ImageLabel

ImageLabel.Parent = MainFrame
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.BackgroundColor3 = Color3.new(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel.Size = UDim2.new(0, 45, 0, 45)
ImageLabel.Image = "rbxassetid://132940723895184"

TextButton.Parent = MainFrame
TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
TextButton.BackgroundTransparency = 1
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0, 0, 0, 0)
TextButton.Size = UDim2.new(0, 45, 0, 45)
TextButton.AutoButtonColor = false
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = ""
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.TextSize = 20

TextButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Insert", false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "Insert", false, game)
end)

local info_tab = Window:AddTab({ Title = "Info", Icon = "info" })
local main_tab = Window:AddTab({ Title = "Main", Icon = "home" })
Window:SelectTab(1)

info_tab:AddParagraph({
    Title = "Welcome",
    Content = "Welcome to Jay Hub! \nBasic Need of a Scripter!"
})

getgenv().mimic_id = nil
getgenv().dilo_id = nil
getgenv().target_id = nil
getgenv().auto_exp = false

local function get_pet_uuid()
    local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        return tool:GetAttribute("PET_UUID")
    end
    return nil
end

main_tab:AddButton({
    Title = "Get Mimic ID",
    Description = "Hold the Mimic.",
    Callback = function()
        local uuid = get_pet_uuid()
        if uuid then
            getgenv().mimic_id = uuid
            print("Mimic UUID saved:", uuid)
        else
            warn("No Mimic PET_UUID found.")
        end
    end
})

main_tab:AddButton({
    Title = "Get Dilo ID",
    Description = "Hold the Dilo.",
    Callback = function()
        local uuid = get_pet_uuid()
        if uuid then
            getgenv().dilo_id = uuid
            print("Dilo UUID saved:", uuid)
        else
            warn("No Dilo PET_UUID found.")
        end
    end
})

main_tab:AddButton({
    Title = "Get Target Pet ID",
    Description = "Hold the Target Pet.",
    Callback = function()
        local uuid = get_pet_uuid()
        if uuid then
            getgenv().target_id = uuid
            print("Target Pet UUID saved:", uuid)
        else
            warn("No Target Pet PET_UUID found.")
        end
    end
})

main_tab:AddToggle("autoExpFarm", {
    Title = "Auto EXP Farm",
    Default = false,
    Callback = function(state)
        getgenv().auto_exp = state

        if not state then return end

        spawn(function()
            while getgenv().auto_exp do
                local mimic = getgenv().mimic_id
                local dilo = getgenv().dilo_id
                local target = getgenv().target_id

                if not (mimic and dilo and target) then
                    warn("Missing one or more UUIDs.")
                    break
                end

                game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("EquipPet", mimic, CFrame.new(42.7972, 0, -79.8887))

                game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("EquipPet", dilo, CFrame.new(42.7972, 0, -79.8887))

                wait(1)

                while getgenv().auto_exp do
                    local cd_data = game:GetService("ReplicatedStorage").GameEvents.GetPetCooldown:InvokeServer(mimic)
                    local mimic_cd = cd_data[1].Time

                    if mimic_cd == 0 then
                        wait(1)

                        game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("UnequipPet", dilo)

                        game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("EquipPet", target, CFrame.new(42.7972, 0, -79.8887))

                        repeat
                            wait(0.5)
                            local cd_check = game:GetService("ReplicatedStorage").GameEvents.GetPetCooldown:InvokeServer(mimic)
                            mimic_cd = cd_check[1].Time
                        until mimic_cd == 15 or not getgenv().auto_exp

                        game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("UnequipPet", target)

                        game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("EquipPet", dilo, CFrame.new(42.7972, 0, -79.8887))
                    end

                    wait(0.5)
                end
            end
        end)
    end
})
