-- Print a message to chat to confirm the addon has loaded
DEFAULT_CHAT_FRAME:AddMessage("MouseCircle Loaded!")
DEFAULT_CHAT_FRAME:AddMessage("To open settings panel enter /sm settings")

-- Create the frame
local circleFrame = CreateFrame("Frame", nil, UIParent)
circleFrame:SetSize(64, 64) -- Set the size of the frame

-- Add the circle texture using a custom texture
local circleTexture = circleFrame:CreateTexture(nil, "BACKGROUND")
circleTexture:SetTexture("Interface\\AddOns\\MouseCircle\\Textures\\circle.tga") -- Point this to your custom texture
circleTexture:SetAllPoints(circleFrame)

-- Create the settings panel frame
local settingsPanel = CreateFrame("Frame", "MyAddonSettingsPanel", UIParent, "BackdropTemplate")
settingsPanel:SetSize(300, 200)
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
transparencySlider:SetPoint("TOPLEFT", visibilityCheckbox, "BOTTOMLEFT", 0, -10)
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
-- Add a button to reset the circle to default values
local resetButton = CreateFrame("Button", nil, settingsPanel, "UIPanelButtonTemplate")
resetButton:SetSize(100, 30)
resetButton:SetPoint("TOPLEFT", 10, -150)
resetButton:SetText("Reset Circle")
resetButton:SetScript("OnClick", function()
    sizeSlider:SetValue(64)
    visibilityCheckbox:SetChecked(true)
    transparencySlider:SetValue(1)
end)

-- Slash command handler
local function SlashCommandHandler(msg)
    if msg == "settings" then
        if settingsPanel:IsShown() then
            settingsPanel:Hide()
        else
            settingsPanel:Show()
        end
    end
end

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
circleFrame:RegisterEvent("PLAYER_LOGIN")
circleFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
circleFrame:SetScript("OnEvent", SetCircleColorByClass)
