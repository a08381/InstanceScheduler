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
            if #Variables.PortalLine > 0 and UnitPosition("player") then
                local sender = Variables.PortalLine[1]
                Variables.InGroupPlayer = sender
                Variables.IsGroupPlayerForPortal = true
                InviteUnit(sender)
                table.remove(Variables.PortalLine, 1)
                return
            end
            if #Variables.Line > 0 and UnitPosition("player") then
                local sender = Variables.Line[1]
                Variables.InGroupPlayer = sender
                InviteUnit(sender)
                table.remove(Variables.Line, 1)
                return
            end
        else
            Variables.InGroupPlayer = ""
            Variables.IsGroupPlayerForPortal = false
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
                    if Variables.IsGroupPlayerForPortal then
                        local imap = Util:GetPlayerMapName("player")
                        if imap ~= map then
                            LeaveParty()
                        else
                            Variables.RunTime = GetTime()
                        end
                    else
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
                    end
                elseif Variables.RunTime ~= 0 then
                    if times - Variables.RunTime >= SavedVariables.LEAVE_TIME then
                        Variables.RunTime = 0
                        LeaveParty()
                        return
                    else
                        if Variables.IsGroupPlayerForPortal then
                            local map, imap = Util:GetPlayerMapName("party1"), Util:GetPlayerMapName("player")
                            if map ~= imap then
                                Variables.RunTime = 0
                                LeaveParty()
                            end
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
end

local settingBlacklist = function()
    local time = time()
    for k, v in pairs(Variables.preBlacklist) do
        if k ~= "CheckTime" and v >= 10 then
            if SavedVariables.Blacklist[k] then
                SavedVariables.Blacklist[k] = SavedVariables.Blacklist[k] + 1800
                if SavedVariables.Blacklist[k] - time >= 7200 then
                    SavedVariables.Blacklist[k] = -1
                end
            else
                SavedVariables.Blacklist[k] = time + 1800
            end
        end
    end
    wipe(Variables.preBlacklist)
    Variables.preBlacklist["CheckTime"] = GetTime()
end

local preparingBlacklist = function()
    for _, n in pairs(Variables.Limit) do
        for k in pairs(n) do
            if Variables.preBlacklist[k] then
                Variables.preBlacklist[k] = Variables.preBlacklist[k] + 1
            else
                Variables.preBlacklist[k] = 1
            end
        end
        wipe(n)
    end
end

function Scheduler()
    if not Variables.Status then return end
    xpcall(CheckTimer, ErrorCatcher)
    preparingBlacklist()
    if Variables.preBlacklist["CheckTime"] - time() >= 60 then
        settingBlacklist()
    end
    if StaticPopup1:IsShown() and StaticPopup1Button1:GetText() == "取消" then
        StaticPopup1Button1:Click()
    end
    C_Timer.After(2, Scheduler)
end
