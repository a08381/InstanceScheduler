--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/5/20
-- Time: 18:08
-- To change this template use File | Settings | File Templates.
--

local _, Addon = ...

setfenv(1, Addon)

local CheckTimer = function()
    if not IsInGroup() then
        if Variables.InGroupPlayer == "" then
            if #Variables.Line > 0 and UnitPosition("player") then
                local sender = Variables.Line[1]
                Variables.InGroupPlayer = sender
                InviteUnit(sender)
                table.remove(Variables.Line, 1)
            end
        else
            Variables.InGroupPlayer = ""
        end
    else
        local members = GetNumGroupMembers()
        local times = GetTime()
        if members == 1 then
            if Variables.TempTime ~= 0 and times - Variables.TempTime >= 8 then
                Variables.TempTime = 0
                LeaveParty()
                return
            end
        elseif members == 2 then
            if not UnitIsConnected("party1") then
                if Variables.InGroupTime ~= 0 and times - Variables.InGroupTime >= 5 then
                    Variables.InGroupTime = 0
                    local s = Util:NameFormat(UnitName("party1"))
                    LeaveParty()
                    Util:SendWhisperMessage(Messages["NetProblem"].response, s)
                    return
                elseif Variables.RunTime ~= 0 then
                    Variables.RunTime = 0
                    LeaveParty()
                    return
                end
            else
                if Variables.InGroupTime ~= 0 then
                    Variables.InGroupTime = 0
                    local map = Util:GetPlayerMapName("party1")
                    for _, v in pairs(Variables.LeaveMaps) do
                        if v == map then
                            Util:SendPartyMessage(Messages["InstanceProblem"].response)
                            C_Timer.After(0.5, function()
                                LeaveParty()
                            end)
                            return
                        end
                    end
                    ResetInstances()
                    Util:SendPartyMessage(Messages["ResetComplete"].response)
                    Variables.RunTime = GetTime()
                elseif Variables.RunTime ~= 0 then
                    if times - Variables.RunTime >= SavedVariables.LEAVE_TIME then
                        Variables.RunTime = 0
                        LeaveParty()
                        return
                    else
                        if not UnitPosition("party1") then
                            Variables.RunTime = 0
                            local name, realm = UnitName("party1")
                            local s = Util:NameFormat(name, realm, true)
                            Util:SendPartyMessage(Messages["ChangeLeader"].response)
                            PromoteToLeader(s)
                            Util:SendPartyMessage(Messages["Leave"].response)
                            C_Timer.After(0.5, function()
                                LeaveParty()
                                local fullname = Util:NameFormat(name, realm)
                                local realm = Util:GetRealm(fullname)
                                if not SavedVariables.Users[realm] then
                                    SavedVariables.Users[realm] = {}
                                end
                                local times = SavedVariables.Users[realm][fullname]
                                if times then
                                    SavedVariables.Users[realm][fullname] = times + 1
                                else
                                    SavedVariables.Users[realm][fullname] = 1
                                end
                                SavedVariables.Total = SavedVariables.Total + 1
                            end)
                        end
                    end
                end
            end
        end
    end
end

function Scheduler()
    if not Variables.Status then return end
    xpcall(CheckTimer, ErrorCatcher)
    if StaticPopup1:IsShown() and StaticPopup1Button1:GetText() == "取消" then
        StaticPopup1Button1:Click()
    end
    Variables.Limit = {
        InLine = {},
        RemoveFromLine = {},
        Menu = {},
        InstanceList = {},
        InstanceLocation = {},
        Advice = {},
        AutoResponse = {}
    }
    C_Timer.After(2, Scheduler)
end
