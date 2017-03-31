--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/28
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

local _, InstanceScheduler = ...
_G["InstanceScheduler"] = InstanceScheduler

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
        if not InstanceSchedulerBlacklist then
            InstanceSchedulerBlacklist = {}
        end
        self:UnregisterEvent("VARIABLES_LOADED")
    elseif event == "CHAT_MSG_WHISPER" then
        if args[1] == "1" and args[2] ~= InstanceScheduler:NameFormat(UnitName("player")) then
            if IsInGroup() then
                if not UnitInParty(args[2]) then
                    SendChatMessage(InstanceScheduler.Messages.OthersInGroup, "WHISPER", nil, args[2])
                else
                    SendChatMessage(InstanceScheduler.Messages.GroupWelcome, "PARTY")
                end
            else
                InviteUnit(args[2])
            end
        end
    elseif event == "CHAT_MSG_PARTY" then
        if args[1] == "1" and args[2] ~= InstanceScheduler:NameFormat(UnitName("player")) then
            PromoteToLeader(args[2])
            SendChatMessage(InstanceScheduler.Messages.ChangeLeader, "PARTY")
        end
    elseif event == "CHAT_MSG_PARTY_LEADER" then
        if args[1] == "1" and args[2] ~= InstanceScheduler:NameFormat(UnitName("player")) then
            SendChatMessage(InstanceScheduler.Messages.Finish, "PARTY")
            if isPaid and IsPaidRealm(InstanceScheduler:NameFormat(UnitName("player"))) then
                SendChatMessage(InstanceScheduler.Messages.Notice, "PARTY")
            end
            C_Timer.After(1, function()LeaveParty() end)
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
        if IsInGroup() and GetNumGroupMembers() == 2 and UnitIsGroupLeader("player") then
            InstanceScheduler:PartySchedule()
        end
    end
end)

if InstanceScheduler:AutoStart then
    frame:RegisterEvent("CHAT_MSG_WHISPER")
    frame:RegisterEvent("CHAT_MSG_PARTY")
    frame:RegisterEvent("CHAT_MSG_PARTY_LEADER")
    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:SetScript("OnUpdate", InstanceScheduler:UpdateSchedule)
end

local button = CreateFrame("Button", "InstanceScheduleButton")
button:SetScript("OnClick", function(self)
    if InstanceScheduler.AutoStart then
        frame:UnregisterAllEvents()
        frame:SetScript("OnUpdate", nil)
        InstanceScheduler.AutoStart = false
        DEFAULT_CHAT_FRAME:AddMessage(InstanceScheduler:PrintPrefix.."已禁用")
    else
        frame:RegisterEvent("CHAT_MSG_WHISPER")
        frame:RegisterEvent("CHAT_MSG_PARTY")
        frame:RegisterEvent("CHAT_MSG_PARTY_LEADER")
        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:SetScript("OnUpdate", InstanceScheduler:UpdateSchedule)
        InstanceScheduler.AutoStart = true
        DEFAULT_CHAT_FRAME:AddMessage(InstanceScheduler.PrintPrefix.."已启用")
    end
end)