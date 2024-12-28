local ScreenManager = require("screens.ScreenManager")
local images = require("modules.images")
local save = require("modules.save")

function love.load()
    love.window.setIcon(love.image.newImageData("/images/icon.png"))
    love.window.setTitle("Snake: Overcomplicated Edition")
    save:LoadUserData()
    images:Load()
    ScreenManager:registerAllScreens()
    ScreenManager:showScreen("MenuLayer")
end

function love.quit()
    save:SaveUserData()
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

function love.mousepressed(x, y, button)
    ScreenManager:OnMousePressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
    ScreenManager:OnMouseMoved(x, y, dx, dy, istouch)
end