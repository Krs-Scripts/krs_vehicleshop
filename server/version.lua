CreateThread(function()
    local resource = 'krs_vehicleshop'
    local repo = 'Krs-Scripts/krs_vehicleshop'

    local currentVersion = GetResourceMetadata(resource, 'version', 0)

    lib.versionCheck(repo)

    PerformHttpRequest(('https://api.github.com/repos/%s/releases/latest'):format(repo), function(status, data)
        if status ~= 200 then
            print(('[%s] ^1Unable to check latest version^0'):format(resource))
            return
        end

        local json = json.decode(data)
        if not json or not json.tag_name then return end

        local latestVersion = json.tag_name:gsub('v', '')

        if currentVersion ~= latestVersion then
            print(('[%s] ^3Update available!^0 Current: ^1%s^0 Latest: ^2%s^0'):format(resource, currentVersion, latestVersion))
        else
            print(('[%s] ^2You are using the latest version (%s)^0'):format(resource, currentVersion))
        end
    end, 'GET')
end)