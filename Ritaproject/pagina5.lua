local composer = require("composer")

local scene = composer.newScene()

local MARGIN = 90

local function criarEfeitoDePoeira(x, y)
    local poeira = display.newImageRect("assets/poeira.png", 100, 100)
    poeira.x = x
    poeira.y = y
    transition.to(poeira, {
        time = 3000,
        alpha = 0,
        xScale = 2,
        yScale = 2,
        onComplete = function()
            display.remove(poeira)
        end
    })
end

local function criarEfeitoDeCatarro()
    local catarro = display.newImageRect("assets/catarro.png", 80, 80)
    catarro.x = 670
    catarro.y = 264

    local velocidade = math.random(800, 1500) -- Velocidade aleatória entre 800ms e 1500ms
    local deslocamentoX = math.random(-50, 50) -- Deslocamento lateral aleatório

    transition.to(catarro, {
        time = velocidade,
        alpha = 0,
        x = catarro.x + deslocamentoX,
        y = display.contentHeight + 50, -- Faz o catarro cair para fora da tela
        onComplete = function()
            display.remove(catarro)
        end
    })
end

local function criarPoeirasAleatorias()
    for i = 1, 30 do -- Ajuste o número de poeiras aqui
        local x = math.random(0, display.contentWidth)
        local y = math.random(0, display.contentHeight)
        criarEfeitoDePoeira(x, y)
    end
end

local function criarCatarrosFixos()
    for i = 1, 20 do -- Ajuste o número de catarros aqui
        timer.performWithDelay(i * 300, function() -- Atraso entre os catarros
            criarEfeitoDeCatarro()
        end)
    end
end

local function reproduzirSomEspirro()
    local somEspirro = audio.loadSound("assets/espirro.mp3")
    audio.play(somEspirro)
end

local function onAccelerometer(event)
    if math.abs(event.xGravity) > 0.8 or math.abs(event.yGravity) > 0.8 then
        criarPoeirasAleatorias()
        criarCatarrosFixos()
        reproduzirSomEspirro()
    end
end

function scene:create(event)
    local sceneGroup = self.view

    local backgroud = display.newImageRect(sceneGroup, "assets/p5.png", 768, 1024)
    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

    local botaoproximo = display.newImage(sceneGroup, "/assets/botaoproximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN

    botaoproximo:addEventListener("tap", function(event)
        composer.gotoScene("pagina6", {
            effect = "fade",
            time = 500
        })
    end)

    local som = display.newImage(sceneGroup, "/assets/som.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN - 540
    som.y = display.contentHeight - som.height - 860

    local botaoanterior = display.newImage(sceneGroup, "/assets/botaoanterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 510
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN + 10

    botaoanterior:addEventListener("tap", function(event)
        composer.gotoScene("pagina4", {
            effect = "fade",
            time = 500
        })
    end)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        Runtime:addEventListener("accelerometer", onAccelerometer)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        Runtime:removeEventListener("accelerometer", onAccelerometer)
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
