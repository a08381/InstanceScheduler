--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/28
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

local _, Addon = ...

_G["InstanceScheduler"] = LibStub("AceAddon-3.0"):NewAddon("InstanceScheduler", Addon, "AceConfig-3.0", "AceConfigDialog-3.0", "AceEvent-3.0", "AceTimer-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("InstanceScheduler")

Addon["Option"] = {
    type = "group",
    args = {
        enable = {
            name = L["enable"],
            desc = L["enable_desc"],
            type = "toggle",
            set = function(info, val)
                Addon:SwitchOn()
            end,
            get = function(info)
                return Addon.Status
            end
        },
        auto_start = {
            name = L["auto_start"],
            desc = L["auto_start_desc"],
            type = "toggle",
            set = function(info, val)
                Addon["AUTO_START"] = val
            end,
            get = function(info)
                return Addon["AUTO_START"]
            end
        }
    }
}
