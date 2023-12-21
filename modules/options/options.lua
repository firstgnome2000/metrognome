local options = metrognome:NewModule('Options')
local locale = LibStub('AceLocale-3.0'):GetLocale(options.baseName)
local util = metrognome:GetModule('Util')
-- ─── LOCALS ─────────────────────────────────────────────────────────────────────
--

--
-- ─── DEFAULTS ───────────────────────────────────────────────────────────────────
--

local defaults = {
    profile = {
        -- INTERNAL

        minimapIcon = {
            hide = false,
            radius = 80,
            minimapPos = 270
        },

        --
        -- ─── GENERAL ─────────────────────────────────────────────────────
        --
        toggleSystemEnable = true,
    }
}

--
-- ─── ACCESS METHODS ────────────────────────────────────────────────────────────────────
--

function Options:Get(info)
    if type(info) == 'table' then
        return self.db.profile[info[#info]]
    else
        return self.db.profile[tostring(info)]
    end
end

function Options:Set(info, value)
    if type(info) == 'table' then
        local old = self.db.profile[info[#info]]
        Util:DebugOption(info[#info], value, old)
        self.db.profile[info[#info]] = value
    else
        self.db.profile[tostring(info)] = value
    end
end

function Options:GetColor(info)
    local color = self.db.profile[info[#info]]
    return color.r,
    color.g,
    color.b,
    color.a
end

function Options:SetColor(info, r, g, b, a)
    if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" or type(a) ~= "number" then
        error("Invalid input values")
    end
    self.db.profile[info[#info]] = {
        ['r'] = r,
        ['g'] = g,
        ['b'] = b,
        ['a'] = a
    }
    Util:DebugOption(
        tostring(info[#info]),
        tostring(r)..', '..
        tostring(g)..', '..
        tostring(b)..', '..
        tostring(a)
    )
end

function Options:SetMoney(info, value)
    if not value or type(value) ~= "string" or not value:match("^%d*%.?%d+$") then
        value = 0
    else
        value = Util:ToCopper(value)
    end
    self:Set(info, value)
end

function Options:GetMoney(info)
    local value = self:Get(info)
    if not tonumber(value) then
        error("Value is not a valid number")
    end
    return Util:FormatMoney(value, 'SMART', true)
end

function Options:ConfirmOption(info, value)
    if value ~= nil then
        return value
    else
        return false
    end
end

function Options:RefreshConfig(db)
end

--
-- ─── OPTIONS TABLE ──────────────────────────────────────────────────────────────
--

optionstable = {
    name = Options.baseName,
    handler = Options,
    type = 'group',
    childGroups = 'tree',
    set = 'Set',
    get = 'Get',
    args = {
        descAddon = {
            name = Util:ColorText('A cool addon!', 'info'),
            type = 'description',
            order = 1
        },
        groupSystem = {
            name = L["groupSystem"],
            type = 'group',
            order = 2,
            args = {
                toggleSystemEnable = {
                    name = ENABLE,
                    type = 'toggle',
                    width = 'full',
                    order = 1
                }
            }
        }
    }
}
--
-- ─── INIT ───────────────────────────────────────────────────────────────────────
--
function Options:OnInitialize()
    -- Create DB
    self.db = LibStub("AceDB-3.0"):New(self.baseName .. "DB", defaults)
    self.db:RegisterDefaults(defaults)

    -- Create Profiles section
    optionsTable.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    optionsTable.args.profile.order = 200

    -- Create About section
    optionsTable.args.about = LibStub("LibAboutPanel-2.0"):AboutOptionsTable(self.baseName)
    optionsTable.args.about.order = 201

    -- Create Options
    LibStub("AceConfig-3.0"):RegisterOptionsTable(self.baseName, optionsTable)

    -- Register callbacks
    self.db:RegisterCallback("OnProfileChanged", self.RefreshConfig, self)
    self.db:RegisterCallback("OnProfileCopied", self.RefreshConfig, self)
    self.db:RegisterCallback("OnProfileReset", self.RefreshConfig, self)
end