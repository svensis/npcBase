AddCSLuaFile("cl_init.lua") -- Make sure clientside
AddCSLuaFile("shared.lua") -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/monk.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
    self:SetUseType(SIMPLE_USE) -- Press "USE" to interact with
    self:DropToFloor()
    self:ResetSequenceInfo()
    timer.Simple(0.5, function()
        self:ResetSequenceInfo()
        self:SetSequence("lineidle03")
    end)

    self:DoEyes()
    self:StartSpeaking()
end

function ENT:DoEyes()
    self.delay = 0

    hook.Add("Think", "EyesLook" .. self:EntIndex(), function()
        if not self:IsValid() then return end
        if CurTime() < self.delay then return end

        for p, ply in pairs(player.GetAll()) do
            if (ply:EyePos():Distance(self:EyePos()) <= 110) then
                self:SetEyeTarget(ply:EyePos())
                break
            end
        end

        self.delay = CurTime() + 1.5
    end)
end

function ENT:StartSpeaking()
    self.delay2 = 0

    hook.Add("Think", "StartSpeak" .. self:EntIndex(), function()
        if not self:IsValid() then return end
        if CurTime() < self.delay2 then return end
        NPCSetup(self, "vo/ravenholm/yard_greetings.wav", 4.5, "vo/ravenholm/shotgun_moveon.wav", 5.5)

        function CustomNPCFunction(ply, ent)
            ply:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 255), 0.5, 2)
            ply:Freeze(false)
            ply:SetPos(Vector(1888.898315, -715.093201, -79.968750))
            ply:SetEyeAngles(Angle(-1.231997, 5.484989, 0.000000))
			ply:SetNWBool("DidSpoke" .. self:EntIndex(), true)
        end

        hook.Add("NPCHook_" .. self:GetClass() .. "+" .. self:EntIndex(), "FinishedNPCTalking", CustomNPCFunction)
        self.delay2 = CurTime() + 1
    end)
end

function ENT:OnRemove()
    hook.Remove("EyesLook" .. self:EntIndex())
    hook.Remove("StartSpeak" .. self:EntIndex())
end