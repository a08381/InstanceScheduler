--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/28
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

local _, Addon = ...
_G["InstanceScheduler"] = Addon

--[[
local blacklist =
{
    "抹茶米粒-屠魔山谷",
    "砍野德就脱坑-阿格拉玛",
    "玉环法神-阿格拉玛",
}
]]

local frame = CreateFrame("Frame", "InstanceScheduleFrame")

frame:SetScript("OnEvent", function(self, event, ...)
    local args = { ... }
    if event == "VARIABLES_LOADED" then
        if not InstanceSchedulerVariables then
            InstanceSchedulerVariables =
            {
                Users = {},
                Blacklist = {},
                Messages =
                {
                    Whisper =
                    {
                        Keywords = Addon.Keywords,
                        Repeats = Addon.Repeats
                    },

                }
            }
        end
        self:UnregisterEvent("VARIABLES_LOADED")
    elseif event == "CHAT_MSG_WHISPER" then
        if args[1] == "1" and args[2] ~= Addon:NameFormat(UnitName("player")) then
            if GetNumGroupMembers() ~= 5 then
                InviteUnit(args[2])
            end
        end
    elseif event == "CHAT_MSG_GUILD" then
        if args[1] == "1" and args[2] ~= Addon:NameFormat(UnitName("player")) then
            if GetNumGroupMembers() ~= 5 then
                InviteUnit(args[2])
            end
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
        local members = GetNumGroupMembers()
        if IsInGroup() and UnitIsGroupLeader("player") and members > Addon.TempMembers then
            for i=1,members-1 do
                if not UnitIsConnected("party"..i) then
                    Addon:PartySchedule("party"..i, 0)
                end
            end
        end
        Addon.TempMembers = members or 0
    end
end)

if Addon:AutoStart then
    frame:RegisterEvent("CHAT_MSG_WHISPER")
    frame:RegisterEvent("CHAT_MSG_GUILD")
    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:SetScript("OnUpdate", Addon:UpdateSchedule)
end

local button = CreateFrame("Button", "InstanceScheduleButton")
button:SetScript("OnClick", function(self)
    if Addon.AutoStart then
        frame:UnregisterAllEvents()
        frame:SetScript("OnUpdate", nil)
        Addon.AutoStart = false
        DEFAULT_CHAT_FRAME:AddMessage(Addon:PrintPrefix.."已禁用")
    else
        frame:RegisterEvent("CHAT_MSG_WHISPER")
        frame:RegisterEvent("CHAT_MSG_GUILD")
        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:SetScript("OnUpdate", Addon:UpdateSchedule)
        Addon.AutoStart = true
        DEFAULT_CHAT_FRAME:AddMessage(Addon.PrintPrefix.."已启用")
    end
end)