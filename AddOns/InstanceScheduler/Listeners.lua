--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/5/20
-- Time: 18:07
-- To change this template use File | Settings | File Templates.
--

local ADDON, Addon = ...

setfenv(1, Addon)

local message, sender
    
Event = {}

Event["CHAT_MSG_WHISPER"] = function(...)
    message, sender = ...
    if UnitPosition("player") and sender ~= Util:NameFormat(UnitName("player")) then
        if Util:First(message, Messages["InLine"].key) and not Variables.Limit.InLine[sender] then
            Variables.Limit.InLine[sender] = true
            for i, v in ipairs(Variables.Line) do
                if sender == v then
                    Util:SendWhisperMessage(Messages["InLine"].response, sender, i)
                    return
                end
            end
            if not UnitInParty(sender) and Variables.InGroupPlayer ~= sender then
                table.insert(Variables.Line, sender)
                Util:SendWhisperMessage(Messages["InLine"].response, sender, #Variables.Line)
            end
        elseif Util:First(message, Messages["RemoveFromLine"].key) and not Variables.Limit.RemoveFromLine[sender] and Variables.InGroupPlayer ~= sender then
            Variables.Limit.RemoveFromLine[sender] = true
            for i, v in ipairs(Variables.Line) do
                if sender == v then
                    table.remove(Variables.Line, i)
                    Util:SendWhisperMessage(Messages["RemoveFromLine"].response, sender)
                    return
                end
            end
        elseif Util:First(message, Messages["Menu"].key) and not Variables.Limit.Menu[sender] then
            Variables.Limit.Menu[sender] = true
            Util:SendWhisperMessage(Messages["Menu"].response, sender)
        elseif Util:First(message, Messages["InstanceList"].key) and not Variables.Limit.InstanceList[sender] then
            Variables.Limit.InstanceList[sender] = true
            Util:SendWhisperMessage(Messages["InstanceList"].response, sender)
        elseif Util:First(message, Messages["InstanceLocation"].key) and not Variables.Limit.InstanceLocation[sender] then
            Variables.Limit.InstanceLocation[sender] = true
            Util:SendWhisperMessage(Messages["InstanceLocation"].response, sender)
        elseif Util:First(message, Messages["Advice"].key) and not Variables.Limit.Advice[sender] then
            Variables.Limit.Advice[sender] = true
            Util:SendWhisperMessage(Messages["Advice"].response, sender)
        elseif not Variables.Limit.AutoResponse[sender] then
            Variables.Limit.AutoResponse[sender] = true
            Util:SendWhisperMessage(Messages["AutoResponse"].response, sender)
        end
    end
end

Event["CHAT_MSG_PARTY"] = function(...)
    message, sender = ...
    if Util:First(message, Messages["ChangeDifficulty"].key) and sender ~= Util:NameFormat(UnitName("player")) then
        SetLegacyRaidDifficultyID(3)
        Util:SendPartyMessage(Messages["ChangeDifficulty"].response)
    end
    if Util:First(message, Messages["ChangeHero"].key) and sender ~= Util:NameFormat(UnitName("player")) then
        SetRaidDifficultyID(15)
        SetLegacyRaidDifficultyID(5)
        Util:SendPartyMessage(Messages["ChangeHero"].response)
    end
end

--[[
Event["CHAT_MSG_GUILD"] = function(...)
    local CommandPrefix, _, message = InstanceScheduler.Commands.CommandPrefix, ...
    if message:len() >= CommandPrefix:len() and message:sub(1, CommandPrefix:len()) == CommandPrefix then
        local arg = message:sub(CommandPrefix:len() + 1, -1)
        if arg:len() >= 4 and arg:sub(1, 4) == "info" then
            Util:CommandInfo(arg:len() == 4 and nil or arg:sub(5, -1))
        end
    end
end
--]]

Event["PARTY_INVITE_REQUEST"] = function(...)
    DeclineGroup()
end

Event["GROUP_ROSTER_UPDATE"] = function(...)
    if Variables.Status then
        if UnitPosition("player") and not Variables.TempStatus then
            Frame:RegisterEvent("CHAT_MSG_WHISPER")
            Frame:RegisterEvent("CHAT_MSG_PARTY")
            Frame:RegisterEvent("PARTY_INVITE_REQUEST")
            Frame:RegisterEvent("GROUP_ROSTER_UPDATE")
            Variables.TempStatus = true
            _ = SavedVariables.Extended and Util:ExtendsSavedInstance(Variables.TempStatus)
        elseif Variables.TempStatus and not UnitPosition("player") then
            Frame:UnregisterEvent("CHAT_MSG_WHISPER")
            Frame:UnregisterEvent("CHAT_MSG_PARTY")
            Frame:UnregisterEvent("PARTY_INVITE_REQUEST")
            Variables.TempStatus = false
            _ = SavedVariables.Extended and Util:ExtendsSavedInstance(Variables.TempStatus)
            return
        end
    end
    if Variables.TempStatus then
        if IsInGroup() then
            if Variables.TempMembers == 0 and GetNumGroupMembers() == 1 then
                Variables.TempTime = GetTime()
            end
            if GetNumGroupMembers() == 2 and Variables.TempMembers == 1 and UnitIsGroupLeader("player") then
                Variables.InGroupTime = GetTime()
            end
            if GetNumGroupMembers() >= 3 and Variables.TempMembers < GetNumGroupMembers() then
                for i = GetNumGroupMembers() - 1, 2 do
                    local name, realm = UnitName("party" .. i)
                    local fullname = Util:NameFormat(name, realm, true)
                    UninviteUnit(fullname)
                    Util:SendWhisperMessage("NetProblem", fullname)
                end
            end
        else
            Variables.TempTime = 0
            Variables.InGroupTime = 0
            if Variables.InGroupPlayer ~= "" then
                Variables.InGroupPlayer = ""
            end
            if GetRaidDifficultyID() ~= 14 then
                SetRaidDifficultyID(14)
            end
            if GetLegacyRaidDifficultyID() ~= 4 then
                SetLegacyRaidDifficultyID(4)
            end
        end
        Variables.TempMembers = IsInGroup() and GetNumGroupMembers() or 0
    end
end

Event["ADDON_LOADED"] = function(...)
    if ADDON == select(1, ...) then
        Frame:UnregisterEvent("ADDON_LOADED")
        local ver = GetAddOnMetadata(ADDON, "Version")
        SavedVariables = _G.InstanceSchedulerVariables
        if not SavedVariables or SavedVariables.Line then
            SavedVariables =
            {
                Messages = Messages,
                AUTO_START = true,
                Extended = true,
                Extended_Only = true,
                LEAVE_TIME = 60,
                Version = ver,
                Users = {},
                Total = 0
            }
            _G.InstanceSchedulerVariables = SavedVariables
        end
        Messages = SavedVariables.Messages
        if SavedVariables.AUTO_START then
            Variables.Status = true
            Frame:RegisterEvent("CHAT_MSG_WHISPER")
            Frame:RegisterEvent("CHAT_MSG_PARTY")
            Frame:RegisterEvent("PARTY_INVITE_REQUEST")
            Frame:RegisterEvent("GROUP_ROSTER_UPDATE")
            C_Timer.After(2, Scheduler)
        end
        LibStub("AceConfig-3.0"):RegisterOptionsTable("InstanceScheduler", Option)
        LibStub("AceConfigDialog-3.0"):AddToBlizOptions("InstanceScheduler", Locale["InstanceScheduler"])
        LibStub("AceConfigDialog-3.0"):AddToBlizOptions("InstanceScheduler", Option.args.basic.name, Locale["InstanceScheduler"], "basic")
        LibStub("AceConfigDialog-3.0"):AddToBlizOptions("InstanceScheduler", Option.args.advanced.name, Locale["InstanceScheduler"], "advanced")
    end
end
