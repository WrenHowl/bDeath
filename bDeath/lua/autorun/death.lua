if CLIENT then
    surface.CreateFont("deathFont", {
        font = "Roboto",
        size = 50,
        weight = 1000
    })

    local deathFont = "deathFont"

    hook.Add("HUDPaint", "HUDDeath", function()
        local ply = LocalPlayer()

        if (ply:Health() <= 0) then        

            draw.SimpleText("YOU'RE DEAD!", deathFont, ScrW() / 2, ScrH() / 2, color_white, TEXT_ALIGN_CENTER)
        
            ply:ScreenFade(SCREENFADE.OUT, Color( 0, 0, 0, 255), 6.5, -1)

            -- Transition
            local shootPos = ply:EyeAngles()
            smoothEye = LerpAngle(0.5 * FrameTime(), (shootPos - Angle(0, 0, 0)), Angle(90, 0, 0))
            ply:SetEyeAngles(smoothEye)

            -- Timer to respawn
            local delay = 2
            local shouldOccur = true 

            if shouldOccur then
                shouldOccur = false 
                timer.Simple(delay, function()
                    ply:Spawn()
                    shouldOccur = true
                end)
            end

            -- Freeze Mouse
            hook.Add("InputMouseApply", "FreezeTurning", function( cmd )
                cmd:SetMouseX( 0 )
                cmd:SetMouseY( 0 )
            
                return true
            end)
        else
            hook.Remove("InputMouseApply", "FreezeTurning")
        end
    end)

elseif SERVER then
    hook.Add("PlayerDeathThink", "DeathRespawnDisable", function (ply)
        return true 
    end)

    hook.Add("PlayerDeathSound", "DeathSoundDisable", function (ply)
        -- Plays Mario
        ply:EmitSound("death_sound.wav")
        return true 
    end) 

    hook.Add("PlayerDeath", "Death", function(vic, wea, att) 
        -- Auto respawn after 9 seconds
        timer.Simple(9, function()
            if (vic:Alive()) then return end
            vic:Spawn()
        end)
    end)
end