--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/28
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

local _, InstanceScheduler = ...
_G["InstanceScheduler"] = InstanceScheduler

local frame = CreateFrame("Frame", "InstanceScheduleFrame")

frame:SetScript("OnEvent", function(self, event, ...)
    local args = { ... }
    if event == "VARIABLES_LOADED" then
        if not InstanceSchedulerVariables then
            InstanceSchedulerVariables =
            {
                Line = {},
                Users = {},
            }
        end
        self:UnregisterEvent("VARIABLES_LOADED")
    elseif event == "CHAT_MSG_WHISPER" then
        if args[1]:sub(1, 1) == "1" and args[2] ~= InstanceScheduler:NameFormat(UnitName("player")) then
            if IsInGroup() then
                if not UnitInParty(args[2]) then
                    for i,v in ipairs(InstanceSchedulerVariables.Line) do
                        if args[2] == v then
                            InstanceScheduler:SendWhisperMessage("AlreadyInLine", args[2], i)
                            return
                        end
                    end
                    table.insert(InstanceSchedulerVariables.Line, args[2])
                    InstanceScheduler:SendWhisperMessage("AddInLine", args[2])
                end
            else
                InviteUnit(args[2])
            end
        end
    elseif event == "CHAT_MSG_PARTY" then
        if args[1]:sub(1, 2) == "10" and args[2] ~= InstanceScheduler:NameFormat(UnitName("player")) then
            SetLegacyRaidDifficultyID(3)
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
        if IsInGroup() and GetNumGroupMembers() == 2 and UnitIsGroupLeader("player") and InstanceScheduler.InGroupPlayer ~= InstanceScheduler:NameFormat(UnitName("party1")) then
            InstanceScheduler.InGroupPlayer = InstanceScheduler:NameFormat(UnitName("party1"))
            InstanceScheduler:PartySchedule(0)
        elseif not IsInGroup() and InstanceScheduler.TempMembers == 1 then
            local name = InstanceSchedulerVariables.Line[1]
            table.remove(InstanceSchedulerVariables.Line, 1)
            InviteUnit(name)
        end
        InstanceScheduler.TempMembers = IsInGroup() and GetNumGroupMembers() or 0
    end
end)

if InstanceScheduler:AutoStart then
    frame:RegisterEvent("CHAT_MSG_WHISPER")
    frame:RegisterEvent("CHAT_MSG_PARTY")
    frame:RegisterEvent("CHAT_MSG_PARTY_LEADER")
    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:SetScript("OnUpdate", InstanceScheduler.UpdateSchedule)
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
        frame:SetScript("OnUpdate", InstanceScheduler.UpdateSchedule)
        InstanceScheduler.AutoStart = true
        DEFAULT_CHAT_FRAME:AddMessage(InstanceScheduler.PrintPrefix.."已启用")
    end
end)
