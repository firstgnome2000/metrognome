-- Load AceAddon, AceConsole, and AceEvent
local AceAddon = LibStub("AceAddon-3.0")
local AceConsole = LibStub("AceConsole-3.0")
local AceEvent = LibStub("AceEvent-3.0")

-- Create the addon object using AceAddon
local Metrognome = AceAddon:NewAddon("Metrognome", "AceConsole-3.0", "AceEvent-3.0")

-- Create the addon frame
local frame

-- Create the character list
local characterList = {}

-- Function to update the gold display
local function UpdateGoldDisplay()
    if not frame:IsShown() then
        return
    end

    -- Clear previous entries
    for i = 1, #characterList do
        characterList[i]:Hide()
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
    -- Create the addon frame
    frame = CreateFrame("Frame", "MetrognomeFrame", UIParent)
    frame:SetSize(300, 200)
    frame:SetPoint("CENTER")
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 16, edgeSize = 16,
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
        UpdateGoldDisplay()
    end)

    -- Register console commands
    AceConsole:RegisterChatCommand("metrognome", HandleConsoleCommand)

    -- Register events
    AceEvent:RegisterEvent("PLAYER_LOGIN", HandleEvent)
    AceEvent:RegisterEvent("PLAYER_LOGOUT", HandleEvent)
end

-- Function to handle player login event
function Metrognome:OnPlayerLogin()
    -- Populate character list
    for i = 1, GetNumCharacters() do
        local name, _, _, _, _, _, _, _, _, _, money = GetCharacterInfo(i)
        characterList[i] = CreateFrame("Frame", nil, frame)
        characterList[i].nameText = characterList[i]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        characterList[i].moneyText = characterList[i]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        characterList[i].name = name
        characterList[i].money = money
    end

    -- Update gold display
    UpdateGoldDisplay()

    print("Metrognome Addon loaded!")
end

-- Initialize the addon
Metrognome:OnInitialize()