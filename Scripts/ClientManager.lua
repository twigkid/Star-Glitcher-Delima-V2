-- StarterPlayer > StarterCharacterScripts > ServerManager.lua

task.wait(0.1)

 g = game
 ws = workspace
 sc = script
 tw=task.wait

 ffc = ws.FindFirstChild -- let's add these so that we can boost the framerate up by .000001%!!!!!!!
 ffcoc = ws.FindFirstChildOfClass
 wfc = ws.WaitForChild

function GetPart(Parent:Instance, Part:string)
	local FoundPart = ffc(Parent,Part, true)
	return FoundPart
end	

function GetJoint(Parent:Instance, Part:Motor6D)
	local FoundPart = ffc(Parent,Part, true)
	return FoundPart
end	

 function Disconnect(Connection: RBXScriptConnection)
	Connection:Disconnect()
end

 function Configure(Part: BasePart)
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CanQuery = false
	Part.Locked = true
end

function countLines(str)
	local lines = 0
	for _ in str:gmatch("\n") do
		lines = lines + 1
	end
	return lines + 1
end

tw(.05)

local rq = require
local Player = ffcoc(g,"Players").LocalPlayer
local Character = Player.Character
local Mouse = Player:GetMouse()

local RunService = ffcoc(g,"RunService")
local ReplicatedStorage = ffcoc(g,"ReplicatedStorage")
local userInput = ffcoc(g,"UserInputService")
local ts = ffcoc(g,"TweenService")

local Heartbeat, System = RunService.Heartbeat, ReplicatedStorage.Game
local Misc = System.Modules.Misc
local Modules, Modes, Skins = System.Modules, System.Modes, System.Skins
local Wings, Welding, AnimateWings, Color, Tween = rq(Modules.Wings.Wings), rq(Modules.Welding.Welding), rq(Modules.Wings.Animate), rq(Modules.Wings.Color), rq(Misc.Tweening)

local CreateWeld, CreateMotor = Welding.CreateWeld, Welding.CreateMotor
local Animate, CustomiseColor, SetWingEnabled, SetWingCount = AnimateWings.AnimateWings, Color.CustomiseColor, Color.SetWingEnabled, Color.SetWingCount
local CreateWings, normalTween, TweenCustomiseColor = Wings.CreateWings, Tween.normalTween, Color.TweenCustomiseColor
local RemoveWings = Wings.RemoveWings
local Text = rq(Misc.Text)

 Humanoid = ffcoc(Character,"Humanoid")

 LeftArm, RightArm, LeftLeg, RightLeg, Torso, Head, RootPart = GetPart(Character, "Left Arm"), GetPart(Character, "Right Arm"), GetPart(Character, "Left Leg"), GetPart(Character, "Right Leg"), GetPart(Character, "Torso"), GetPart(Character, "Head"), GetPart(Character, "HumanoidRootPart")
 LeftShoulder, RightShoulder, LeftHip, RightHip, Neck, RootJoint = GetJoint(Torso, "LeftShoulder"), GetJoint(Torso, "RightShoulder"), GetJoint(Torso, "LeftHip"), GetJoint(Torso, "RightHip"), GetJoint(Torso, "Neck"), GetJoint(Humanoid.RootPart, "RootJoint")
 Camera = ws.CurrentCamera

 PlayerGui = Player.PlayerGui
 AuthToken = ""
 _root = sc.Parent
 Events = _root.Events
 s = false

 Ly=0
 CurrentTable = {}
 cf = CFrame.new
 v3 = Vector3.new
 clk = os.clock
 sin = math.sin
 clamp = math.clamp
 Style = Enum.EasingStyle
 Dir = Enum.EasingDirection
 pls = g.Players
 tc = tick
 cs = ColorSequence.new
 vars = _root.Vars
 hsv=Color3.fromHSV
 prs = pairs
 ns, nsk = NumberSequence.new, NumberSequenceKeypoint.new
 rgb = Color3.fromRGB
 sp = task.spawn
 tw = task.wait
 rand = math.random
 ud2 = UDim2.new
 dir, style = Enum.EasingDirection, Enum.EasingStyle
 info = TweenInfo.new
 ins = Instance.new
 gm = game
 rq = require
 st = string
 floor = math.floor
 ceil = math.ceil
 Sounds = script.Sounds
 kc = Enum.KeyCode
 c3 = Color3.new
 cf_0 = cf(0,0,0)
 Lerp = cf_0.Lerp
 Lerp_P = v3(0,0,0).Lerp
 out, ein = dir.Out, dir.In
 sine = clk()
 esine = style.Sine
 linear = Style.Linear
 elastic = Style.Elastic
 globcon = {}
 inse = table.insert
 clr = table.clear
 tickspeed=3.5

 a=Mouse.KeyDown:Connect(function(Key)
	Events.KeyDown:FireServer(Key)
end)

 b=Mouse.KeyUp:Connect(function(Key)
	Events.KeyUp:FireServer(Key)
end)

 c=userInput.InputBegan:Connect(function(input)
	if input.KeyCode ~= nil then
		Events.InputBegan:FireServer(input.KeyCode)
	end
end)

 d=userInput.InputEnded:Connect(function(input)
	if input.KeyCode ~= nil then
		Events.InputEnded:FireServer(input.KeyCode)
	end
end)

userInput.InputBegan:Connect(function(Input)
	if Input == kc.LeftShift then
		normalTween(Humanoid, linear, ein, 2, {WalkSpeed = vars.RunSpeed.Value})
	end
end)

userInput.InputEnded:Connect(function(Player, Input)
	if Input == kc.LeftShift then
		normalTween(Humanoid, linear, ein,.4, {WalkSpeed = vars.WalkSpeed.Value})
	end
end)


inse(globcon,a)
inse(globcon,b)
inse(globcon,c)
inse(globcon,d)

tw(.25)

Theme = wfc(RootPart,"Theme", 9e9)
Theme.Parent = Camera

-- Camera Animations

local OriginOffset = Humanoid.CameraOffset
local last_delta = 0
local SVisible = false
local cam = RunService.RenderStepped:Connect(function(deltaTime: number)
	last_delta = last_delta + deltaTime
	
	if last_delta >= (1 / 60) and not s then
		local C0 = RootJoint.C0
		local rot_vel = RootPart.RotVelocity
		local mag = RootPart.Velocity.Magnitude
		
		Humanoid.CameraOffset = Lerp_P(Humanoid.CameraOffset , OriginOffset + v3((C0.X / 2 + .1 * sin(sine * 1.25)) + clamp(rot_vel.X, -2, 2), C0.Y  - .15 * sin((sine+6) * 1.25), (C0.Z / 2 + .15 * sin((sine+7.1)*1.25)) + clamp(mag, 0, 2)), .045)

		Tween.normalTween(Camera, esine, ein, .235, {FieldOfView = 67.5 + clamp(mag, 0, 34)})	
		
		last_delta = 0
	end
end)

-- Main UI

local MainUI = ReplicatedStorage.Game.UI.Main:Clone()
local Music = MainUI.Music:GetChildren()
local Top, Main = ud2(0, 0, -.2, 0), ud2(0, 0,1.15, 0)
local Mid = ud2(0, 0, 1.085, 0)

MainUI.Top.Position = Top
MainUI.Main.Position = Main
MainUI.Music.Position = Mid

MainUI.Parent = Player.PlayerGui

local f1, f2 = c3(0, 0, 0), c3(0, 0, 0)
local Color1, Color2 = vars.Color1, vars.Color2

function transform(seconds)
	seconds =  floor(seconds+.5)
	local minutes,extra = 0,""

	if seconds >= 60 then
		repeat
			if seconds >= 60 then
				seconds = seconds - 60
				minutes = minutes + 1
			end
		until seconds < 60
	end
	if seconds < 10 then
		extra = "0"
	end
	return(minutes..":"..extra..seconds)
end


local function Setup(v, val, rev)
	sp(function()
		while true do
			tw()
			if val == 0 then
				if rev then
					v.BackgroundColor3 = Color2.Value
				else
					v.BackgroundColor3 = Color1.Value
				end
			elseif val == 1 then
				if rev then
					v.TextColor3 = Color2.Value
				else
					v.TextColor3 = Color1.Value
				end
			elseif val == 2 then
				if rev then
					v.ImageColor3 = Color2.Value
				else
					v.ImageColor3 = Color1.Value
				end
			end
		end
	end)
end

local function OnFinished(tween:Tween)
	tween.Completed:Once(function()
		tween:Destroy()
		tween = nil
	end)
end

local col = rgb(0, 170, 255)
for i, v in prs(MainUI:GetDescendants()) do
	if v:IsA("Frame") and v.BackgroundColor3 == col then
		Setup(v, 0)
	elseif v:IsA("TextLabel") and v.TextColor3 == col then
		--Setup(v, 1)
	elseif v:IsA("ImageLabel") and v.ImageColor3 == col then
		Setup(v, 2)
	end
end

for _, x in prs(Music) do
	if x:IsA("Frame") then
		local Val = rand(600, 1000)
		local bool = ins("NumberValue",x)
		bool.Value = Val
		sp(function()
			while true do
				tw(rand(.1, .2))
				local Val = rand(600, 1000)
				bool.Value = Val
				if Humanoid.Health == 0 then
					break
				end
			end
		end)
	end
end

local Bot = MainUI.Bot
local Grad = Bot.UIGradient
sp(function()
	while true do
		for i, b in prs(Music) do
			if b:IsA("Frame") then
				local lo = Theme.PlaybackLoudness
				local scale = clamp(lo / b.Value.Value, 0, 1)
				local newSize = ud2(.062, 0, scale, 0)
				local tweenInfo = info(.045, linear)
				local tween = ts:Create(b, tweenInfo, {Size = newSize})
				tween:Play()
				OnFinished(tween)
			end
		end
		
		tw()

		if Humanoid.Health == 0 then
			for i, b in prs(Music) do
				if b:IsA("Frame") then
					normalTween(b, esine, ein, 2, {Size = ud2(.062, 0, 0, 0)})
				end
			end
			break
		end
	end
end)

local AUTH, NAME, TOP = MainUI.Main.AUTH, MainUI.Main.NAME, MainUI.Top.TOP
local TIME, Lyric, Warning, Chat = MainUI.Main.TIME, MainUI.Lyric, MainUI.Warning, MainUI.Chat
local HP = MainUI.Main.HP
local lyrc = false
local maxHealth = Humanoid.MaxHealth
local ui_multiplier = 0
local color1, color2 = vars.Color1, vars.Color2
local md, song, ar = vars.Mode, vars.Song, vars.Artist
local sd = vars.Side
local shake = vars.TextShake
local Update = PlayerGui.Update
local Txt = Update.TXT
local LD, RD = Update.LeftDoor, Update.RightDoor
local Button = MainUI.Button
local Button2 = MainUI.Button2
local Options = MainUI.Options
local v3_0=v3(0,0,0)
local c3_0=c3(0,0,0)
local lerp = cf_0.Lerp
local vlerp = v3_0.Lerp
local clerp = c3_0.Lerp

md.Changed:Connect(function(Value)
	TOP.Text = md.Value.." : "..sd.Value.." // DELIMA // STATUS: "..Humanoid.Health.." // "..maxHealth
end)
ar.Changed:Connect(function(Value)
	AUTH.Text = ar.Value:upper()
end)
song.Changed:Connect(function(Value)
	NAME.Text = song.Value:upper()
end)
Humanoid.HealthChanged:Connect(function(health)
	TOP.Text = md.Value.." : "..vars.Side.Value.." // DELIMA // STATUS: "..ceil(health).." // "..ceil(maxHealth)
end)

Color1.Changed:Connect(function()
	local MainColor = Color1.Value
	TOP.TextColor3 =MainColor
	NAME.TextColor3 =MainColor
	AUTH.TextColor3 =MainColor
	TIME.TextColor3 =MainColor

	MainUI.Lyric.BorderColor3 = MainColor

	Warning.txt.TextColor3 =MainColor
	MainUI.Warning.BorderColor3 =MainColor

	Chat.BorderColor3 = MainColor
	Chat.Messages.BorderColor3 = MainColor

	Chat.Type.TextColor3 =MainColor
	Chat.Type.PlaceholderColor3 =MainColor
	Chat.Send.TextColor3 =MainColor

	HP.BorderColor3 =MainColor
	HP.TextColor3 =MainColor

	Button.BorderColor3 =MainColor
	Button.TextColor3 =MainColor	
	
	Button2.BorderColor3 =MainColor
	Button2.TextColor3 =MainColor	
end)

sp(function()
	while true do
		tw()
		if not s then
			local MainColor = Color1.Value

			TIME.Text = transform(Theme.TimePosition) .. " // " ..  transform(Theme.TimeLength)

			if not shake.Value  then
				TOP.Position = ud2(0, 0 + 40 * sin(sine*1.5),.006, 0 + 2.5 * sin((sine+6)*1.5))
				TOP.Rotation = 0 + .45 * sin((sine+7)*1.5)

				NAME.Position = ud2(.017, 0 + 10.5 * sin((sine+6.455)*1.25),.081, 0)
				NAME.Rotation = 0 + 1 * sin(sine*1.25)

				AUTH.Position = ud2(.014, 0 + 7.5 * sin((sine+6.455)*1.35),.355, 0)
				AUTH.Rotation = 0 + .75 * sin(sine*1.35)

				if lyrc then
					local x,y = Lyric.Position.X, Lyric.Position.Y
					Lyric.Position = ud2(x.Scale, 0 +  7.5 * sin((sine+6.455)*1.35 ), y.Scale, 0 - 7.5 * sin((sine)*1.35))
					Lyric.Rotation = 0 + 3 * sin((sine+5.6)*1.35)
					x,y=nil
				end

			else

				TOP.Position = ud2(0, 0 + 66 * sin(sine*173),.006, 0 + 2.5 * sin((sine+6)*137))
				TOP.Rotation = 0 + .45 * sin((sine+7)*162)

				NAME.Position = ud2(.017, 0 + 15.5 * sin((sine+6.455)*123),.081, 0)
				NAME.Rotation = 0 + 1 * sin(sine*152)

				AUTH.Position = ud2(.014, 0 + 10 * sin((sine+6.455)*164),.355, 0)
				AUTH.Rotation = 0 + .75 * sin(sine*132)

				if lyrc then
					local x,y = Lyric.Position.X, Lyric.Position.Y
					Lyric.Position = ud2(x.Scale, 0 +  7.5 * sin((sine+6.455)*143), y.Scale, 0 - 7.5 * sin((sine)*153))
					Lyric.Rotation = 0 + 3 * sin((sine+5.6)*124)
					x,y=nil
				end
			end
		end
		
		if Humanoid.Health == 0 then
			break
		end
	end
end)

-- Lyrics System

local start_pos, end_pos = ud2(1.25, 0,.499, 0), ud2(.697, 0,.555, 0)
local CurrentLyrics = {}
local CurrentModule = nil
local LyricFrame = MainUI.Lyric
local TextLyric = LyricFrame.UIListLayout.Lyric
local t=4.5

local function FlyOut(vis: BoolValue)
	if not vis then
		lyrc = false
		normalTween(LyricFrame, esine, ein, .65, {Position = start_pos, Rotation = 180})
	elseif vis then
		normalTween(LyricFrame, elastic, out, .65, {Position = end_pos, Rotation = 0})
		tw(0.65)
		lyrc = true
	end
end

FlyOut(false)

local function NewLyric(Table, mod: ModuleScript)
	sp(function()
		local a = false

		Events.StopAllLyrics.OnClientEvent:Once(function()
			a=true
		end)

		repeat tw()
			if Humanoid.Health == 0 then
				break
			end
			if a then
				break
			end
		until Theme.TimePosition > Table.Time

		if Humanoid.Health == 0 then
			return
		end
		if a then
			return
		end

		if not lyrc  then
			t=0
		else
			t=.3
		end

		local ActualText = TextLyric:Clone()
		ActualText.Visible = true
		ActualText.Text = "[ "..Table.Lyric.." ]"
		ActualText.Parent = LyricFrame
		ActualText.TextColor3 = c3(1,1,1)
		ActualText.TextTransparency = 1

		normalTween(ActualText, esine, ein, .5, {TextTransparency = 0, TextColor3 = vars.f1.Value})

		tw(Table.Lifetime)

		normalTween(ActualText, esine, ein, .3, {TextTransparency = 1})

		tw(.35)

		ActualText:Destroy() ActualText=nil
	end)
end

local a2=vars.Lyric.Changed:Connect(function(Value)
	Ly = Ly + 1

	if Ly == 1 then
		CurrentModule = Value
		CurrentLyrics = rq(vars.Lyric.Value)

		tw(.2)

		for _, v in prs(CurrentLyrics) do
			NewLyric(v)
		end
	end
end)

local a3=Theme.DidLoop:Connect(function()
	tw(1)
	for _, v in prs(CurrentLyrics) do
		NewLyric(v)
	end
end)

sp(function()
	while true do
		tw(.1)

		if t < 4.6 then
			t = t + .1
		end

		if t == 4.5 then
			FlyOut(false)
		elseif t < .2 then
			FlyOut(true)
		end

		if Humanoid.Health == 0 then
			break
		end
	end
end)

inse(globcon, a2) inse(globcon, a3)

-- WARNING!!!

local Warning = MainUI.Warning
local start, endp = ud2(0, 0, 0, 127), ud2(0, 0, -.65, 127)
local movestart = ud2(-1.5, 0, .155, 0)
local anim_start = ud2(1.15, 0, .155, 0)
local en = false
local txt = Warning.txt

local b1=Humanoid.HealthChanged:Connect(function(Prop)
	if Humanoid.Health < 2500 and Humanoid.Health > 1 then
		normalTween(Warning, esine, out, 1.25, {Position = start}) normalTween(Theme, elastic, ein, 1.5, {Pitch = .8}) ui_multiplier=-1.5 Sounds.alarm.Playing = true en = true
	elseif Humanoid.Health > 2500 then
		normalTween(Warning, esine, out, 2, {Position = endp})  normalTween(Theme, linear, ein, 2, {Pitch = 1}) ui_multiplier=0 Sounds.alarm.Playing = false en = false
	elseif Humanoid.Health == 0 then
		normalTween(Warning, esine, out, 4, {Position = endp}) normalTween(Sounds.alarm, linear, ein, 4, {Pitch = 0, Volume = 0}) normalTween(Theme, linear, ein, 4, {Pitch = 0}) ui_multiplier=-10 en = false
	end
end)

inse(globcon, b1)

sp(function()
	while true do
		tw()
		if en and not s then
			txt.Position = movestart
			normalTween(txt, linear, ein, 6, {Position = anim_start})

			tw(6)
		end
		
		if Humanoid.Health == 0 then
			break
		end
	end
end)

-- Chat

local Last = 0
local Chat = System.Chat
local SendMessage = Chat.SendMessage
local ChatFrame = MainUI.Chat
local ChatScroller, ChatBox, Send = ChatFrame.Messages, ChatFrame.Type, ChatFrame.Send
local Example = ChatFrame.UIGradient.example
local slide1, slide2 = ud2(.011, 0,.1, 0), ud2(-1, 0,.1, 0)
local rot1, rot2 = 0, -45
local ch = Sounds.chat

local function SlideOut(Visible: boolean)
	if Visible then
		normalTween(ChatFrame, esine, out, .65, {Position = slide1, Rotation = rot1})
	else
		normalTween(ChatFrame, esine, out, .65, {Position = slide2, Rotation = rot2})
	end
end

local function NewMessage(Table)
	local CurrentPlayer: Player, Message: string = Table[1], Table[2]
	local TextLabel = Example:Clone()
	
	local Lines = countLines(Message)
	if typeof(CurrentPlayer) == "string" then
		TextLabel.TextTransparency = 1
		TextLabel.Parent = ChatScroller
		TextLabel.Text = "[ "..CurrentPlayer.." ]: ".. Message
		for i=1, Lines do
			TextLabel.Size=ud2(TextLabel.Size.X.Scale, TextLabel.Size.X.Offset, TextLabel.Size.Y.Scale, TextLabel.Size.Y.Offset + 10)
		end
	else
		TextLabel.TextTransparency = 1
		TextLabel.Parent = ChatScroller
		TextLabel.Text = "[ "..CurrentPlayer.DisplayName.." ]: ".. Message
	end
	
	ch:Play()
	
	SlideOut(true)
	
	normalTween(TextLabel, esine, out, .65, {TextTransparency = 0})
	
	tw(60)
	
	normalTween(TextLabel, esine, out, .65, {TextTransparency = 1})
	
	tw(1.5)
	
	TextLabel:Destroy() TextLabel = nil
	CurrentPlayer, Message = nil, nil
end

local b2=Send.MouseButton1Down:Connect(function()
	SendMessage:FireServer(ChatBox.Text)
	
	ChatBox.Text = ""
end)

local b3=userInput.InputBegan:Connect(function(input: InputObject)
	if input.KeyCode == kc.Slash and not ChatBox:IsFocused() then
		ChatBox:CaptureFocus()
		
		tw()
		
		ChatBox.Text = ""
		
		SlideOut(true)
		
		Last = 0
	end
end)

local b4=ChatBox.FocusLost:Connect(function(enterPressed: boolean)
	if enterPressed then
		SendMessage:FireServer(ChatBox.Text)
		
		ChatBox.Text = ""
	end
end)

local b5=SendMessage.OnClientEvent:Connect(function(Table)
	NewMessage(Table)
end)

sp(function()
	while true do
		tw(.01)
		for i, v in prs(ChatScroller:GetChildren()) do
			if v:IsA("TextLabel") then
				v.TextColor3 = Color1.Value
			end
		end
		
		if Humanoid.Health == 0 then
			break
		end
	end
end)

sp(function()
	while true do
		tw(.1)
		if Last < 30.1 then
			Last = Last + .1
		end
		
		if Last > 30 and not ChatBox:IsFocused() then
			SlideOut(false)
		elseif ChatBox:IsFocused() then
			Last = 0
		end
		
		if Humanoid.Health == 0 then
			break
		end
	end
end)

SlideOut(false)

normalTween(MainUI.Top, esine, out, 2, {Position = ud2(0,0,0,0)})
normalTween(MainUI.Main, esine, out, 2, {Position = ud2(0, 0,.816, 0)})
normalTween(MainUI.Music, esine, out, 2, {Position = ud2(0, 0,.564, 0)})

inse(globcon, b2) inse(globcon, b3) inse(globcon, b4) inse(globcon, b5)

-- main loop

sp(function()
	while true do
		tw()
		sine = clk()
		
		if Humanoid.Health == 0 then
			break
		end
	end
end)

Humanoid.Died:Once(function()
	RootPart.CFrame = Torso.CFrame

	Humanoid.CameraOffset = v3(0,0,0)
	Camera.CameraSubject = Head

	normalTween(Sounds.alarm, linear, ein, 4, {Pitch = 0})
	normalTween(Theme, linear, ein, 4, {Pitch = 0})
	normalTween(vars.Color1, esine, ein, 4, {Value = c3(0, 0, 0)})
	normalTween(vars.Color2, esine, ein, 4, {Value = c3(0, 0, 0)})

	normalTween(MainUI.Top, esine, out, 4, {Position = Top})
	normalTween(MainUI.Main, esine, out, 4, {Position = Main})

	normalTween(Theme, esine, ein, 4, {Pitch = 0})
	
	tw(pls.RespawnTime - .1)

	for _, v in prs(globcon) do
		Disconnect(v) v=nil
	end

	clr(globcon)
	globcon = nil

	Disconnect(cam) cam=nil

	Theme:Destroy()
end)

-- Options

local Visible = false
Button.MouseButton1Down:Connect(function()
	Visible = not Visible
	
	Options.Visible = Visible
	
	if Visible then
		Options.Open:Play()
	else
		Options.Close:Play()
	end
end)

for _, v in prs(Options:GetDescendants()) do
	if v:IsA("TextLabel") then
		v.TextColor3 = Color1.Value
		local Is=ins("BoolValue",v)
		Is.Name="ch"Is.Value=true
	end
	if v:IsA("TextBox") then
		v.TextColor3 = Color1.Value
		v.BorderColor3 = Color1.Value
		local Is=ins("BoolValue",v)
		Is.Name="ch"Is.Value=true
	end
	if v:IsA("TextButton") then
		v.TextColor3 = Color1.Value
		v.BorderColor3 = Color1.Value
		local Is=ins("BoolValue",v)
		Is.Name="ch"Is.Value=true
	end
	if v:IsA("Frame") then
		v.BorderColor3=Color1.Value
		local Is=ins("BoolValue",v)
		Is.Name="ch"Is.Value=true
	end
end

sp(function()
	while true do
		tw()
		if Visible then
			local color = Color1.Value
			for _, v in prs(Options:GetDescendants()) do
				if v:IsA("TextLabel") and v["ch"] then
					v.TextColor3=color
				end
				if v:IsA("TextBox") and v["ch"] then
					v.TextColor3=color
					v.BorderColor3=color
				end
				if v:IsA("TextButton") and v["ch"] then
					v.TextColor3 = color
					v.BorderColor3 = color
				end
				if v:IsA("Frame") and v["ch"] then
					v.BorderColor3=color
				end
			end

			Options.BorderColor3 = color
		end
		
		if en and not s then
			Warning.Rotation = 0 + 1.5 * sin(sine*1.25)

			Warning.bot.Position = ud2(((clk()+3)/5.5)%.5, 0, -.003, 0)
			Warning.top.Position = ud2((-(clk()+3)/5.5)%.5, 0, .746, 0)

			local b=Warning.bot.Position
			local x,y=b.X,b.Y
			Warning.bot2.Position=  ud2(x.Scale - 1.12, x.Offset, y.Scale, y.Offset)

			local t=Warning.top.Position
			local x,y=t.X,t.Y
			Warning.top2.Position=  ud2(x.Scale - 1.12, x.Offset, y.Scale, y.Offset)

			b,t,x,y=nil
		end
	end
end)

vars.Mode_M.Changed:Connect(function(Value)
	CurrentTable = rq(Value)
	Ly=0
end)

-- Skin system

local function VBeam(particle: ParticleEmitter, emit_count: number, RootPart: BasePart, argstable)
	particle.Color = argstable.Color
	particle.Size = argstable.Size
	particle.Lifetime = argstable.Lifetime
	particle.Speed = argstable.Speed
	particle.TimeScale = argstable.TimeScale
	particle.Squash = argstable.Squash

	particle:Emit(emit_count)
end

local function VDust(particle: ParticleEmitter, emit_count: number, RootPart: BasePart, argstable)
	particle.Color = argstable.Color
	particle.Size = argstable.Size
	particle.Lifetime = argstable.Lifetime
	particle.Speed = argstable.Speed
	particle.TimeScale = argstable.TimeScale
	particle.Squash = argstable.Squash

	particle:Emit(emit_count)
end

local function VSlash(particle: ParticleEmitter, emit_count: number, RootPart: BasePart, argstable)
	particle.Color = argstable.Color
	particle.Size = argstable.Size
	particle.Lifetime = argstable.Lifetime
	particle.Speed = argstable.Speed
	particle.TimeScale = argstable.TimeScale
	particle.Squash = argstable.Squash
	particle.SpreadAngle = argstable.SpreadAngle

	particle:Emit(emit_count)
end


local function ColorBracelet(Bracelet: Model, Color: Color3, Color2: Color3, Tween: boolean)
	if Tween then
		normalTween(Bracelet.Glow, style.Sine, dir.In, .3, {Color = Color})
		Bracelet.WeldPoint.Trail.Color = cs(Color)
	else
		Bracelet.M.Color = c3(0, 0, 0)
		Bracelet.Glow.Color = Color
		Bracelet.WeldPoint.Trail.Color = cs(Color)
	end
end

local SkinButton = MainUI.Button2
local Selector = ws.Selector
local Rig = Selector.Rig
local SkinSelector = MainUI.SkinSelector
local Equip = SkinSelector.Equip
local Scroller = SkinSelector.Main.Scroller

local Torso, RootPart = Rig.Torso, Rig.HumanoidRootPart
local LeftArm, RightArm, LeftLeg, RightLeg, Head = Rig["Left Arm"], Rig["Right Arm"], Rig["Left Leg"], Rig["Right Leg"], Rig.Head
local Ls, Rs, Lh, Rh, Nj, Rj = Torso["Left Shoulder"], Torso["Right Shoulder"], Torso["Left Hip"], Torso["Right Hip"], Torso.Neck, RootPart.RootJoint
local Example = Scroller.UIListLayout.Example
local rHumanoid = Rig.Humanoid

local cast_Plane = ins("Part", Selector)
cast_Plane.Size = v3(0, 0, 0)
cast_Plane.Anchored = true
cast_Plane.Transparency = 1
cast_Plane.Name = "cast_Plane"
cast_Plane.CanCollide = false cast_Plane.CanTouch = false cast_Plane.CanQuery =false

local ground_attachment = ins("Attachment", RootPart)
ground_attachment.Name = "ground"

LegacyEffects = ReplicatedStorage.Game.LegacyEffects

SwitchVF = LegacyEffects.Switch.Switch:Clone()
SwitchVF.Parent = Torso

ExplodeVF = LegacyEffects.Explode.Explosion:Clone()
ExplodeVF.Parent = Torso

Smoke = LegacyEffects.Smoke.Smoke:Clone()
Smoke.Parent = ground_attachment

Beam = LegacyEffects.Particles.Beam:Clone()
Beam.Parent = cast_Plane

Dust = LegacyEffects.Particles.Dust:Clone()
Dust.Parent = cast_Plane

local SlashV = LegacyEffects.Slash:Clone()
local RP = SlashV.Slash
RP.Parent = cast_Plane

local SkinTheme = ins("Sound", SkinSelector)
SkinTheme.Volume=0
SkinTheme.Looped = true

SlashV = RP

local FireV = LegacyEffects.Fire:Clone()
local RP1 = FireV.Fire
RP1.Parent = cast_Plane


local JointTable = {Ls, Rs, Lh, Rh, Nj, Rj}

SkinButton.MouseButton1Down:Connect(function()
	SVisible = not SVisible
	
	if SVisible then
		normalTween(MainUI.Top, esine, out, 2, {Position = Top})
		normalTween(MainUI.Main, esine, out, 2, {Position = Main})
		normalTween(MainUI.Music, esine, out, 2, {Position = Mid})
		
		normalTween(Theme, linear, ein, 2, {Pitch = 0})
		
		Sounds.button:Play()
		
		normalTween(MainUI.Black, esine, out, 1, {BackgroundTransparency = 0})
		

		tw(1) Camera.CameraSubject = rHumanoid
		Camera.FieldOfView = 80
		
		normalTween(SkinTheme, linear, ein, 2, {Pitch = 1, Volume=1})
		
		 MainUI.SkinSelector.Visible = true
		
		normalTween(MainUI.Black, esine, out, 1, {BackgroundTransparency = 1})
		
		normalTween(Camera, esine, out, 2, {FieldOfView = 67.5}) s = true
	else
		normalTween(MainUI.Top, esine, out, 2, {Position = ud2(0,0,0,0)})
		normalTween(MainUI.Main, esine, out, 2, {Position = ud2(0, 0,.816, 0)})
		normalTween(MainUI.Music, esine, out, 2, {Position = ud2(0, 0,.564, 0)})
		normalTween(Theme, linear, ein, 2, {Pitch = 1})
		
		Sounds.button2:Play()
		
		normalTween(SkinTheme, linear, ein, 2, {Pitch = 0})
		
		normalTween(MainUI.Black, esine, out, 1, {BackgroundTransparency = 0})
		
		tw(1) Camera.CameraSubject = Humanoid MainUI.SkinSelector.Visible = false s = false
		vars.Color1.Value = vars.f1.Value
		
		normalTween(MainUI.Black, esine, out, 1, {BackgroundTransparency = 1})
	end
end)

local Wings = CreateWings(7, Torso, Selector.WingStorage)
local CurrentEffectTable = {}
local WingAnimation = function()end
local Animation = function()end
local MColor1 = c3(0, 0, 0)
local VFX = ins("Folder", Selector)
local ColorSync = false
local Slash = rq(System.LegacyEffects.Modules.Slash).Slash
local TextShake = false
local Bracelet = System.Models.bracelet

local CurrentModule = nil
local ParMode = nil
local RandomFlash=false
local RainbowEnabled=false
local EffectsEnabled = false
local Core = System.Models.core:Clone()
local rcp = RaycastParams.new

local LA, RA = Bracelet:Clone(), Bracelet:Clone()
local LL, RL = Bracelet:Clone(), Bracelet:Clone()

Welding.CreateWeld(LeftArm, LA.PrimaryPart, cf(0,.5,0),cf_0)
Welding.CreateWeld(RightArm, RA.PrimaryPart, cf(0,.5,0),cf_0)

Welding.CreateWeld(LeftLeg, LL.PrimaryPart, cf(0,-.5,0),cf_0)
Welding.CreateWeld(RightLeg, RL.PrimaryPart, cf(0,-.5,0),cf_0)

LA.Parent, RA.Parent = Selector, Selector LL.Parent, RL.Parent = Selector, Selector

local WingSine, WingOffset = 2, 0

local billBoard = ins("BillboardGui", Torso)
billBoard.LightInfluence = 0
billBoard.Brightness = 2
billBoard.Size  = ud2(23.5, 0, 4, 0)
local FlashEnabled=false
local text = ins("TextLabel", billBoard)
text.Size = ud2(1, 0, 1, 0)
text.BackgroundTransparency = 1
text.TextScaled = true
text.Font = Enum.Font.Arcade
text.RichText=true
text.TextTransparency=0
text.TextStrokeTransparency = 0
text.TextColor3=c3(1, 1, 1)
local cb = nil
local FlashEnabled, FlashTable1, FlashTable2 = false, {}, {}
local Cycle0, Cycle1 = 0, 0
angles, rad = CFrame.Angles, math.rad
local V0, V1 = 0, 0

local function GetNumber(Value)
	if typeof(Value) == "NumberRange" then
		return rand(Value.Min, Value.Max)
	elseif typeof(Value) == "number" then
		return Value
	end
end

local function ConvertTableToCFrame(Table)
	local Position, Orientation = Table.Position, Table.Orientation

	if (Position and Orientation) then
		local X, Y, Z = GetNumber(Position.X), GetNumber(Position.Y), GetNumber(Position.Z)
		local aX, aY, aZ = GetNumber(Position.X), GetNumber(Position.Y), GetNumber(Position.Z)

		return cf(X,Y,Z) * angles(rad(aX), rad(aY), rad(aZ))
	end
end

local function General3D(Parent:Instance, StartCFrame:CFrame, CFrameMultipler: CFrame, TransparencySpeed: number, SizeTable, ColorTable, Shape: Enum.PartType, Material: Enum.Material)
	local StartSize, EndSize, SizeAlpha = SizeTable[1], SizeTable[2], SizeTable[3]
	local StartColor, EndColor, ColorAlpha = ColorTable[1], ColorTable[2], ColorTable[3]

	local vfx=ins("Part",Parent)
	vfx.Size=StartSize vfx.Anchored=true vfx.CanCollide=false vfx.CanTouch=false vfx.CanQuery=false
	vfx.Shape=Shape vfx.Material=Material
	vfx.Color=StartColor
	vfx.CFrame=StartCFrame

	local color_enabled=false

	if StartColor ~= EndColor then
		color_enabled=true
	end

	sp(function()
		local ldt=0
		local con=nil
		con=Heartbeat:Connect(function(dt:number)
			ldt=ldt+dt
			if ldt >= (1 / 60) then
				vfx.Transparency = vfx.Transparency + TransparencySpeed
				vfx.CFrame = vfx.CFrame * CFrameMultipler
				
				if vfx.Size ~= EndSize then
					vfx.Size = vlerp(vfx.Size, EndSize, SizeAlpha)
				end
				if color_enabled then
					vfx.Color = clerp(vfx.Color, EndColor, ColorAlpha)
				end

				if vfx.Transparency>1 then
					StartColor, EndColor, ColorAlpha = nil,nil,nil
					StartSize, EndSize, SizeAlpha = nil,nil,nil

					vfx:Destroy() vfx=nil
					con:Disconnect()
					con=nil
				end

				ldt=0
			end
		end)
	end)
end

local function InterpVFX(Table, del)
	local Name = Table.Name
	if Name == "Beam" then
		local zSize, zColor, zSpeed, zLifetime, zSquash, zTimeScale, zColorSync = Table.Size, Table.Color, Table.Speed, Table.Lifetime, Table.Squash, Table.TimeScale, Table.ColorSync
		local zEmit = Table.Emit
		cast_Plane.Size = Table.CastSize
		VBeam(Beam, zEmit, RootPart, {
			Size=zSize,
			Color=zColor,
			Speed=zSpeed,
			Lifetime=zLifetime,
			Squash=zSquash,
			TimeScale=zTimeScale,
		})

		ColorSync = zColorSync
		zSize=nil
		zColor=nil
		zSpeed=nil
		zLifetime=nil
		zSquash=nil
		zTimeScale=nil
		zColorSync=nil

	elseif Name == "Dust" then
		local zSize, zColor, zSpeed, zLifetime, zSquash, zTimeScale, zColorSync = Table.Size, Table.Color, Table.Speed, Table.Lifetime, Table.Squash, Table.TimeScale, Table.ColorSync
		local zEmit = Table.Emit
		cast_Plane.Size = Table.CastSize
		VDust(Dust, zEmit, RootPart, {
			Size=zSize,
			Color=zColor,
			Speed=zSpeed,
			Lifetime=zLifetime,
			Squash=zSquash,
			TimeScale=zTimeScale,
		})

		ColorSync = zColorSync
		zSize=nil
		zColor=nil
		zSpeed=nil
		zLifetime=nil
		zSquash=nil
		zTimeScale=nil
		zColorSync=nil

	elseif Name == "AuraSmoke" then
		local zSize, zColor, zSpeed, zLifetime, zSquash, zTimeScale, zColorSync = Table.Size, Table.Color, Table.Speed, Table.Lifetime, Table.Squash, Table.TimeScale, Table.ColorSync
		local zEmit = Table.Emit
		cast_Plane.Size = Table.CastSize
		VDust(Dust, zEmit, RootPart, {
			Size=zSize,
			Color=zColor,
			Speed=zSpeed,
			Lifetime=zLifetime,
			Squash=zSquash,
			TimeScale=zTimeScale,
		})

		ColorSync = zColorSync
		zSize=nil
		zColor=nil
		zSpeed=nil
		zLifetime=nil
		zSquash=nil
		zTimeScale=nil
		zColorSync=nil

	elseif Name == "Slash3D" then
		local zss, zes, zts, zsc, zec, zcd, zsd = Table.StartSize, Table.EndSize, Table.TransparencySpeed, Table.StartColor, Table.EndColor, Table.ColorDelta, Table.SizeDelta
		if (zss and zes and zts and zsc and zcd and zsd) ~= nil then
			Slash(VFX, RootPart.Position, RootPart.CFrame.UpVector * -100, zss, zes, zts, zsc, zec, zcd, zsd, del)
		else
			zss=nil
			zes=nil
			zts=nil
			zsc=nil
			zcd=nil
			zsd=nil
		end
	elseif Name == "Slash" then
		local zSize, zColor, zSpeed, zLifetime, zSquash, zTimeScale, zColorSync = Table.Size, Table.Color, Table.Speed, Table.Lifetime, Table.Squash, Table.TimeScale, Table.ColorSync
		local zSpreadAngle = Table.SpreadAngle
		local zEmit = Table.Emit
		cast_Plane.Size = Table.CastSize
		VSlash(SlashV.Slash, zEmit, RootPart, {
			Size=zSize,
			Color=zColor,
			Speed=zSpeed,
			Lifetime=zLifetime,
			Squash=zSquash,
			TimeScale=zTimeScale,
			SpreadAngle=zSpreadAngle
		})	

		zSize=nil
		zColor=nil
		zSpeed=nil
		zLifetime=nil
		zSquash=nil
		zTimeScale=nil
		zColorSync=nil
	elseif Name == "Fire" then
		local zSize, zColor, zSpeed, zLifetime, zSquash, zTimeScale, zColorSync = Table.Size, Table.Color, Table.Speed, Table.Lifetime, Table.Squash, Table.TimeScale, Table.ColorSync
		local zSpreadAngle = Table.SpreadAngle
		local zEmit = Table.Emit
		cast_Plane.Size = Table.CastSize
		VSlash(RP1.Slash, zEmit, RootPart, {
			Size=zSize,
			Color=zColor,
			Speed=zSpeed,
			Lifetime=zLifetime,
			Squash=zSquash,
			TimeScale=zTimeScale,
			SpreadAngle=zSpreadAngle
		})		

		zSize=nil
		zColor=nil
		zSpeed=nil
		zLifetime=nil
		zSquash=nil
		zTimeScale=nil
		zColorSync=nil

	elseif Name == "Gen3D" then
		local StartCFrame, CFrameMultipler = ConvertTableToCFrame(Table.StartCFrame), ConvertTableToCFrame(Table.CFrameMultipler)
		local SizeTable, ColorTable = Table.SizeTable, Table.ColorTable
		local TransparencySpeed = Table.TransparencySpeed

		local Shape, Material = Table.Shape, Table.Material

		General3D(VFX, RootPart.CFrame * StartCFrame, CFrameMultipler, TransparencySpeed, SizeTable, ColorTable, Shape, Material)
	end
end

local function LoadFromModule(Module: ModuleScript)
	RainbowEnabled = false
	
	local Mode = rq(Module)
	local Color1, Color2 = Mode.Color1, Mode.Color2
	
	MColor1 = Color1 vars.Color1.Value = c3(1,1,1)
	vars.Color1.Value = MColor1
	
	WingAnimation = rq(Mode.WingAnimation).Animate
	Animation = rq(Mode.Animation).Animate
	
	CustomiseColor(Color1, Wings)
	SetWingCount(Wings, Mode.WingCount)

	CurrentEffectTable = Mode.LegacyEffects
	Smoke.Smoke_1.Enabled = Mode.SmokeEnabled
	Smoke.Smoke_1.Drag = Mode.SmokeDrag
	Smoke.Smoke_1.Color = cs(Color1)
	
	FlashEnabled = Mode.ColorFlashEnabled
	FlashTable1 = Mode.ColorFlashMain
	FlashTable2 = Mode.ColorFlashSec
	
	Cycle0, Cycle1 = #FlashTable1, #FlashTable2
	
	EffectsEnabled = Mode.UsesLegacyEffects
	
	text.Text = Mode.Name
	text.TextColor3=MColor1
	text.TextStrokeColor3=MColor1
	
	FlashEnabled = Mode.ColorFlashEnabled
	RandomFlash = Mode.RandomColorFlash
	if Mode.RainbowEnabled then
		RainbowEnabled=true
	else
		RainbowEnabled=false
	end                                                                                                                                                                                                                            
	                                                         
	SkinTheme.SoundId = "rbxassetid://"..Mode.SoundID
	SkinTheme:Play()
	SkinTheme.TimePosition = Mode.StartTime
	
	TextShake = Mode.TextShakeEnabled
  
	if Mode.WingAnimationSpeed then
		WingSine = Mode.WingAnimationSpeed
	else
		WingSine = 2
	end

	if Mode.WingAnimationOffset then
		WingOffset = Mode.WingAnimationOffset
	else
		WingOffset = 0
	end
	
	ColorBracelet(LA, Color1, Color2, true)
	ColorBracelet(RA, Color1, Color2, true)
	ColorBracelet(LL, Color1, Color2, true)
	ColorBracelet(RL, Color1, Color2, true)
end

local function SyncColors(Color1, Color2)
	Equip.ModeName.TextColor3 = Color1
	Equip.SubText.TextColor3 = Color1
	
	Equip.BorderColor3 = Color1
	Equip.Description.BorderColor3 = Color1
	Equip.Equip.BorderColor3 = Color1
	
	Equip.Description.TextColor3 = Color1
	Equip.Equip.TextColor3 = Color1

	Equip.Song.TextColor3 = Color1
	Equip.Credits.TextColor3 = Color1

	text.TextColor3 = Color1
	text.TextStrokeColor3 = Color2
end

local function OnPress(Module: ModuleScript, Table)
	LoadFromModule(Module)
	local ModeName = Table.Name
	
	Equip.ModeName.Text = Table.Name
	Equip.SubText.Text = Table.SubName
	
	Equip.Song.Text = "Song: "..Table.SongName
	Equip.Credits.Text = "By: "..Table.Creator..", Animated by: "..Table.Animator
	
	if Table.Description ~= "" then
		Equip.Description.Text = Table.Description
	else
		Equip.Description.Text = "No description."
	end
	
	text.Text = Table.Name
	
	SyncColors(Table.Color1, Table.Color2)
end

local function CreateNewButton(Module: ModuleScript)
	local NewButton = Example:Clone()
	local Mode = rq(Module)
	
	if Mode then
		NewButton.Parent = Scroller
		NewButton.Text = Mode.Name
		NewButton.Name=Mode.Name
		
		local ScrollerN = SkinSelector.Main.SkinScroll:Clone()
		ScrollerN.Parent = SkinSelector.Main
		ScrollerN.Name = Mode.Name
		
		local NewButton2 = Example:Clone()
		NewButton2.Parent = ScrollerN
		NewButton2.Text = Mode.Name
		NewButton2.Name=Mode.Name

		NewButton2.MouseEnter:Connect(function()
			OnPress(Module, Mode)
			CurrentModule = Module
			Sounds.move:Play()
			cb=NewButton2
			NewButton2.TextColor3=c3(1,1,1)
		end)

		for _, v in prs(Skins.Main:GetChildren()) do
			if v:IsA("ModuleScript") then
				local Mod = rq(v)
				if Mod.ParentMode then
					if Mod.ParentMode == Module then
						local NewButton2 = Example:Clone()
						NewButton2.Parent = ScrollerN
						NewButton2.Text = Mod.Name
						NewButton2.Name=Mod.Name
						
						NewButton2.MouseEnter:Connect(function()
							OnPress(v, Mod)
							CurrentModule = v
							Sounds.move:Play()
							cb=NewButton2
							NewButton2.TextColor3=c3(1,1,1)
						end)
					end
				end
			end
		end
		
		NewButton.MouseEnter:Connect(function()
			OnPress(Module, Mode)
			Sounds.move:Play()
			cb=NewButton
			NewButton.TextColor3=c3(1,1,1)
		end)
		
		NewButton.MouseButton1Down:Connect(function()
			for _, v: Instance in prs(SkinSelector.Main:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					if v.Name == Mode.Name then
						v.Visible = true SkinSelector.Main.Exit.Visible = true ParMode = Module
					else
						v.Visible = false
					end
				end
			end
		end)
	end
end

SkinSelector.Equip.Equip.MouseButton1Down:Connect(function()
	if CurrentModule then
		Skins.Events.SetSkin:FireServer(CurrentModule)
	end
end)

SkinSelector.Main.Exit.MouseButton1Down:Connect(function()
	for _, v: Instance in prs(SkinSelector.Main:GetChildren()) do
		if v:IsA("ScrollingFrame") then
			if v.Name == "Scroller" then
				v.Visible = true SkinSelector.Main.Exit.Visible = false	
			else
				v.Visible = false
			end
		end
	end
end)

local ldt = 0
RunService.Heartbeat:Connect(function(dt)
	ldt = ldt + dt
	if ldt >= (1 / 144) and s then
		local sine = clk()
		
		WingAnimation(Wings, sine, WingSine, WingOffset)
		
		Animation(JointTable, sine, .05)
		
		local rc = ws:Raycast(RootPart.Position, RootPart.CFrame.UpVector * -100, rcp())
		if rc then
			cast_Plane.Position = rc.Position
		end
		
		if not TextShake then
			text.Rotation = 0 - 5 * sin((sine+2.6) * 2.45)
			billBoard.StudsOffset = v3(0 + .95 * sin((sine+5.65) * 2.45), 4.5, 0)
		else
			text.Rotation = 0 - 15 * sin((sine+2.5) * 271)
			billBoard.StudsOffset = v3(0 + 2 * sin((sine+5.5) * 251), 4.5 + 1 * sin(sine * 231), 0)
		end
		
		if ColorSync then
			Beam.Color = cs(MColor1)
			Dust.Color = cs(MColor1)
		end
		
		if RandomFlash then
			local Color1, Color2 = c3(rand(1,255) / 255, rand(1,255) / 255, rand(1,255) / 255), c3(0, 0, 0)

			CustomiseColor(Color1, Wings)

			Core.Main.Color = Color1
			Core.Second.Color = Color2
			Core.Main.a.PointLight.Color = Color1
			Core.Main.b.PointLight.Color = Color1

			MColor1 = Color1

			ColorBracelet(LA, Color1, Color2, false) ColorBracelet(RA, Color1, Color2, false) ColorBracelet(LL, Color1, Color2, false) ColorBracelet(RL, Color1, Color2, false)
			
			SyncColors(MColor1, Color2)
			
			text.TextStrokeColor3 = Color1
			text.TextColor3=Color2
		end
		
		if RainbowEnabled then
			local hue = tc() % tickspeed / tickspeed
			local Color2 = c3(0,0,0)
			MColor1 = hsv(hue,1,1) 

			CustomiseColor(MColor1, Wings)

			Core.Main.Color = MColor1
			Core.Second.Color = Color2
			Core.Main.a.PointLight.Color = MColor1
			Core.Main.b.PointLight.Color = MColor1

			ColorBracelet(LA, MColor1, Color2, false) ColorBracelet(RA, MColor1, Color2, false) ColorBracelet(LL, MColor1, Color2, false) ColorBracelet(RL, MColor1, Color2, false)
			
			SyncColors(MColor1, Color2)
			
			text.TextStrokeColor3 = MColor1
			text.TextColor3=Color2
		end
		
		Rig.p.Color3 = MColor1
		Rig.s.Color3= MColor1
	end
end)

sp(function()
	while true do
		tw(1/30)
		if s then
			if EffectsEnabled  then
				for _, v in pairs(CurrentEffectTable) do
					if v.Name == "Slash3D"  then
						tw(.04)
					elseif v.Name == "Slash" then
						tw(.02)
					elseif v.Name == "Fire" then
						tw(.02)
					elseif v.Name == "Gen3D" and v.Limited then
						tw(v.LimitedTime)
					end

					InterpVFX(v,1)

					cast_Plane.Orientation = cast_Plane.Orientation + v3(0, RootPart.Orientation.Y, 0)
				end
			end
			
			if FlashEnabled then
				V0 = V0 + 1
				V1 = V1 + 1

				if (V0 and V1) > (Cycle0 or Cycle1) then
					V0, V1 = 0, 0
				end

				local CurColor1, CurColor2 = FlashTable1[V0], FlashTable2[V1]
				if (CurColor1 and CurColor2) then
					vars.Color1.Value = CurColor1
					vars.Color2.Value = CurColor2

					CustomiseColor(CurColor1, Wings)

					Core.Main.Color = CurColor1
					Core.Second.Color = CurColor2
					Core.Main.a.PointLight.Color = CurColor1
					Core.Main.b.PointLight.Color = CurColor1
					text.TextColor3 = CurColor1 text.TextStrokeColor3 = CurColor2

					--Smoke.Color = cs(CurColor1)

					ColorBracelet(LA, CurColor1, CurColor2, false)
					ColorBracelet(RA, CurColor1, CurColor2, false)
					ColorBracelet(LL, CurColor1, CurColor2, false)
					ColorBracelet(RL, CurColor1, CurColor2, false)
				end

				CurColor1, CurColor2 = nil, nil
			end

			for i, v in prs(SkinSelector.Main:GetDescendants()) do
				if v:IsA("TextButton") then
					if v ~= cb then
						v.TextColor3 = MColor1
					end
					v.BorderColor3 = MColor1
				end
			end

			SkinSelector.Main.Exit.BorderColor3 = MColor1
			SkinSelector.Main.Exit.TextColor3 = MColor1
			SkinSelector.Main.BorderColor3 = MColor1
		end
	end
end)


vars.Color1.Changed:Connect(function()
	if s then
		vars.Color1.Value = MColor1
	end
end)

tw(1)

for _, v in prs(Modes.Main:GetChildren()) do
	if v:IsA("ModuleScript") then
		CreateNewButton(v)
	end
end

Humanoid.Died:Connect(function()
	RemoveWings(Wings)
	SkinTheme:Destroy()
	
	rq(System.Animations.Modes.Main.NoAnimation).Animate(JointTable, 0, 1)
	billBoard:Destroy()
end)

LoadFromModule(Modes.Main.Descent)
SetWingCount(Wings, 3)

for _, v: Instance in prs(SkinSelector.Main:GetChildren()) do
	if v:IsA("ScrollingFrame") then
		if v.Name == "Scroller" then
			v.Visible = true SkinSelector.Main.Exit.Visible = false	
		else
			v.Visible = false
		end
	end
end

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false) 

local Saving = ReplicatedStorage.Saving
local Events = Saving.Events
sp(function()
	while tw(120) do
		Events.SaveSkins:FireServer()
	end
end)
