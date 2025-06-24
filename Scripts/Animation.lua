-- StarterPlayer > StarterPlayerScripts

local ws=workspace
local rcp=RaycastParams.new
local g=game
local rq=require

local Players = g:FindFirstChildOfClass("Players")
local LocalPlayer = Players.LocalPlayer

local RunService, ReplicatedStorage = g:FindFirstChildOfClass("RunService"), g:FindFirstChildOfClass("ReplicatedStorage")

local Heartbeat, System = RunService.Heartbeat, ReplicatedStorage.Game
local Misc = System.Modules.Misc
local Modules, Modes, Skins = System.Modules, System.Modes, System.Skins
local Wings, Welding, AnimateWings, Color, Tween = rq(Modules.Wings.Wings), rq(Modules.Welding.Welding), rq(Modules.Wings.Animate), rq(Modules.Wings.Color), rq(Misc.Tweening)

local CreateWeld, CreateMotor = Welding.CreateWeld, Welding.CreateMotor
local Animate, CustomiseColor, SetWingEnabled, SetWingCount = AnimateWings.AnimateWings, Color.CustomiseColor, Color.SetWingEnabled, Color.SetWingCount
local CreateWings, normalTween, TweenCustomiseColor = Wings.CreateWings, Tween.normalTween, Color.TweenCustomiseColor
local RemoveWings = Wings.RemoveWings
local Slash = rq(System.LegacyEffects.Modules.Slash).Slash

local ParticleMod = rq(Misc.Particles)

local Models = System.Models
local Storage = ws.Storage
local Camera = ws.CurrentCamera
local Settings = LocalPlayer:WaitForChild("Settings",9e9)
local tc, rgb = tick, Color3.fromRGB
local hsv = Color3.fromHSV
local rcolor = Color3.new(0,0,0)

local ffc = ws.FindFirstChild -- let's add these so that we can boost the framerate up by .000001%!!!!!!!
local ffcoc = ws.FindFirstChildOfClass
local wfc = ws.WaitForChild

local RenderDistance = 1000

local function GetPart(Parent:Instance, Part:string)
	local FoundPart = Parent:FindFirstChild(Part)
	return FoundPart
end	

local function GetJoint(Parent:Instance, Part:Motor6D)
	local FoundPart = Parent:FindFirstChild(Part)
	return FoundPart
end	

local function Configure(Part: BasePart)
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CanQuery = false
	Part.Locked = true
end

local function GetDistanceFromCamera(Position: Vector3)
	return (Position - Camera.CFrame.p).Magnitude
end

local Bracelet = Models.bracelet
local ins = Instance.new
local v3 = Vector3.new
local clk, tw = os.clock, task.wait
local cf, angles, rad, rand, clamp, sin = CFrame.new, CFrame.Angles, math.rad, math.random, math.clamp, math.sin

local rq, style, dir, cs = require, Enum.EasingStyle, Enum.EasingDirection, ColorSequence.new
local pr = pairs
local hst = Enum.HumanoidStateType
local sp = task.spawn
local c3 = Color3.new
local ps = PhysicalProperties.new
local ud2 = UDim2.new

local cf_0 = cf(0,0,0)
local Lerp = cf_0.Lerp
local prop=ps(15, .3, .5, 1, 1)
local zero = cf(0, 0, 0) * angles(0, 0, 0)
local c30 = c3(0,0,0)

local v3_0=v3(0,0,0)
local c3_0=c3(0,0,0)
local lerp = cf_0.Lerp
local vlerp = v3_0.Lerp
local clerp = c3_0.Lerp

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

local function ConvertTableToCFrame(Table)
	local function GetNumber(Value)
		if typeof(Value) == "NumberRange" then
			return rand(Value.Min, Value.Max)
		elseif typeof(Value) == "number" then
			return Value
		end
	end
	
	local Position, Orientation = Table.Position, Table.Orientation
	
	if (Position and Orientation) then
		local X, Y, Z = GetNumber(Position.X), GetNumber(Position.Y), GetNumber(Position.Z)
		local aX, aY, aZ = GetNumber(Position.X), GetNumber(Position.Y), GetNumber(Position.Z)
		
		return cf(X,Y,Z) * angles(rad(aX), rad(aY), rad(aZ))
	end
end

local function Visual(Item)
	local Player = Players:FindFirstChild(Item.Name)
	if Player then
		tw(1.5)
		
		local cast_Plane = wfc(Item,"cast_Plane")
		local _pc = Player.Character
		local Character = _pc
		local _hum = wfc(_pc,"Humanoid")
		local root = _hum.RootPart

		local WingsStorage = wfc(Item, "WingStorage")
		local _tors = _pc.Torso
		local billboard = ffcoc(_tors,"BillboardGui")
		local textlabel = ffcoc(billboard,"TextLabel")
		local grad = ffcoc(textlabel,"UIGradient")

		local ground = ffc(root,"ground")
		local Wings = CreateWings(7, _tors, WingsStorage)
		local cur_mod = wfc(Item,"cur_mod")
		local Core = Models.core:Clone()
		local sine = 0
		local RainbowEnabled = false
		
		local CurrentWingAnimation = function()

		end

		local Animation = function()

		end
		
		local CurrentEffectTable = {}
		
		local LeftArm = ffc(Character,"Left Arm")
		local RightArm = ffc(Character,"Right Arm")
		local LeftLeg = ffc(Character,"Left Leg")
		local RightLeg = ffc(Character,"Right Leg")
		local Torso = ffc(Character,"Torso")
		local Head = ffc(Character,"Head")
		local RootPart = _hum.RootPart

		local LeftShoulder, RightShoulder = ffc(Torso,"Left Shoulder"), ffc(Torso,"Right Shoulder")
		local LeftHip, RightHip = ffc(Torso,"Left Hip"), ffc(Torso,"Right Hip")
		local Neck, RootJoint = ffc(Torso,"Neck"), ffcoc(RootPart,"Motor6D")

		local AnimationId = 1
		local TextShake = false
		local Movetype = "Walk"
		local ColorSync = false
		local Color1, Color2 = c30,c30
		local Theme = ffc(RootPart,"Theme") or ffcoc(Camera,"Sound")
		local VFX = ins("Folder", Item)
		local Vars = wfc(Character,"Vars",9e9)
		local RenderDistance = 0

		VFX.Name = "VFX"

		local Smoke = ground.Smoke.Smoke_1
		local Dust = cast_Plane.Dust
		local Beam = cast_Plane.Beam
		local RSlash = cast_Plane.Slash.Slash
		local Fire = cast_Plane.Fire.Slash

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
				VSlash(RSlash, zEmit, RootPart, {
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
				VSlash(Fire, zEmit, RootPart, {
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

		local LA, RA = Bracelet:Clone(), Bracelet:Clone()
		local LL, RL = Bracelet:Clone(), Bracelet:Clone()

		Welding.CreateWeld(LeftArm, LA.PrimaryPart, cf(0,.5,0),cf_0)
		Welding.CreateWeld(RightArm, RA.PrimaryPart, cf(0,.5,0),cf_0)

		Welding.CreateWeld(LeftLeg, LL.PrimaryPart, cf(0,-.5,0),cf_0)
		Welding.CreateWeld(RightLeg, RL.PrimaryPart, cf(0,-.5,0),cf_0)

		LA.Parent, RA.Parent = Item, Item LL.Parent, RL.Parent = Item, Item

		local FlashEnabled, FlashTable1, FlashTable2 = false, {}, {}
		local Cycle0, Cycle1 = 0, 0

		local CameraShake, Intensity = false, 0
		local ColorSwap = false

		local RandomColorFlash = false
		local EffectsEnabled = false
		local WingSpeed = 2
		local WingOffset = 0

		local function Update()
			RainbowEnabled = false
			
			local Mode = rq(cur_mod.Value)
			local ColorSwap = Mode.ColorSwap
			local LeftEnabled, RightEnabled = Mode.LeftWingsEnabled, Mode.RightWingsEnabled

			Color1, Color2 = Mode.Color1, Mode.Color2

			TweenCustomiseColor(Color1, Wings, style.Sine, dir.In, .3)

			SetWingEnabled(Wings, "Left", LeftEnabled) SetWingEnabled(Wings, "Right", RightEnabled)
			SetWingCount(Wings, Mode.WingCount)

			normalTween(Core.Main, style.Sine, dir.In, .3, {Color = Color1})
			normalTween(Core.Second, style.Sine, dir.In, .3, {Color = c30})
			normalTween(textlabel, style.Sine, dir.In, .3, {TextColor3 = Color1, TextStrokeColor3 = Color2})

			normalTween(Core.Main.a.PointLight, style.Sine, dir.In, .3, {Color = Color1})
			normalTween(Core.Main.b.PointLight, style.Sine, dir.In, .3, {Color = Color1})

			AnimationId = Mode.WingAnimationID
			TextShake = Mode.TextShakeEnabled
			Movetype = Mode.MoveType

			Animation = rq(Mode.Animation).Animate
			CurrentWingAnimation = rq(Mode.WingAnimation).Animate

			FlashEnabled = Mode.ColorFlashEnabled
			FlashTable1 = Mode.ColorFlashMain
			FlashTable2 = Mode.ColorFlashSec

			Cycle0, Cycle1 = #FlashTable1, #FlashTable2
			RandomColorFlash = Mode.RandomColorFlash

			CameraShake = Mode.CameraShake
			Intensity = Mode.ShakeIntensity

			EffectsEnabled = Mode.UsesLegacyEffects
			CurrentEffectTable = Mode.LegacyEffects

			ColorBracelet(LA, Color1, Color2, true)
			ColorBracelet(RA, Color1, Color2, true)
			ColorBracelet(LL, Color1, Color2, true)
			ColorBracelet(RL, Color1, Color2, true)

			Smoke.Enabled = Mode.SmokeEnabled
			Smoke.Drag = Mode.SmokeDrag
			Smoke.Color = cs(Color1)

			sine = 0

			Vars.TextShake.Value = TextShake
			
			if Mode.WingAnimationSpeed then
				WingSpeed = Mode.WingAnimationSpeed
			else
				WingSpeed = 2
			end
			
			if Mode.WingAnimationOffset then
				WingOffset = Mode.WingAnimationOffset
			else
				WingOffset = 0
			end
			
			if Mode.RainbowEnabled then
				tw(.3)
				RainbowEnabled = true
			else
				RainbowEnabled = false
			end

			if Mode.LargeRingEnabled then
				Wings[4].Transparency = 0
				ParticleMod.SetAllParticles(Wings[4], true)
				ParticleMod.ColorAllParticles(Wings[4], cs(Color1))
			else
				Wings[4].Transparency = 1
				ParticleMod.SetAllParticles(Wings[4], false)
			end
			
			if ffc(Character,"p") and ffc(Character,"s") then
				Character.p.Color3 = Color1 Character.s.Color3 = Color1
			end
		end

		local change = cur_mod.Changed:Connect(function(Prop)
			Update()
		end)

		RootPart.CustomPhysicalProperties = prop


		local Joint_Table = {LeftShoulder, RightShoulder, LeftHip, RightHip, Neck, RootJoint}
		local rjo = RootJoint.C1

		local Animations = ReplicatedStorage.Game.Animations

		local Weld = Welding.CreateWeld(Torso, Core.PrimaryPart, zero, cf_0)

		local Walk = rq(Animations.Movement.Walk)
		local Float = rq(Animations.Movement.Float)
		local Jump = rq(Animations.Movement.Walk1.Jump)

		local WalkAnimation, RunAnimation = Walk.WalkAnimate, Walk.RunAnimate
		local FloatAnimation, FloatRunAnimation = Float.FloatAnimate, Float.FloatRunAnimate
		local JumpAnimate, FallAnimate = Jump.JumpAnimate, Jump.FallAnimate
		local Sprint = Item.Sprint

		local Ring = Wings[3]

		local nj1 = Neck.C1
		local lh1, rh1 = LeftHip.C1, RightHip.C1
		local ls1, rs1 = LeftShoulder.C1, RightShoulder.C1
		local Ylevel = 0
		local animations_enabled = true

		local V0, V1 = 0, 0
		local RingWeld = ffcoc(Wings[3],"Motor6D")
		local RingOrigin = RingWeld.C0

		local old_speed = 1
		local ldt = 0

		sp(function()
			while true do
				local dt = Heartbeat:Wait()
				
				ldt = ldt + dt
				
				if animations_enabled and ldt >= (1 / 144) then
					local MoveDir = _hum.MoveDirection
					local Root_Y, Magnitude, Yvel = RootPart.RotVelocity.Y, RootPart.Velocity.Magnitude, RootPart.Velocity.Y
					local dtv = dt * 6
					local mMag = MoveDir.Magnitude
					local globaljointdt = .07 + dtv
					local cur_state = _hum:GetState()
					
					sine = clk()

					RingWeld.C0 = Lerp(RingWeld.C0, RingOrigin * cf(0 + .05 * sin((sine) * 1.5), 0 - .05 * sin((sine + 5.5) * 1.5), 0), .095)

					if TextShake == false then
						textlabel.Rotation = 0 - 5 * sin((sine+2.6) * 2.45)
						billboard.StudsOffset = v3(0 + .95 * sin((sine+5.65) * 2.45), 4.5, 0)
					else
						textlabel.Rotation = 0 - 15 * sin((sine+2.5) * 271)
						billboard.StudsOffset = v3(0 + 2 * sin((sine+5.5) * 251), 4.5 + 1 * sin(sine * 231), 0)
					end

					if mMag == 0 then
						CurrentWingAnimation(Wings, sine, WingSpeed, WingOffset)	
					else
						CurrentWingAnimation(Wings, sine, -2, .5)	
					end				

					if mMag == 0  and Yvel < 5 and Yvel > -5 and (cur_state ~= hst.Jumping and cur_state ~= hst.Freefall) then
						Animation(Joint_Table, sine, .05 + dtv)

						if Movetype == "Float" then
							Ylevel = RootJoint.C0.Y
						end
					end
					
					if mMag > 0  and Yvel < 5 and Yvel > -5 and (cur_state ~= hst.Jumping and cur_state ~= hst.Freefall) then
						if Movetype == "Walk" then
							if not Sprint.Value then
								local speed = clamp(Magnitude / 10, -2 ,2)
								if Root_Y < .1 and Root_Y > -.1 and Yvel < .01 and Yvel > -.01 then
									old_speed = speed
								else
									speed = 1
								end
								
								WalkAnimation(Joint_Table, sine, .13 + dtv, old_speed)
								
							else
								RunAnimation(Joint_Table, sine, .13 + dtv)
							end
						elseif Movetype == "Float" then
							if not Sprint.Value then
								FloatAnimation(Joint_Table, sine, .095 + dtv, Ylevel)
							else
								FloatRunAnimation(Joint_Table, sine, .095 + dtv, Ylevel)
							end
						end
					end

					if Yvel > 5 then
						JumpAnimate(Joint_Table, sine, .065 + dtv)
					elseif Yvel < -5 then
						FallAnimate(Joint_Table, sine, .065 + dtv)
					end
					
					if RainbowEnabled then
						Vars.Color1.Value = rcolor
						Vars.Color2.Value = c30

						CustomiseColor(rcolor, Wings)

						Core.Main.Color = rcolor
						Core.Second.Color = c30
						Core.Main.a.PointLight.Color = rcolor
						Core.Main.b.PointLight.Color = rcolor
						textlabel.TextColor3 = c30 textlabel.TextStrokeColor3 = rcolor

						Smoke.Color = cs(rcolor)

						ColorBracelet(LA, rcolor, c30, false)
						ColorBracelet(RA, rcolor, c30, false)
						ColorBracelet(LL, rcolor, c30, false)
						ColorBracelet(RL, rcolor, c30, false)
					end

					if Yvel > 5 then
						RootJoint.C1 = Lerp(RootJoint.C1, rjo * angles(rad(clamp(Magnitude, -15, 15)), rad(-clamp(Root_Y * 2, -50, 50)), rad(clamp(Root_Y * 3, -40, 40))), globaljointdt)
					else
						RootJoint.C1 = Lerp(RootJoint.C1, rjo * angles(rad(-clamp(Magnitude, -15, 15)), rad(-clamp(Root_Y * 2, -50, 50)), rad(clamp(Root_Y * 3, -40, 40))), globaljointdt)
					end

					Neck.C1 = Lerp(Neck.C1, nj1 * angles(rad(clamp(Root_Y, -30, 30)), 0, rad(clamp(Root_Y, -25, 25))), globaljointdt)

					RightHip.C1 = Lerp(RightHip.C1, rh1 * angles(rad(clamp(Root_Y * 3.5, -25, 25)), rad(-clamp(Root_Y * 2, -20, 20)), 0), globaljointdt)
					LeftHip.C1 = Lerp(LeftHip.C1, lh1 * angles(rad(-clamp(Root_Y * 3.5, -25, 25)), rad(clamp(Root_Y * 2, -20, 20)), 0), globaljointdt)

					LeftShoulder.C1 = Lerp(LeftShoulder.C1, ls1 * angles(rad(clamp(Root_Y * 3.5, -35, 35)), rad(clamp(Root_Y * 3.5, -35, 35)), rad(clamp(Root_Y * 2, -35, 35))), globaljointdt)
					RightShoulder.C1 = Lerp(RightShoulder.C1, rs1 * angles(rad(-clamp(Root_Y * 3.5, -35, 35)), rad(clamp(Root_Y * 3.5, -35, 35)), rad(clamp(Root_Y * 2, -35, 35))), globaljointdt)

					local rayCast = ws:Raycast(RootPart.Position, RootPart.CFrame.UpVector * -100, rcp())
					if (rayCast and Item) then
						cast_Plane.Position = rayCast.Position
						cast_Plane.Orientation = rayCast.Normal + v3(0, RootPart.Orientation.Y, 0)
						
						ground.WorldPosition = rayCast.Position
					end
					
					if CameraShake then
						_hum.CameraOffset = _hum.CameraOffset:Lerp(v3(rand(-Intensity, Intensity) / 10, Ylevel + rand(-Intensity, Intensity) / 11 ,rand(-Intensity, Intensity) / 10), .4)
					end
										
					if ColorSync then
						Beam.Color = cs(Color1)
						Dust.Color = cs(Color1)
					end

					if _hum.Health == 0 then
						LeftArm, RightArm, LeftLeg, RightLeg, Head, Torso = nil, nil, nil, nil, nil, nil
						LeftShoulder, RightShoulder, LeftHip, RightHip, Neck, RootJoint = nil, nil, nil, nil, nil, nil
						Walk, Float, Jump = nil, nil, nil
						WalkAnimation, JumpAnimate, FloatAnimation, FloatRunAnimation, RunAnimation = nil, nil, nil, nil, nil
						change:Disconnect() change = nil
						Wings = nil
						LA:Destroy() RA:Destroy() RL:Destroy() LL:Destroy()
						Core:Destroy()
						Joint_Table=nil
						break
					end
					
					ldt=0
					
					Root_Y = nil
					rayCast = nil
					Magnitude = nil
					Yvel = nil
				end
			end
		end)
		
		local ldt1 = 0
		local del = 0
		sp(function()
			while true do
				tw(1/30)
				local Distance = GetDistanceFromCamera(RootPart.Position)
			
				if EffectsEnabled  then
					for _, v in pr(CurrentEffectTable) do
						if v.Name == "Slash3D"  then
							tw(.04)
						elseif v.Name == "Slash" then
							tw(.02)
						elseif v.Name == "Fire" then
							tw(.02)
						elseif v.Name == "Gen3D" and v.Limited then
							tw(v.LimitedTime)
						end

						InterpVFX(v,del)

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
						Vars.Color1.Value = CurColor1
						Vars.Color2.Value = CurColor2

						CustomiseColor(CurColor1, Wings)

						Core.Main.Color = CurColor1
						Core.Second.Color = CurColor2
						Core.Main.a.PointLight.Color = CurColor1
						Core.Main.b.PointLight.Color = CurColor1
						textlabel.TextColor3 = CurColor1 textlabel.TextStrokeColor3 = CurColor2

						Smoke.Color = cs(CurColor1)

						ColorBracelet(LA, CurColor1, CurColor2, false)
						ColorBracelet(RA, CurColor1, CurColor2, false)
						ColorBracelet(LL, CurColor1, CurColor2, false)
						ColorBracelet(RL, CurColor1, CurColor2, false)
					end

					CurColor1, CurColor2 = nil, nil
				end

				if RandomColorFlash then
					local Color1, Color2 = c3(rand(1,255) / 255, rand(1,255) / 255, rand(1,255) / 255), c3(0, 0, 0)

					CustomiseColor(Color1, Wings)

					Core.Main.Color = Color1
					Core.Second.Color = Color2
					Core.Main.a.PointLight.Color = Color1
					Core.Main.b.PointLight.Color = Color1
					textlabel.TextStrokeColor3 = Color1

					Vars.Color1.Value = Color1

					ColorBracelet(LA, Color1, Color2, false) ColorBracelet(RA, Color1, Color2, false) ColorBracelet(LL, Color1, Color2, false) ColorBracelet(RL, Color1, Color2, false)
				end
				
				if _hum.Health == 0 or Character == nil then
					break
				end
			end
		end)

		Update()
	
		_hum.Died:Once(function()
			normalTween(textlabel, style.Sine, dir.In, 1, {TextColor3 = c30, TextStrokeColor3 = c30, Rotation = 0, TextTransparency = 1, TextStrokeTransparency = 1})
		end)
		
		Core.Parent = Item
		

		sp(function()
			local tickspeed = 3.5

			while tw() do
				if RainbowEnabled then
					local hue = tc() % tickspeed / tickspeed
					rcolor = hsv(hue,1,1) 
				end
			end
		end)
		

		VFX.Name = "VFX"
		Core.Parent = Item
	end
end

for i, v in pr(Storage:GetChildren()) do
	Visual(v)	
end

Storage.ChildAdded:Connect(function(Item)
	Visual(Item)
end)

Settings.RenderDistance.Changed:Connect(function(Value)
	RenderDistance = Value
end)
