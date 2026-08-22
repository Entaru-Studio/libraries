local sandbox = {}

function sandbox.doCode(code, allowedFunctions, callback)
    local codeFunction = loadstring(code)
    if codeFunction then
        setfenv(codeFunction, allowedFunctions);
        allowedFunctions._G = allowedFunctions
        local isSuccess, err = pcall(codeFunction);
        if isSuccess == true then
            callback({
                status="success"
            })
        else
            callback({
                status="error",
                message = err
            })
        end
    else
        callback({
            status="error",
            message = "code incorrect"
        })
    end
end

function sandbox.version()
    print("Library version: 1.0.0 | © Entaru Studios. 2026")
end

return sandbox