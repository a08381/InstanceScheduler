--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/5/20
-- Time: 18:07
-- To change this template use File | Settings | File Templates.
--

local AddonName, InstanceScheduler = ...

InstanceScheduler["CHAT_MSG_WHISPER"] = function(...)
    local _, message, sender = ...
    if message:sub(1, 1) == "1" and sender ~= InstanceScheduler:NameFormat(UnitName("player")) then
        for i, v in ipairs(InstanceSchedulerVariables.Line) do
            if sender == v then
                InstanceScheduler:SendWhisperMessage("AlreadyInLine", sender, i)
                if not IsInGroup() and #InstanceSchedulerVariables.Line > 0 then
                    local name = InstanceSchedulerVariables.Line[1]
                    table.remove(InstanceSchedulerVariables.Line, 1)
                    InviteUnit(name)
                end
                return
            end
        end
        if not UnitInParty(sender) then
            table.insert(InstanceSchedulerVariables.Line, sender)
            if InstanceSchedulerVariables.Line[1] == sender and not IsInGroup() then
                InviteUnit(sender)
                table.remove(InstanceSchedulerVariables.Line, 1)
            else
                InstanceScheduler:SendWhisperMessage("AddInLine", sender)
            end
        end
    end
end

InstanceScheduler["CHAT_MSG_PARTY"] = function(...)
    local _, message, sender = ...
    if message:len() >= 2 and message:sub(1, 2) == "10" and sender ~= InstanceScheduler:NameFormat(UnitName("player")) then
        SetLegacyRaidDifficultyID(3)
        InstanceScheduler:SendPartyMessage("ChangeDifficulty")
    end
end

InstanceScheduler["CHAT_MSG_GUILD"] = function(...)
    local CommandPrefix, _, message = InstanceScheduler.Commands.CommandPrefix, ...
    if message:len() >= CommandPrefix:len() and message:sub(1, CommandPrefix:len()) == CommandPrefix then
        local arg = message:sub(CommandPrefix:len() + 1, -1)
        if arg:len() >= 4 and arg:sub(1, 4) == "info" then
            InstanceScheduler:CommandInfo(arg:len() == 4 and nil or arg:sub(5, -1))
        end
    end
end

InstanceScheduler["PARTY_INVITE_REQUEST"] = function(...)
    DeclineGroup()
end

InstanceScheduler["GROUP_ROSTER_UPDATE"] = function(...)
    if IsInGroup() then
        if GetNumGroupMembers() == 1 then
            InstanceScheduler:InviteSchedule(0)
        end
        if GetNumGroupMembers() == 2 and UnitIsGroupLeader("player") and InstanceScheduler.InGroupPlayer ~= InstanceScheduler:NameFormat(UnitName("party1")) then
            InstanceScheduler.InGroupPlayer = InstanceScheduler:NameFormat(UnitName("party1"))
            InstanceScheduler:PartySchedule(0)
        end
    else
        if InstanceScheduler.InGroupPlayer ~= "" then
            InstanceScheduler.InGroupPlayer = ""
        end
        if GetLegacyRaidDifficultyID() == 3 then
            SetLegacyRaidDifficultyID(4)
        end
        if InstanceScheduler.TempMembers == 1 or InstanceScheduler.TempMembers == 2 then
            if #InstanceSchedulerVariables.Line > 0 then
                local name = InstanceSchedulerVariables.Line[1]
                table.remove(InstanceSchedulerVariables.Line, 1)
                InviteUnit(name)
            end
        end
    end
    InstanceScheduler.TempMembers = IsInGroup() and GetNumGroupMembers() or 0
end

InstanceScheduler["VARIABLES_LOADED"] = function(...)
    local frame = ...
    local ver = GetAddOnMetadata(AddonName, "Version")
    if not InstanceSchedulerVariables then
        InstanceSchedulerVariables =
        {
            Version = ver,
            Line = {},
            Users = {},
            Total = 0
        }
    elseif not InstanceSchedulerVariables.Version then
        InstanceSchedulerVariables.Version = ver
        local temp = InstanceSchedulerVariables.Users
        InstanceSchedulerVariables.Users = {}
        local total = 0
        for k,v in pairs(temp) do
            local realm = InstanceScheduler:GetRealm(k)
            if not InstanceSchedulerVariables.Users[realm] then
                InstanceSchedulerVariables.Users[realm] = {}
            end
            InstanceSchedulerVariables.Users[realm][k] = v
            total = total + v
        end
        InstanceSchedulerVariables.Total = total
    end
    frame:UnregisterEvent("VARIABLES_LOADED")
    if InstanceScheduler.AutoStart then
        frame:RegisterEvent("CHAT_MSG_WHISPER")
        frame:RegisterEvent("CHAT_MSG_PARTY")
        frame:RegisterEvent("PARTY_INVITE_REQUEST")
        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:SetScript("OnUpdate", InstanceScheduler.UpdateSchedule)
    end
end
