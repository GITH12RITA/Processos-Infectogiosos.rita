local composer = require("composer")

local scene = composer.newScene()

local MARGIN = 90

-- Variáveis para o som
local narracao = audio.loadStream("narracao/audio6.m4a")
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
        botaosom.fill = { type = "image", filename = "assets/Somdesligado.png" }
    else
        somLigado = true
        somAtivo = audio.play(narracao, { loops = -1 })
        botaosom.fill = { type = "image", filename = "assets/som.png" }
    end
end

-- Função para adicionar sangue e capturar os parâmetros do evento touch
local function adicionarSangue(event)
    print("Phase: " .. event.phase)
    print("Location: " .. tostring(event.x) .. "," .. tostring(event.y))
    print("Unique touch ID: " .. tostring(event.id))
    print("----------")

    if event.phase == "began" and math.abs(event.x - 649.5) < 50 and math.abs(event.y - 901.5) < 50 then
        local sangue = display.newImageRect(scene.view, "assets/sangue.png", 50, 50)
        sangue.x = 649.5
        sangue.y = 901.5
        print("Sangue adicionado na perna")
    end
    return true
end

function scene:create(event)
    local sceneGroup = self.view

    -- Ativa multitouch
    system.activate("multitouch")

    -- Fundo da tela
    local backgroud = display.newImageRect(sceneGroup, "assets/p6.png", 768, 1024)
    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

    -- Imagem da perna (exemplo)
    local pernaImagem = display.newImageRect(sceneGroup, "assets/imagem.png", 685, 346)
    pernaImagem.x = display.contentCenterX
    pernaImagem.y = display.contentHeight - 350

    -- Adiciona evento de toque ao fundo
    backgroud:addEventListener("touch", adicionarSangue)

    -- Botão próximo
    local botaoproximo = display.newImage(sceneGroup, "assets/botaoproximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN
    botaoproximo:addEventListener("tap", function(event)
        composer.gotoScene("contracapa", { effect = "fade", time = 500 })
    end)

    -- Botão anterior
    local botaoanterior = display.newImage(sceneGroup, "assets/botaoanterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 500
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN
    botaoanterior:addEventListener("tap", function(event)
        composer.gotoScene("pagina5", { effect = "fade", time = 500 })
    end)

    -- Adicionando o botão de som
    botaosom = display.newImage(sceneGroup, "assets/som.png")
    botaosom.x = display.contentWidth - botaosom.width / 2 - MARGIN - 540
    botaosom.y = display.contentHeight - botaosom.height - 860
    botaosom:addEventListener("tap", alternarSom)
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
