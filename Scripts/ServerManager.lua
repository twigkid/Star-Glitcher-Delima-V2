-- StarterPlayer > StarterCharacterScripts

task.wait(1)

local Storage = workspace.Storage
local _root = script
local rq = require
local gm = game
local sc = script
local ws = workspace
local par = sc.Parent

local ffc = ws.FindFirstChild -- let's add these so that we can boost the framerate up by .000001%!!!!!!!
local ffcoc = ws.FindFirstChildOfClass
local wfc = ws.WaitForChild

local Players, RunService, ReplicatedStorage, ServerStorage = ffcoc(gm,"Players"), ffcoc(gm,"RunService"), ffcoc(gm,"ReplicatedStorage"), ffcoc(gm,"ServerStorage")
local LocalPlayer = Players:GetPlayerFromCharacter(par)
local Character = LocalPlayer.Character

local Heartbeat, System = RunService.Heartbeat, ReplicatedStorage.Game
local Modules, Modes, Subs, Skins = System.Modules, System.Modes, System.Modes.Sub, System.Skins
local Misc, Sound = System.Modules.Misc, System.Modules.Sound
local Wings, Welding, AnimateWings, Color, Tween, SoundEffects = rq(Modules.Wings.Wings), rq(Modules.Welding.Welding), rq(Modules.Wings.Animate), rq(Modules.Wings.Color), rq(Misc.Tweening), rq(Sound.Sound)

local CreateWeld, CreateMotor = Welding.CreateWeld, Welding.CreateMotor
local Animate, CustomiseColor = AnimateWings.AnimateWings, Color.CustomiseColor
local CreateWings, normalTween, TweenCustomiseColor = Wings.CreateWings, Tween.normalTween, Color.TweenCustomiseColor
local Debounce = false

local function GetPart(Parent:Instance, Part:string)
	local FoundPart = ffc(Parent,Part, true)
	return FoundPart
end	

local function Configure(Part: BasePart)
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CanQuery = false
	Part.Locked = true
end


local LeftArm, RightArm, LeftLeg, RightLeg, Torso, Head, RootPart = GetPart(Character, "Left Arm"), GetPart(Character, "Right Arm"), GetPart(Character, "Left Leg"), GetPart(Character, "Right Leg"), GetPart(Character, "Torso"), GetPart(Character, "Head"), GetPart(Character, "HumanoidRootPart")
local Humanoid = ffcoc(Character,"Humanoid")

local Events = _root.Events
local Vars = _root.Vars
local sp = task.spawn
local cs = ColorSequence.new
local tw = task.wait
local st = string
local rq = require
local v3 = Vector3.new
local ud2 = UDim2.new
local c3 = Color3.new
local kc = Enum.KeyCode
local fn = Enum.Font
local ws = workspace
local prs = pairs
local rgb = Color3.fromRGB
local csk = ColorSequenceKeypoint.new
local hst = Enum.HumanoidStateType
local cf, angles, rad, rand, clamp, sin = CFrame.new, CFrame.Angles, math.rad, math.random, math.clamp, math.sin
local ins = Instance.new
local EasingStyle = Enum.EasingStyle
local EasingDirection = Enum.EasingDirection
local style, dir = EasingStyle, EasingDirection
local find, split, sub = st.find, st.split, st.sub
local vmode, vsong, vartist = Vars.Mode, Vars.Song, Vars.Artist

local CurrentModule = nil
local MWalkSpeed, MRunSpeed = 0, 0
local Sprint = false

local _Root_Storage = ins("Folder", Storage)
local WingsStorage = ins("Folder", _Root_Storage)

WingsStorage.Name = "WingStorage"
_Root_Storage.Name = LocalPlayer.Name
Character.Parent = ws.Players

local cast_Plane = ins("Part", _Root_Storage)
cast_Plane.Size = v3(0, 0, 0)
cast_Plane.Anchored = true
cast_Plane.Transparency = 1
cast_Plane.Name = "cast_Plane"
cast_Plane.CanCollide = false cast_Plane.CanTouch = false cast_Plane.CanQuery = false

local billBoard = ins("BillboardGui", Torso)
billBoard.LightInfluence = 0
billBoard.Brightness = 2

local text = ins("TextLabel", billBoard)
text.Size = ud2(1, 0, 1, 0)
text.BackgroundTransparency = 1
text.TextScaled = true
text.Font = fn.Arcade
text.RichText=true
text.TextTransparency=1
text.TextStrokeTransparency = 1
text.TextColor3=c3(1, 1, 1)

local grad = ins("UIGradient", text)
grad.Rotation = 90
grad.Color = cs({csk(0, rgb(161, 161, 161)), csk(.5, c3(1, 1, 1)), csk(1, rgb(161, 161, 161))})

local SprintVal = ins("BoolValue", _Root_Storage)
SprintVal.Name = "Sprint"

local cur_mod = ins("ObjectValue", _Root_Storage)
cur_mod.Name = "cur_mod"

local Theme = ins("Sound", RootPart)
Theme.Volume = .75
Theme.Looped = true
Theme.Name = "Theme"
Theme.Playing = true

local ground_attachment = ins("Attachment", RootPart)
ground_attachment.Name = "ground"

local LegacyEffects = ReplicatedStorage.Game.LegacyEffects

local SwitchVF = LegacyEffects.Switch.Switch:Clone()
SwitchVF.Parent = Torso

local ExplodeVF = LegacyEffects.Explode.Explosion:Clone()
ExplodeVF.Parent = Torso

local Smoke = LegacyEffects.Smoke.Smoke:Clone()
Smoke.Parent = ground_attachment

local Beam = LegacyEffects.Particles.Beam:Clone()
Beam.Parent = cast_Plane

local Dust = LegacyEffects.Particles.Dust:Clone()
Dust.Parent = cast_Plane

local Slash = LegacyEffects.Slash:Clone()
Slash.Slash.Parent = cast_Plane

local Fire = LegacyEffects.Fire:Clone()
Fire.Fire.Parent = cast_Plane

local Mouse = {
	KeyDown = Events.KeyDown.OnServerEvent,
	KeyUp = Events.KeyUp.OnServerEvent,
}

local UserInputService = {
	InputBegan = Events.InputBegan.OnServerEvent,
	InputEnded = Events.InputEnded.OnServerEvent,
}

Configure(cast_Plane) 

normalTween(billBoard, style.Sine, dir.Out, 1, {StudsOffset = v3(0,5,0), Size = ud2(23.5, 0, 4, 0)})
normalTween(text, style.Sine, dir.In, 1, {TextTransparency = 0, TextStrokeTransparency = 0})

Humanoid.MaxHealth = 10000
Humanoid.Health = 10000

local function Switch(Table, Table2, Module, Module2)
	if Module ~= CurrentModule then
		local save = Module2
		CurrentModule = Module2
		
		cur_mod.Value = Module
		Vars.Mode_M.Value = Module
		
		local Name = Table.Name
		
		local MainColor1, MainColor2 = Table.Color1, Table.Color2		
		local WalkSpeed, RunSpeed = Table2.WalkSpeed, Table2.RunSpeed
		
		Vars.WalkSpeed.Value = WalkSpeed
		Vars.RunSpeed.Value = RunSpeed
		
		MWalkSpeed, MRunSpeed = WalkSpeed, RunSpeed
		
		if not Sprint then
			normalTween(Humanoid, EasingStyle.Linear, EasingDirection.In, .45, {WalkSpeed = WalkSpeed})
		else
			normalTween(Humanoid, EasingStyle.Linear, EasingDirection.In, .5, {WalkSpeed = RunSpeed})
		end
		
		Vars.f1.Value = MainColor1
		
		normalTween(Vars.Color1, EasingStyle.Sine, EasingDirection.In, .5, {Value = MainColor1})
		normalTween(Vars.Color2, EasingStyle.Sine, EasingDirection.In, .5, {Value = MainColor2})
		
		Theme.SoundId = Table.SoundID
		
		local SName = Table.SongName
		local RName = split(SName, "//")
		
		Vars.Lyric.Value = ReplicatedStorage.Game.Lyrics.None
		
		if Table.Lyric then
			Vars.Lyric.Value = Table.Lyric
		end
		
		SwitchVF.a.Color = cs(MainColor1)
		SwitchVF.b.Color = cs(MainColor2)
		SwitchVF.c.Color = cs(MainColor1)
		
		SoundEffects.NewSoundEffect(847061203, 1, .95 + rand(-1, 1) / 10, true, Torso)
		
		Humanoid.UseJumpPower = true
		Humanoid.JumpPower = Table2.JumpPower
		
		for i, v in prs(SwitchVF:GetChildren()) do
			if v:IsA("ParticleEmitter") then
				v:Emit(15)
			end
		end
		
		text.Font = Table.TextFont
		
		Theme.SoundId = "rbxassetid://"..Table.SoundID
		Theme.TimePosition = Table.StartTime
		Theme:Play()

		vsong.Value = " "
		vartist.Value = " "
		vmode.Value = " "
		
		sp(function()
			if RName[1] then
				for i = 1, #RName[1] do
					tw()
					vsong.Value = sub(RName[1], 1, i)
					if CurrentModule ~= save then
						break
					end
				end
			else
				warn("Song name is missing.")
			end
		end)
		sp(function()
			if RName[2] then
				for i = 1, #RName[2] do
					tw()
					vartist.Value = sub(RName[2], 1, i)
					if CurrentModule ~= save then
						break
					end
				end
			else
				warn("Artist is missing.")
			end
		end)
		sp(function()
			for i = 1, #Name do
				tw(.025)
				text.Text = sub(Name, 1, i)
				if CurrentModule ~= save then
					break
				end
			end
		end)
		sp(function()
			for i = 1, #Name do
				tw()
				vmode.Value = sub(Name, 1, i)
				if CurrentModule ~= save then
					break
				end
			end
		end)
		
		
		Debounce = true
		Vars.Lyrics.Value = false
		Events.StopAllLyrics:FireClient(LocalPlayer)
		
		tw(.2)
		
		Debounce = false
		Vars.Lyrics.Value = true
		
		Table, Module = nil, nil
		MainColor1, MainColor2 = nil, nil
		WalkSpeed, RunService = nil, nil
	end
end
-- THE skin equipper of all time 🤑
-- real 🐟
local Mode_Table = Modes.Main:GetChildren()
local Sub_Table = Subs:GetChildren()
local main = Mouse.KeyDown:Connect(function(Player, Key)
	if Player == LocalPlayer then
		local Input = Key:lower()
		
		for _, obj: Folder in prs(Player.Skins.Main:GetDescendants()) do
			if obj:IsA("Folder") then
				local MainMod = rq(obj.ModeModule.Value)
				if MainMod.Key:lower() == Key:lower() and CurrentModule ~= obj.ModeModule.Value and not Debounce then
					Switch(rq(obj.SkinModule.Value), MainMod, obj.SkinModule.Value, obj.ModeModule.Value)
					break
				end
			end
		end
		
		for _, obj: Folder in prs(Player.Skins.Sub:GetDescendants()) do
			if obj:IsA("Folder") then
				local MainMod = rq(obj.ModeModule.Value)
				if MainMod.Key:lower() == Key:lower() and MainMod.ParentMode == CurrentModule and not Debounce then
					Switch(rq(obj.SkinModule.Value), MainMod, obj.SkinModule.Value, obj.ModeModule.Value)
					break
				end
			end
		end
	else
		Player:Kick()
	end
end)

UserInputService.InputBegan:Connect(function(Player, Input)
	if Player == LocalPlayer then
		if Input == kc.LeftShift then
			Sprint = true
			SprintVal.Value = true
			normalTween(Humanoid, EasingStyle.Linear, EasingDirection.In, 2, {WalkSpeed = MRunSpeed})
		end
	else
		Player:Kick()
	end
end)

UserInputService.InputEnded:Connect(function(Player, Input)
	if Player == LocalPlayer then
		if Input == kc.LeftShift then
			Sprint = false
			SprintVal.Value = false
			normalTween(Humanoid, EasingStyle.Linear, EasingDirection.In, .4, {WalkSpeed = MWalkSpeed})
		end
	else
		Player:Kick()
	end
end)

for i, v in prs(Character:GetDescendants()) do
	if v:IsA("BasePart") then
		Configure(v)
	end
end

local LastAttacked = 0
local lasthealth = Humanoid.Health

Humanoid.HealthChanged:Connect(function()
	if Humanoid.Health < lasthealth then
		lasthealth = Humanoid.Health
		LastAttacked=0
	end
end)

sp(function()
	while true do
		tw(.1)
		LastAttacked = LastAttacked + .1
		if LastAttacked > 5.5 then
			if Humanoid.Health < Humanoid.MaxHealth then
				Humanoid.Health = Humanoid.Health + rand(10, 23)
			end
		end
	end
end)

Humanoid.Died:Once(function()
	if RootPart:IsDescendantOf(ws) then
		RootPart:SetNetworkOwner(LocalPlayer)
	end
	
	tw(.15)
	
	main:Disconnect()
	main = nil
	
	rq(Misc.Ragdoll).Ragdoll(Character)
	
	Humanoid.CameraOffset = v3(0,0,0)
	
	_Root_Storage:Destroy()
	_Root_Storage=nil
end)


Humanoid:SetStateEnabled(hst.Ragdoll, false)
Humanoid:SetStateEnabled(hst.Physics, false)
Humanoid:SetStateEnabled(hst.PlatformStanding, false)

Humanoid.BreakJointsOnDeath = false

tw(1.51)

Switch(rq(wfc(LocalPlayer,"Skins", 9e9).Main:WaitForChild("DESCENT").SkinModule.Value), rq(Modes.Main.Descent), wfc(LocalPlayer,"Skins", 9e9).Main:WaitForChild("DESCENT").SkinModule.Value, Modes.Main.Descent)

Vars.Parent = Character
