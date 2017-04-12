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

function InstanceScheduler:PartySchedule(times)
    if IsInGroup() then
        if UnitIsConnected("party1") then
            ResetInstances()
            self:SendPartyMessage("ResetComplete")
            self.InGroupTime = GetTime()
            C_Timer.After(1, function()
                self:IntoInstanceSchedule()
            end)
        else
            if times >= 6 then
                local name,realm = UnitName("party1")
                local s = self:NameFormat(name, realm, true)
                UninviteUnit(s)
                self:SendWhisperMessage("NetProblem", s)
            else
                C_Timer.After(1, function()
                    self:PartySchedule(times+1)
                end)
            end
        end
    end
end

function InstanceScheduler:IntoInstanceSchedule()
    if IsInGroup() then
        if not GetPlayerMapPosition("party1") then
            local name,realm = UnitName("party1")
            local s = self:NameFormat(name, realm, true)
            PromoteToLeader(s)
            self:SendPartyMessage("ChangeLeader")
            C_Timer.After(5, function()
                if IsInGroup() then
                    self:SendPartyMessage("LeaveMessage")
                    C_Timer.After(1, function()
                        LeaveParty()
                        local fullname = self:NameFormat(name, realm)
                        local times = InstanceSchedulerVariables.Users[fullname]
                        if times then
                            InstanceSchedulerVariables.Users[fullname] = times + 1
                        else
                            InstanceSchedulerVariables.Users[fullname] = 1
                        end
                    end)
                end
            end)
        else
            if not UnitIsConnected("party1") then
                LeaveParty()
            elseif self.InGroupTime - GetTime() > 120 and #InstanceSchedulerVariables.Line > 0 then
                LeaveParty()
            else
                C_Timer.After(1, function()
                    self:IntoInstanceSchedule()
                end)
            end
        end
    end
end

function InstanceScheduler:UpdateSchedule()
    local t = GetTime()
    if StaticPopup1:IsShown() and StaticPopup1Button1:GetText() == "取消" then
        if t - InstanceScheduler.TempTime > 1 then
            StaticPopup1Button1:Click()
            InstanceScheduler.TempTime = t
        end
    end
end
