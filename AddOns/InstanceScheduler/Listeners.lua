--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/5/20
-- Time: 18:07
-- To change this template use File | Settings | File Templates.
--

local ADDON, Addon = ...

setfenv(1, Addon)

Event = {}

Event["CHAT_MSG_WHISPER"] = function(...)
    local message, sender = ...
    if UnitPosition("player") and sender ~= Util:NameFormat(UnitName("player")) then
        if SavedVariables.Blacklist[sender] and not Variables.Limit.Blacklist[sender] then
            Variables.Limit.Blacklist[sender] = true
            if SavedVariables.Blacklist[sender] ~= -1 then
                local time = SavedVariables.Blacklist[sender] - time()
                if time >= 0 then
                    Util.SendWhisperMessage(Messages["InBlacklist"].response, sender, time)
                else
                    SavedVariables.Blacklist[sender] = nil
                end
            else
                return
            end
        end
        if Util:First(message, Messages["InLine"].key) then
            if not Variables.Limit.InLine[sender] then
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
            end
        elseif Util:First(message, Messages["RemoveFromLine"].key) and Variables.InGroupPlayer ~= sender then
            if not Variables.Limit.RemoveFromLine[sender] then
                Variables.Limit.RemoveFromLine[sender] = true
                for i, v in ipairs(Variables.Line) do
                    if sender == v then
                        table.remove(Variables.Line, i)
                        Util:SendWhisperMessage(Messages["RemoveFromLine"].response, sender)
                        return
                    end
                end
            end
        elseif Util:First(message, Messages["WaitPortal"].key) then
            if not Variables.Limit.WaitPortal[sender] then
                Variables.Limit.WaitPortal[sender] = true
                for i, v in ipairs(Variables.PortalLine) do
                    if sender == v then
                        Util:SendWhisperMessage(Messages["WaitPortal"].response, sender, i)
                        return
                    end
                end
                if not UnitInParty(sender) and Variables.InGroupPlayer ~= sender then
                    table.insert(Variables.PortalLine, sender)
                    Util:SendWhisperMessage(Messages["WaitPortal"].response, sender, #Variables.PortalLine)
                end
            end
        else
            for k, v in pairs(Messages["Extras"]) do
                if Util:First(message, v.key) then
                    if not Variables.Limit[k][sender] then
                        Variables.Limit[k][sender] = true
                        Util:SendWhisperMessage(v.response, sender)
                    end
                    return
                end
            end
            if not Variables.Limit.AutoResponse[sender] then
                Variables.Limit.AutoResponse[sender] = true
                Util:SendWhisperMessage(Messages["AutoResponse"].response, sender)
            end
        end
    end
end

Event["CHAT_MSG_PARTY"] = function(...)
    local message, sender = ...
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
    local sender = ...
    if Variables.preBlacklist[sender] then
        Variables.preBlacklist[sender] = Variables.preBlacklist[sender] + 1
    else
        Variables.preBlacklist[sender] = 1
    end
    DeclineGroup()
end

Event["GROUP_ROSTER_UPDATE"] = function()
    if Variables.Status then
        if IsInGroup() then
            local members = GetNumGroupMembers()
            if Variables.TempMembers == 0 and members == 1 then
                Variables.TempTime = GetTime()
            end
            if members == 2 and Variables.TempMembers == 1 and UnitIsGroupLeader("player") then
                Variables.InGroupTime = GetTime()
            end
            if members >= 3 and Variables.TempMembers < members then
                for i = members - 1, 2 do
                    local name, realm = UnitName("party" .. i)
                    local fullname = Util:NameFormat(name, realm, true)
                    UninviteUnit(fullname)
                    Util:SendWhisperMessage("NetProblem", fullname)
                end
            end
        else
            Variables.TempTime = 0
            Variables.InGroupTime = 0
            Variables.RunTime = 0
            Variables.InGroupPlayer = ""
            Variables.IsGroupPlayerForPortal = false
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

Event["PLAYER_LOGIN"] = function()
    Frame:UnregisterEvent("PLAYER_LOGIN")
    if SavedVariables.AUTO_START then
        Util:SwitchOn()
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
        if SavedVariables.Version ~= ver then
            SavedVariables.Version = ver
        end
        if not SavedVariables.Blacklist then
            SavedVariables.Blacklist = {}
        end

        for k, v in pairs(Messages) do
            if k ~= "Extras" then
                if not SavedVariables.Messages[k] then
                    SavedVariables.Messages[k] = v
                end
            else
                for n, t in pairs(v) do
                    if not SavedVariables.Messages.Extras[n] then
                        SavedVariables.Messages.Extras[n] = t
                    end
                end
            end
        end
        for k, v in pairs(SavedVariables.Messages) do
            if k ~= "Extras" then
                if not Messages[k] then
                    SavedVariables.Messages[k] = nil
                end
            else
                for n in pairs(v) do
                    if not Messages.Extras[n] then
                        SavedVariables.Messages.Extras[n] = nil
                    end
                end
            end
        end
        Messages = SavedVariables.Messages
        for k in pairs(Messages.Extras) do
            Variables.Limit[k] = {}
        end

        Option.args.message.args = Util:GetMessageTable()
        LibStub("AceConfig-3.0"):RegisterOptionsTable("InstanceScheduler", Option)
        LibStub("AceConfigDialog-3.0"):AddToBlizOptions("InstanceScheduler", Locale["InstanceScheduler"], nil, "global")
        LibStub("AceConfigDialog-3.0"):AddToBlizOptions("InstanceScheduler", Option.args.basic.name, Locale["InstanceScheduler"], "basic")
        LibStub("AceConfigDialog-3.0"):AddToBlizOptions("InstanceScheduler", Option.args.message.name, Locale["InstanceScheduler"], "message")
        LibStub("AceConfigDialog-3.0"):AddToBlizOptions("InstanceScheduler", Option.args.advanced.name, Locale["InstanceScheduler"], "advanced")
    end
end
