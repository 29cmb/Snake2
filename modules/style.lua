local style = {}
style.font24 = love.graphics.newFont(24)
style.font14 = love.graphics.newFont(14)

function style:DropShadow(text, x, y, textColor, limit, alignment, distance, angle)
    local offsetX = distance * math.cos(angle)
    local offsetY = distance * math.sin(angle)

    love.graphics.setColor(0,0,0)
    love.graphics.printf(text, x + offsetX, y + offsetY, limit, alignment)
    love.graphics.setColor(textColor.r, textColor.g, textColor.b)
    love.graphics.printf(text, x, y, limit, alignment)
    love.graphics.setColor(1,1,1)
end

function style:Stroke(text, x, y, textColor, strokeColor, limit, alignment)
    love.graphics.setColor(strokeColor.r, strokeColor.g, strokeColor.b)
    love.graphics.printf(text, x - 1, y - 1, limit, alignment)
    love.graphics.printf(text, x + 1, y - 1, limit, alignment)
    love.graphics.printf(text, x - 1, y + 1, limit, alignment)
    love.graphics.printf(text, x + 1, y + 1, limit, alignment)
    love.graphics.setColor(textColor.r, textColor.g, textColor.b)
    love.graphics.printf(text, x, y, limit, alignment)
    love.graphics.setColor(1,1,1)
end

return style