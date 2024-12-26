local SnakeLayer = {}
local SNAKE_SPEED = 4.5
local utils = require("modules.utils")

SnakeLayer.name = "SnakeLayer"
SnakeLayer.segments = {}
SnakeLayer.direction = "right"
SnakeLayer.alive = true

-- Variables that can be changed for upgrades when I eventually make that
SnakeLayer.foodSpawnAmount = 1
SnakeLayer.growthIncrease = 10

local foodLocations = {
    {x = 100, y = 100}
}

function SnakeLayer:Load()
    local startX = love.graphics.getWidth() / 2
    local startY = love.graphics.getHeight() / 2
    self.segments = {
        {x = startX, y = startY}
    }
end

function SnakeLayer:Draw()
    love.graphics.setColor(255, 0, 0)
    for _, food in pairs(foodLocations) do
        love.graphics.circle("fill", food.x + 10, food.y + 10, 10)
    end

    if self.alive == false then
        love.graphics.setColor(255, 255, 0)
    else
        love.graphics.setColor(0, 255, 0)
    end

    for _, segment in ipairs(self.segments) do
        love.graphics.rectangle("fill", segment.x + 10, segment.y + 10, 20, 20, 5, 5)
    end

    love.graphics.setColor(255, 255, 255)
end

function SnakeLayer:Update()
    if self.alive == false then return end

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

    if head.x + 20 > love.graphics.getWidth() or head.x < 0 or head.y + 20 > love.graphics.getHeight() or head.y < 0 then
        self.alive = false
    end

    for i, food in ipairs(foodLocations) do
        if utils:CheckCollision(head.x, head.y, 20, 20, food.x, food.y, 20, 20) then
            table.remove(foodLocations, i)
            self:Grow()

            if #foodLocations == 0 then
                for i = self.foodSpawnAmount, 1, -1 do
                    table.insert(foodLocations, 
                        {x = math.random(20, love.graphics.getWidth() - 20), y = math.random(20, love.graphics.getHeight() - 20)}
                    )
                end

            end
            
        end
    end

    for index,segment in pairs(self.segments) do
        if utils:CheckCollision(head.x, head.y, 20, 20, segment.x, segment.y, 20, 20) and index > 11 then
            self.alive = false
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
