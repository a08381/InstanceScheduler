--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/28
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

local frame = CreateFrame("Frame", "InstanceSchedulerFrame")

frame:SetScript("OnEvent", function(self, event, message, sender)
    if event == "CHAT_MSG_WHISPER" then
        if message:sub(1, 1) == "1" and sender ~= InstanceScheduler:NameFormat(UnitName("player")) then
            for i,v in ipairs(InstanceSchedulerVariables.Line) do
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
            if IsInGroup() then
                if not UnitInParty(sender) then
                    table.insert(InstanceSchedulerVariables.Line, sender)
                    InstanceScheduler:SendWhisperMessage("AddInLine", sender)
                end
            else
                table.insert(InstanceSchedulerVariables.Line, sender)
                if InstanceSchedulerVariables.Line[1] == sender and not IsInGroup() then
                    InviteUnit(sender)
                    table.remove(InstanceSchedulerVariables.Line, 1)
                else
                    InstanceScheduler:SendWhisperMessage("AddInLine", sender)
                end
            end
        end
    elseif event == "CHAT_MSG_PARTY" then
        if message:len() >= 2 and message:sub(1, 2) == "10" and sender ~= InstanceScheduler:NameFormat(UnitName("player")) then
            SetLegacyRaidDifficultyID(3)
            InstanceScheduler:SendPartyMessage("ChangeDifficulty")
        end
    elseif event == "PARTY_INVITE_REQUEST" then
        DeclineGroup()
    elseif event == "CHAT_MSG_GUILD" then
        local CommandPrefix = InstanceScheduler.Commands.CommandPrefix
        if message:len() >= CommandPrefix:len() and message:sub(1, CommandPrefix:len()) == CommandPrefix then
            local arg = message:sub(CommandPrefix:len() + 1, -1)
            if arg:len() >= 4 and arg:sub(1, 4) == "info" then
                InstanceScheduler:CommandInfo(arg:len()==4 and nil or arg:sub(5, -1))
            end
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
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
    elseif event == "VARIABLES_LOADED" then
        if not InstanceSchedulerVariables then
            InstanceSchedulerVariables =
            {
                Line = {},
                Users = {},
            }
        end
        self:UnregisterEvent("VARIABLES_LOADED")
        if InstanceScheduler.AutoStart then
            self:RegisterEvent("CHAT_MSG_WHISPER")
            self:RegisterEvent("CHAT_MSG_PARTY")
            self:RegisterEvent("PARTY_INVITE_REQUEST")
            self:RegisterEvent("GROUP_ROSTER_UPDATE")
            self:SetScript("OnUpdate", InstanceScheduler.UpdateSchedule)
        end
    end
end)

frame:RegisterEvent("VARIABLES_LOADED")
--frame:RegisterEvent("CHAT_MSG_GUILD")
