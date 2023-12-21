-- Load necessary libraries
local libraryLoader = LibStub("LibStub-1.0")
local addon = libraryLoader("AceAddon-3.0")
local console = libraryLoader("AceConsole-3.0")
local event = libraryLoader("AceEvent-3.0")
if not (addon and console and event) then
    error("Failed to load necessary libraries.")
end

-- Create the addon object using AceAddon
local Metrognome = addon:NewAddon("Metrognome", "AceConsole-3.0", "AceEvent-3.0")

-- Create the addon frame
local frame

-- Create the character list
local characterList = {}

-- Function to update the gold display
local function UpdateGoldDisplay()
    if not frame:IsShown() then
        return
    end

    -- Update character gold information
    local yOffset = -10
    for i, character in ipairs(characterList) do
        character.nameText:SetText(character.name)
        character.moneyText:SetText(GetCoinTextureString(character.money))
        character:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, yOffset)
        character:Show()
        yOffset = yOffset - 20
    end

    -- Hide remaining character frames
    for i = #characterList + 1, #frame do
        frame[i]:Hide()
    end
end

-- Function to handle console commands
local function HandleConsoleCommand(input)
    -- Handle the console command here
    print("Received console command: " .. input)
end

-- Function to handle events
local function HandleEvent(event, ...)
    -- Handle the event here
    print("Received event: " .. event)
end

-- Function to initialize the addon
function Metrognome:OnInitialize()
    -- Declare frame variable with local
    frame = CreateFrame("Frame", "MetrognomeFrame", UIParent)
    frame:SetSize(300, 200)
    frame:SetPoint("CENTER")
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0, 0, 0, 1)
    frame:Hide()

    -- Create the title text
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", frame, "TOP", 0, -10)
    title:SetText("Metrognome Addon")

    -- Register slash command
    self:RegisterChatCommand("income", function()
        frame:SetShown(not frame:IsShown())
        -- UpdateGoldDisplay()
    end)
end

-- Register console commands
console:RegisterChatCommand("metrognome", HandleConsoleCommand)

-- Register events
event:RegisterEvent("PLAYER_LOGIN", HandleEvent)
event:RegisterEvent("PLAYER_LOGOUT", HandleEvent)

-- Function to handle player login event
local function OnPlayerLogin()
    -- Populate character list
    characterList = {}
    local frame = CreateFrame("Frame") -- Assuming frame is a valid frame object
    for i = 1, GetNumCharacters() do
        local name, _, _, _, _, _, _, _, _, _, money = GetCharacterInfo(i)
        if name and money then
            local character = characterList[i]
            if not character then
                character = CreateFrame("Frame", nil, frame)
                characterList[i] = character
            end
            character.nameText = character:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            character.moneyText = character:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            character.name = name
            character.money = money
        end
    end

    -- Update gold display
    UpdateGoldDisplay()

    print("Metrognome Addon loaded!")
end

-- Initialize the addon
local function OnInitialize()
    Metrognome.OnPlayerLogin = OnPlayerLogin
    -- Add other functions and variables to Metrognome table as needed
    -- ...
    Metrognome:OnPlayerLogin()
end

OnInitialize()