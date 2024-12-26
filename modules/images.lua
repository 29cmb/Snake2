local images = {
    Sprites = { 
        ["heart"] = "images/heart.png" 
    }
}

function images:Load()
    for k, v in pairs(self.Sprites) do
        self.Sprites[k] = love.graphics.newImage(v)
    end
end

return images