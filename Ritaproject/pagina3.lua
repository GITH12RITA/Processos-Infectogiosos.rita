local composer = require( "composer" )
 
local scene = composer.newScene()
 
local MARGIN = 90
 
function scene:create( event )
    local sceneGroup = self.view

    local backgroud = display.newImageRect(sceneGroup, "assets/p3.jpeg", 768, 1024)

    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

    local botaoproximo = display.newImage(sceneGroup, "/assets/botaoproximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width/2 - MARGIN
    botaoproximo.y = display.contentHeight - botaoproximo.height/2 - MARGIN

    botaoproximo:addEventListener("tap", function (event)
        composer.gotoScene("pagina4", {
            effect = "fade",
            time = 500
        });
        
    end)

    local som = display.newImage(sceneGroup, "/assets/som.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN - 540
    som.y = display.contentHeight - som.height - 860


    local botaoanterior = display.newImage(sceneGroup, "/assets/botaoanterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width/2 - MARGIN - 510
    botaoanterior.y = display.contentHeight - botaoanterior.height/2 - MARGIN +10

    botaoanterior:addEventListener("tap", function (event)
        composer.gotoScene("pagina2", {
            effect = "fade",
            time = 500
        });

    end)

    local agente = display.newImageRect(sceneGroup, "/assets/agente.png", 186, 191)
    agente.x = 400
    agente.y = 868
    
    agente:addEventListener("tap", function (event)
        composer.gotoScene("interacao3", {
            effect = "fade",
            time = 500
        });

    end)


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
 
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then

    end
end
 
function scene:destroy( event )
    local sceneGroup = self.view
end
 
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
 
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene
