local LibStub = LibStub("LibStub-1.0")
local metrognome = LibStub("AceAddon-3.0"):NewAddon("metrognome", "AceConsole-3.0", "AceEvent-3.0")
local addonName = metrognome:GetName()
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- Minimap Icon
local function OpenOptionsWindow()
    local Ace = LibStub("AceConfigDialog-3.0")
    Ace:Open(addonName)
end

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
    type = "launcher",
    icon = format("Interface\\AddOns\\%s\\icon", addonName),
    OnClick = function(clickedframe, button)
        if button == "LeftButton" then
            OpenOptionsWindow()
        end
    end,
    OnTooltipShow = function(Tip)
        if not Tip or not Tip.AddLine then
            return
        end
        Tip:AddLine(addonName, 1, 1, 1)
    end,
})

-- Initialize
function metrognome:OnInitialize()
    -- No initialization code
end

-- Enable
function metrognome:OnEnable()
    -- Get Modules
    Options = self:GetModule("Options")
    Util = self:GetModule("Util")

    -- Slash Commands
    self:RegisterChatCommand("income", "ChatCommand")

    -- Minimap Icon
    LibStub("LibDBIcon-1.0"):Register("metrognome", LDB, Options:Get("minimapIcon"))
end

-- Chat Commands
function metrognome:ChatCommand(input)
    if not input or input:trim() == "" then
        OpenOptionsWindow()
    elseif input == "help" then
        Util:Print("--- Available Commands ---")
        -- NOTE: Print other chat commands here
    else
        OpenOptionsWindow()
    end
end