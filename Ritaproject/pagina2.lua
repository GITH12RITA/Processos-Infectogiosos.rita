local composer = require("composer")
local scene = composer.newScene()

local MARGIN = 90
local screenWidth = display.contentWidth
local centerX = display.contentCenterX

-- Variáveis de controle de áudio
local narracao = audio.loadStream("narracao/audio2.m4a")
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

-- Armazenar as imagens fixas como principais
local hospImages = {}
local currentIndex = 1
local prevImage, nextImage

-- Atualizar imagens anterior e próxima
local function atualizar(delta)
    currentIndex = currentIndex + delta
    prevImage = hospImages[currentIndex - 1]
    nextImage = hospImages[currentIndex + 1]
end

-- Evento de arrastar as imagens
local function onDrag(event)
    local phase = event.phase
    local target = event.target

    if phase == "began" then
        display.currentStage:setFocus(target)
        target.touchOffsetX = event.x - target.x
    elseif phase == "moved" then
        target.x = event.x - target.touchOffsetX

        if prevImage then prevImage.x = target.x - screenWidth end
        if nextImage then nextImage.x = target.x + screenWidth end
    elseif phase == "ended" or phase == "cancelled" then
        display.currentStage:setFocus(nil)

        if target.x < centerX - 160 and nextImage then
            transition.to(target, { time = 300, x = centerX - screenWidth, onComplete = function() atualizar(1) end })
            transition.to(nextImage, { time = 300, x = centerX })
        elseif target.x > centerX + 160 and prevImage then
            transition.to(target, { time = 300, x = centerX + screenWidth, onComplete = function() atualizar(-1) end })
            transition.to(prevImage, { time = 300, x = centerX })
        else
            transition.to(target, { time = 300, x = centerX })
            if prevImage then transition.to(prevImage, { time = 300, x = centerX - screenWidth }) end
            if nextImage then transition.to(nextImage, { time = 300, x = centerX + screenWidth }) end
        end
    end

    return true
end

function scene:create(event)
    local sceneGroup = self.view

    -- Fundo
    local background = display.newImageRect(sceneGroup, "assets/p2.png", 768, 1024)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Botão de som
    botaosom = display.newImageRect(sceneGroup, "assets/som.png", 90, 90)
    botaosom.x = display.contentWidth - botaosom.width / 2 - MARGIN - 540
    botaosom.y = display.contentHeight - botaosom.height - 860
    botaosom:addEventListener("tap", alternarSom)

    -- Setas
    local seta = display.newImageRect(sceneGroup, "assets/seta.png", 99, 99)
    seta.x = display.contentWidth - seta.width / 2 - 164
    seta.y = display.contentHeight - seta.height / 2 - 240
    seta.rotation = 40

    local seta2 = display.newImageRect(sceneGroup, "assets/seta.png", 99, 99)
    seta2.x = display.contentWidth - seta2.width / 2 - 500
    seta2.y = display.contentHeight - seta2.height / 2 - 240
    seta2.rotation = 310
    seta2.xScale = -1

    -- Adicionar imagens principais
    hospImages[1] = display.newImageRect(sceneGroup, "assets/grup.png", 276, 284)
    hospImages[1].x = display.contentWidth - hospImages[1].width / 2 - 240
    hospImages[1].y = display.contentHeight - hospImages[1].height + 20

    hospImages[2] = display.newImageRect(sceneGroup, "assets/hosp2.png", 160, 160)
    hospImages[2].x = display.contentWidth - hospImages[2].width / 2 - 600
    hospImages[2].y = display.contentHeight - hospImages[2].height / 2 - 160

    hospImages[3] = display.newImageRect(sceneGroup, "assets/hosp3.png", 120, 120)
    hospImages[3].x = display.contentWidth - hospImages[3].width / 2 - 50
    hospImages[3].y = display.contentHeight - hospImages[3].height / 2 - 190

    hospImages[4] = display.newImageRect(sceneGroup, "assets/hosp4.png", 160, 160)
    hospImages[4].x = display.contentWidth - hospImages[4].width / 2 - 5
    hospImages[4].y = display.contentHeight - hospImages[4].height / 2 - 190
    hospImages[4].isVisible = false

    hospImages[5] = display.newImageRect(sceneGroup, "assets/hosp5.png", 160, 160)
    hospImages[5].x = display.contentWidth - hospImages[5].width / 2 - 5
    hospImages[5].y = display.contentHeight - hospImages[5].height / 2 - 190
    hospImages[5].isVisible = false

    local function dragHosp3(event)
        if event.phase == "ended" then
            hospImages[4].isVisible = true
        end
        return true
    end

    hospImages[3]:addEventListener("touch", dragHosp3)

    local function dragHosp4(event)
        if event.phase == "ended" then
            hospImages[5].isVisible = true
        end
        return true
    end

    hospImages[4]:addEventListener("touch", dragHosp4)

    for i = 1, #hospImages do
        hospImages[i]:addEventListener("touch", onDrag)
    end

    atualizar(0)

    -- Botões de navegação
    local botaoproximo = display.newImage(sceneGroup, "assets/botaoproximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN
    botaoproximo:addEventListener("tap", function()
        composer.gotoScene("pagina3", { effect = "fade", time = 500 })
    end)

    local botaoanterior = display.newImage(sceneGroup, "assets/botaoanterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 510
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN + 10
    botaoanterior:addEventListener("tap", function()
        composer.gotoScene("capa", { effect = "fade", time = 500 })
    end)
end

function scene:show(event)
    local phase = event.phase
    if phase == "did" then
        if somLigado and not somAtivo then
            somAtivo = audio.play(narracao, { loops = -1 })
        end
    end
end

function scene:hide(event)
    local phase = event.phase
    if phase == "will" then
        if somAtivo then
            audio.stop(somAtivo)
            somAtivo = nil
        end
    end
end

function scene:destroy(event)
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
