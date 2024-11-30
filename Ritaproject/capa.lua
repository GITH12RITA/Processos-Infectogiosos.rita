local composer = require("composer")
local scene = composer.newScene()

local MARGIN = 90

-- Variáveis de controle de áudio
local narracao = audio.loadStream("narracao/audio1.m4a")
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

-- Função para criar a cena
function scene:create(event)
    local sceneGroup = self.view

    -- Fundo
    local background = display.newImageRect(sceneGroup, "assets/capa.png", 768, 1024)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Botão "Próximo"
    local botaoproximo = display.newImage(sceneGroup, "assets/botaoproximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN
    botaoproximo:addEventListener("tap", function()
        composer.gotoScene("pagina2", { effect = "fade", time = 500 })
    end)

    -- Botão de som (criação única)
    if not botaosom then
        botaosom = display.newImageRect(sceneGroup, "assets/som.png", 90,90)
        botaosom.x = MARGIN   
        botaosom.y = display.contentHeight - botaosom.height / 2 - MARGIN +10
        botaosom:addEventListener("tap", alternarSom)
    end
    atualizarImagemBotaoSom() -- Garante que o estado visual inicial seja correto
end

-- Função executada ao exibir a cena
function scene:show(event)
    local phase = event.phase

    if (phase == "did") then
        if somLigado and not somAtivo then
            somAtivo = audio.play(narracao, { loops = -1 })
        end
    end
end

-- Função executada ao ocultar a cena
function scene:hide(event)
    local phase = event.phase

    if (phase == "will") then
        if somAtivo then
            audio.stop()
            somAtivo = nil
        end
    end
end

-- Função para destruir a cena
function scene:destroy(event)
    if narracao then
        audio.dispose(narracao)
        narracao = nil
    end
end

-- Adiciona listeners para os eventos da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
