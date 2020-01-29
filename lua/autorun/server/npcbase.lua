-- Here is example usage, you have to call it in loop. 
-- NPCSetup(self, "vo/ravenholm/yard_greetings.wav", 4.5, "vo/ravenholm/shotgun_moveon.wav", 5.5)
function NPCSetup(ent, audio, delay, audio2, delay2, teleport, pos, ang)
    for p, ply in pairs(player.GetAll()) do
        if ply:GetMoveType() == MOVETYPE_NOCLIP then continue end
        if ent.IsSpeaking == true then break end

        if ply:GetNWBool("DidSpoke" .. ent:EntIndex()) ~= true and (ply:EyePos():Distance(ent:EyePos()) <= 100) then
            ent.IsSpeaking = true
            local angleEyes = (ent:GetPos() - ply:GetPos()):Angle()
            local angleEyes2 = ent:GetAngles()
            ply:SetEyeAngles(Angle(angleEyes2.p, angleEyes.y, angleEyes2.r))
            ply:Freeze(true)

            timer.Simple(0.5, function()
                ent:EmitSound(audio)

                timer.Simple(delay, function()
                    ent:EmitSound(audio2)
                    file.Write(tostring(ply:SteamID64()) .. "/" .. ent:GetClass() .. ".txt")

                    timer.Simple(delay2, function()
                        hook.Run("NPCHook_" .. ent:GetClass() .. "+" .. ent:EntIndex(), ply, ent)
                    end)
                end)
            end)
        end
    end
end