local ScreenManager = {}
ScreenManager.screens = {}
ScreenManager.currentScreen = nil

function ScreenManager:registerAllScreens()
    self:registerScreen(require("screens.SnakeLayer"))
end

function ScreenManager:registerScreen(screen)
    print("Registering screen: " .. screen.name)
    screen:Load()
    table.insert(self.screens, screen)
end

function ScreenManager:DrawScreens()
    for i,v in pairs(self.screens) do
        if v == currentScreen then 
            v:Draw()
        end
    end
end

function ScreenManager:UpdateScreens(dt)
    for i,v in pairs(self.screens) do
        if v == currentScreen then 
            v:Update(dt)
        end
    end
end

function ScreenManager:OnKeyPressed(key)
    for i,v in pairs(self.screens) do
        if v == currentScreen then 
            v:OnKeyPressed(key)
        end
    end
end

function ScreenManager:showScreen(screenName)
    for i,v in pairs(self.screens) do
        if v.name == screenName then
            currentScreen = v
            print("Showing screen: " .. screenName)
            return
        end
    end

    warn("Screen not found: " .. screenName)
end

return ScreenManager