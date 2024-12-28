---@diagnostic disable: undefined-field
local MenuLayer = {}
local utils = require("modules.utils")
local images = require("modules.images")
local ScreenManager = require("screens.ScreenManager")
MenuLayer.name = "MenuLayer"
MenuLayer.logoRotation = 0

local buttons = {
    {
        Sprite = images.Sprites["play"],
        x = (love.graphics.getWidth() / 2),
        y = 450,
        hovering = false,
        initialScale = 1.3,
        scale = 1.3,
        clicked = function(this)
            this.hovering = false
            ScreenManager:hideScreen("MenuLayer")
            ScreenManager:showScreen("SnakeLayer")
        end
    },
    {
        Sprite = images.Sprites["upgrades"],
        x = ((love.graphics.getWidth() / 3) * 2) + 30,
        y = 450,
        hovering = false,
        initialScale = 1,
        scale = 1,
        clicked = function(this)
            this.hovering = false
            ScreenManager:hideScreen("MenuLayer")
            ScreenManager:showScreen("UpgradesLayer")
        end
    }
}

function MenuLayer:Load()
    for _,button in pairs(buttons) do
        button.width = button.Sprite:getWidth()
        button.height = button.Sprite:getHeight()
    end
end

function MenuLayer:Activate() end

function MenuLayer:Deactivate() end

function MenuLayer:Draw()
    love.graphics.setBackgroundColor(1,1,1)

    local logo = images.Sprites["logo"]
    local logoWidth = logo:getWidth()
    local logoHeight = logo:getHeight()
    love.graphics.draw(images.Sprites["logo"], (love.graphics.getWidth() / 2), 200, self.logoRotation, 1, 1, logoWidth / 2, logoHeight / 2)

    for _, button in pairs(buttons) do
        love.graphics.draw(button.Sprite, button.x, button.y, 0, button.scale, button.scale, button.width / 2, button.height / 2)
    end
end

function MenuLayer:Update(dt)
    local maxRotation = math.rad(20)
    local minRotation = math.rad(-20)

    self.logoRotation = minRotation + (maxRotation - minRotation) * (math.sin(love.timer.getTime() * 0.5) * 0.5 + 0.5)

    for _, button in pairs(buttons) do
        if button.hovering then
            button.scale = utils:Clamp(button.scale + dt, button.initialScale, button.initialScale + 0.2)
        else
            button.scale = utils:Clamp(button.scale - dt, button.initialScale, button.initialScale + 0.2)
        end
    end
end

function MenuLayer:OnKeyPressed(key) end

function MenuLayer:OnMousePressed(x,y,button)
    for _,button in pairs(buttons) do
        if button.hovering then
            button.clicked(button)
        end
    end
end

function MenuLayer:OnMouseMoved(x, y, dx, dy, istouch) 
    for _,v in pairs(buttons) do
        if utils:CheckCollision(x, y, 1, 1, v.x - v.width / 2, v.y - v.height / 2, v.width, v.height) then
            v.hovering = true
        else
            v.hovering = false
        end
    end
end

return MenuLayer