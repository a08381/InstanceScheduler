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
            if IsInGroup() then
                if not UnitInParty(sender) then
                    for i,v in ipairs(InstanceSchedulerVariables.Line) do
                        if sender == v then
                            InstanceScheduler:SendWhisperMessage("AlreadyInLine", sender, i)
                            return
                        end
                    end
                    table.insert(InstanceSchedulerVariables.Line, sender)
                    InstanceScheduler:SendWhisperMessage("AddInLine", sender)
                end
            else
                InviteUnit(sender)
            end
        end
    elseif event == "CHAT_MSG_PARTY" then
        if message:len() >= 2 and message:sub(1, 2) == "10" and sender ~= InstanceScheduler:NameFormat(UnitName("player")) then
            SetLegacyRaidDifficultyID(3)
            InstanceScheduler:SendPartyMessage("ChangeDifficulty")
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
        if IsInGroup() and GetNumGroupMembers() == 2 and UnitIsGroupLeader("player") and InstanceScheduler.InGroupPlayer ~= InstanceScheduler:NameFormat(UnitName("party1")) then
            InstanceScheduler.InGroupPlayer = InstanceScheduler:NameFormat(UnitName("party1"))
            InstanceScheduler:PartySchedule(0)
        elseif not IsInGroup() then
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
    end
end)

frame:RegisterEvent("VARIABLES_LOADED")

if InstanceScheduler.AutoStart then
    frame:RegisterEvent("CHAT_MSG_WHISPER")
    frame:RegisterEvent("CHAT_MSG_PARTY")
    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:SetScript("OnUpdate", InstanceScheduler.UpdateSchedule)
end

local button = CreateFrame("Button", "InstanceSchedulerButton")
button:SetScript("OnClick", function(self)
    if InstanceScheduler.AutoStart then
        frame:UnregisterAllEvents()
        frame:SetScript("OnUpdate", nil)
        InstanceScheduler.AutoStart = false
        DEFAULT_CHAT_FRAME:AddMessage(InstanceScheduler.PrintPrefix.."已禁用")
    else
        frame:RegisterEvent("CHAT_MSG_WHISPER")
        frame:RegisterEvent("CHAT_MSG_PARTY")
        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:SetScript("OnUpdate", InstanceScheduler.UpdateSchedule)
        InstanceScheduler.AutoStart = true
        DEFAULT_CHAT_FRAME:AddMessage(InstanceScheduler.PrintPrefix.."已启用")
    end
end)
