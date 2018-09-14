--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/28
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

local _, Addon = ...

local _G = _G
local rawset = rawset

_G["InstanceScheduler"] = Addon

setmetatable(Addon, {
    __index = function(self, key)
        local val = _G[key]
        if val ~= nil then
            rawset(self, key, val)
        end
        return val
    end })

setfenv(1, Addon)

Variables = {
    InGroupPlayer = "",
    IsGroupPlayerForPortal = false,
    TempTime = 0,
    InGroupTime = 0,
    RunTime = 0,
    TempMembers = 0,
    DifficultyID = { 3, 4, 5, 6, 9, 14, 15 },
    HordeClubID = 832431025,
    AllianceClubID = 832431205,
    HordeInviteCode = "xkMZG9vUOMG",
    AllianceInviteCode = "vgPrwnpTMPm",
    SavedInstances =
    {
        "冰冠堡垒",
        "奥杜尔",
        "火焰之地",
        "风神王座",
        --"巨龙之魂",
        --"魔古山宝库",
        --"雷电王座",
        --"永春台",
        "黑翼血环",
        "决战奥格瑞玛",
        "黑暗神殿",
        "安其拉神殿",
        "地狱火堡垒",
        "黑石铸造厂"
    },
    LeaveMaps =
    {
        "雷神岛",
        "翡翠林",
        "昆莱山",
        "时光之穴"
    },
    Line = {},
    PortalLine = {},
    Limit = {
        InLine = {},
        RemoveFromLine = {},
        WaitPortal = {},
        AutoResponse = {},
        Blacklist = {}
    },
    preBlacklist = {
        CheckTime = GetTime()
    }
}

Frame = CreateFrame("Frame")

Frame:SetScript("OnEvent", function(self, event, ...)
    xpcall(Event[event], ErrorCatcher, ...)
end)

Frame:RegisterEvent("ADDON_LOADED")
