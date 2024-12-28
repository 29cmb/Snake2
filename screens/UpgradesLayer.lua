local UpgradesLayer = {}
local images = require("modules.images")
local utils = require("modules.utils")
local upgrades = require("data.upgrades")
local save = require("modules.save")
local style= require("modules.style")
local ScreenManager = require("screens.ScreenManager")
UpgradesLayer.name = "UpgradesLayer"

local upgradeButtons = {
    {
        Sprite = images.Sprites["healthUpgrade"],
        x = 175,
        y = 250,
        hovering = false,
        initialScale = 1,
        scale = 1,
        upgrade = upgrades["Lives"]
    },
    {
        Sprite = images.Sprites["foodSpawnUpgrade"],
        x = 325,
        y = 250,
        hovering = false,
        initialScale = 1,
        scale = 1,
        upgrade = upgrades["FoodSpawn"]
    },
    {
        Sprite = images.Sprites["snakeGrowthUpgrade"],
        x = 475,
        y = 250,
        hovering = false,
        initialScale = 1,
        scale = 1,
        upgrade = upgrades["GrowthIncrease"]
    },
    {
        Sprite = images.Sprites["windowXUpgrade"],
        x = 625,
        y = 250,
        hovering = false,
        initialScale = 1,
        scale = 1,
        upgrade = upgrades["WindowSizeX"]
    },
    {
        Sprite = images.Sprites["windowYUpgrade"],
        x = 175,
        y = 400,
        hovering = false,
        initialScale = 1,
        scale = 1,
        upgrade = upgrades["WindowSizeY"]
    }
}

local buttons = {
    {
        Sprite = images.Sprites["back"],
        x = 75,
        y = 75,
        hovering = false,
        initialScale = 0.8,
        scale = 0.8,
        clicked = function(this)
            this.hovering = false
            ScreenManager:hideScreen("UpgradesLayer")
            ScreenManager:showScreen("MenuLayer")
        end
    }
}

function PurchaseUpgrade(button)
    if 
        (button.upgrade["PricePerLevel"] * save.Data["UpgradeLevels"][button.upgrade["Name"]] <= save.Data["Statistics"]["Points"]) 
        and (save.Data["UpgradeLevels"][button.upgrade["Name"]] < button.upgrade["MaxLevel"])
    then
        save.Data["Statistics"]["Points"] = save.Data["Statistics"]["Points"] - button.upgrade["PricePerLevel"] * save.Data["UpgradeLevels"][button.upgrade["Name"]]
        save.Data["UpgradeLevels"][button.upgrade["Name"]] = save.Data["UpgradeLevels"][button.upgrade["Name"]] + 1
        save.Data["Upgrades"][button.upgrade["SaveKey"]] = button.upgrade["Default"] + (button.upgrade["Increase"] * (save.Data["UpgradeLevels"][button.upgrade["Name"]] - 1))
    end
end

function UpgradesLayer:Load()
    for _,button in pairs(upgradeButtons) do
        button.width = button.Sprite:getWidth()
        button.height = button.Sprite:getHeight()
    end

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
    love.graphics.draw(images.Sprites["upgradesTitle"], love.graphics.getWidth() / 2, 70, 0, 1, 1, images.Sprites["upgradesTitle"]:getWidth() / 2, images.Sprites["upgradesTitle"]:getHeight() / 2)
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(style.font24)
    love.graphics.printf("Points: " .. save.Data["Statistics"]["Points"], 0, 120, love.graphics.getWidth(), "center")
    love.graphics.setColor(1,1,1)
    for _, button in pairs(upgradeButtons) do
        if button.upgrade["PricePerLevel"] * save.Data["UpgradeLevels"][button.upgrade["Name"]] > save.Data["Statistics"]["Points"] or save.Data["UpgradeLevels"][button.upgrade["Name"]] >= button.upgrade["MaxLevel"] then 
            love.graphics.setColor(0.5,0.5,0.5)
        end
        love.graphics.draw(button.Sprite, button.x, button.y, 0, button.scale, button.scale, button.Sprite:getWidth() / 2, button.Sprite:getHeight() / 2)
        love.graphics.setColor(1,1,1)
        love.graphics.setColor(0,1,128/255)

        local priceText = "$" .. button.upgrade["PricePerLevel"] * save.Data["UpgradeLevels"][button.upgrade["Name"]]
        local priceX = button.x - button.width / 2
        local priceY = button.y + 20
        style:Stroke(priceText, priceX, priceY, {r = 54/255, g = 214/255, b = 134/255}, {r = 0, g = 0, b = 0}, button.width, "center")
    end

    for _, button in pairs(upgradeButtons) do
        if button.hovering then
            local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
            local boxWidth, boxHeight = 250, 120
            local padding = 10
            local boxX, boxY = mouseX, mouseY
    
            if mouseX + boxWidth + padding > love.graphics.getWidth() then
                boxX = mouseX - boxWidth - padding
            end
    
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", boxX - 5, boxY - 5, boxWidth + 10, boxHeight + 10, 10, 10)
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.rectangle("fill", boxX, boxY, boxWidth, boxHeight, 10, 10)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(button.upgrade["DisplayName"], boxX + 10, boxY + 10)
            love.graphics.setFont(style.font14)
            love.graphics.printf(button.upgrade["Description"], boxX + 10, boxY + 40, boxWidth - 20, "left")
            love.graphics.printf("Level " .. save.Data["UpgradeLevels"][button.upgrade["Name"]] .. "/" .. button.upgrade["MaxLevel"], boxX - 10, boxY + 100, boxWidth, "right")
        end
    end

    for _, button in pairs(buttons) do
        love.graphics.draw(button.Sprite, button.x, button.y, 0, button.scale, button.scale, button.Sprite:getWidth() / 2, button.Sprite:getHeight() / 2)
    end
end

function UpgradesLayer:Update(dt)
    for _, button in pairs(upgradeButtons) do
        if button.hovering then
            button.scale = utils:Clamp(button.scale + dt, button.initialScale, button.initialScale + 0.2)
        else
            button.scale = utils:Clamp(button.scale - dt, button.initialScale, button.initialScale + 0.2)
        end
    end

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
    for _,button in pairs(upgradeButtons) do
        if button.hovering then
            PurchaseUpgrade(button)
        end
    end

    for _,button in pairs(buttons) do
        if button.hovering then
            button.clicked(button)
        end
    end
end

function UpgradesLayer:OnMouseMoved(x, y, dx, dy, istouch) 
    for _,v in pairs(upgradeButtons) do
        if utils:CheckCollision(x, y, 1, 1, v.x - v.width / 2, v.y - v.height / 2, v.width, v.height) then
            v.hovering = true
        else
            v.hovering = false
        end
    end

    for _,v in pairs(buttons) do
        if utils:CheckCollision(x, y, 1, 1, v.x - v.width / 2, v.y - v.height / 2, v.width, v.height) then
            v.hovering = true
        else
            v.hovering = false
        end
    end
end

return UpgradesLayer