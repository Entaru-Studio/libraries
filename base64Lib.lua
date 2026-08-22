local Base64 = {}

local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function Base64.encode(data)
    local bytes = {}
    for i = 1, #data do
        local byte = string.byte(data, i)
        table.insert(bytes, byte)
    end
    
    local result = {}
    local len = #bytes
    
    for i = 1, len, 3 do
        local b1, b2, b3 = bytes[i], bytes[i + 1], bytes[i + 2]
        
        local n = (b1 or 0) * 65536 + (b2 or 0) * 256 + (b3 or 0)
        
        local c1 = math.floor(n / 262144) % 64 + 1
        local c2 = math.floor(n / 4096) % 64 + 1
        local c3 = math.floor(n / 64) % 64 + 1
        local c4 = n % 64 + 1
        
        table.insert(result, chars:sub(c1, c1))
        table.insert(result, chars:sub(c2, c2))
        table.insert(result, chars:sub(c3, c3))
        table.insert(result, chars:sub(c4, c4))
    end
    
    if len % 3 == 1 then
        result[#result] = '='
        result[#result - 1] = '='
    elseif len % 3 == 2 then
        result[#result] = '='
    end
    
    return table.concat(result)
end

function Base64.decode(data)
    data = data:gsub('[^%w%+%/%=]', '')
    
    local result = {}
    local temp = 0
    local count = 0
    
    for i = 1, #data do
        local char = data:sub(i, i)
        
        if char == '=' then
            break
        end
        
        local value = chars:find(char)
        if value then
            value = value - 1
            temp = temp * 64 + value
            count = count + 1
            
            if count == 4 then
                local b1 = math.floor(temp / 65536) % 256
                local b2 = math.floor(temp / 256) % 256
                local b3 = temp % 256
                
                table.insert(result, string.char(b1))
                table.insert(result, string.char(b2))
                table.insert(result, string.char(b3))
                
                temp = 0
                count = 0
            end
        end
    end
    
    if count == 2 then
        temp = temp * 64 * 64
        local b1 = math.floor(temp / 65536) % 256
        table.insert(result, string.char(b1))
    elseif count == 3 then
        temp = temp * 64
        local b1 = math.floor(temp / 65536) % 256
        local b2 = math.floor(temp / 256) % 256
        table.insert(result, string.char(b1))
        table.insert(result, string.char(b2))
    end
    
    return table.concat(result)
end

return Base64