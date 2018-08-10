--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/28
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

local _, Addon = ...

_G["InstanceScheduler"] = LibStub("AceAddon-3.0"):NewAddon("InstanceScheduler", Addon, "AceConfig-3.0", "AceConfigDialog-3.0", "AceEvent-3.0", "AceTimer-3.0")

function Addon:OnEnable()
    if not InstanceSchedulerVariables then
        InstanceSchedulerVariables = {
            Locale = Addon.Locale
        }
        Addon.SavedVariables = InstanceSchedulerVariables
    end
end

