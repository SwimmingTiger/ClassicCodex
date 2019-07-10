CodexHistory = {}
codexColors = {}
CodexConfig = {
    ["trackingmethod"] = 1,
}

-- default config
codexDefaultConfig = {
    ["trackingMethod"] = 1, -- 1: All Quests  2: Tracked Quests  3: Manual  4: Hide
    ["allQuestGivers"] = "1", -- Show Available Questgivers
    -- ["currentquestgivers"] = "1", -- Show Current Questgiver Nodes
    -- ["showlowlevel"] = "0", -- Show Lowlevel Questgiver Nodes
    -- ["showhighlevel"] = "1", -- Show Level+3 Questgiver Nodes
    -- ["showfestival"] = "1", -- Show Event Questgiver Nodes
    -- ["minimapnodes"] = "1", -- Show MiniMap Nodes
    -- ["cutoutminimap"] = "1", -- Use Cut-Out Minimap Node Icon
    -- ["questlogbuttons"] = "1", -- Show QuestLog Buttons
    -- ["worldmapmenu"] = "1", -- Show WorldMap Menu
    -- ["minimapbutton"] = "1", -- Show MiniMap Button
    -- ["showids"] = "0", -- Show IDs
    -- ["colorbyspawn"] = "1", -- Color Map Nodes By Spawn
    -- ["questlinks"] = "1", -- Enable Quest Links
    -- ["worldmaptransp"] = "1.0", -- WorldMap Node Transparency
    -- ["minimaptransp"] = "1.0", -- MiniMap Node Transparency
    -- ["mindropchance"] = "0", -- Minimum Drop Chance
}

function setDefaults()
    print("hello")
end

function textFactory(parent, value, size)
    local text = parent:CreateFontString(nil, "ARTWORK")
    text:SetFont("Fonts/FRIZQT__.ttf", size)
    text:SetJustifyV("CENTER")
    text:SetJustifyH("CENTER")
    text:SetText(value)
    return text
end

function checkboxFactory(parent, name, description, onClick)
    local checkbox = CreateFrame("CheckButton", name, parent, "ChatConfigCheckButtonTemplate")
    getglobal(checkbox:GetName() .. "Text"):SetText(name)
    checkbox.tooltip = description
    checkbox:SetScript("OnClick", function(self)
        onClick(self)
    end)
    checkbox:SetScale(1.1)
    return checkbox
end

function editBoxFactory(parent, name, width, height, onEnter)
    local editBox = CreateFrame("EditBox", nil, parent)
    editBox.title_text = textFactory(editBox, name, 12)
    editBox.title_text:SetPoint("TOP", 0, 12)
    editBox:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 26,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4}
    })
    editBox:SetBackdropColor(0,0,0,1)
    editBox:SetSize(width, height)
    editBox:SetMultiLine(false)
    editBox:SetAutoFocus(false)
    editBox:SetMaxLetters(6)
    editBox:SetJustifyH("CENTER")
	editBox:SetJustifyV("CENTER")
    editBox:SetFontObject(GameFontNormal)
    editBox:SetScript("OnEnterPressed", function(self)
        onEnter(self)
        self:ClearFocus()
    end)
    editBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    return editBox
end

function allQuestGiversOnClick()
    print("bonjour")
end

function createConfigPanel(parent)
    local config = CreateFrame("Frame", nil, parent)
    local settings = 0

    -- Title
    config.titleText = textFactory(config, "Configuration", 20)
    config.titleText:SetPoint("TOPLEFT", 0, 0)
    config.titleText:SetTextColor(1, 0.9, 0, 1)
    
    -- All Quest Givers
    config.allQuestGiversCheckbox = checkboxFactory(config, " All Quest Givers", "Display Available Questgivers", allQuestGiversOnClick)
    config.allQuestGiversCheckbox:SetPoint("TOPLEFT", 10, -35)

    return config
end

codexConfig = CreateFrame("Frame", "codexConfig", UIParent)
codexConfig.name = "Classic Codex"
codexConfig.default = setDefaults
InterfaceOptions_AddCategory(codexConfig)

local scrollFrame = CreateFrame("ScrollFrame", nil, codexConfig)
scrollFrame:SetPoint('TOPLEFT', 5, -5)
scrollFrame:SetPoint('BOTTOMRIGHT', -5, 5)
scrollFrame:EnableMouseWheel(true)
scrollFrame:SetScript('OnMouseWheel', function(self, direction)
    if direction == 1 then
        scrollValue = math.max(self:GetVerticalScroll() - 50, 1)
        self:SetVerticalScroll(scrollValue)
        self:GetParent().scrollBar:SetValue(scrollValue) 
    elseif direction == -1 then
        scrollValue = math.min(self:GetVerticalScroll() + 50, 250)
        self:SetVerticalScroll(scrollValue)
        self:GetParent().scrollBar:SetValue(scrollValue)
    end
end)
codexConfig.scrollFrame = scrollFrame

local scrollBar = CreateFrame("Slider", nil, scrollFrame, "UIPanelScrollBarTemplate")
scrollBar:SetPoint("TOPLEFT", codexConfig, "TOPRIGHT", -20, -20) 
scrollBar:SetPoint("BOTTOMLEFT", codexConfig, "BOTTOMRIGHT", -20, 20) 
scrollBar:SetMinMaxValues(1, 250) 
scrollBar:SetValueStep(1) 
scrollBar.scrollStep = 1 
scrollBar:SetValue(0) 
scrollBar:SetWidth(16) 
scrollBar:SetScript("OnValueChanged", function (self, value)
    self:GetParent():SetVerticalScroll(value) 
end) 
local scrollBackground = scrollBar:CreateTexture(nil, "BACKGROUND") 
scrollBackground:SetAllPoints(scrollBar) 
scrollBackground:SetColorTexture(0, 0, 0, 0.6) 
codexConfig.scrollBar = scrollBar

local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(1, 1)
scrollFrame.content = content
scrollFrame:SetScrollChild(content)
-- Add main panel
content.panel = createConfigPanel(content)
content.panel:SetPoint("TOPLEFT", 10, -10)
content.panel:SetSize(1, 1)




-- codexConfig = CreateFrame("Frame", "codexConfig", UIParent)
-- codexConfig:Hide()
-- codexConfig:SetWidth(280)
-- codexConfig:SetHeight(440)
-- codexConfig:SetPoint("CENTER", 0, 0)
-- codexConfig:SetFrameStrata("TOOLTIP")
-- codexConfig:SetMovable(true)
-- codexConfig:EnableMouse(true)
-- codexConfig:RegisterEvent("ADDON_LOADED")
-- codexConfig:SetScript("OnEvent", function()
--     if arg1 == "ClassicCodex" then
--         codexConfig:LoadConfig()
--         -- codexConfig:MigrateHistory()

--         codexConfig:CreateConfigEntry("allQuestGivers", "Display Available Questgivers", "checkbox")

--         -- if pfBrowserIcon and pfQuest_config["minimapbutton"] == "0" then
--         --     pfBrowserIcon:Hide()
--         -- end
--     end
-- end)

-- codexConfig:SetScript("OnMouseDown", function() 
--     codexConfig:StartMoving()
-- end)

-- codexConfig:SetScript("OnMouseUp", function()
--     codexConfig:StopMovingOrSizing()
-- end)

-- codexConfig.vpos = 30

-- CodexUI:CreateBackdrop(codexConfig, nil, 0.75)
-- table.insert(UISpecialFrames, "codexConfig")

-- codexConfig.title = codexConfig:CreateFontString("Status", "LOW", "GameFontNormal")
-- codexConfig.title:SetFontObject(GameFontWhite)
-- codexConfig.title:SetPoint("TOP", codexConfig, "TOP", 0, -8)
-- codexConfig.title:SetJustifyH("LEFT")
-- codexConfig.title:SetFont(CodexUI.defaultFont, 14)
-- codexConfig.title:SetText("|cff33ffccpf|rQuest " .. "Config")

-- codexConfig.close = CreateFrame("Button", "codexConfigClose", codexConfig)
-- codexConfig.close:SetPoint("TOPRIGHT", -5, -5)
-- codexConfig.close:SetHeight(12)
-- codexConfig.close:SetWidth(12)
-- codexConfig.close.texture = codexConfig.close:CreateTexture("pfQuestionDialogCloseTex")
-- codexConfig.close.texture:SetTexture("Interface\\Addons\\ClassicCodex\\img\\close.tga")
-- codexConfig.close.texture:ClearAllPoints()
-- codexConfig.close.texture:SetAllPoints(codexConfig.close)
-- codexConfig.close.texture:SetVertexColor(1,.25,.25,1)
-- -- pfUI.api.SkinButton(codexConfig.close, 1, .5, .5)
-- -- codexConfig.close:SetScript("OnClick", function()
-- --  this:GetParent():Hide()
-- -- end)

-- -- codexConfig.clean = CreateFrame("Button", "codexConfigReload", codexConfig)
-- -- codexConfig.clean:SetWidth(260)
-- -- codexConfig.clean:SetHeight(30)
-- -- codexConfig.clean:SetPoint("BOTTOM", 0, 10)
-- -- codexConfig.clean:SetScript("OnClick", function()
-- --   ReloadUI()
-- -- end)
-- -- codexConfig.clean.text = codexConfig.clean:CreateFontString("Caption", "LOW", "GameFontWhite")
-- -- codexConfig.clean.text:SetAllPoints(codexConfig.clean)
-- -- codexConfig.clean.text:SetFont(pfUI.font_default, pfUI_config.global.font_size, "OUTLINE")
-- -- codexConfig.clean.text:SetText(pfQuest_Loc["Close & Reload"])
-- -- pfUI.api.SkinButton(codexConfig.clean)

-- function codexConfig:LoadConfig()
--     if not CodexConfig then CodexConfig = {} end

--     for key, value in pairs(codexDefaultConfig) do
--         if not CodexConfig[key] then
--             CodexConfig[key] = value
--         end
--     end
-- end

-- function codexConfig:MigrateHistory()
--     -- local match = false

--     -- for entry in pairs(pfQuest_history) do
--     --   if type(entry) == "string" then
--     --     match = true
--     --     for id in pairs(pfDatabase:GetIDByName(entry, "quests")) do
--     --       pfQuest_history[id] = true
--     --     end
--     --     pfQuest_history[entry] = nil
--     --   end
--     -- end
  
--     -- if match == true then
--     --   DEFAULT_CHAT_FRAME:AddMessage("|cff33ffccpf|cffffffffQuest|r: " .. pfQuest_Loc["Quest history migration completed."])
--     -- end
-- end

-- function codexConfig:CreateConfigEntry(config, description, type)
--     -- basic frame
--     local frame = getglobal("codexConfig" .. config) or CreateFrame("Frame", "codexConfig" .. config, codexConfig)
--     frame:SetWidth(280)
--     frame:SetHeight(25)
--     frame:SetPoint("TOP", 0, -codexConfig.vpos)

--     -- caption
--     frame.caption = frame.caption or frame:CreateFontString("Status", "LOW", "GameFontWhite")
--     frame.caption:SetFont("Fonts\\ARIALN.TTF", 12, "OUTLINE")
--     frame.caption:SetPoint("LEFT", 20, 0)
--     frame.caption:SetJustifyH("LEFT")
--     frame.caption:SetText(description)

--     -- checkbox
--     if type == "checkbox" then
--         frame.input = frame.input or CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
--         frame.input:SetNormalTexture("")
--         frame.input:SetPushedTexture("")
--         frame.input:SetHighlightTexture("")
--         CodexUI:CreateBackdrop(frame.input, nil)
    
--         frame.input:SetWidth(12)
--         frame.input:SetHeight(12)
--         frame.input:SetPoint("RIGHT" , -20, 0)
    
--         frame.input.config = config
--         if CodexConfig[config] == "1" then
--             frame.input:SetChecked()
--         end

--         frame.input:SetScript("OnClick", function ()
--             if frame.input:GetChecked() then
--                 CodexConfig[frame.input.config] = "1"
--             else
--                 CodexConfig[frame.input.config] = "0"
--             end
--         end)

--     -- Input field
--     elseif type == "text" then
--         frame.input = frame.input or CreateFrame("EditBox", nil, frame)
--         frame.input:SetTextColor(0.2, 1, 0.8, 1)
--         frame.input:SetJustifyH("RIGHT")
        
--         frame.input:SetWidth(50)
--         frame.input:SetHeight(20)
--         frame.input:SetPoint("RIGHT", -20, 0)
--         frame.input:SetFontObject(GameFontNormal)
--         frame.input:SetAutoFocus(false)
--         frame.input:SetScript("OnEscapePressed", function()
--             frame.input:ClearFocus()
--         end)

--         frame.input.config = config
--         frame.input:SetText(CodexConfig[config])

--         frame.input:SetScript("OnTextChanged", function()
--             CodexConfig[frame.input.config] = frame.input:GetText()
--         end)
--     end

--     codexConfig.vpos = codexConfig.vpos + 23
-- end
    