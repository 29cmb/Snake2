local ScreenManager = {}
local utils = require("modules.utils")
ScreenManager.screens = {}
ScreenManager.currentScreens = {}

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
        if utils:TableFind(self.currentScreens, v) then 
            v:Draw()
        end
    end
end

function ScreenManager:UpdateScreens(dt)
    for i,v in pairs(self.screens) do
        if utils:TableFind(self.currentScreens, v) then 
            v:Update(dt)
        end
    end
end

function ScreenManager:OnKeyPressed(key)
    for i,v in pairs(self.screens) do
        if utils:TableFind(self.currentScreens, v) then 
            v:OnKeyPressed(key)
        end
    end
end

function ScreenManager:showScreen(screenName)
    for i,v in pairs(self.screens) do
        if v.name == screenName then
            table.insert(self.currentScreens, v)
            v:Activate()
            print("Showing screen: " .. screenName)
            return
        end
    end

    warn("Screen not found: " .. screenName)
end

function ScreenManager:hideScreen(screenName)
    for i,v in pairs(self.screens) do
        if v.name == screenName then
            table.remove(self.currentScreens, utils:TableFind(self.currentScreens, v))
            v:Deactivate()
            print("Hiding screen: " .. screenName)
            return
        end
    end

    warn("Screen not found: " .. screenName)
end

return ScreenManager