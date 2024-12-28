local images = {
    Sprites = { 
        ["heart"] = "images/heart.png",
        ["logo"] = "images/logo.png",
        ["play"] = "images/play.png",
        ["upgrades"] = "images/upgrades.png",
        ["upgradesTitle"] = "images/UpgradesTitle.png",
        ["healthUpgrade"] = "images/health_upgrade.png",
        ["back"] = "images/back.png"
    }
}

function images:Load()
    for k, v in pairs(self.Sprites) do
        self.Sprites[k] = love.graphics.newImage(v)
    end
end

return images