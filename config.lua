CodexConfig = {}
colorListPickers = {}

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
    ["colorList"] = {
        {0.901, 0.098, 0.294},--redish
        {0.235, 0.705, 0.294}, --light green
        {1, 0.882, 0.098}, --yellow
        {0, 0.509, 0.784}, --blue
        {0.960, 0.509, 0.188}, --orange
        {0.568, 0.117, 0.705}, --purple
        {0.274, 0.941, 0.941}, --cyan
        {0.941, 0.196, 0.901}, --magenta
        {0, 1, 0}, --neon green
        {1, 0, 0}, --neon red
        {0, 0.501, 0.501}, --teal
        {0, 0.1, 1}, --neon blue
        {0.666, 0.431, 0.156}, --brown
        {0.4, 0, 0.4}, -- dark purple
        {0.501, 0, 0}, --maroon
        {0.666, 1, 0.764}, --mint
        {0.521, 0.266, 0.258}, --cappuccino
        {1, 0.843, 0.705}, --apricot
        {0, 0, 0.501}, --navy
        {0.501, 0.501, 0.501}, --grey
        {1, 1, 1}, --white
        {1, 1, 1}, --white
        {1, 1, 1}, --white
        {1, 1, 1}, --white
        {1, 1, 1}, --white
        {1, 1, 1}, --white
        {1, 1, 1}, --white
        {1, 1, 1}, --white
        {1, 1, 1}, --white
        {1, 1, 1}, --white
    },
}

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

function colorPickerFactory(parent, name, r, g, b, text, onClick)
    local colorPicker = CreateFrame("Button", name, parent)
    colorPicker:SetSize(15, 15)
    colorPicker.normal = colorPicker:CreateTexture(nil, "BACKGROUND")
    colorPicker.normal:SetColorTexture(1, 1, 1, 1)
    colorPicker.normal:SetPoint("TOPLEFT", -1, 1)
    colorPicker.normal:SetPoint("BOTTOMRIGHT", 1, -1)
    colorPicker.foreground = colorPicker:CreateTexture(nil, "OVERLAY")
    colorPicker.foreground:SetColorTexture(r, g, b, 1)
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
            CodexConfig[key] = val
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

    for k, v in pairs(colorListPickers) do
        r, g, b = unpack(CodexConfig.colorList[k])
        print(r)
        print(g)
        print(b)
        v.foreground:SetColorTexture(r, g, b)
        v.reset = true
    end
end

function createConfigPanel(parent)
    local config = CreateFrame("Frame", nil, parent)
    local settings = 0

    -- Title
    config.titleText = textFactory(config, "Configuration", 20)
    config.titleText:SetPoint("TOPLEFT", 0, 0)
    config.titleText:SetTextColor(1, 0.9, 0, 1)
    
    -- Auto-Accept Quests
    config.autoAcceptQuestsCheckbox = checkboxFactory(config, "Auto-Accept Quests", "Toggle auto-accepting quests", function(self)
        CodexConfig.autoAccept = self:GetChecked()
    end)
    config.autoAcceptQuestsCheckbox:SetPoint("TOPLEFT", 10, -35)

    -- Auto-Turnin Quests
    config.autoTurninQuestsCheckbox = checkboxFactory(config, "Auto-Turnin Quests", "Toggle auto-turning in quests", function(self)
        CodexConfig.autoTurnin = self:GetChecked()
    end)
    config.autoTurninQuestsCheckbox:SetPoint("TOPLEFT", 10, -70)

    -- Quest Icon on Nameplate
    config.nameplateIconCheckbox = checkboxFactory(config, "Nameplate Quest Icon", "Toggle quest icon on top of enemy nameplates", function(self)
        CodexConfig.nameplateIcon = self:GetChecked()
    end)
    config.nameplateIconCheckbox:SetPoint("TOPLEFT", 10, -105)

    config.allQuestGiversCheckbox = checkboxFactory(config, "All Questgivers", "If selected, this will display all questgivers on the map", function(self)
        CodexConfig.allQuestGivers = self:GetChecked()
        CodexQuest:ResetAll()
    end)
    config.allQuestGiversCheckbox:SetPoint("TOPLEFT", 10, -140)

    config.currentQuestGiversCheckbox = checkboxFactory(config, "Current Questgivers", "If selected, current quest-ender npcs/objects will be displayed on the map for active quests", function(self)
        CodexConfig.currentQuestGivers = self:GetChecked()
        CodexQuest:ResetAll()
    end)
    config.currentQuestGiversCheckbox:SetPoint("TOPLEFT", 10, -175)

    config.showLowLevelCheckbox = checkboxFactory(config, "Show low-level quests", "If selected, low-level quests will be hidden on the map", function(self)
        CodexConfig.showLowLevel = self:GetChecked()
        CodexQuest:ResetAll()
    end)
    config.showLowLevelCheckbox:SetPoint("TOPLEFT", 10, -210)

    config.showHighLevelCheckbox = checkboxFactory(config, "Show high-level quests", "If selected, quests with a level requirement of your level + 3 will be shown on the map", function(self)
        CodexConfig.showHighLevel = self:GetChecked()
        CodexQuest:ResetAll()
    end)
    config.showHighLevelCheckbox:SetPoint("TOPLEFT", 10, -245)

    config.showFestivalCheckbox = checkboxFactory(config, "Show festival quests", "If selected, quests related to WoW festive seasons will be displayed on the map", function(self)
        CodexConfig.showFestival = self:GetChecked()
        CodexQuest:ResetAll()
    end)
    config.showFestivalCheckbox:SetPoint("TOPLEFT", 10, -280)

    -- Marker Colors
    config.markerColorsTitle = textFactory(config, "Map Marker Colors", 20)
    config.markerColorsTitle:SetPoint("TOPLEFT", 0, -350)
    config.markerColorsTitle:SetTextColor(1, 0.9, 0, 1)

    config.restoreColorsButton = CreateFrame("Button", nil, config)
    config.restoreColorsButton:SetPoint("TOPLEFT", 190, -349)
    config.restoreColorsButton:SetSize(190, 35)
    config.restoreColorsButton:SetNormalTexture("Interface/Buttons/UI-Panel-Button-Up")
    config.restoreColorsButton:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight")
    config.restoreColorsButton:SetPushedTexture("Interface/Buttons/UI-Panel-Button-Down")
    local font = config.restoreColorsButton:CreateFontString()
    font:SetFont("Fonts/FRIZQT__.TTF", 12)
    font:SetPoint("TOPLEFT", config.restoreColorsButton, "TOPLEFT", 10, -6)
    font:SetText("Restore Defaults")
    config.restoreColorsButton:SetFontString(font)
    config.restoreColorsButton:SetScript("OnClick", function(self)
        CodexConfig.colorList = DefaultCodexConfig.colorList
        CodexQuest:ResetAll()
        UpdateConfigPanel(config)
    end)

    for k, v in pairs(CodexConfig.colorList) do
        local colorPickerFrame = colorPickerFactory(config, "Color " .. k, v[1], v[2], v[3], "Color " .. k, function(self)
            local function func(restore)
                if restore then
                    r, g, b = unpack(restore)
                else
                    r, g, b = ColorPickerFrame:GetColorRGB()
                end
                CodexConfig.colorList[k] = {r, g, b}

                self.foreground:SetColorTexture(r, g, b, 1)
                CodexQuest:ResetAll()
            end

            ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = func, func, func
            if self.reset then
                self.reset = false
                r, g, b = unpack(CodexConfig.colorList[k])
                ColorPickerFrame:SetColorRGB(r, g, b)
            else
                r, g, b = unpack(CodexConfig.colorList[k])
                ColorPickerFrame:SetColorRGB(r, g, b)
            end
            ColorPickerFrame.opacity = 1
            ColorPickerFrame.previousValues = 
            ColorPickerFrame:Show()
        end)

        colorPickerFrame:SetPoint("TOPLEFT", ((k - 1) % 6) * 85, -385 - math.floor((k - 1) / 6) * 25)

        table.insert(colorListPickers, colorPickerFrame)
    end

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
