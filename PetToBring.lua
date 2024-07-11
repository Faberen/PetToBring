if not MyAddonDB then
    MyAddonDB = {}
end

-- Create the main frame
local mainFrame = CreateFrame("Frame", "MyAddonMainFrame", UIParent, "BasicFrameTemplateWithInset")
mainFrame:SetSize(250, 350)
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

-- Customize the title background
mainFrame.TitleBg:SetHeight(30)

-- Create the title font string
mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
mainFrame.title:SetPoint("TOPLEFT", mainFrame.TitleBg, "TOPLEFT", 5, -3)
mainFrame.title:SetText("PetToBring")
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
local WowClasses = {
    ["Death Knight"] = {
        specs = {
            { name = "Blood",    icon = "Interface\\Icons\\Spell_Deathknight_BloodPresence" },
            { name = "Frost DK", icon = "Interface\\Icons\\Spell_Deathknight_FrostPresence" },
            { name = "Unholy",   icon = "Interface\\Icons\\Spell_Deathknight_UnholyPresence" }
        }
    },
    ["Druid"] = {
        specs = {
            { name = "Balance",     icon = "Interface\\Icons\\spell_nature_starfall" },
            { name = "Feral",       icon = "Interface\\Icons\\ability_druid_catform" },
            { name = "Guardian",    icon = "Interface\\Icons\\ability_racial_bearform" },
            { name = "Restoration", icon = "Interface\\Icons\\spell_nature_healingtouch" }
        }
    },
    ["Hunter"] = {
        specs = {
            { name = "Beast Mastery", icon = "Interface\\Icons\\ability_hunter_beasttaming" },
            { name = "Marksmanship",  icon = "Interface\\Icons\\ability_hunter_focusedaim" },
            { name = "Survival",      icon = "Interface\\Icons\\ability_hunter_camouflage" }
        }
    },
    ["Mage"] = {
        specs = {
            { name = "Arcane", icon = "Interface\\Icons\\spell_holy_magicalsentry" },
            { name = "Fire",   icon = "Interface\\Icons\\spell_fire_firebolt02" },
            { name = "Frost",  icon = "Interface\\Icons\\spell_frost_frostbolt02" }
        }
    },
    ["Paladin"] = {
        specs = {
            { name = "Holy",        icon = "Interface\\Icons\\spell_holy_holybolt" },
            { name = "Protection",  icon = "Interface\\Icons\\ability_paladin_shieldofthetemplar" },
            { name = "Retribution", icon = "Interface\\Icons\\spell_holy_auraoflight" }
        }
    },
    ["Priest"] = {
        specs = {
            { name = "Discipline", icon = "Interface\\Icons\\spell_holy_wordfortitude" },
            { name = "Holy",       icon = "Interface\\Icons\\spell_holy_guardianspirit" },
            { name = "Shadow",     icon = "Interface\\Icons\\spell_shadow_shadowwordpain" }
        }
    },
    ["Rogue"] = {
        specs = {
            { name = "Assassination", icon = "Interface\\Icons\\ability_rogue_eviscerate" },
            { name = "Combat",        icon = "Interface\\Icons\\inv_sword_30" },
            { name = "Subtlety",      icon = "Interface\\Icons\\ability_stealth" }
        }
    },
    ["Shaman"] = {
        specs = {
            { name = "Elemental",   icon = "Interface\\Icons\\spell_nature_lightning" },
            { name = "Enhancement", icon = "Interface\\Icons\\spell_nature_lightningshield" },
            { name = "Restoration", icon = "Interface\\Icons\\spell_nature_magicimmunity" }
        }
    },
    ["Warlock"] = {
        specs = {
            { name = "Affliction",  icon = "Interface\\Icons\\spell_shadow_deathcoil" },
            { name = "Demonology",  icon = "Interface\\Icons\\spell_shadow_metamorphosis" },
            { name = "Destruction", icon = "Interface\\Icons\\spell_shadow_rainoffire" }
        }
    },
    ["Warrior"] = {
        specs = {
            { name = "Arms",               icon = "Interface\\Icons\\ability_warrior_savageblow" },
            { name = "Fury",               icon = "Interface\\Icons\\ability_warrior_innerrage" },
            { name = "Protection Warrior", icon = "Interface\\Icons\\inv_shield_06" }
        }
    }
}

local selectedSpecs = {}
-- checkbtns
local function createCheckButton(parent, xOff, yOff, spec, texture)
    local checkButton = CreateFrame("CheckButton", nil, parent, "UIPanelButtonTemplate")
    checkButton:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, yOff)
    checkButton:SetSize(26, 26)
    checkButton.tooltip = spec
    local disabledTexture = checkButton:CreateTexture()
    disabledTexture:SetTexture(texture)
    disabledTexture:SetAllPoints()
    disabledTexture:SetVertexColor(0.3, 0.3, 0.3, 1) -- Make texture darker

    local highlightTexture = checkButton:CreateTexture()
    highlightTexture:SetTexture(texture)
    highlightTexture:SetAllPoints()

    checkButton:SetNormalTexture(disabledTexture)
    checkButton:SetHighlightTexture(highlightTexture)
    checkButton:SetCheckedTexture(texture)

    checkButton:HookScript("OnClick", function()
        if checkButton:GetChecked() then
            table.insert(selectedSpecs, spec)
        else
            for i, v in ipairs(selectedSpecs) do
                if v == spec then
                    table.remove(selectedSpecs, i)
                end
            end
        end
    end);
    return checkButton;
end

local xcord = 15
local ycord = -50
local no = 0

for class, data in pairs(WowClasses) do
    no = no + 1
    local classLabel = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    classLabel:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", xcord, ycord + 15)
    classLabel:SetText(class)
    for _, spec in pairs(data.specs) do
        createCheckButton(mainFrame, xcord, ycord, spec.name, spec.icon);
        xcord = xcord + 30
    end

    if no == 5 then
        xcord = 115
        ycord = -50
    elseif no > 5 then
        xcord = 115
        ycord = ycord - 50
    else
        xcord = 15
        ycord = ycord - 50
    end
end

local function containsAny(table, required_specs)
    for _, item in ipairs(table) do
        for _, spec in ipairs(required_specs) do
            if item == spec then
                return true
            end
        end
    end
    return false
end

local function ShowPopup(text)
    StaticPopupDialogs["MY_CUSTOM_POPUP"] = {
        text = text,
        button1 = "OK",
        OnAccept = function() end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("MY_CUSTOM_POPUP")
end

local calcbutton = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
calcbutton:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, 10)
calcbutton:SetSize(100, 40)
calcbutton:SetText("Find pet")
calcbutton:SetScript("OnClick", function(self, button, down)
    if not containsAny(selectedSpecs, { "Protection Warrior", "Guardian" }) then
        ShowPopup("Serpent or Raptor")
    elseif not containsAny(selectedSpecs, { "Fury", "Elemental", "Subtlety", "Feral" }) then
        ShowPopup("Wolf or Devilsaur")
    elseif not containsAny(selectedSpecs, { "Arms", "Combat", "Frost DK" }) then
        ShowPopup("Ravager")
    elseif not containsAny(selectedSpecs, { "Assassination", "Unholy", "Balance", "Affliction", "Demonology", "Destruction" }) then
        ShowPopup("Wind Serpent or DragonHawk")
    elseif not containsAny(selectedSpecs, { "Arms", "Fury", "Protection Warrior", "Enhancement", "Unholy", "Frost DK", "Blood" }) then
        ShowPopup("Cat or spiritbeasts")
    elseif not containsAny(selectedSpecs, { "Arms", "Feral", "Subtlety" }) then
        ShowPopup("Hyena")
    else
        ShowPopup("Bring Whatever u want")
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
