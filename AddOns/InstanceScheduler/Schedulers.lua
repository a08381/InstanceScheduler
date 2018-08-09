--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/5/20
-- Time: 18:08
-- To change this template use File | Settings | File Templates.
--

local _, InstanceScheduler = ...

local table, pairs, After, GetTime = table, pairs, C_Timer.After, GetTime
local StaticPopup1, StaticPopup1Button1 = StaticPopup1, StaticPopup1Button1

local IsInGroup, GetNumGroupMembers, LeaveParty, UnitIsConnected, UnitPosition
    = IsInGroup, GetNumGroupMembers, LeaveParty, UnitIsConnected, UnitPosition

local ResetInstances, UnitName, PromoteToLeader, InviteUnit
    = ResetInstances, UnitName, PromoteToLeader, InviteUnit

function InstanceScheduler:InviteSchedule(times)
    if IsInGroup() and GetNumGroupMembers() == 1 then
        if times >= 5 then
            LeaveParty()
        else
            After(1, function()
                self:InviteSchedule(times + 1)
            end)
        end
    end
end

function InstanceScheduler:PartySchedule(times)
    if IsInGroup() then
        if UnitIsConnected("party1") then
            local map = self:GetPlayerMapName("party1")
            for _, v in pairs(self.LeaveMaps) do
                if v == map then
                    self:SendPartyMessage("InstanceProblem")
                    After(0.5, function()
                        LeaveParty()
                    end)
                    return
                end
            end
            ResetInstances()
            self:SendPartyMessage("ResetComplete")
            self.InGroupTime = GetTime()
            After(1, function()
                self:IntoInstanceSchedule()
            end)
        else
            if times >= 6 then
                local s = self:NameFormat(UnitName("party1"))
                LeaveParty()
                self:SendWhisperMessage("NetProblem", s)
            else
                After(1, function()
                    self:PartySchedule(times + 1)
                end)
            end
        end
    end
end

function InstanceScheduler:IntoInstanceSchedule()
    if IsInGroup() then
        if not UnitPosition("party1") then
            local name, realm = UnitName("party1")
            local s = self:NameFormat(name, realm, true)
            After(0.5, function()
                if IsInGroup() then
                    PromoteToLeader(s)
                    self:SendPartyMessage("ChangeLeader")
                    self:SendPartyMessage("LeaveMessage")
                    After(0.5, function()
                        LeaveParty()
                        local fullname = self:NameFormat(name, realm)
                        local realm = self:GetRealm(fullname)
                        if not self.Variables.Users[realm] then
                            self.Variables.Users[realm] = {}
                        end
                        local times = self.Variables.Users[realm][fullname]
                        if times then
                            self.Variables.Users[realm][fullname] = times + 1
                        else
                            self.Variables.Users[realm][fullname] = 1
                        end
                        self.Variables.Total = self.Variables.Total + 1
                    end)
                end
            end)
        else
            if not UnitIsConnected("party1") then
                LeaveParty()
            elseif GetTime() - self.InGroupTime > 20 and #self.Variables.Line > 0 then
                LeaveParty()
            else
                After(1, function()
                    self:IntoInstanceSchedule()
                end)
            end
        end
    end
end

function InstanceScheduler:UpdateSchedule()
    local t = GetTime()
    if t - InstanceScheduler.InviteSchedulerTempTime > 1 then
        InstanceScheduler.InviteSchedulerTempTime = t
        if not IsInGroup() then
            if InstanceScheduler.InGroupPlayer == "" then
                if #InstanceScheduler.Variables.Line > 0 and UnitPosition("player") then
                    local sender = InstanceScheduler.Variables.Line[1]
                    InstanceScheduler.InGroupPlayer = sender
                    InviteUnit(sender)
                    table.remove(InstanceScheduler.Variables.Line, 1)
                end
            else
                InstanceScheduler.CheckTime = InstanceScheduler.CheckTime or 0
                InstanceScheduler.CheckTime = InstanceScheduler.CheckTime + 1
                if InstanceScheduler.CheckTime >= 5 then
                    if InstanceScheduler.CheckTime >= 15 then
                        InstanceScheduler.CheckTime = 0
                        InstanceScheduler.InGroupPlayer = ""
                    else
                        InviteUnit(InstanceScheduler.InGroupPlayer)
                    end
                end
            end
        else
            InstanceScheduler.CheckTime = 0
        end
    end
    if StaticPopup1:IsShown() and StaticPopup1Button1:GetText() == "取消" then
        if t - InstanceScheduler.TempTime > 1 then
            StaticPopup1Button1:Click()
            InstanceScheduler.TempTime = t
        end
    end
end
