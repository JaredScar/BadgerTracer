--- CONFIG ---
webhook = '';



--- CODE ---
function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end
function sendToDiscord(title, msg)
    local embed = {}
    embed = {
        {
            ["color"] = 16711680,
            ["title"] = "**".. title .."**",
            ["description"] = msg,
            ["footer"] = {
                ["text"] = "",
            },
        }
    }
    PerformHttpRequest(webhook, 
    function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end
playerTracker = {}
function GetAllPlayers()
    local players = {}

    for _, i in ipairs(GetPlayers()) do
        table.insert(players, i)    
    end

    return players
end
prefix = '^9[^5BadgerTracer^9] ^3'
AddEventHandler('playerConnecting', function(playerName, deferrals)
    local src = source 
    local ip = ExtractIdentifiers(src).ip 
    if playerTracker[ip] ~= nil then 
        if playerTracker[ip] ~= GetPlayerName(src) then 
            -- Print their name changed to staff 
            local players = GetAllPlayers()
            for i=1, #players do
                if IsPlayerAceAllowed(players[i], 'BadgerTracer.Access') then 
                    TriggerClientEvent('chatMessage', players[i], prefix .. "Player ^1" .. GetPlayerName(src) .. " ^3used to be named ^1" ..
                        playerTracker[ip])
                end
            end
            sendToDiscord('CHANGED NAME ALERT', "Player __" .. GetPlayerName(src) .. "__ used to be named __" ..
                        playerTracker[ip] .. "__")
        end
    end 
    playerTracker[ip] = GetPlayerName(src)
end)