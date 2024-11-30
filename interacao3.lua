local composer = require("composer")
local scene = composer.newScene()

local MARGIN = 90

-- Função para verificar colisão
local function hasCollided(obj1, obj2)
    if not (obj1 and obj2) then
        return false
    end
    local left1, left2 = obj1.contentBounds.xMin, obj2.contentBounds.xMin
    local right1, right2 = obj1.contentBounds.xMax, obj2.contentBounds.xMax
    local top1, top2 = obj1.contentBounds.yMin, obj2.contentBounds.yMin
    local bottom1, bottom2 = obj1.contentBounds.yMax, obj2.contentBounds.yMax

    return left1 < right2 and right1 > left2 and top1 < bottom2 and bottom1 > top2
end

local fungo, tratogastrointestinal, vacina1, vacina2

-- Função para espalhar fungos de forma aleatória pelo trato intestinal
local function espalharFungos()
    local tratoWidth = tratogastrointestinal.contentWidth - 50
    local tratoHeight = tratogastrointestinal.contentHeight - 50
    local startX = tratogastrointestinal.x - tratoWidth / 2
    local startY = tratogastrointestinal.y - tratoHeight / 2

    -- Criar fungos pequenos espalhados aleatoriamente
    for i = 1, 15 do -- Número de fungos criados
        local miniFungo = display.newImageRect(scene.view, "assets/fungo.png", 40, 40) -- 20% do tamanho original
        miniFungo.x = math.random(startX, startX + tratoWidth)
        miniFungo.y = math.random(startY, startY + tratoHeight)
    end
end

-- Função de arrastar
local function drag(event)
    local target = event.target

    if event.phase == "began" then
        -- Define o foco no objeto
        display.currentStage:setFocus(target)
        target.isFocus = true

        -- Armazena as posições iniciais do toque
        target.touchOffsetX = event.x - target.x
        target.touchOffsetY = event.y - target.y

    elseif event.phase == "moved" and target.isFocus then
        -- Move o objeto com o toque
        target.x = event.x - target.touchOffsetX
        target.y = event.y - target.touchOffsetY

        -- Verifica colisão com o trato intestinal
        if hasCollided(target, tratogastrointestinal) then
            -- Remove o objeto arrastável
            display.remove(target)
            target = nil
            -- Espalhar fungos no trato intestinal
            espalharFungos()
        end

        -- Verifica colisão com as vacinas
        if hasCollided(target, vacina1) or hasCollided(target, vacina2) then
            -- Remove o objeto arrastável
            display.remove(target)
            target = nil
            -- Recria o fungo na posição inicial
            recreateFungo()
        end

    elseif event.phase == "ended" or event.phase == "cancelled" then
        if target.isFocus then
            -- Libera o foco
            display.currentStage:setFocus(nil)
            target.isFocus = false
        end
    end

    return true
end

-- Função para recriar a imagem arrastável
function recreateFungo()
    fungo = display.newImageRect(scene.view, "assets/fungo.png", 100, 100)
    fungo.x, fungo.y = 387, 688.5

    -- Adiciona o evento de toque à imagem arrastável
    fungo:addEventListener("touch", drag)
end

-- Criação de tela
function scene:create(event)
    local sceneGroup = self.view

    -- Tela de fundo
    local backgroud = display.newImageRect(sceneGroup, "assets/fundo.png", 768, 1024)
    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

    -- Botão de encerrar
    local encerrar = display.newImage(sceneGroup, "assets/encerrar.png")
    encerrar.x = display.contentWidth / 2
    encerrar.y = display.contentHeight - encerrar.height / 2 - MARGIN
    encerrar:addEventListener("tap", function(event)
        composer.removeScene("interacao3")
        composer.gotoScene("pagina3", { effect = "fade", time = 500 })
    end)

    -- Imagem de destino (trato intestinal)
    tratogastrointestinal = display.newImageRect(sceneGroup, "assets/trato-gastrointestinal.png", 200, 200)
    tratogastrointestinal.x, tratogastrointestinal.y = 378, 183

    -- Imagem de vacina 1
    vacina1 = display.newImage(sceneGroup, "assets/agulha.png")
    vacina1.x, vacina1.y = 54, 517.5

    -- Imagem de vacina 2
    vacina2 = display.newImage(sceneGroup, "assets/agulha.png")
    vacina2.x, vacina2.y = 475.5, 504

    -- Cria a primeira imagem arrastável
    recreateFungo()
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código que será executado antes da tela ser exibida
    elseif (phase == "did") then
        -- Código que será executado assim que a tela for exibida
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código que será executado antes da tela sair de exibição
    elseif (phase == "did") then
        -- Código que será executado logo após a tela sair de exibição
    end
end

function scene:destroy(event)
    local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
