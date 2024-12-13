local composer = require("composer")
local scene = composer.newScene()

local MARGIN = 75

-- Variáveis de controle de áudio
local narracao = audio.loadStream("narracao/audio7.m4a")
local somLigado = true
local somAtivo = nil
local botaosom -- Botão de som

-- Função para atualizar a imagem do botão de som
local function atualizarImagemBotaoSom()
    local imagem = somLigado and "assets/som.png" or "assets/somdesligado.png"
    if botaosom then
        botaosom.fill = { type = "image", filename = imagem }
    end
end

-- Função para alternar o estado do som
local function alternarSom()
    if somLigado then
        somLigado = false
        if somAtivo then
            audio.stop(somAtivo)
            somAtivo = nil
        end
    else
        somLigado = true
        somAtivo = audio.play(narracao, { loops = -1 })
    end
    atualizarImagemBotaoSom()
end

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImageRect(sceneGroup, "assets/contracapa.png", 768, 1024)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Botão de som
    botaosom = display.newRect(sceneGroup, display.contentWidth - MARGIN -590, MARGIN, 90, 90)
    botaosom:addEventListener("tap", alternarSom)
    atualizarImagemBotaoSom()

    local botaoanterior = display.newImage(sceneGroup, "assets/botaoanterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 526
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN

    botaoanterior:addEventListener("tap", function(event)
        composer.gotoScene("pagina6", { effect = "fade", time = 500 })
    end)

    local voltartudo = display.newImage(sceneGroup, "assets/voltartudo.png")
    voltartudo.x = display.contentWidth - voltartudo.width / 2 - MARGIN - 20
    voltartudo.y = display.contentHeight - voltartudo.height / 2 - MARGIN

    voltartudo:addEventListener("tap", function(event)
        composer.gotoScene("capa", { effect = "fade", time = 500 })
    end)
end

function scene:show(event)
    local phase = event.phase
    if (phase == "did") then
        -- Reproduzir o som inicial se ativado
        if somLigado then
            somAtivo = audio.play(narracao, { loops = -1 })
        end
    end
end

function scene:hide(event)
    local phase = event.phase
    if (phase == "will") then
        if somAtivo then
            audio.stop(somAtivo)
            somAtivo = nil
        end
    end
end

function scene:destroy(event)
    if somAtivo then
        audio.dispose(narracao)
        somAtivo = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
