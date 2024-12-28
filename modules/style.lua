local style = {}

function style:DropShadow(text, x, y, textColor, limit, alignment, distance, angle)
    local offsetX = distance * math.cos(angle)
    local offsetY = distance * math.sin(angle)

    love.graphics.setColor(0,0,0)
    love.graphics.printf(text, x + offsetX, y + offsetY, limit, alignment)
    love.graphics.setColor(textColor.r, textColor.g, textColor.b)
    love.graphics.printf(text, x, y, limit, alignment)
end

return style