local composer = require("composer")

local scene = composer.newScene()

local MARGIN = 90

-- Variáveis para o som
local narracao = audio.loadStream("narracao/audio5.m4a")
local somLigado = true
local somAtivo = nil
local botaosom -- Variável para o botão de som

-- Função para alternar o som
local function alternarSom()
    if somLigado then
        somLigado = false
        if somAtivo then
            audio.stop(somAtivo)
            somAtivo = nil
        end
        botaosom.fill = { type = "image", filename = "assets/Somdesligado.png" } -- Atualiza para imagem de som desligado
    else
        somLigado = true
        somAtivo = audio.play(narracao, { loops = -1 })
        botaosom.fill = { type = "image", filename = "assets/som.png" } -- Atualiza para imagem de som ligado
    end
end

function scene:create(event)
    local sceneGroup = self.view

    local backgroud = display.newImageRect(sceneGroup, "assets/p5.png", 768, 1024)
    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

    local botaoproximo = display.newImage(sceneGroup, "assets/botaoproximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN

    botaoproximo:addEventListener("tap", function(event)
        composer.gotoScene("pagina6", {
            effect = "fade",
            time = 500,
        })
    end)

    -- Botão de som
    botaosom = display.newImageRect(sceneGroup, "assets/som.png", 80, 80)
    botaosom.x = display.contentWidth - botaosom.width / 2 - MARGIN - 540
    botaosom.y = display.contentHeight - botaosom.height - 860
    botaosom:addEventListener("tap", alternarSom) -- Associa o botão ao alternarSom

    local botaoanterior = display.newImage(sceneGroup, "assets/botaoanterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 510
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN + 10

    botaoanterior:addEventListener("tap", function(event)
        composer.gotoScene("pagina4", {
            effect = "fade",
            time = 500,
        })
    end)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Pré-carregar o som se estiver ligado
        if somLigado and not somAtivo then
            somAtivo = audio.play(narracao, { loops = -1 })
        end
    elseif phase == "did" then
        -- Nada adicional aqui
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Parar o som ao sair da cena
        if somAtivo then
            audio.stop(somAtivo)
            somAtivo = nil
        end
    elseif phase == "did" then
        -- Nada adicional aqui
    end
end

function scene:destroy(event)
    local sceneGroup = self.view

    -- Liberar o áudio ao destruir a cena
    if narracao then
        audio.dispose(narracao)
        narracao = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
