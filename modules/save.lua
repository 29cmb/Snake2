local save = {
    Data = {
        ["Upgrades"] = {
            ["FoodSpawnAmount"] = 1,
            ["GrowthIncrease"] = 10,
            ["Lives"] = 1,
            ["WindowSizeX"] = 400,
            ["WindowSizeY"] = 400
        }
    }
}

local function tableToString(tbl, indent)
    local result = "{\n"
    local nextIndent = indent .. "    "
    for k, v in pairs(tbl) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        if type(v) == "string" then
            v = string.format("%q", v)
        elseif type(v) == "table" then
            v = tableToString(v, nextIndent)
        end
        result = result .. string.format("%s[%s] = %s,\n", nextIndent, k, v)
    end
    result = result .. indent .. "}"
    return result
end

function save:LoadUserData()
    print("Loading user data.")
    love.filesystem.setIdentity("snake-overcomplicated")
    if love.filesystem.getInfo("save.snake") then
        print("Save file found, loading...")
        self.Data = love.filesystem.load("save.snake")()
    else
        self:SaveUserData()
    end
end

function save:SaveUserData()
    print("Saving user data.")
    love.filesystem.setIdentity("snake-overcomplicated")
    love.filesystem.newFile("save.snake")
    love.filesystem.write("save.snake", "return " .. tableToString(self.Data, ""))
end

return save