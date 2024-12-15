local composer = require("composer")
local scene = composer.newScene() -- Garante que a cena seja inicializada corretamente

local MARGIN = 90

-- Variáveis de controle de áudio
local narracao = audio.loadStream("narracao/audio5.m4a")
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

    local velocidade = math.random(800, 1500)
    local deslocamentoX = math.random(-50, 50)

    transition.to(catarro, {
        time = velocidade,
        alpha = 0,
        x = catarro.x + deslocamentoX,
        y = display.contentHeight + 50,
        onComplete = function()
            display.remove(catarro)
        end
    })
end

local function criarPoeirasAleatorias()
    for i = 1, 30 do
        local x = math.random(0, display.contentWidth)
        local y = math.random(0, display.contentHeight)
        criarEfeitoDePoeira(x, y)
    end
end

local function criarCatarrosFixos()
    for i = 1, 20 do
        timer.performWithDelay(i * 300, function()
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

    botaosom = display.newImageRect(sceneGroup, "assets/som.png", 80,80)
    botaosom.x = display.contentWidth - botaosom.width / 2 - MARGIN - 540
    botaosom.y = display.contentHeight - botaosom.height - 880

    botaosom:addEventListener("tap", alternarSom) -- Evento para alternar som
    atualizarImagemBotaoSom() -- Atualiza a imagem inicial do botão de som

    -- Inicia a narração apenas se o som estiver ligado
    if somLigado then
        somAtivo = audio.play(narracao, { loops = -1 })
    end

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
        -- Remove o listener do acelerômetro
        Runtime:removeEventListener("accelerometer", onAccelerometer)

        -- Para a narração e libera o canal de áudio
        if somAtivo then
            audio.stop(somAtivo)
            somAtivo = nil
        end
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
