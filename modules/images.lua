local images = {
    Sprites = { 
        ["heart"] = "images/heart.png",
        ["logo"] = "images/logo.png",
        ["play"] = "images/play.png"
    }
}

function images:Load()
    for k, v in pairs(self.Sprites) do
        self.Sprites[k] = love.graphics.newImage(v)
    end
end

return images