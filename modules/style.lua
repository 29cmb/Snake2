local style = {}

function style:DropShadow(text, x, y, limit, alignment, distance, angle)
    local offsetX = distance * math.cos(angle)
    local offsetY = distance * math.sin(angle)

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf(text, x + offsetX, y + offsetY, limit, alignment)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf(text, x, y, limit, alignment)
end

return style