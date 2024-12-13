local composer = require("composer")
local scene = composer.newScene()

local MARGIN = 90

-- Variáveis de controle de áudio
local narracao = audio.loadStream("narracao/audio3.m4a")
local somLigado = true
local somAtivo = nil
local botaosom -- Botão de som

-- Função para atualizar a imagem do botão de som
local function atualizarImagemBotaoSom()
    local imagem = somLigado and "/assets/som.png" or "/assets/somdesligado.png"
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

    -- Fundo
    local backgroud = display.newImageRect(sceneGroup, "assets/p3.jpeg", 768, 1024)
    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

    -- Botão de próximo
    local botaoproximo = display.newImage(sceneGroup, "/assets/botaoproximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN

    botaoproximo:addEventListener("tap", function(event)
        composer.gotoScene("pagina4", {
            effect = "fade",
            time = 500,
        })
    end)

    -- Botão de som
    botaosom = display.newImage(sceneGroup, "/assets/som.png")
    botaosom.x = display.contentWidth - botaosom.width / 2 - MARGIN - 540
    botaosom.y = display.contentHeight - botaosom.height - 860
    botaosom:addEventListener("tap", alternarSom)

    -- Botão de anterior
    local botaoanterior = display.newImage(sceneGroup, "/assets/botaoanterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 510
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN + 10

    botaoanterior:addEventListener("tap", function(event)
        composer.gotoScene("pagina2", {
            effect = "fade",
            time = 500,
        })
    end)

    -- Agente
    local agente = display.newImageRect(sceneGroup, "/assets/agente.png", 186, 191)
    agente.x = 400
    agente.y = 868

    agente:addEventListener("tap", function(event)
        composer.gotoScene("interacao3", {
            effect = "fade",
            time = 500,
        })
    end)

    -- Criar quadrados arrastáveis
    local function createDraggableSquare(event)
        if event.phase == "began" then
            local square = display.newRect(event.x, event.y, 50, 50)
            square:setFillColor(0, 0.5, 1, 0.7)
            square.isTemporary = true

            local function dragSquare(dragEvent)
                if dragEvent.phase == "moved" then
                    square.x = dragEvent.x
                    square.y = dragEvent.y
                elseif dragEvent.phase == "ended" or dragEvent.phase == "cancelled" then
                    print("Coordenadas do quadrado: x=" .. square.x .. ", y=" .. square.y)
                    square:removeSelf()
                    square = nil
                end
            end

            square:addEventListener("touch", dragSquare)
        end
    end

    Runtime:addEventListener("touch", createDraggableSquare)
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
