local composer = require( "composer" )
 
local scene = composer.newScene()
 
local MARGIN = 90
 
function scene:create( event )
    local sceneGroup = self.view

    local backgroud = display.newImageRect(sceneGroup, "assets/p5.png", 768, 1024)

    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

    local botaoproximo = display.newImage(sceneGroup, "/assets/botaoproximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width/2 - MARGIN
    botaoproximo.y = display.contentHeight - botaoproximo.height/2 - MARGIN

    botaoproximo:addEventListener("tap", function (event)
        composer.gotoScene("pagina6", {
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
        composer.gotoScene("pagina4", {
            effect = "fade",
            time = 500
        });
        
    end)
    
end
 
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then

    end
end
 
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
 
    end
end
 
 
function scene:destroy( event )
    local sceneGroup = self.view
end
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene