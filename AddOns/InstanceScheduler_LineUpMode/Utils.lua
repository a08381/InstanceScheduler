--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/29
-- Time: 0:03
-- To change this template use File | Settings | File Templates.
--

local _, InstanceScheduler = ...

local pairs, table, select = pairs, table, select

local SendChatMessage, GetRealmName, GetMapID, GetMapInfo
    = SendChatMessage, GetRealmName, C_Map.GetBestMapForUnit, C_Map.GetMapInfo

local map = {}
local none = {}

local messages, fullName, res, temp, mapid, player

function InstanceScheduler:SendPartyMessage(key, ...)
    messages = self.Messages[key] or key
    if select('#', ...) > 0 then
        messages = messages:format(...)
    end
    for _, message in pairs(self:Split(messages)) do
        SendChatMessage(message, "PARTY")
    end
end

function InstanceScheduler:SendWhisperMessage(key, name, ...)
    messages = self.Messages[key] or key
    if select('#', ...) > 0 then
        messages = messages:format(...)
    end
    for _, message in pairs(self:Split(messages)) do
        SendChatMessage(message, "WHISPER", nil, name)
    end
end

function InstanceScheduler:SendGuildMessage(key, ...)
    messages = self.Commands[key] or key
    if select('#', ...) > 0 then
        messages = messages:format(...)
    end
    for _, message in pairs(self:Split(messages)) do
        SendChatMessage(message, "GUILD")
    end
end

function InstanceScheduler:NameFormat(name, realm, hide)
    fullName = name
    if not realm or realm == "" then
        if not hide then
            fullName = fullName.."-"..GetRealmName()
        end
    else
        fullName = fullName.."-"..realm
    end
    return fullName
end

function InstanceScheduler:First(main, str)
    return main:len() >= str:len() and main:sub(1, str:len()) == str:lower()
end

function InstanceScheduler:Split(str)
    res = {}
    if not str:match('\r?\n') then
        table.insert(res, str)
    else
        str:gsub('([^\r\n]+)\r?\n', function(n)
            temp = n:match('^%s*(.+)%s*$')
            if temp and not temp:match('^%s*$') then
                table.insert(res, temp)
            end
        end)
    end
    return res
end

function InstanceScheduler:GetPlayerMapName(unit)
    mapid = GetMapID(unit)
    if not mapid then return end
    if not map[mapid] then
        map[mapid] = GetMapInfo(mapid) or none
    end
    return map[mapid].name
end

function InstanceScheduler:GetRealm(fullName)
    return fullName:sub(fullName:find("-") + 1, -1)
end

function InstanceScheduler:ExtendsSavedInstance(stats)
    for i=1,GetNumSavedInstances() do
        local a, _, _, b, _, c = GetSavedInstanceInfo(i)
        for _,v in pairs(self.SavedInstances) do
            if v == a and c~=stats then
                for _, v in pairs(self.DifficultyID) do
                    if v == b then
                        SetSavedInstanceExtend(i, stats)
                        break
                    end
                end
            end
        end
    end
end

function InstanceScheduler:SwitchOn()
    if InstanceScheduler.Status then
        InstanceSchedulerFrame:UnregisterAllEvents()
        InstanceSchedulerFrame:SetScript("OnUpdate", nil)
        InstanceScheduler.Status = false
        InstanceScheduler:ExtendsSavedInstance(InstanceScheduler.Status)
        DEFAULT_CHAT_FRAME:AddMessage(InstanceScheduler.PrintPrefix.."已禁用")
    else
        InstanceSchedulerFrame:RegisterEvent("CHAT_MSG_WHISPER")
        InstanceSchedulerFrame:RegisterEvent("CHAT_MSG_PARTY")
        InstanceSchedulerFrame:RegisterEvent("PARTY_INVITE_REQUEST")
        InstanceSchedulerFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
        InstanceSchedulerFrame:SetScript("OnUpdate", InstanceScheduler.UpdateSchedule)
        InstanceScheduler.Status = true
        InstanceScheduler:ExtendsSavedInstance(InstanceScheduler.Status)
        DEFAULT_CHAT_FRAME:AddMessage(InstanceScheduler.PrintPrefix.."已启用")
    end
end

function InstanceScheduler:CommandInfo(str)
    local stats = 0
    local fps = GetFramerate()
    local _, _, latencyHome, latencyWorld = GetNetStats()
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
