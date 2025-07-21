repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local CraftingService = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("CraftingGlobalObjectService")

local jay = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua", true))()

local CraftingTable = ReplicatedStorage.Modules.UpdateService.DinoEvent:WaitForChild("DinoCraftingTable")
local Workbench = "DinoEventWorkbench"

if getgenv().Egg ~= "Dinosaur Egg" and getgenv().Egg ~= "Primal Egg" then
	jay:Notify({
		Title = "⚠️ Invalid Egg",
		Content = "getgenv().Egg must be 'Dinosaur Egg' or 'Primal Egg'",
		Duration = 5
	})
	return
end

CraftingService:FireServer("SetRecipe", CraftingTable, Workbench, getgenv().Egg)
task.wait(0.25)

local eggUUID
for _, tool in ipairs(Backpack:GetChildren()) do
	if tool:IsA("Tool") then
		if getgenv().Egg == "Dinosaur Egg" and tool:GetAttribute("h") == "Common Egg" then
			eggUUID = tool:GetAttribute("c")
			break
		elseif getgenv().Egg == "Primal Egg" and tool:GetAttribute("h") == "Dinosaur Egg" then
			eggUUID = tool:GetAttribute("c")
			break
		end
	end
end

if not eggUUID then
	jay:Notify({
		Title = "⚠️ Missing Item",
		Content = getgenv().Egg == "Dinosaur Egg" and "Common Egg not found" or "Dinosaur Egg not found",
		Duration = 5
	})
	return
end

local blossomUUID
for _, tool in ipairs(Backpack:GetChildren()) do
	if tool:IsA("Tool") and tool:GetAttribute("f") == "Bone Blossom" then
		blossomUUID = tool:GetAttribute("c")
		break
	end
end

if not blossomUUID then
	jay:Notify({
		Title = "⚠️ Missing Item",
		Content = "Bone Blossom not found",
		Duration = 5
	})
	return
end

CraftingService:FireServer("InputItem", CraftingTable, Workbench, 1, {
	ItemType = "PetEgg",
	ItemData = { UUID = eggUUID }
})
task.wait(0.2)

CraftingService:FireServer("InputItem", CraftingTable, Workbench, 2, {
	ItemType = "Holdable",
	ItemData = { UUID = blossomUUID }
})
task.wait(0.2)

CraftingService:FireServer("Craft", CraftingTable, Workbench)

jay:Notify({
	Title = "Jay Devs - Auto Craft",
	Content = "Successfully crafted " .. getgenv().Egg,
	Duration = 4
})
task.wait(1)

jay:Notify({
	Title = "Rejoining",
	Content = "Rejoining current server...",
	Duration = 3
})

local eggValue = getgenv().Egg
local queueScript = 'getgenv().Egg = "' .. eggValue .. '"\n' ..'loadstring(game:HttpGet("https://raw.githubusercontent.com/Jay-Devss/Jay-Hub/refs/heads/main/primal-vulnv3.lua"))()'
if queue_on_teleport then
	queue_on_teleport(queueScript)
elseif syn and syn.queue_on_teleport then
	syn.queue_on_teleport(queueScript)
end

TeleportService:Teleport(game.PlaceId)
