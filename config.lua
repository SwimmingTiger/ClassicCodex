CodexConfig = {}

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

function toggleAutoAccept(self)
    CodexConfig.autoAccept = self:GetChecked()
end

function toggleAutoTurnin(self)
    CodexConfig.autoTurnin = self:GetChecked()
end

function toggleNameplateIcon(self)
    CodexConfig.nameplateIcon = self:GetChecked()
end

function loadDefaultConfig()
    if CodexConfig.autoAccept == nil then
        CodexConfig.autoAccept = true
    end

    if CodexConfig.autoTurnin == nil then
        CodexConfig.autoTurnin = true
    end

    if CodexConfig.nameplateIcon == nil then
        CodexConfig.nameplateIcon = true
    end
end

function loadConfig(configPanel)
    configPanel.autoAcceptQuestsCheckbox:SetChecked(CodexConfig.autoAccept)
    configPanel.autoTurninQuestsCheckbox:SetChecked(CodexConfig.autoTurnin)
    configPanel.nameplateIconCheckbox:SetChecked(CodexConfig.nameplateIcon)
end

function createConfigPanel(parent)
    local config = CreateFrame("Frame", nil, parent)
    local settings = 0

    -- Title
    config.titleText = textFactory(config, "Configuration", 20)
    config.titleText:SetPoint("TOPLEFT", 0, 0)
    config.titleText:SetTextColor(1, 0.9, 0, 1)
    
    -- Auto-Accept Quests
    config.autoAcceptQuestsCheckbox = checkboxFactory(config, "Auto-Accept Quests", "Toggle auto-accepting quests", toggleAutoAccept)
    config.autoAcceptQuestsCheckbox:SetPoint("TOPLEFT", 10, -35)

    -- Auto-Turnin Quests
    config.autoTurninQuestsCheckbox = checkboxFactory(config, "Auto-Turnin Quests", "Toggle auto-turning in quests", toggleAutoTurnin)
    config.autoTurninQuestsCheckbox:SetPoint("TOPLEFT", 10, -70)

    -- Quest Icon on Nameplate
    config.nameplateIconCheckbox = checkboxFactory(config, "Nameplate Quest Icon", "Toggle quest icon on top of enemy nameplates", toggleNameplateIcon)
    config.nameplateIconCheckbox:SetPoint("TOPLEFT", 10, -105)

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

-- Add main panel
content.panel = createConfigPanel(content)
content.panel:SetPoint("TOPLEFT", 10, -10)
content.panel:SetSize(1, 1)

codexConfig:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "ClassicCodex" then
        loadDefaultConfig()
        loadConfig(content.panel)
    end
end)
