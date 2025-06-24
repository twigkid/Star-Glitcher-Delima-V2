-- > ServerScriptService

local Players = game:FindFirstChildOfClass("Players")
local ReplicatedStorage = game:FindFirstChildOfClass("ReplicatedStorage")
local DatastoreService = game:GetService("DataStoreService")
local HttpService = game:FindFirstChildOfClass("HttpService")
local ChatService = game:FindFirstChildOfClass("Chat")
local System = ReplicatedStorage.Game
local Chat = System.Chat
local prs = pairs
local ws = workspace
local find = string.find
local split = string.split
local sc = script
local Settings = sc.Settings
local Skins = sc.Skins
local SkinsFolder = ReplicatedStorage.Game.Skins
local rq = require

local ffc = ws.FindFirstChild
local wfc = ws.WaitForChild
local ffcoc = ws.FindFirstChildOfClass

local Datastore = DatastoreService:GetDataStore("Skins")
local Whitelist = {"AlgodooUser123", "ShadeChip", "441312v", "INSULT_BALL", "ChippyB0i"}

local function SaveSkins(Player: Player, SkinsN: Folder)
	local CurrentSkins = {}

	for _, skin in prs(SkinsN.Main:GetChildren()) do
		if skin:IsA("Folder") then
			local SkinModule = skin.SkinModule

			table.insert(CurrentSkins, {Main=skin.Name, Skin=SkinModule.Value.Name, Sub=false})
		end
	end

	local Encoded = HttpService:JSONEncode({CurrentSkins})
	Datastore:SetAsync(Player.UserId.."_skins", CurrentSkins)
end

local function GetPlayer(Name: string)
	for _, v in prs(Players:GetChildren()) do
		if v.Name:lower() == Name:lower() then
			return v
		end
	end
end

local function getInstanceFromPath(path)
	local currentInstance = game
	for part in string.gmatch(path, "[^%.]+") do
		currentInstance = ffc(currentInstance,part)
		if not currentInstance then
			return nil
		end
	end
	return currentInstance
end

local function setPropertyFromCommand(command)
	local instancePath, propertyName, valueString = command:match("set:%s*(.-)%s*,%s*(.-)%s*,%s*(.+)")

	if not instancePath or not propertyName or not valueString then
		return
	end

	local success, value = pcall(function() return loadstring("return " .. valueString)() end)
	if not success then
		return
	end

	local instance = getInstanceFromPath(instancePath)
	if instance and instance[propertyName] ~= nil then
		instance[propertyName] = value
	end
end
Chat.SendMessage.OnServerEvent:Connect(function(Player: Player, Message: string)
	local FilteredMessage = ChatService:FilterStringForBroadcast(Message, Player)
	if Message ~= "" and not find(Message, "kick:") and not find(Message, "mp:") and not find(Message, "lo") and not find(Message, "set:") then
		Chat.SendMessage:FireAllClients({Player, FilteredMessage})
	elseif find(Message, "kick:") then
		local Event = ReplicatedStorage.Moderation.Remotes.Event
		local Name = split(Message, ",")[2]

		for _, v in prs(Whitelist) do
			if Player.Name == v then
				local ExpectedPlayer = GetPlayer(Name)
				if ExpectedPlayer ~= nil then
					Event:FireClient(ExpectedPlayer, Message) Chat.SendMessage:FireClient(Player, {"System", "Kicked: "..ExpectedPlayer.Name.." For: "..Message})
					
					ExpectedPlayer.Character:Destroy()	
					
					if ffc(ws.Storage,Player.Name) then
						ws.Storage[Player.Name]:Destroy()
					end	
				else
					Chat.SendMessage:FireClient(Player, {"System", "Player "..Name.." doesn't  exist."})
				end
			end
		end
	elseif find(Message, "mp:") then
		for _, v in prs(Whitelist) do
			if Player.Name == v or (game.PrivateServerId ~= "" and game.PrivateServerOwnerId ~= 0) then
				local mod = split(Message, "mp:")[2]
				local model = System.Models:FindFirstChild(mod)
				if model and model.ClassName == "Model" then
					local model = System.Models[mod]
					for _, x in prs(Player.Character:GetChildren()) do
						if x:IsA("Accessory") or x:IsA("BodyColors") or x:IsA("Shirt") or x:IsA("Pants") then
							x:Destroy()
						end
					end
					
					for _, x in prs(model:GetChildren()) do
						if x:IsA("Accessory") or x:IsA("BodyColors") or x:IsA("Shirt") or x:IsA("Pants") then
							x:Clone().Parent = Player.Character
						end
					end
					
					Player.Character.Head.face:Destroy()
					Player.Character.Head:FindFirstChildOfClass("SpecialMesh"):Destroy()
					model.Head:FindFirstChildOfClass("SpecialMesh"):Clone().Parent = Player.Character.Head
				else
					Chat.SendMessage:FireClient(Player, {"System", "Cannot find '"..mod.."' in RPS Game > Models"})
				end
				break
			end
		end
	elseif find(Message, "lo:") then
		local msg="\n"
		local Parent = ffc(System,split(Message, "lo:")[2])
		
		for i, v in prs(Parent:GetChildren()) do
			if v:IsA("Instance") then
				msg = msg..v.Name.."\n"
			end
		end
		
		Chat.SendMessage:FireClient(Player, {"System", msg})
	elseif find(Message, "set:") then
		for _, v in prs(Whitelist) do
			if v == Player.Name then
				setPropertyFromCommand(Message)
				break
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(Player: Player)
	local loaded = {}
	local s, m = pcall(function()
		loaded = Datastore:GetAsync(Player.UserId.."_skins")
	end)
	
	if not s then
		warn("skin load failed for: "..Player.Name)
		local Encoded = HttpService:JSONEncode({})
		Datastore:SetAsync(Player.UserId.."_skins", {})
		loaded = {}
	end
	
	local SkinTable = {}
	if loaded then
		SkinTable = loaded
	end
	
	local CharacterAdded = Player.CharacterAdded:Connect(function(Model: Model)
		local Humanoid = wfc(Model,"Humanoid", 9e9)
		
		Humanoid.Died:Once(function()
			for i, v in prs(Model:GetDescendants()) do
				if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" and v:IsDescendantOf(ws) then
					v:SetNetworkOwner(nil)
				end
			end
		end)
	end)
	
	local SettingsN = Settings:Clone()
	SettingsN.Parent = Player
	SettingsN.LastSave.Value = tick()
	local SkinsN = Skins:Clone()
	SkinsN.Parent = Player
	
	
	
	local MainExample, SubExample = SkinsN.Main.Example_Modename, SkinsN.Sub.Example_Modename
	
	for _, v in prs(ReplicatedStorage.Game.Modes.Main:GetChildren()) do
		if v:IsA("ModuleScript") then
			local Mode = rq(v)
			local NewFolder = MainExample:Clone()
			NewFolder.Name = Mode.Name
			NewFolder.SkinModule.Value = v
			NewFolder.Parent = SkinsN.Main
			NewFolder.SkinModule.Value=v
			NewFolder.ModeModule.Value=v
			
			-- Skins
			
			if loaded then
				for _, x in prs(loaded) do
					local Main, Skin, Sub = x.Main, x.Skin, x.Sub
					if Sub == false then
						if Main:lower() == Mode.Name:lower() then
							for _, b in prs(System.Skins.Main:GetChildren()) do
								if b.Name:lower() == Skin:lower() then
									NewFolder.SkinModule.Value = b
									break
								end
							end

						end
					end
				end
			end
		end
	end
	
	for _, v in prs(ReplicatedStorage.Game.Modes.Sub:GetChildren()) do
		if v:IsA("ModuleScript") then
			local Mode = rq(v)
			local NewFolder = SubExample:Clone()
			NewFolder.Name = Mode.Name
			NewFolder.SkinModule.Value = v
			NewFolder.Parent = SkinsN.Sub
			NewFolder.SkinModule.Value=v
			NewFolder.ModeModule.Value=v
		end
	end
	
	MainExample:Destroy()
	SubExample:Destroy()
	
	Players.PlayerRemoving:Once(function(Plr: Player)
		if Plr == Player then
			SkinsN.Parent = ws
			
			 local CurrentSkins = {}
			 
			 for _, skin in prs(SkinsN.Main:GetChildren()) do
				if skin:IsA("Folder") then
					local SkinModule = skin.SkinModule
					
					table.insert(CurrentSkins, {Main=skin.Name, Skin=SkinModule.Value.Name, Sub=false})
				end
			 end

			 local Encoded = HttpService:JSONEncode({CurrentSkins})
			 Datastore:SetAsync(Player.UserId.."_skins", CurrentSkins)
			
			if ffc(ws.Storage,Player.Name) then
				ws.Storage[Player.Name]:Destroy()
			end	

			CharacterAdded:Disconnect()
			CharacterAdded = nil
			
			
			SkinsN:Destroy()
			SkinsN=nil
		end
	end)
end)

SkinsFolder.Events.SetSkin.OnServerEvent:Connect(function(Player, NewModule)
	if typeof(NewModule) == "Instance" then
		for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
			if v == NewModule then
				local mod = rq(NewModule)
				for _, v:Instance in prs(Player.Skins.Main:GetChildren()) do
					if mod.ParentMode then
						if v:IsA("Folder") and v.Name:lower() == mod.ParentMode.Name:lower() then
							v.SkinModule.Value = NewModule
						end
					else
						if v:IsA("Folder") and NewModule.Name:lower() == v.Name:lower() then
							v.SkinModule.Value = NewModule
						end
					end
				end
				break
			end
		end
	end
end)

ReplicatedStorage.Saving.Events.SaveSkins.OnServerEvent:Connect(function(Player: Player)
	local LastSave = Player.Settings.LastSave
	if LastSave.Value - tick() > 60 then -- 2:00
		SaveSkins(Player, wfc(Player,"Skins"))
	end
end)
