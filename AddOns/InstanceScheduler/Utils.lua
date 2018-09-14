--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/29
-- Time: 0:03
-- To change this template use File | Settings | File Templates.
--

local _, Addon = ...

setfenv(1, Addon)

Util = {}

local map = {}
local none = {}

local messages, fullName, res, temp, mapid, player

ErrorCatcher = function(err)
    SELECTED_CHAT_FRAME:AddMessage("|cff99ffff【副本进度共享】|r|cfff1c232哦！代码出错了！|r")
    SELECTED_CHAT_FRAME:AddMessage("|cfff1c232请将以下内容截图发送给插件作者以便于调试|r")
    SELECTED_CHAT_FRAME:AddMessage(err)
end

function Util:SendPartyMessage(messages, ...)
    if select('#', ...) > 0 then
        messages = messages:format(...)
    end
    for _, message in pairs(self:Split(messages)) do
        SendChatMessage(message, "PARTY")
    end
end

function Util:SendWhisperMessage(messages, name, ...)
    if select('#', ...) > 0 then
        messages = messages:format(...)
    end
    for _, message in pairs(self:Split(messages)) do
        SendChatMessage(message, "WHISPER", nil, name)
    end
end

function Util:SendGuildMessage(messages, ...)
    if select('#', ...) > 0 then
        messages = messages:format(...)
    end
    for _, message in pairs(self:Split(messages)) do
        SendChatMessage(message, "GUILD")
    end
end

function Util:NameFormat(name, realm, hide)
    if not name then error("正常操作，坐下") return end
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

function Util:First(main, str)
    local flag = false
    str:gsub("[^|]+", function(k)
        if main:len() >= k:len() and main:sub(1, k:len()):lower() == k:lower() then
            flag = true
        end
    end)
    return flag
end

function Util:Split(str)
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

function Util:GetPlayerMapName(unit)
    mapid = C_Map.GetBestMapForUnit(unit)
    if not mapid then return end
    if not map[mapid] then
        map[mapid] = C_Map.GetMapInfo(mapid) or none
    end
    return map[mapid].name
end

function Util:GetRealm(fullName)
    return fullName:sub(fullName:find("-") + 1, -1)
end

function Util:ExtendsSavedInstance(stats)
    for i=1,GetNumSavedInstances() do
        local a, _, _, b, _, c = GetSavedInstanceInfo(i)
        for _,v in pairs(Variables.SavedInstances) do
            if v == a and c~=stats then
                for _, v in pairs(Variables.DifficultyID) do
                    if v == b then
                        if not stats and SavedVariables.Extended_Only then break end
                        SetSavedInstanceExtend(i, stats)
                        break
                    end
                end
            end
        end
    end
end

function Util:SwitchOn()
    if Variables.Status then
        Frame:UnregisterAllEvents()
        Variables.Status = false
        if SavedVariables.Extended then Util:ExtendsSavedInstance(Variables.Status) end
        DEFAULT_CHAT_FRAME:AddMessage(Locale.PrintPrefix..Locale.SwitchOff)
    else
        Frame:RegisterEvent("CHAT_MSG_WHISPER")
        Frame:RegisterEvent("CHAT_MSG_PARTY")
        Frame:RegisterEvent("PARTY_INVITE_REQUEST")
        Frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        Variables.Status = true
        C_Timer.After(2, Scheduler)
        if SavedVariables.Extended then Util:ExtendsSavedInstance(Variables.Status) end
        Variables.preBlacklist["CheckTime"] = GetTime()
        DEFAULT_CHAT_FRAME:AddMessage(Locale.PrintPrefix..Locale.SwitchOn)
    end
end

function Util:CommandInfo(str)
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
