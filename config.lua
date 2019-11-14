local L = LibStub("AceLocale-3.0"):GetLocale("ClassicCodex")

CodexConfig = {}
CodexColors = {}

DefaultCodexConfig = {
    ["trackingMethod"] = 1, -- 1: All Quests; 2: Tracked Quests; 3: Manual; 4: Hide
    ["autoAccept"] = true, -- Auto-accept quests
    ["autoTurnin"] = true, -- Auto-turnin quests
    ["nameplateIcon"] = true, -- Show quest icon above nameplates
    ["allQuestGivers"] = true, -- Show available quest givers
    ["currentQuestGivers"] = true, -- Show current quest giver nodes
    ["showLowLevel"] = false, -- Show low level quest giver nodes
    ["showHighLevel"] = true, -- Show level+3 quest giver nodes
    ["showFestival"] = true, -- Show event quest giver nodes
    ["colorBySpawn"] = true,
    ["questMarkerSize"] = 14,
    ["spawnMarkerSize"] = 10,
    ["minimumDropChance"] = 2, -- (%) Hide markers with a drop probability less than this value
}

function textFactory(parent, value, size)
    local text = parent:CreateFontString(nil, "ARTWORK")
    -- Different languages require different fonts, and 
    -- using inappropriate fonts will result in text not displaying correctly.
    -- So the choice of font needs to be localized.
    text:SetFont(L["CONFIG_TEXT_FONT"], size)
    text:SetJustifyV("CENTER")
    text:SetJustifyH("CENTER")
    text:SetText(value)
    return text
end

function buttonFactory(width, parent, name, description, onClick)
    local button = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
    button:SetHeight(25)
    button:SetWidth(width)
    button:SetText(name)
    button.tooltipText = description
    button:SetScript("OnClick", function(self)
        onClick(self)
    end)
    return button
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

function sliderFactory(parent, name, title, minVal, maxVal, valStep, func, sliderWidth)
    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    local editBox = CreateFrame("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(valStep)
    slider.text = _G[name .. "Text"]
    slider.text:SetText(title)
    slider.textLow = _G[name .. "Low"]
    slider.textHigh = _G[name .. "High"]
    slider.textLow:SetText(floor(minVal))
    slider.textHigh:SetText(floor(maxVal))
    slider.textLow:SetTextColor(0.8,0.8,0.8)
    slider.textHigh:SetTextColor(0.8,0.8,0.8)
    if sliderWidth ~= nil then
        slider:SetWidth(sliderWidth)
    end
    slider:SetObeyStepOnDrag(true)
    editBox:SetSize(45,30)
    editBox:ClearAllPoints()
    editBox:SetPoint("LEFT", slider, "RIGHT", 15, 0)
    editBox:SetText(slider:GetValue())
    editBox:SetAutoFocus(false)
    slider:SetScript("OnValueChanged", function(self)
        editBox:SetText(tostring(self:GetValue()))
        func(self)
    end)
    editBox:SetScript("OnTextChanged", function(self)
        local val = self:GetText()
        if tonumber(val) then
            self:GetParent():SetValue(val)
        end
    end)
    editBox:SetScript("OnEnterPressed", function(self)
        local val = self:GetText()
        if tonumber(val) then
            self:GetParent():SetValue(val)
            self:ClearFocus()
        end
    end)
    slider.editBox = editBox
    return slider
end


function colorPickerFactory(parent, name, r, g, b, text, onClick)
    local colorPicker = CreateFrame("Button", name, parent)
    colorPicker:SetSize(15, 15)
    colorPicker.normal = colorPicker:CreateTexture(nil, "BACKGROUND")
    colorPicker.normal:SetColorTexture(1, 1, 1, 1)
    colorPicker.normal:SetPoint("TOPLEFT", -1, 1)
    colorPicker.normal:SetPoint("BOTTOMRIGHT", 1, -1)
    colorPicker.r = r
    colorPicker.g = g
    colorPicker.b = b
    colorPicker.foreground = colorPicker:CreateTexture(nil, "OVERLAY")
    colorPicker.foreground:SetColorTexture(colorPicker.r, colorPicker.g, colorPicker.b, 1)
    colorPicker.foreground:SetAllPoints()
    colorPicker:SetNormalTexture(colorPicker.normal)
    colorPicker:SetScript("OnClick", onClick)
    colorPicker.text = textFactory(colorPicker, text, 12)
    colorPicker.text:SetPoint("LEFT", 20, 0)
    
    return colorPicker
end

function LoadConfig()
    if not CodexConfig then CodexConfig = {} end

    for key, val in pairs(DefaultCodexConfig) do
        if CodexConfig[key] == nil then
            if key == "colorList" then
                CodexConfig[key] = {unpack(val)}
            else
                CodexConfig[key] = val
            end
        end
    end
end

function UpdateConfigPanel(configPanel)
    configPanel.autoAcceptQuestsCheckbox:SetChecked(CodexConfig.autoAccept)
    configPanel.autoTurninQuestsCheckbox:SetChecked(CodexConfig.autoTurnin)
    configPanel.nameplateIconCheckbox:SetChecked(CodexConfig.nameplateIcon)
    configPanel.allQuestGiversCheckbox:SetChecked(CodexConfig.allQuestGivers)
    configPanel.currentQuestGiversCheckbox:SetChecked(CodexConfig.currentQuestGivers)
    configPanel.showLowLevelCheckbox:SetChecked(CodexConfig.showLowLevel)
    configPanel.showHighLevelCheckbox:SetChecked(CodexConfig.showHighLevel)
    configPanel.showFestivalCheckbox:SetChecked(CodexConfig.showFestival)
    configPanel.colorBySpawnCheckbox:SetChecked(CodexConfig.colorBySpawn)
    configPanel.alwaysShowIdCheckbox:SetChecked(CodexConfig.alwaysShowId)

    configPanel.questMarkerSizeSlider:SetValue(CodexConfig.questMarkerSize)
    configPanel.questMarkerSizeSlider.editBox:SetCursorPosition(0)

    configPanel.spawnMarkerSizeSlider:SetValue(CodexConfig.spawnMarkerSize)
    configPanel.spawnMarkerSizeSlider.editBox:SetCursorPosition(0)

    configPanel.minimumDropChanceSlider:SetValue(CodexConfig.minimumDropChance)
    configPanel.minimumDropChanceSlider.editBox:SetCursorPosition(0)

    -- for k, v in pairs(colorListPickers) do
    --     r, g, b = unpack(CodexConfig.colorList[k])
    --     v.r = r
    --     v.g = g
    --     v.b = b
    --     v.foreground:SetColorTexture(r, g, b)
    -- end

    -- r, g, b = unpack(CodexConfig.searchColor)
    -- configPanel.searchColorPicker.r = r
    -- configPanel.searchColorPicker.g = g
    -- configPanel.searchColorPicker.b = b
    -- configPanel.searchColorPicker.foreground:SetColorTexture(r, g, b)
end

function createConfigPanel(parent)
    local config = CreateFrame("Frame", nil, parent)
    local settings = 0

    -- Title
    config.titleText = textFactory(config, "Configuration", 20)
    config.titleText:SetPoint("TOPLEFT", 0, 0)
    config.titleText:SetTextColor(1, 0.9, 0, 1)
    
    -- Auto-Accept Quests
    config.autoAcceptQuestsCheckbox = checkboxFactory(config, L["Auto-Accept Quests"], L["Toggle auto-accepting quests"], function(self)
        CodexConfig.autoAccept = self:GetChecked()
    end)
    config.autoAcceptQuestsCheckbox:SetPoint("TOPLEFT", 10, -35)

    -- Auto-Turnin Quests
    config.autoTurninQuestsCheckbox = checkboxFactory(config, L["Auto-Turnin Quests"], L["Toggle auto-turning in quests"], function(self)
        CodexConfig.autoTurnin = self:GetChecked()
    end)
    config.autoTurninQuestsCheckbox:SetPoint("TOPLEFT", 10, -70)

    -- Quest Icon on Nameplate
    config.nameplateIconCheckbox = checkboxFactory(config, L["Nameplate Quest Icon"], L["Toggle quest icon on top of enemy nameplates"], function(self)
        CodexConfig.nameplateIcon = self:GetChecked()
    end)
    config.nameplateIconCheckbox:SetPoint("TOPLEFT", 10, -105)

    config.allQuestGiversCheckbox = checkboxFactory(config, L["All Questgivers"], L["If selected, this will display all questgivers on the map"], function(self)
        CodexConfig.allQuestGivers = self:GetChecked()
        CodexQuest:ResetAll()
    end)
    config.allQuestGiversCheckbox:SetPoint("TOPLEFT", 10, -140)

    config.currentQuestGiversCheckbox = checkboxFactory(config, L["Current Questgivers"], L["If selected, current quest-ender npcs/objects will be displayed on the map for active quests"], function(self)
        CodexConfig.currentQuestGivers = self:GetChecked()
        CodexQuest:ResetAll()
    end)
    config.currentQuestGiversCheckbox:SetPoint("TOPLEFT", 10, -175)

    config.showLowLevelCheckbox = checkboxFactory(config, L["Show Low-level Quests"], L["If selected, low-level quests will be hidden on the map"], function(self)
        CodexConfig.showLowLevel = self:GetChecked()
        CodexQuest:ResetAll()
    end)
    config.showLowLevelCheckbox:SetPoint("TOPLEFT", 10, -210)

    config.showHighLevelCheckbox = checkboxFactory(config, L["Show High-level Quests"], L["If selected, quests with a level requirement of your level + 3 will be shown on the map"], function(self)
        CodexConfig.showHighLevel = self:GetChecked()
        CodexQuest:ResetAll()
    end)
    config.showHighLevelCheckbox:SetPoint("TOPLEFT", 10, -245)

    config.showFestivalCheckbox = checkboxFactory(config, L["Show Festival/PVP/Misc Quests"], L["If selected, quests related to WoW festive seasons or PVP or not available at the current stage will be displayed on the map"], function(self)
        CodexConfig.showFestival = self:GetChecked()
        CodexQuest:ResetAll()
    end)
    config.showFestivalCheckbox:SetPoint("TOPLEFT", 10, -280)

    config.colorBySpawnCheckbox = checkboxFactory(config, L["Color By Spawn"], L["If selected, markers' colors will be set per spawn type or per quest if not selected"], function(self)
        CodexConfig.colorBySpawn = self:GetChecked()
        CodexQuest:ResetAll()
    end)
    config.colorBySpawnCheckbox:SetPoint("TOPLEFT", 10, -315)

    config.alwaysShowIdCheckbox = checkboxFactory(config, L["Always Show ID In Browser"], L["If selected, the item/object/unit/quest ID will be displayed when you searching something in ClassicCodex Browser."], function(self)
        CodexConfig.alwaysShowId = self:GetChecked()
        CodexBrowser.input:Search()
    end)
    config.alwaysShowIdCheckbox:SetPoint("TOPLEFT", 250, -35)

    config.questMarkerSizeSlider = sliderFactory(config, "questMarkerSize", L["Quest Marker Size"], 10, 25, 1, function(self)
        CodexConfig.questMarkerSize = tonumber(self:GetValue())
        CodexMap:UpdateNodes()
    end)
    config.questMarkerSizeSlider:SetPoint("TOPLEFT", 45, -395)

    config.spawnMarkerSizeSlider = sliderFactory(config, "spawnMarkerSize", L["Spawn Marker Size"], 6, 20, 1, function(self)
        CodexConfig.spawnMarkerSize = tonumber(self:GetValue())
        CodexMap:UpdateNodes()
    end)
    config.spawnMarkerSizeSlider:SetPoint("TOPLEFT", 325, -395)

    config.minimumDropChanceSlider = sliderFactory(config, "minimumDropChance", L["Hide items with a drop probability less than (%)"], 0, 100, 1, function(self)
        CodexConfig.minimumDropChance = tonumber(self:GetValue())
        CodexQuest:ResetAll()
    end, 424)
    config.minimumDropChanceSlider:SetPoint("TOPLEFT", 45, -447)

    config.listHiddenQuests = buttonFactory(250, config, L["List Manually Hidden Quests"], nil, function(self)
        if CodexBrowser then
            CodexBrowser.input:SetText('!')
            CodexBrowser:OpenView('quests')
        end
    end)
    config.listHiddenQuests:SetPoint("TOPLEFT", 15, -485)

    config.listCompletedQuests = buttonFactory(250, config, L["List Completed Quests"], nil, function(self)
        if CodexBrowser then
            CodexBrowser.input:SetText('@')
            CodexBrowser:OpenView('quests')
        end
    end)
    config.listCompletedQuests:SetPoint("TOPLEFT", 280, -485)
    
    config.showAllHiddenQuests = buttonFactory(400, config, L["Show All Quests You Manually Hide Again"], L["Show all the quests you have hidden by shift + click."].."\n"..
                                                       L["Hide a quest by holding the shift key and clicking on the quest icon on the minimap or world map."], function(self)
        local size = Codex:tablelen(CodexHiddenQuests)
        CodexHiddenQuests = {}
        CodexQuest:ResetAll()
        if size < 1 then
            print(L["ClassicCodex: You have no manually hidden quests. You can hold the shift key and click on the quest icon on the minimap or world map to hide it."])
        else
            print(string.format(L["ClassicCodex: %d hidden quests will be able to show again."], size))
        end
    end)
    config.showAllHiddenQuests:SetPoint("TOPLEFT", 15, -515)

    -- Marker Colors
    -- config.markerColorsTitle = textFactory(config, "Map Marker Colors", 20)
    -- config.markerColorsTitle:SetPoint("TOPLEFT", 0, -350)
    -- config.markerColorsTitle:SetTextColor(1, 0.9, 0, 1)

    -- config.restoreColorsButton = CreateFrame("Button", nil, config)
    -- config.restoreColorsButton:SetPoint("TOPLEFT", 190, -349)
    -- config.restoreColorsButton:SetSize(190, 35)
    -- config.restoreColorsButton:SetNormalTexture("Interface/Buttons/UI-Panel-Button-Up")
    -- config.restoreColorsButton:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight")
    -- config.restoreColorsButton:SetPushedTexture("Interface/Buttons/UI-Panel-Button-Down")
    -- local font = config.restoreColorsButton:CreateFontString()
    -- font:SetFont("Fonts/FRIZQT__.TTF", 12)
    -- font:SetPoint("TOPLEFT", config.restoreColorsButton, "TOPLEFT", 10, -6)
    -- font:SetText("Restore Defaults")
    -- config.restoreColorsButton:SetFontString(font)
    -- config.restoreColorsButton:SetScript("OnClick", function(self)
    --     CodexConfig.colorList = {unpack(DefaultCodexConfig.colorList)}
    --     CodexQuest:ResetAll()
    --     UpdateConfigPanel(config)
    -- end)

    -- for k, v in pairs(CodexConfig.colorList) do
    --     local colorPickerFrame = colorPickerFactory(config, "Color " .. k, v[1], v[2], v[3], "Color " .. k, function(self)
    --         local function func(restore)
    --             if restore then
    --                 r, g, b = unpack(restore)
    --             else
    --                 r, g, b = ColorPickerFrame:GetColorRGB()
    --             end
    --             CodexConfig.colorList[k] = {r, g, b}

    --             self.r, self.g, self.b = r, g, b
    --             self.foreground:SetColorTexture(r, g, b, 1)
    --             CodexQuest:ResetAll()
    --         end

    --         ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = func, func, func
    --         ColorPickerFrame:SetColorRGB(self.r, self.g, self.b)
    --         ColorPickerFrame.opacity = 1
    --         ColorPickerFrame.previousValues = {self.r, self.g, self.b}
    --         ColorPickerFrame:Show()
    --     end)

    --     colorPickerFrame:SetPoint("TOPLEFT", ((k - 1) % 6) * 85 + 10, -385 - math.floor((k - 1) / 6) * 25)

    --     table.insert(colorListPickers, colorPickerFrame)
    -- end

    -- Search Color
    -- config.searchColorTitle = textFactory(config, "Search Marker Color", 20)
    -- config.searchColorTitle:SetPoint("TOPLEFT", 0, -525)
    -- config.searchColorTitle:SetTextColor(1, 0.9, 0, 1)

    -- config.searchColorPicker = colorPickerFactory(config, "Search Color", CodexConfig.searchColor[1], CodexConfig.searchColor[2], CodexConfig.searchColor[3], "Search Color", function(self)
    --     local function func(restore)
    --         if restore then
    --             r, g, b = unpack(restore)
    --         else
    --             r, g, b = ColorPickerFrame:GetColorRGB()
    --         end
    --         CodexConfig.searchColor = {r, g, b}

    --         self.r, self.g, self.b = r, g, b
    --         self.foreground:SetColorTexture(r, g, b, 1)
    --         CodexQuest.ResetAll()
    --     end

    --     ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = func, func, func
    --     ColorPickerFrame:SetColorRGB(self.r, self.g, self.b)
    --     ColorPickerFrame.opacity = 1
    --     ColorPickerFrame.previousValues = {self.r, self.g, self.b}
    --     ColorPickerFrame:Show()
    -- end)
    -- config.searchColorPicker:SetPoint("TOPLEFT", 10, -560)

    return config
end

codexConfig = CreateFrame("Frame", "codexConfig", UIParent)
codexConfig:RegisterEvent("ADDON_LOADED")
codexConfig.name = "ClassicCodex"
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


codexConfig:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "ClassicCodex" then
        LoadConfig()

        -- Add main panel
        content.panel = createConfigPanel(content)
        content.panel:SetPoint("TOPLEFT", 10, -10)
        content.panel:SetSize(1, 1)
        
        UpdateConfigPanel(content.panel)
    end
end)
