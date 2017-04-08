--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/29
-- Time: 0:03
-- To change this template use File | Settings | File Templates.
--

local Addon = _G["InstanceScheduler"]

function Addon:NameFormat(name, realm)
    local fullName = name.."-"
    if not realm or realm == "" then
        fullName = fullName..GetRealmName()
    else
        fullName = fullName..realm
    end
    return fullName
end

function Addon:CommandInfo(str)
    local stats = 0
    local fps = GetFramerate()
    local _,_,latencyHome,latencyWorld = GetNetStats()
    if fps >= 30 then
        stats = stats + 0
    elseif fps >= 20 and fps < 30 then
        stats = stats + 1
    elseif fps >= 10 and fps < 20 then
        stats = stats + 2
    else
        stats = stats + 3
    end
    if latencyHome < 150 then
        stats = stats + 0
    elseif latencyHome >= 150 and latencyHome < 300 then
        stats = stats + 1
    elseif latencyHome >= 300 and latencyHome < 500 then
        stats = stats + 2
    else
        stats = stats + 3
    end
    if latencyWorld < 150 then
        stats = stats + 0
    elseif latencyWorld >= 150 and latencyWorld < 300 then
        stats = stats + 1
    elseif latencyWorld >= 300 and latencyWorld < 500 then
        stats = stats + 2
    else
        stats = stats + 3
    end
    local statusText
    if stats == 0 then
        statusText = Addon.Messages.InfoGreat
    elseif stats == 1 then
        statusText = Addon.Messages.InfoGood
    elseif stats == 2 then
        statusText = Addon.Messages.InfoNotbad
    elseif stats == 3 then
        statusText = Addon.Messages.InfoBad
    else
        statusText = Addon.Messages.InfoWorst
    end
    SenfChatMessage(Addon.Messages.CommandInfo:format(latencyHome, latencyWorld, fps, statusText), "GUILD")
end

function Addon:PartySchedule(unit, i)
    if UnitIsConnected(unit) then
        ResetInstances()
        SendChatMessage(self.Messages.GroupWelcome,"PARTY")
    else
        if i > 6 then
            UninviteUnit(self:NameFormat(UnitName(unit)), "Disconneted")
            return
        end
        C_Timer.After(1, function()self:PartySchedule(unit, i+1) end)
    end
end

function Addon:UpdateSchedule()
    local t = GetTime()
    if StaticPopup1:IsShown() and StaticPopup1Button1:GetText() == "取消" then
        if t - self.TempTime > 1 then
            StaticPopup1Button1:Click()
            self.TempTime = t
        end
    end
end

function Addon:AddBlacklistSlash(str)
    local fullName = str:gsub("^%s*(.-)%s*$", "%1")
    for _,v in pairs(InstanceSchedulerBlacklist) do
        if fullName == v then
            DEFAULT_CHAT_FRAME:AddMessage(self.PrintPrefix..self.Messages.AlreadyInBlacklist)
            return
        end
    end
    InstanceSchedulerBlacklist:insert(fullName)
    DEFAULT_CHAT_FRAME:AddMessage(self.PrintPrefix..self.Messages.AddBlacklistSuccess)
end

function Addon:RemoveBlacklistSlash(str)
    local fullName = str:gsub("^%s*(.-)%s*$", "%1")
    for i,v in ipairs(InstanceSchedulerBlacklist) do
        if fullName == v then
            InstanceSchedulerBlacklist:remove(i)
            DEFAULT_CHAT_FRAME:AddMessage(self.PrintPrefix..self.Messages.RemoveBlacklistSuccess)
            return
        end
    end
    DEFAULT_CHAT_FRAME:AddMessage(self.PrintPrefix..self.Messages.NotInBlacklist)
end

function Addon:ListBlacklistSlash(str)
    DEFAULT_CHAT_FRAME:AddMessage(self.Messages.ListBlacklist:format(#InstanceSchedulerBlacklist))
    for i,v in ipairs(InstanceSchedulerBlacklist) do
        DEFAULT_CHAT_FRAME:AddMessage(self.Messages.BlacklistFormat:format(i, v))
    end
end

SlashCmdList["INSTANCESCHEDULERADDBLACKLIST"] = InstanceScheduler.AddBlacklistSlash
SLASH_INSTANCESCHEDULERADDBLACKLIST1 = "/isadd"
SlashCmdList["INSTANCESCHEDULERREMOVEBLACKLIST"] = InstanceScheduler.RemoveBlacklistSlash
SLASH_INSTANCESCHEDULERREMOVEBLACKLIST1 = "/isrm"
SlashCmdList["INSTANCESCHEDULERLISTBLACKLIST"] = InstanceScheduler.ListBlacklistSlash
SLASH_INSTANCESCHEDULERLISTBLACKLIST1 = "/isls"