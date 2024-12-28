local save = {
    Data = {
        ["Upgrades"] = {
            ["FoodSpawnAmount"] = 1,
            ["GrowthIncrease"] = 10,
            ["Lives"] = 1,
            ["WindowSizeX"] = 400,
            ["WindowSizeY"] = 400
        },
        ["Statistics"] = {
            ["Highscore"] = 0,
            ["TotalGames"] = 0
        }
    }
}

function save:LoadUserData()
    print("Loading user data.")
    love.filesystem.setIdentity("snake-overcomplicated")
    if love.filesystem.getInfo("save.snake") then
        print("Save file found, loading...")
        local data = love.filesystem.read("save.snake")
        local saveData = self:DecodeSaveFile(data)

        for category, table in pairs(saveData) do
            for k, v in pairs(table) do
                self.Data[category][k] = v
            end
        end
    else
        self:SaveUserData()
    end
end

function save:SaveUserData()
    print("Saving user data.")
    love.filesystem.setIdentity("snake-overcomplicated")
    local data = self:EncodeSaveFile()
    love.filesystem.write("save.snake", data)
end

function save:EncodeSaveFile()
    local data = ""

    for category, table in pairs(self.Data) do
        data = data .. category .. ":{"
        for k, v in pairs(table) do
            data = data .. k .. "=" .. v .. ";"
        end
        data = data .. "}|"
    end

    return data
end

function save:DecodeSaveFile(data)
    local decoded = {}
    for category, tableData in data:gmatch("(%w+):{(.-)}|") do
        decoded[category] = {}
        for k, v in tableData:gmatch("(%w+)=(%w+);") do
            decoded[category][k] = tonumber(v) or v
        end
    end
    return decoded
end

return save