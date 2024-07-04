print("MyAddon successfully loaded!")
if not MyAddonDB then 
    MyAddonDB = {}
end

-- Create the main frame
local mainFrame = CreateFrame("Frame", "MyAddonMainFrame", UIParent, "BasicFrameTemplateWithInset")
mainFrame:SetSize(550, 420)
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

-- Customize the title background
mainFrame.TitleBg:SetHeight(30)

-- Create the title font string
mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
mainFrame.title:SetPoint("TOPLEFT", mainFrame.TitleBg, "TOPLEFT", 5, -3)
mainFrame.title:SetText("PetToBring")
mainFrame.playerName = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainFrame.playerName:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 15, -35)
mainFrame.playerName:SetText("Character: " .. UnitName("player") .. " (Level " .. UnitLevel("player") .. ")")
mainFrame:Hide()
table.insert(UISpecialFrames, "MyAddonMainFrame")

-- Make the frame interactable and movable
mainFrame:EnableMouse(true)
mainFrame:SetMovable(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
mainFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

-- Play sound on show and hide
mainFrame:SetScript("OnShow", function(self)
    PlaySound(808)
end)
mainFrame:SetScript("OnHide", function(self)
    PlaySound(808)
end)

-- slash command
SLASH_PETTOBRING1 = "/ptb"
SLASH_PETTOBRING2 = "/pettobring"
SlashCmdList["PETTOBRING"] = function()
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:Show()
    end
end

-- Specializations
local specs = {
    "Blood DK", "Frost DK", "Unholy DK",
    "Balance", "Feral DPS", "Feral Tank", "Resto Druid",
    "Beast Mastery", "Marksmanship", "Survival",
    "Arcane Mage", "Fire Mage", "Frost Mage",
    "Holy Paladin", "Protection Paladin", "Retribution",
    "Discipline ", "Holy Priest", "Shadow Priest",
    "Assassination", "Combat", "Subtlety",
    "Elemental", "Enhancement", "Resto Shaman",
    "Affliction", "Demonology", "Destruction",
    "Arms", "Fury", "Protection Warrior"
}
-- checkbtns
local function createCheckButton(parent, xOff, yOff, text)
    local checkButton = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
        checkButton:SetPoint("TOPLEFT",mainFrame.TitleBg, "BOTTOMLEFT", xOff,yOff)
        checkButton.Text:SetText(text)
        return checkButton;
end

local xcord = 10
local ycord = -35
local selectedSpecs = {}

for _, specName in ipairs(specs) do
    local myCheckButton = createCheckButton(mainFrame, xcord, ycord, specName);
        myCheckButton.tooltip = specName;
        myCheckButton:HookScript("OnClick", function()
            if myCheckButton:GetChecked() then
                print("you selected " .. specName)
                table.insert(selectedSpecs,specName)
            else 
                print("you removed " .. specName)
                for i, v in ipairs (selectedSpecs) do
                    if v == specName then
                        table.remove(selectedSpecs,i)
                    end
                end
            end
        end);
        xcord = xcord + 125  -- Adjust x position for next button
        if xcord > 400 then
            xcord = 15
            ycord = ycord - 25  -- Adjust y position for next row
        end
end

function containsAny(table, required_specs)
    for _, item in ipairs(table) do
        for _, spec in ipairs(required_specs) do
            if item == spec then
                return true
            end
        end
    end
    return false
end

local calcbutton = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
calcbutton:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, 10)
calcbutton:SetSize(100, 40)
calcbutton:SetText("Find pet")
calcbutton:SetScript("OnClick", function(self, button, down)
	if not containsAny(selectedSpecs, {"Protection Warrior", "Feral Tank"}) then
        print("Serpent or Raptor")
    elseif not containsAny(selectedSpecs, {"Fury", "Elemental", "Subtlety", "Feral DPS"}) then
        print("Wolf or Devilsaur")
    elseif not containsAny(selectedSpecs, {"Arms", "Combat", "Frost DK"}) then
        print("Ravager")
    elseif not containsAny(selectedSpecs, {"Assassination", "Unholy DK", "Balance", "Affliction", "Demonology", "Destruction"}) then
        print("Wind Serpent or DragonHawk")
    elseif not containsAny(selectedSpecs, {"Arms", "Fury", "Protection Warrior", "Enhancement", "Unholy DK", "Frost DK", "Blood DK"}) then
        print("Cat or spiritbeasts")
    elseif not containsAny(selectedSpecs, {"Arms", "Feral DPS", "Subtlety"}) then
        print("Hyena")
    else
        print("Bring Whatever You want")
    end
end)

local eventListenerFrame = CreateFrame("Frame", "MyAddonEventListenerFrame", UIParent)

local function eventHandler(self, event, ...)
    if event == "PLAYER_REGEN_DISABLED" then
        mainFrame:Hide()
    end
end

eventListenerFrame:SetScript("OnEvent", eventHandler)
eventListenerFrame:RegisterEvent("PLAYER_REGEN_DISABLED")