--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/29
-- Time: 0:03
-- To change this template use File | Settings | File Templates.
--

function InstanceScheduler:SendPartyMessage(key, ...)
    local args = { ... }
    local message = self.Messages[key]
    if #args > 0 then
        message = message:format(...)
    end
    SendChatMessage(message, "PARTY")
end

function InstanceScheduler:SendWhisperMessage(key, name, ...)
    local args = { ... }
    local message = self.Messages[key]
    if #args > 0 then
        message = message:format(...)
    end
    SendChatMessage(message, "WHISPER", nil, name)
end

function InstanceScheduler:SendGuildMessage(key, ...)
    local args = { ... }
    local message = self.Commands[key]
    if #args > 0 then
        message = message:format(...)
    end
    SendChatMessage(message, "GUILD")
end

function InstanceScheduler:NameFormat(name, realm, hide)
    local fullName = name
    if not realm or realm == "" then
        if not hide then
            fullName = fullName.."-"..GetRealmName()
        end
    else
        fullName = fullName.."-"..realm
    end
    return fullName
end

function InstanceScheduler:ExtendsSavedInstance(stats)
    for i=1,GetNumSavedInstances() do
        local a,_,_,_,_,c = GetSavedInstanceInfo(i)
        for _,v in pairs(self.SavedInstances) do
            if v == a and c~=stats then
                SetSavedInstanceExtend(i, stats)
            end
        end
    end
end

function InstanceScheduler:SwitchOn()
    if InstanceScheduler.AutoStart then
        InstanceSchedulerFrame:UnregisterAllEvents()
        InstanceSchedulerFrame:SetScript("OnUpdate", nil)
        InstanceScheduler.AutoStart = false
        InstanceScheduler:ExtendsSavedInstance(InstanceScheduler.AutoStart)
        DEFAULT_CHAT_FRAME:AddMessage(InstanceScheduler.PrintPrefix.."已禁用")
    else
        InstanceSchedulerFrame:RegisterEvent("CHAT_MSG_WHISPER")
        InstanceSchedulerFrame:RegisterEvent("CHAT_MSG_PARTY")
        InstanceSchedulerFrame:RegisterEvent("PARTY_INVITE_REQUEST")
        InstanceSchedulerFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
        InstanceSchedulerFrame:SetScript("OnUpdate", InstanceScheduler.UpdateSchedule)
        InstanceScheduler.AutoStart = true
        InstanceScheduler:ExtendsSavedInstance(InstanceScheduler.AutoStart)
        DEFAULT_CHAT_FRAME:AddMessage(InstanceScheduler.PrintPrefix.."已启用")
    end
end

function InstanceScheduler:CommandInfo(str)
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
    local statusText = InstanceScheduler.Commands.InfoWorst
    if stats == 0 then
        statusText = InstanceScheduler.Commands.InfoGreat
    elseif stats == 1 then
        statusText = InstanceScheduler.Commands.InfoGood
    elseif stats == 2 then
        statusText = InstanceScheduler.Commands.InfoNotbad
    elseif stats == 3 then
        statusText = InstanceScheduler.Commands.InfoBad
    end
    self:SendGuildMessage("CommandInfo", latencyHome, latencyWorld, fps, statusText)
end
