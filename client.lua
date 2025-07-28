------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE OTIMIZAÇÃO | FPS ON/OFF
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local FPS_COMMAND = false

RegisterCommand("fps", function(source, args)
    if (not args[1]) then
        TriggerEvent("QBCore:Notify", "Para ativar o sistema de fps, você precisa digitar /fps on/off.", "error")
        return
    end

    if args[1] == "on" then
        FPS_COMMAND = true
        SetTimecycleModifier("cinema") 
        TriggerEvent("QBCore:Notify", "Sistema de fps foi habilitado!", "success")
    elseif args[1] == "off" then
        FPS_COMMAND = false
        SetTimecycleModifier("default")
        TriggerEvent("QBCore:Notify", "Sistema de fps foi desabilitado!", "error")
    else
        TriggerEvent("QBCore:Notify", "Comando inválido. Use /fps on ou /fps off.", "error")
    end
end)

CreateThread(function()
    while true do
        Wait(1000) -- Aguarda um segundo antes de verificar o estado do FPS_COMMAND
        if FPS_COMMAND then
            local idle = 30000
            local ped = PlayerPedId()

            ClearAllHelpMessages()        -- Remove todas as mensagens de ajuda (F9)
            ClearBrief()                  -- Remove mensagens de objetivos/missões
            ClearGpsFlags()               -- Remove rotas e setas do GPS
            ClearPrints()                 -- Remove prints temporários
            ClearSmallPrints()            -- Remove pequenos textos da tela
            ClearReplayStats()            -- Limpa estatísticas de replay
            ClearAllBrokenGlass()         -- Remove efeitos visuais de vidro quebrado
            ClearFloatingHelp()           -- Remove mensagens flutuantes de instrução
            ClearThisPrint()              -- Cancela última mensagem printada
            ClearDrawOrigin()             -- Cancela origem de desenho 3D

            -- HUD E PLACARES
            LeaderboardsReadClearAll()    -- Limpa leitura de placares
            LeaderboardsClearCacheData()  -- Limpa cache de dados de placar

            -- PED (PERSONAGEM DO JOGADOR)
            ClearPedBloodDamage(ped)          -- Remove manchas de sangue
            ClearPedWetness(ped)              -- Remove efeito de molhado
            ClearPedEnvDirt(ped)              -- Remove sujeira do ambiente
            ResetPedVisibleDamage(ped)        -- Remove marcas de danos visíveis
            ResetPedRagdollTimer(ped)         -- Reseta ragdoll (queda corpo mole)
            ResetPedMovementClipset(ped, 0.0) -- Reseta animações de movimento
            ResetPedStrafeClipset(ped)        -- Reseta animação de andar de lado
            ClearPedLastWeaponDamage(ped)     -- Limpa último dano de arma
            ClearPedDecorations(ped)          -- Remove tatuagens temporárias
            ClearPedSecondaryTask(ped)        -- Cancela tarefas secundárias (celular)
            SetPedMoveRateOverride(ped, 1.0)  -- Garante movimento fluido
            SetPedResetFlag(ped, 240, true)   -- Força reset de estado

            -- CLIMA E AMBIENTE
            ClearOverrideWeather()            -- Remove clima forçado
            ClearWeatherTypePersist()         -- Remove clima persistente
            SetRainLevel(0.0)                 -- Remove chuva
            SetWindSpeed(0.0)                 -- Remove vento
            SetWind(0.0)                      -- Remove vento ativo
            SetCloudHatOpacity(0.0)           -- Remove nuvens visuais
            ClearFocus()                      -- Remove foco de câmera forçado
            ClearHdArea()                     -- Libera memória HD
            SetArtificialLightsState(false)   -- Remove luzes artificiais forçadas

            -- SONS E ÁUDIO - REMOVE TODOS OS SONS POSSÍVEIS
            StopAllScreenEffects()                            -- Para efeitos visuais de tela
            StopAudioScenes()                                 -- Para todas as cenas de áudio
            ReleaseAmbientAudioBank()                         -- Libera banco de áudio ambiente
            ReleaseNamedScriptAudioBank("DLC_HEIST_HACKING_SNAKE") -- Libera áudio de script nomeado
            ReleaseScriptAudioBank()                          -- Libera todos os bancos de script
            StopSound(-1)                                     -- Para todos os sons em execução
            CancelMusicEvent("FM_INTRO_START")               -- Cancela música de introdução
            CancelMusicEvent("FM_INTRO_STOP")                -- Cancela música de fim de intro
            CancelMusicEvent("DEATH_FAIL_RESPAWN_SOUNDSET")  -- Cancela música de morte/respawn
            CancelMusicEvent("ASSASSINATIONS_HOTEL_TIMER")   -- Cancela evento de tempo com música
            CancelCurrentPoliceReport()                       -- Cancela rádio policial
            DisablePoliceReports()                            -- Impede relatórios policiais
            SetAudioFlag("PoliceScannerDisabled", true)       -- Desativa rádio policial
            SetAudioFlag("DisableFlightMusic", true)          -- Desativa música de voo
            SetAudioFlag("LoadMPData", false)                 -- Evita carregar dados de áudio do MP
            SetAudioFlag("DisableBarks", true)                -- Silencia NPCs/animais
            SetAudioFlag("WantedMusicDisabled", true)         -- Remove música de procurado
            SetAudioFlag("OnlyAllowScriptTriggerPoliceScanner", true) -- Rádio policial só por script
            SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", false, false) -- Desativa zona de som
            SetAmbientZoneListStatePersistent("AZL_HUD_ZONES", false, false)
            SetAmbientZoneListState("AZL_DLC_Hei4_Island_Disabled_Zones", false, false)
            SetAmbientZoneStatePersistent("AZ_SPECIAL_VEHICLE_TARMAC_LIFT_OFF", false, false)
            SetAmbientZoneStatePersistent("AZ_COUNTRYSIDE_PRISON_01_ANNOUNCER_GENERAL", false, false)
            SetAmbientZoneState("AZ_COUNTRYSIDE_PRISON_01_ANNOUNCER_GENERAL", false, false)
            SetAmbientZoneState("AZ_SPECIAL_VEHICLE_TARMAC_LIFT_OFF", false, false)

            -- TELA E VISUAL
            ClearTimecycleModifier()              -- Remove filtro visual
            SetTransitionTimecycleModifier("")   -- Remove transição de filtro
            ClearExtraTimecycleModifier()        -- Remove efeitos visuais extra
            StopGameplayCamShaking(true)          -- Para tremores de câmera
            StopGameplayHint()                    -- Para dicas visuais
            InvalidateIdleCam()                   -- Impede câmera ociosa
            InvalidateVehicleIdleCam()            -- Impede câmera ociosa no carro

            -- OTIMIZAÇÃO DE STREAMING E RENDER
            SetReducePedModelBudget(true)         -- Reduz uso de memória de peds
            SetReduceVehicleModelBudget(true)     -- Reduz uso de memória de veículos

            -- LOD E DISTÂNCIA
            SetFlashLightFadeDistance(0.0)        -- Remove fade da lanterna
            SetParticleFxLoopedFarClipDist(0.0)   -- Reduz distância de partículas

            -- ÁREA E MEMÓRIA ADICIONAL
            RemoveNamedPtfxAsset("core")          -- Remove asset de partículas
            RemoveParticleFxInRange(0.0, 0.0, 0.0, 5000.0) -- Remove partículas
            RemoveDecalsInRange(GetEntityCoords(ped), 100.0) -- Remove manchas, sangue, pneu

            -- FINALIZAÇÃO
            DisableScreenblurFade()               -- Remove desfoque de tela

            TriggerEvent("")
            Wait(idle)
        end
    end
end)