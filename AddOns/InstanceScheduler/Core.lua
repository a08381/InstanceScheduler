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
local V = Addon.Variables

Addon["Option"] = {
    name = L["option"],
    type = "group",
    childGroups = "tab",
    args = {
        enable = {
            name = L["enable"],
            desc = L["enable_desc"],
            type = "toggle",
            set = function(info, val)
                Addon:SwitchOn()
            end,
            get = function(info)
                return V.Status
            end
        },
        auto_start = {
            name = L["auto_start"],
            desc = L["auto_start_desc"],
            type = "toggle",
            set = function(info, val)
                V["AUTO_START"] = val
            end,
            get = function(info)
                return V["AUTO_START"]
            end
        },
        raid_settings = {
            name = L["raid_setings"],
            type = "group",
            disabled = function(info)
                return not V.Status
            end,
            args = {
                extend = {
                    name = L["extend"],
                    desc = L["extend_desc"],
                    type = "toggle",
                    set = function(info, val)
                        V.Extended = val
                    end,
                    get = function(info)
                        return V.Extended
                    end
                },
                only_extend = {
                    name = L["only_extend"],
                    desc = L["only_extend_desc"],
                    type = "toggle",
                    hidden = function(info)
                        return not V.Extended
                    end,
                    set = function(info, val)
                        V.Extended_Only = val
                    end,
                    get = function(info)
                        return V.Extended_Only
                    end
                }
            }
        },
        other_setings = {
            name = L["other_setings"],
            type = "group",
            disabled = function(info)
                return not V.Status
            end,
            args = {
                leave_time = {
                    name = L["leave_time"],
                    desc = L["leave_time_desc"],
                    type = "range",
                    min = 20,
                    max = 120,
                    
                }
            }
        }
    }
}
