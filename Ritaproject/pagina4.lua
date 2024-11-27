local composer = require("composer")
local scene = composer.newScene()

local MARGIN = 90

function scene:create(event)
    local sceneGroup = self.view

    -- Fundo
    local background = display.newImageRect(sceneGroup, "assets/p4.png", 768, 1024)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Imagem do Homem
    local homem = display.newImageRect(sceneGroup, "assets/homem.png", 340, 600) -- Substitua o caminho da imagem
    homem.x = display.contentCenterX + 200
    homem.y = display.contentCenterY -- Ajuste conforme necessário para centralizar a imagem

    -- Botão Verde (Porta de Entrada)
    local botaoVerde = display.newCircle(sceneGroup, display.contentCenterX +200, display.contentCenterY - 420, 40)
    botaoVerde:setFillColor(0, 1, 0) -- Cor verde
    botaoVerde:addEventListener("tap", function()
        print("Botão verde pressionado: Porta de entrada")
    end)

    -- Botão Amarelo (Porta de Saída)
    local botaoAmarelo = display.newCircle(sceneGroup, display.contentCenterX + 100, display.contentCenterY  -420, 40)
    botaoAmarelo:setFillColor(1, 1, 0) -- Cor amarela
    botaoAmarelo:addEventListener("tap", function()
        print("Botão amarelo pressionado: Porta de saída")
    end)

    -- Botão Próximo
    local botaoproximo = display.newImage(sceneGroup, "/assets/botaoproximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN
    botaoproximo:addEventListener("tap", function(event)
        composer.gotoScene("pagina5", {
            effect = "fade",
            time = 500
        })
    end)

    -- Botão Som
    local som = display.newImage(sceneGroup, "/assets/som.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN - 540
    som.y = display.contentHeight - som.height - 860

    -- Botão Anterior
    local botaoanterior = display.newImage(sceneGroup, "/assets/botaoanterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 510
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN + 10
    botaoanterior:addEventListener("tap", function(event)
        composer.gotoScene("pagina3", {
            effect = "fade",
            time = 500
        })
    end)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código a executar antes de a cena aparecer
    elseif (phase == "did") then
        -- Código a executar após a cena aparecer
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código a executar antes de a cena desaparecer
    elseif (phase == "did") then
        -- Código a executar após a cena desaparecer
    end
end

function scene:destroy(event)
    local sceneGroup = self.view
    -- Código para limpar objetos e listeners da cena
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
