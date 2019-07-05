CodexUI = {
    ["cache"] = {},
    ["backdrop"] = {
        backgroundFile = "Interface\\BUTTONS\\WHITE8X8", tile = false, tileSize = 0,
        edgeFile = "Interface\\BUTTONS\\WHITE8X8", edgeSize = 1,
        border = {left = -1, right = -1, top = -1, bottom = -1},
    },
    ["backdropSmall"] = {
        backgroundFile = "Interface\\BUTTONS\\WHITE8X8", tile = false, tileSize = 0,
        edgeFile = "Interface\\BUTTONS\\WHITE8X8", edgeSize = 1,
        border = {left = 0, right = 0, top = 0, bottom = 0},
    },
    ["defaultFont"] = "Fonts\\ARIALN.TTF",
    ["defaultFontSize"] = 12,
    ["defaultBorderBackground"] = "0,0,0,1",
    ["defaultBorderColor"] = "0.2,0.2,0.2,1",
    ["defaultBorderSize"] = "3",
}

function CodexUI:strsplit(delimiter, data)
    if not data then return nil end
    local delimiter, fields = delimiter or ":", {}
    local pattern = string.format("([^%s]+)", delimiter)
    string.gsub(data, pattern, function(c) fields[table.getn(fields) + 1] = c end)
    return unpack(fields)
end

local sanitizeCache = {}
function CodexUI:SanitizePattern(pattern)
    if not sanitizeCache[pattern] then
        local result = pattern

        -- escape magic characters
        result = gsub(result, "([%+%-%*%(%)%?%[%]%^])", "%%%1")
        -- remove capture indexes
        result = gsub(result, "%d%$","")
        -- catch all characters
        result = gsub(result, "(%%%a)","%(%1+%)")
        -- convert all %s to .+
        result = gsub(result, "%%s%+",".+")
        -- set priority to number over strings
        result = gsub(result, "%(.%+%)%(%%d%+%)","%(.-%)%(%%d%+%)")

        sanitizeCache[pattern] = result
    end

    return sanitizeCache[pattern]
end

function CodexUI:CreateBackdrop(frame, border, transp)
    if not frame then return end

    local borderSize = border
    if not borderSize then
        borderSize = tonumber(CodexUI.defaultBorderSize)
    end

    if not CodexUI.cache.br then
        local br, bg, bb, ba = CodexUI:strsplit(",", CodexUI.defaultBorderBackground)
        local er, eg, eb, ea = CodexUI:strsplit(",", CodexUI.defaultBorderColor)
        CodexUI.cache.br, CodexUI.cache.bg, CodexUI.cache.bb, CodexUI.cache.ba = br, bg, bb, ba 
        CodexUI.cache.er, CodexUI.cache.eg, CodexUI.cache.eb, CodexUI.cache.ea = er, eg, eb, ea
    end

    local br, bg, bb, ba = CodexUI.cache.br, CodexUI.cache.bg, CodexUI.cache.bb, CodexUI.cache.ba
    local er, eg, eb, ea = CodexUI.cache.er, CodexUI.cache.eg, CodexUI.cache.eb, CodexUI.cache.ea
    if transp then ba = transp end

    frame:SetBackdrop(CodexUI.backdrop)
    frame:SetBackdropColor(br, bg, bb, ba)
    frame:SetBackdropBorderColor(er, eg, eb, ea)
    return
end