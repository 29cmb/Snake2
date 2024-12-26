local ScreenManager = require("screens.ScreenManager")
local images = require("modules.images")

function love.load()
    images:Load()
    ScreenManager:registerAllScreens()
    ScreenManager:showScreen("SnakeLayer")
end

function love.draw()
    ScreenManager:DrawScreens()
end

function love.update(dt)
    ScreenManager:UpdateScreens(dt)
end

function love.keypressed(key)
    ScreenManager:OnKeyPressed(key)
end