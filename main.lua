local HttpService = game:GetService("HttpService")

local supportedGamesUrl = "https://raw.githubusercontent.com/topraqk11/Helixia-HUB/refs/heads/main/supportedGames"

local success, response = pcall(function()
    return game:HttpGet(supportedGamesUrl)
end)

if not success then
    warn("Supported games list could not be fetched.")
    return
end

local supportedGames = HttpService:JSONDecode(response)

local placeId = game.PlaceId
local foundGame = nil

for _, gameData in ipairs(supportedGames) do
    if tonumber(gameData.placeId) == placeId then
        foundGame = gameData
        break
    end
end

if foundGame and foundGame.url then
    loadstring(game:HttpGet(foundGame.url))()
else
    local HelixiaHUB = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/topraqk11/Helixia-HUB/refs/heads/main/library/source"
    ))()

    HelixiaHUB:Notify({
        Title = "Helixia HUB",
        Message = "This game is not supported yet. Please check back later.",
        Type = "Error",
        Duration = 5
    })
end
