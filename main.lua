local ScreenManager = require("screens.ScreenManager")

function love.load()
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