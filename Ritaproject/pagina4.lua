local composer = require("composer")
local scene = composer.newScene()

local MARGIN = 90

-- Variáveis para o som
local narracao = audio.loadStream("narracao/audio4.m4a")
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
        botaosom.fill = { type = "image", filename = "/assets/Somdesligado.png" } -- Atualiza para imagem de som desligado
    else
        somLigado = true
        somAtivo = audio.play(narracao, { loops = -1 })
        botaosom.fill = { type = "image", filename = "/assets/som.png" } -- Atualiza para imagem de som ligado
    end
end

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

    -- Imagem do ferida
    local ferida = display.newImageRect(sceneGroup, "assets/ferida.png", 45, 45)
    ferida.x = display.contentCenterX + 273
    ferida.y = display.contentCenterY - 130

    -- Imagem do corte
    local corte = display.newImageRect(sceneGroup, "assets/corte.png", 40, 45)
    corte.x = display.contentCenterX + 175
    corte.y = display.contentCenterY + 45

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
    criarPonto(grupoVerde, homem.x, homem.y - 200, "verde") -- Boca
    criarPonto(grupoVerde, homem.x, homem.y - 220, "verde") -- Nariz
    criarPonto(grupoVerde, homem.x - 15, homem.y - 240, "verde") -- Olhos
    criarPonto(grupoVerde, homem.x + 20, homem.y - 240, "verde") -- Olhos
    criarPonto(grupoVerde, homem.x, homem.y - 80, "verde") -- Estômago
    criarPonto(grupoVerde, homem.x, homem.y - 10, "verde") -- Trato urinário
    criarPonto(grupoVerde, homem.x - 20, homem.y + 40, "verde") -- Corte na perna
    criarPonto(grupoVerde, homem.x + 80, homem.y - 120, "verde") -- Braço

    -- Criando pontos amarelos (portas de saída)
    criarPonto(grupoAmarelo, homem.x, homem.y - 220, "amarelo") -- Nariz
    criarPonto(grupoAmarelo, homem.x, homem.y - 200, "amarelo") -- Boca
    criarPonto(grupoAmarelo, homem.x - 20, homem.y + 40, "amarelo") -- Corte na perna
    criarPonto(grupoAmarelo, homem.x, homem.y - 10, "amarelo") -- Trato urinário
    criarPonto(grupoAmarelo, homem.x + 80, homem.y - 120, "amarelo") -- Braço

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
            time = 500,
        })
    end)

    -- Botão Som
    botaosom = display.newImageRect(sceneGroup, "/assets/som.png", 80, 80)
    botaosom.x = display.contentWidth - botaosom.width / 2 - MARGIN - 540
    botaosom.y = display.contentHeight - botaosom.height - 860
    botaosom:addEventListener("tap", alternarSom)

    -- Botão Anterior
    local botaoanterior = display.newImage(sceneGroup, "/assets/botaoanterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 510
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN + 10
    botaoanterior:addEventListener("tap", function(event)
        composer.gotoScene("pagina3", {
            effect = "fade",
            time = 500,
        })
    end)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "did" then
        if somLigado and not somAtivo then
            somAtivo = audio.play(narracao, { loops = -1 })
        end
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        if somAtivo then
            audio.stop(somAtivo)
            somAtivo = nil
        end
    end
end

function scene:destroy(event)
    local sceneGroup = self.view

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
