local m = {}

local lfs = require "lfs"
local json = require "json"

function m.write(path, data, mode, directory)
    if not path then
        error("поле path не имеет значения", 2)
    elseif not data then
        error("поле data не имеет значения", 2)
    else
        local function gm()
            if mode ~= 2 then
                return "w"
            else
                return "wb"
            end
        end
        local file = io.open(system.pathForFile(path, directory or system.DocumentsDirectory), gm())
        if file then
            file:write(data)
            file:close()
            return true
        else
            return false
        end
    end
end

function m.read(path, mode, directory)
    if not path then
        error("поле path не имеет значения", 2)
    else
        local function gm()
            if mode ~= 2 then
                return "r"
            else
                return "rb"
            end
        end
        local file = io.open(system.pathForFile(path, directory or system.DocumentsDirectory), gm())
        if file then
            local data = file:read("*a")
            file:close()
            return true, data
        else
            return false
        end
    end
end

function m.rename(path, newPath, directory)
    if not path then
        error("поле path не имеет значения", 2)
    elseif not newPath then
        error("поле newPath не имеет значения", 2)
    else
        local oldPath = system.pathForFile(path, directory or system.DocumentsDirectory)
        local newPath = system.pathForFile(newPath, directory or system.DocumentsDirectory)
        local result, reason = os.rename(oldPath, newPath)
        if result then
            return true
        else
            return false, reason
        end
    end
end

function m.remove(path, directory)
    if not path then
        error("поле path не имеет значения", 2)
    else
        local fullPath = system.pathForFile(path, directory or system.DocumentsDirectory)
        local table = lfs.attributes(fullPath)
        if table and table.mode == "file" then
            local result, reason = os.remove(fullPath)
            if result then
                return true
            else
                return false, reason
            end
        elseif table and table.mode == "directory" then
            local function delInside(path)
                for file in lfs.dir(path) do
                    if file ~= "." and file ~= ".." then
                        local fullPathOther = path .. "/" .. file
                        local attributes = lfs.attributes(fullPathOther)
                        if attributes.mode == "file" then
                            os.remove(fullPathOther)
                        elseif attributes.mode == "directory" then
                            delInside(fullPathOther)
                            lfs.rmdir(fullPathOther)
                        end
                    end
                end
            end
            delInside(fullPath)
            lfs.rmdir(fullPath)
        elseif table then
            return false, "неизвестный тип файла"
        else
            return false, "файл не найден"
        end
        print(json.prettify( table ))
    end 
end

function m.folder(path, folderName, directory)
    if not path then
        error("поле path не имеет значения", 2)
    elseif not folderName then
        error("поле folderName не имеет значения", 2)
    else
        local fullPath = system.pathForFile(path, directory or system.DocumentsDirectory) .. "/" .. folderName
        local result, reason = lfs.mkdir(fullPath)
        if result then
            return true
        else
            return false, reason
        end
    end
end

function m.list(path, directory)
    local template = {dir={}, files={}, unk={}}
    for file in lfs.dir(system.pathForFile(path, directory or system.DocumentsDirectory)) do
        if file ~= "." and file ~= ".." then
            local fullPath = system.pathForFile(path, directory or system.DocumentsDirectory) .. "/" .. file
            local attributes = lfs.attributes(fullPath)
            if attributes.mode == "file" then
                template.files[#template.files + 1] = file
            elseif attributes.mode == "directory" then
                template.dir[#template.dir + 1] = file
            else
                template.unk[#template.unk + 1] = file
            end
        end
    end
    return template
end

-- ENTARU STUDIO 2026
-- VERSION 1.0

return m