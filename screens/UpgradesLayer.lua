---@diagnostic disable: undefined-field
local UpgradesLayer = {}
local images = require("modules.images")
local utils = require("modules.utils")
UpgradesLayer.name = "UpgradesLayer"

local buttons = {
    {
        Sprite = images.Sprites["healthUpgrade"],
        x = 200,
        y = 250,
        hovering = false,
        initialScale = 1,
        scale = 1,
        clicked = function()
            print("Health upgrade clicked")
        end
    }
}

function UpgradesLayer:Load()
    for _,button in pairs(buttons) do
        button.width = button.Sprite:getWidth()
        button.height = button.Sprite:getHeight()
    end
end

function UpgradesLayer:Activate()

end

function UpgradesLayer:Deactivate()

end

function UpgradesLayer:Draw()
    love.graphics.draw(images.Sprites["upgradesTitle"], love.graphics.getWidth() / 2, 100, 0, 1, 1, images.Sprites["upgradesTitle"]:getWidth() / 2, images.Sprites["upgradesTitle"]:getHeight() / 2)

    for _, button in pairs(buttons) do
        love.graphics.draw(button.Sprite, button.x, button.y, 0, button.scale, button.scale, button.Sprite:getWidth() / 2, button.Sprite:getHeight() / 2)
    end
end

function UpgradesLayer:Update(dt)
    for _, button in pairs(buttons) do
        if button.hovering then
            button.scale = utils:Clamp(button.scale + dt, button.initialScale, button.initialScale + 0.2)
        else
            button.scale = utils:Clamp(button.scale - dt, button.initialScale, button.initialScale + 0.2)
        end
    end
end

function UpgradesLayer:OnKeyPressed(key)

end

function UpgradesLayer:OnMousePressed(x,y,button)
    for _,button in pairs(buttons) do
        if button.hovering then
            button.clicked()
        end
    end
end

function UpgradesLayer:OnMouseMoved(x, y, dx, dy, istouch) 
    for _,v in pairs(buttons) do
        if utils:CheckCollision(x, y, 1, 1, v.x - v.width / 2, v.y - v.height / 2, v.width, v.height) then
            v.hovering = true
        else
            v.hovering = false
        end
    end
end

return UpgradesLayer