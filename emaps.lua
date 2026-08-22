local M = {}

local json = require "json"
local ver, nver = "1.0.0", 1

local mapGroup = display.newGroup();

function M.renderMap(options)
    if not options.map then
        error("options.map == nil", 2)
    elseif not options.listener then
        error("options.listener == nil", 2)
    else
        for i, v in ipairs(options.map) do
            local locpar = v
            if type(locpar[1]) == "table" then
                local obj = display.newRect(locpar[1], locpar[2], locpar[3], locpar[4], locpar[5]);
                options.listener({createdObjects=i, totalObjects=#options.map, object=obj, copyright="© Entaru Studios 2026. All right reserved"})
            else
                local obj = display.newRect(mapGroup, locpar[1], locpar[2], locpar[3], locpar[4]);
                options.listener({createdObjects=i, totalObjects=#options.map, object=obj, copyright="© Entaru Studios 2026. All right reserved"})
            end
        end
    end
end

function M.clearMap()
    display.remove(mapGroup);
end

function M.version()
    print(string.format("Version %s (%s). © Entaru Studios 2026. All rights reserved", ver, nver))
    return nver, ver
end

function M.checkVersion(needver)
    if nver > needver then
        return "newer"
    elseif nver < needver then
        return "older"
    elseif nver == needver then
        return "equal"
    end
end

return M