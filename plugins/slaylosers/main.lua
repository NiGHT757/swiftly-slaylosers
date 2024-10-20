AddEventHandler("OnPluginStart", function (event)
    config:Create("slaylosers", {
        fix_player_score = true
    })
end)


AddEventHandler("OnRoundEnd", function(event)
    local winner = event:GetInt("winner")
    if winner < 2 then return end

    local counter = 0
    SetTimeout(100, function()
        for i = 0, playermanager:GetPlayerCap() - 1, 1 do
            local player = GetPlayer(i)
            if player ~= nil and player:IsValid() and player:CBasePlayerController().Connected == PlayerConnectedState.PlayerConnected and player:CBaseEntity().TeamNum == (winner == 2 and 3 or 2) and player:CBaseEntity().LifeState == LifeState_t.LIFE_ALIVE then
                player:Kill()
                counter = counter + 1

                if config:Fetch("slaylosers.fix_player_score") then
                    local roundstats = player:CCSPlayerController().ActionTrackingServices.MatchStats.Parent
                    roundstats.Deaths = roundstats.Deaths - 1
                    roundstats.Kills = roundstats.Kills + 1
                end
            end
        end


        if counter == 0 then
            return
        end
        
        for i = 0, playermanager:GetPlayerCap() - 1, 1 do
            local player = GetPlayer(i)
            if player ~= nil and player:IsValid() and player:CBasePlayerController().Connected == PlayerConnectedState.PlayerConnected then
                ReplyToCommand(i, FetchTranslation("slaylosers.prefix", i), FetchTranslation("slaylosers.message", i):gsub("{count}", counter))
            end
        end
        
    end)
end)