local SnakeLayer = {}
local SNAKE_SPEED = 4.5
local utils = require("modules.utils")
local style = require("modules.style")
local images = require("modules.images")

SnakeLayer.name = "SnakeLayer"
SnakeLayer.segments = {}
SnakeLayer.direction = "right"
SnakeLayer.maxLives = 10
SnakeLayer.lives = 10
SnakeLayer.alive = true
SnakeLayer.spawnProtectionTicks = 0

-- Variables that can be changed for upgrades when I eventually make that
SnakeLayer.foodSpawnAmount = 1
SnakeLayer.growthIncrease = 10
SnakeLayer.WindowSX = 400
SnakeLayer.WindowSY = 400

local foodLocations = {
    {x = 100, y = 100}
}

function SnakeLayer:Load()
    local startX = love.graphics.getWidth() / 2
    local startY = love.graphics.getHeight() / 2
    self.segments = {
        {x = startX, y = startY}
    }
    self.font24 = love.graphics.newFont(24)
end

function SnakeLayer:Activate()
    love.window.setMode(self.WindowSX, self.WindowSY)
end

function SnakeLayer:Deactivate()
    love.window.setMode(800, 600)
end

function SnakeLayer:Draw()
    love.graphics.setBackgroundColor(18/255, 53/255, 84/255)
    love.graphics.setColor(1, 0, 0)
    for _, food in pairs(foodLocations) do
        love.graphics.rectangle("fill", food.x + 10, food.y + 10, 20, 20, 30)
    end

    if self.alive == false then
        love.graphics.setColor(40/255, 40/255, 40/255)
    else
        if self.spawnProtectionTicks > 0 then
            love.graphics.setColor(1, 1, 0)
        else 
            love.graphics.setColor(0, 1, 0)
        end
    end

    for _, segment in ipairs(self.segments) do
        love.graphics.rectangle("fill", segment.x + 10, segment.y + 10, 20, 20, 5, 5)
    end

    love.graphics.setColor(1, 1, 1)

    -- UI
    love.graphics.setFont(self.font24)
    style:DropShadow("Score: " .. #self.segments - 1, 10, 10, love.graphics.getWidth(), "left", 3, 90)

    for i = 1, self.lives do
        love.graphics.draw(images.Sprites.heart, ((i - 1) * 32) + 9, 40)
    end
end

function SnakeLayer:Update(dt)
    if self.alive == false then return end
    self.spawnProtectionTicks = utils:Clamp(self.spawnProtectionTicks - dt, 0, 2)

    for i = #self.segments, 2, -1 do
        self.segments[i].x = self.segments[i - 1].x
        self.segments[i].y = self.segments[i - 1].y
    end

    local head = self.segments[1]

    if self.direction == "right" then
        head.x = head.x + SNAKE_SPEED
    elseif self.direction == "left" then
        head.x = head.x - SNAKE_SPEED
    elseif self.direction == "up" then
        head.y = head.y - SNAKE_SPEED
    elseif self.direction == "down" then
        head.y = head.y + SNAKE_SPEED
    end

    if (head.x + 20 > love.graphics.getWidth() or head.x < 0 or head.y + 20 > love.graphics.getHeight() or head.y < 0) and self.spawnProtectionTicks == 0 then
        self.lives = self.lives - 1
        if self.lives == 0 then
            self.alive = false
        else
            head.x = love.graphics.getWidth() / 2
            head.y = love.graphics.getHeight() / 2
            self.direction = "right"
            self.spawnProtectionTicks = 2
        end
    end

    for i, food in ipairs(foodLocations) do
        if utils:CheckCollision(head.x, head.y, 20, 20, food.x, food.y, 20, 20) then
            table.remove(foodLocations, i)
            self:Grow()

            if #foodLocations == 0 then
                for i = self.foodSpawnAmount, 1, -1 do
                    table.insert(foodLocations, 
                        {x = math.random(20, love.graphics.getWidth() - 20), y = math.random(30, love.graphics.getHeight() - 100)}
                    )
                end
            end
        end
    end

    for index,segment in pairs(self.segments) do
        if utils:CheckCollision(head.x, head.y, 20, 20, segment.x, segment.y, 20, 20) and index > 11 and self.spawnProtectionTicks == 0 then
            self.lives = self.lives - 1
            if self.lives == 0 then
                self.alive = false
            else
                head.x = love.graphics.getWidth() / 2
                head.y = love.graphics.getHeight() / 2
                self.direction = "right"
                self.spawnProtectionTicks = 2
            end
        end
    end
end

function SnakeLayer:Grow()
    -- Performance?
    -- Maybe.
    for i = self.growthIncrease, 1, -1 do
        local lastSegment = self.segments[#self.segments]
        table.insert(self.segments, {x = lastSegment.x, y = lastSegment.y})
    end
end

function SnakeLayer:OnKeyPressed(key)
    if (key == "right" or key == "d") and self.direction ~= "left" then
        self.direction = "right"
    elseif (key == "left" or key == "a") and self.direction ~= "right" then
        self.direction = "left"
    elseif (key == "up" or key == "w") and self.direction ~= "down" then
        self.direction = "up"
    elseif (key == "down" or key == "s") and self.direction ~= "up" then
        self.direction = "down"
    end
end

return SnakeLayer
