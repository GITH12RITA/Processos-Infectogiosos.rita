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
    local homem = display.newImageRect(sceneGroup, "assets/homem.png", 340, 600)
    homem.x = display.contentCenterX + 200
    homem.y = display.contentCenterY

    -- Imagem do Homem
        local ferida = display.newImageRect(sceneGroup, "assets/ferida.png", 45,45)
        ferida.x = display.contentCenterX +273
        ferida.y = display.contentCenterY -130

        -- Imagem do Homem
    local corte = display.newImageRect(sceneGroup, "assets/corte.png", 40, 45)
    corte.x = display.contentCenterX +175
    corte.y = display.contentCenterY+ 45

    -- Grupos para pontos verdes e amarelos
    local grupoVerde = display.newGroup()
    local grupoAmarelo = display.newGroup()
    sceneGroup:insert(grupoVerde)
    sceneGroup:insert(grupoAmarelo)

    -- Função para criar pontos
    local function criarPonto(grupo, x, y, cor)
        local ponto = display.newCircle(grupo, x, y, 10)
        if cor == "verde" then
            ponto:setFillColor(0, 45, 0) -- Cor verde
        elseif cor == "amarelo" then
            ponto:setFillColor(45, 45, 0) -- Cor amarela
        end
    end

    -- Criando pontos verdes (portas de entrada)
    criarPonto(grupoVerde, homem.x, homem.y - 200, "verde") --boca
    criarPonto(grupoVerde, homem.x, homem.y - 220, "verde") -- Nariz
    criarPonto(grupoVerde, homem.x -15, homem.y - 240, "verde") -- Olhos
    criarPonto(grupoVerde, homem.x +20, homem.y - 240, "verde") -- Olhos
    criarPonto(grupoVerde, homem.x, homem.y -80, "verde") -- Estômago
    criarPonto(grupoVerde, homem.x, homem.y -10, "verde") -- Trato urinário
    criarPonto(grupoVerde, homem.x -20, homem.y +40, "verde") -- Corte na perna
    criarPonto(grupoVerde, homem.x + 80 , homem.y -120, "verde") -- braço


    -- Criando pontos amarelos (portas de saída)
    criarPonto(grupoAmarelo, homem.x, homem.y - 220, "amarelo") -- Nariz
    criarPonto(grupoAmarelo, homem.x, homem.y - 200, "amarelo") -- boca
    criarPonto(grupoAmarelo, homem.x-20, homem.y +40, "amarelo") -- corte na perna
    criarPonto(grupoAmarelo, homem.x, homem.y - 10, "amarelo") -- Trato urinário
    criarPonto(grupoAmarelo, homem.x + 80, homem.y - 120, "amarelo") -- braço

    -- Inicialmente, ambos os grupos de pontos estão invisíveis
    grupoVerde.isVisible = false
    grupoAmarelo.isVisible = false

    -- Botão Verde (Portas de Entrada)
    local botaoVerde = display.newCircle(sceneGroup, display.contentCenterX + 200, display.contentCenterY - 420, 40)
    botaoVerde:setFillColor(0, 45, 0) -- Cor verde
    botaoVerde:addEventListener("tap", function()
        print("Botão verde pressionado: Porta de entrada")
        grupoVerde.isVisible = true
        grupoAmarelo.isVisible = false
    end)

    -- Botão Amarelo (Portas de Saída)
    local botaoAmarelo = display.newCircle(sceneGroup, display.contentCenterX + 100, display.contentCenterY - 420, 40)
    botaoAmarelo:setFillColor(45, 45, 0) -- Cor amarela
    botaoAmarelo:addEventListener("tap", function()
        print("Botão amarelo pressionado: Porta de saída")
        grupoVerde.isVisible = false
        grupoAmarelo.isVisible = true
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
