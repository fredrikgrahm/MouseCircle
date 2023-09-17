-- Print a message to chat to confirm the addon has loaded
DEFAULT_CHAT_FRAME:AddMessage("MouseCircle Loaded!")
DEFAULT_CHAT_FRAME:AddMessage("To open settings panel enter /sm settings")

settings = {}
MouseCircleSettings = MouseCircleSettings or {}
-- Create the frame
local circleFrame = CreateFrame("Frame", nil, UIParent)
circleFrame:SetSize(64, 64) -- Set the size of the frame

-- Add the circle texture using a custom texture
local circleTexture = circleFrame:CreateTexture(nil, "BACKGROUND")
circleTexture:SetTexture("Interface\\AddOns\\MouseCircle\\Textures\\circle.tga") -- Point this to your custom texture
circleTexture:SetAllPoints(circleFrame)

-- Create the settings panel frame
local settingsPanel = CreateFrame("Frame", "MyAddonSettingsPanel", UIParent, "BackdropTemplate")
settingsPanel:SetSize(400, 300)
settingsPanel:SetPoint("CENTER")

settingsPanel.title = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
settingsPanel.title:SetPoint("TOP", 0, -10)
settingsPanel.title:SetText("MouseCircle settings")

-- Apply backdrop properties using the Backdrop mixin
settingsPanel:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = {
        left = 4,
        right = 4,
        top = 4,
        bottom = 4
    }
})
settingsPanel:SetBackdropColor(0, 0, 0, 0.8)

-- Make the settings panel movable
settingsPanel:SetMovable(true)
settingsPanel:EnableMouse(true)
settingsPanel:RegisterForDrag("LeftButton")
settingsPanel:SetScript("OnDragStart", settingsPanel.StartMoving)
settingsPanel:SetScript("OnDragStop", settingsPanel.StopMovingOrSizing)

-- Create the close button
local closeButton = CreateFrame("Button", nil, settingsPanel, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", -8, -8) -- Set the position of the close button

-- Add a click event handler to hide the settings panel
closeButton:SetScript("OnClick", function()
    settingsPanel:Hide()
end)

-- Add a slider to control the size of the circle
local sizeSlider = CreateFrame("Slider", nil, settingsPanel, "OptionsSliderTemplate")
sizeSlider:SetSize(200, 20)
sizeSlider:SetPoint("TOPLEFT", 10, -50)
sizeSlider:SetMinMaxValues(32, 128)
sizeSlider:SetValue(32, 128)
sizeSlider:SetValue(64)
sizeSlider:SetValueStep(1)
sizeSlider:SetOrientation("HORIZONTAL")
sizeSlider:SetScript("OnValueChanged", function(self, value)
    local size = math.floor(value)
    circleFrame:SetSize(size, size)
end)

-- Add a label for the size slider
local sizeLabel = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
sizeLabel:SetPoint("BOTTOMLEFT", sizeSlider, "TOPLEFT", 0, 5)
sizeLabel:SetText("Circle Size")

-- Add a checkbox to toggle the visibility of the circle
local visibilityCheckbox = CreateFrame("CheckButton", nil, settingsPanel, "UICheckButtonTemplate")
visibilityCheckbox:SetSize(20, 20)
visibilityCheckbox:SetPoint("TOPLEFT", 10, -100)
visibilityCheckbox:SetChecked(true)
visibilityCheckbox:SetScript("OnClick", function(self)
    if self:GetChecked() then
        circleFrame:Show()
    else
        circleFrame:Hide()
    end
end)

-- Add a label for the visibility checkbox
local visibilityLabel = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
visibilityLabel:SetPoint("BOTTOMLEFT", visibilityCheckbox, "TOPLEFT", 0, 5)
visibilityLabel:SetText("Show Circle")
-- Add a slider to control the transparency of the circle
local transparencySlider = CreateFrame("Slider", nil, settingsPanel, "OptionsSliderTemplate")
transparencySlider:SetSize(200, 20)
transparencySlider:SetPoint("TOPLEFT", visibilityCheckbox, "BOTTOMLEFT", 0, -20)
transparencySlider:SetMinMaxValues(0, 1)
transparencySlider:SetValue(1)
transparencySlider:SetValueStep(0.1)
transparencySlider:SetOrientation("HORIZONTAL")
transparencySlider:SetScript("OnValueChanged", function(self, value)
    local alpha = value
    circleTexture:SetAlpha(alpha)
end)

-- Add a label for the transparency slider
local transparencyLabel = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
transparencyLabel:SetPoint("BOTTOMLEFT", transparencySlider, "TOPLEFT", 0, 10)
transparencyLabel:SetText("Circle Transparency")







-- Reset the size of the circle to its default value
local resetSizeButton = CreateFrame("Button", nil, settingsPanel, "UIPanelButtonTemplate")
resetSizeButton:SetSize(100, 30)
resetSizeButton:SetPoint("LEFT", sizeSlider, "RIGHT", 10, 0)
resetSizeButton:SetText("Default")
resetSizeButton:SetScript("OnClick", function()
    sizeSlider:SetValue(defaultSettings.circleSize)
    settings.circleSize = defaultSettings.circleSize
end)

-- Reset the transparency of the circle to its default value
local resetTransparencyButton = CreateFrame("Button", nil, settingsPanel, "UIPanelButtonTemplate")
resetTransparencyButton:SetSize(100, 30)
resetTransparencyButton:SetPoint("LEFT", transparencySlider, "RIGHT", 10, 0)
resetTransparencyButton:SetText("Default")
resetTransparencyButton:SetScript("OnClick", function()
    transparencySlider:SetValue(defaultSettings.circleTransparency)
    settings.circleTransparency = defaultSettings.circleTransparency
end)

-- Create the revert button (without the OnClick script)
local revertButton = CreateFrame("Button", nil, settingsPanel, "UIPanelButtonTemplate")
revertButton:SetSize(100, 30)
revertButton:SetPoint("LEFT", saveButton, "RIGHT", 10, 0)
revertButton:SetText("Revert")
revertButton:Disable() -- Disable the button initially

-- Create the save button
local saveButton = CreateFrame("Button", nil, settingsPanel, "UIPanelButtonTemplate")
saveButton:SetSize(100, 30)
saveButton:SetPoint("BOTTOMLEFT", 10, 10)
saveButton:SetText("Save")
saveButton:Disable() -- Disable the button initially

saveButton:SetScript("OnClick", function()
    -- Save the current settings
    settings.circleSize = sizeSlider:GetValue()
    settings.circleVisibility = visibilityCheckbox:GetChecked()
    settings.circleTransparency = transparencySlider:GetValue()

    -- Disable the save and revert buttons since nothing has changed
    saveButton:Disable()
    revertButton:Disable()
end)

-- Create the revert button
local revertButton = CreateFrame("Button", nil, settingsPanel, "UIPanelButtonTemplate")
revertButton:SetSize(100, 30)
revertButton:SetPoint("LEFT", saveButton, "RIGHT", 10, 0)
revertButton:SetText("Revert")
revertButton:Disable() -- Disable the button initially

revertButton:SetScript("OnClick", function()
    -- Revert the settings to the last saved state
    sizeSlider:SetValue(settings.circleSize)
    visibilityCheckbox:SetChecked(settings.circleVisibility)
    transparencySlider:SetValue(settings.circleTransparency)

    -- Disable the save and revert buttons since nothing has changed
    saveButton:Disable()
    revertButton:Disable()
end)

-- Enable the save and revert buttons when a setting is changed
local function OnSettingChanged()
    saveButton:Enable()
    revertButton:Enable()
end

-- Modify the scripts to update the settings and call OnSettingChanged
sizeSlider:SetScript("OnValueChanged", function(self, value)
    local size = math.floor(value)
    circleFrame:SetSize(size, size)
    settings.circleSize = size -- Update the setting
    OnSettingChanged()
end)

visibilityCheckbox:SetScript("OnClick", function(self)
    local isChecked = self:GetChecked()
    if isChecked then
        circleFrame:Show()
    else
        circleFrame:Hide()
    end
    settings.circleVisibility = isChecked -- Update the setting
    OnSettingChanged()
end)

transparencySlider:SetScript("OnValueChanged", function(self, value)
    local alpha = value
    circleTexture:SetAlpha(alpha)
    settings.circleTransparency = alpha -- Update the setting
    OnSettingChanged()
end)

local function SaveSettings()
    MouseCircleSettings = settings -- Save the settings
end

circleFrame:RegisterEvent("PLAYER_LOGOUT")
circleFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGOUT" then
        SaveSettings()
    else
        SetCircleColorByClass()
    end
end)

-- Register slash command
SLASH_MOUSECIRCLE1 = "/sm"
SlashCmdList["MOUSECIRCLE"] = SlashCommandHandler

-- Update the circle's position to follow the mouse
local function UpdateCirclePosition()
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    circleFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
end

-- Function to set the color based on class
local function SetCircleColorByClass()
    local _, class = UnitClass("player")
    print("Setting color for class: " .. class)
    if class == "MAGE" then
        circleTexture:SetVertexColor(0.4, 0.8, 1, 1) -- Light blue for Mage
    elseif class == "WARRIOR" then
        circleTexture:SetVertexColor(0.78, 0.61, 0.43) -- Brown for Warrior
    elseif class == "HUNTER" then
        circleTexture:SetVertexColor(0.67, 0.83, 0.45) -- Green for Hunter
    elseif class == "ROGUE" then
        circleTexture:SetVertexColor(1, 0.96, 0.41) -- Yellow for Rogue
    elseif class == "WARLOCK" then
        circleTexture:SetVertexColor(0.58, 0.51, 0.79) -- Purple for Warlock
    elseif class == "PALADIN" then
        circleTexture:SetVertexColor(0.96, 0.55, 0.73) -- Pink for Paladin
    elseif class == "PRIEST" then
        circleTexture:SetVertexColor(1, 1, 1) -- White for Priest
    elseif class == "DEATHKNIGHT" then
        circleTexture:SetVertexColor(0.77, 0.12, 0.23) -- Red for Death Knight
    elseif class == "SHAMAN" then
        circleTexture:SetVertexColor(0, 0.44, 0.87) -- Blue for Shaman
    elseif class == "DRUID" then
        circleTexture:SetVertexColor(1, 0.49, 0.04) -- Orange for Druid
    end
end

-- Register events and update circle position
circleFrame:SetScript("OnUpdate", UpdateCirclePosition)


circleFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
circleFrame:RegisterEvent("ADDON_LOADED")
circleFrame:RegisterEvent("PLAYER_LOGOUT")


local function SaveSettings()
    MouseCircleSettings = settings -- Save the settings
end


-- Define default settings
local defaultSettings = {
    circleSize = 64,
    circleVisibility = true,
    circleTransparency = 1
}
circleFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "MouseCircle" then
        -- Load the saved settings or use the default settings if none exist
        if MouseCircleSettings and MouseCircleSettings.circleSize then
            print("Loaded custom MouseCircleSettings")
        else
            print("Loaded defaultSettings")
            MouseCircleSettings = defaultSettings
        end
        settings = MouseCircleSettings

        -- Apply the loaded settings
        sizeSlider:SetValue(settings.circleSize or defaultSettings.circleSize)
        visibilityCheckbox:SetChecked(settings.circleVisibility or defaultSettings.circleVisibility)
        transparencySlider:SetValue(settings.circleTransparency or defaultSettings.circleTransparency)
    elseif event == "PLAYER_LOGOUT" then
        SaveSettings() -- Save the current settings
    elseif event == "PLAYER_ENTERING_WORLD" then
        SetCircleColorByClass()
    end
end)