--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/29
-- Time: 0:03
-- To change this template use File | Settings | File Templates.
--

function InstanceScheduler:NameFormat(name, realm)
    local fullName = name.."-"
    if not realm or realm == "" then
        fullName = fullName..GetRealmName()
    else
        fullName = fullName..realm
    end
    return fullName
end

function InstanceScheduler:GetRealm(fullName)
    if fullName:find("-") then
        local _, index = fullName:find("-")
        index = index + 1
        return fullName:sub(index)
    else
        return GetRealmName()
    end
end

function InstanceScheduler:IsPaidRealm(fullName)
    for _,v in pairs(self.PaidRealm) do
        if GetRealm(fullName) == v then
            return true
        end
    end
    return false
end

function InstanceScheduler:PartySchedule()
    if UnitIsConnected("party1") then
        ResetInstances()
        SendChatMessage(self.Messages.GroupWelcome,"PARTY")
    else
        C_Timer.After(1, self.PartySchedule)
    end
end

function InstanceScheduler:UpdateSchedule()
    local t = GetTime()
    if StaticPopup1:IsShown() and StaticPopup1Button1:GetText() == "取消" then
        if t - self.TempTime > 1 then
            StaticPopup1Button1:Click()
            self.TempTime = t
        end
    end
end

function InstanceScheduler:AddBlacklistSlash(str)
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