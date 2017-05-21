--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/5/20
-- Time: 18:08
-- To change this template use File | Settings | File Templates.
--

function InstanceScheduler:InviteSchedule(times)
    if IsInGroup() and GetNumGroupMembers() == 1 then
        if times >= 5 then
            LeaveParty()
        else
            C_Timer.After(1, function()
                self:InviteSchedule(times+1)
            end)
        end
    end
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
                LeaveParty()
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
            C_Timer.After(1, function()
                if IsInGroup() then
                    self:SendPartyMessage("LeaveMessage")
                    C_Timer.After(1, function()
                        LeaveParty()
                        local fullname = self:NameFormat(name, realm)
                        local realm = self:GetRealm(fullname)
                        local times = InstanceSchedulerVariables.Users[realm][fullname]
                        if times then
                            InstanceSchedulerVariables.Users[realm][fullname] = times + 1
                        else
                            InstanceSchedulerVariables.Users[realm][fullname] = 1
                        end
                        InstanceSchedulerVariables.Total = InstanceSchedulerVariables.Total + 1
                    end)
                end
            end)
        else
            if not UnitIsConnected("party1") then
                LeaveParty()
            elseif GetTime() - self.InGroupTime > 60 and #InstanceSchedulerVariables.Line > 0 then
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
